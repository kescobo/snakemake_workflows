if not config["skipknead"]:
    include: "workflows/kneaddata.snakefile"
else:
    kneadfolder = os.path.join(output_folder, "kneaddata")

include: "workflows/metaphlan.snakefile"
include: "workflows/humann.snakefile"

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
