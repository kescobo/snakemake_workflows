kneadfolder = os.path.join(output_folder, "kneaddata/kneaddata_output/")
(samples, lanes) = glob_wildcards(os.path.join(input_folder, "{sample}_{lane,L\d+}_R1_001.fastq.gz"))

samples = list(set(samples))
samples.sort()
lanes = list(set(lanes))
lanes.sort()

print(samples)
print(lanes)

rule knead_cat1:
    input: expand(os.path.join(input_folder, "{{sample}}_{lane}_R1_001.fastq.gz"), lane=lanes)
    output: os.path.join(input_folder, "{sample}.1.fastq.gz")
    wildcard_constraints:
        sample = "[\w\-]-(F|E)[A-Z0-9]+"
    run:
        shell("cat {input} > {output}")

rule knead_cat2:
    input: expand(os.path.join(input_folder, "{{sample}}_{lane}_R2_001.fastq.gz"), lane=lanes)
    output: os.path.join(input_folder, "{sample}.2.fastq.gz")
    wildcard_constraints:
        sample = "[\w\-]-(F|E)[A-Z0-9]+"
    run:
        shell("cat {input} > {output}")

rule kneaddata:
    input:
        fwd = os.path.join(input_folder, "{sample}.1.fastq.gz"),
        rev = os.path.join(input_folder, "{sample}.2.fastq.gz"),
        # db = config["databases"]["human_sequences"]
    output:
        fwd = os.path.join(kneadfolder, "{sample}_kneaddata_paired_1.fastq"),
        rev = os.path.join(kneadfolder, "{sample}_kneaddata_paired_2.fastq")
    wildcard_constraints:
        sample = "[\w\-]-(F|E)[A-Z0-9]+"
    run:
        shell("kneaddata --input {{input.fwd}} --input {{input.rev}} --reference-db {{input.db}} --output {}".format(kneadfolder))


rule kneaddata_counts:
    input:
        fwd = expand(os.path.join(kneadfolder, "{sample}_kneaddata_paired_1.fastq"), sample = samples),
        rev = expand(os.path.join(kneadfolder, "{sample}_kneaddata_paired_2.fastq"), sample = samples)
    output:
        os.path.join(output_folder, "kneaddata/kneaddata_read_counts.txt")
    shell:
        "kneaddata_read_count_table --input {} --output {{output}}".format(kneadfolder)


rule kneaddata_report:
    input:
        os.path.join(output_folder, "kneaddata/kneaddata_read_counts.txt")
    output:
        os.path.join(output_folder, "kneaddata/kneaddata_report.html")
    run:
        from snakemake.utils import report
        report("""
        KneadData works!!!
        """, output[0])
