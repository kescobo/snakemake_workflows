# set options with "--config "

kneadfolder = os.path.join(output_folder, "kneaddata")
include: "workflows/kneaddata.snakefile"

metaphlanfolder = os.path.join(output_folder, "metaphlan")
include: "workflows/metaphlan.snakefile"

humannfolder = os.path.join(output_folder, "humann")
include: "workflows/humann.snakefile"

rule all:
    input:
        os.path.join(output_folder, "report.html")


rule report:
    input:
        kneaddata = os.path.join(kneadfolder, "kneaddata_report.html"),
        metaphlan = os.path.join(metaphlanfolder, "metaphlan_report.html"),
        humann = os.path.join(humannfolder, "humann_report.html")
    output:
        os.path.join(output_folder, "report.html")
    run:
        from snakemake.utils import report
        report("""
        Pipeline works!!!
        """, output[0])
