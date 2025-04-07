mv geo/*_fastq/*.fastq.gz geo/

zgrep -c "^+$" geo/*.fastq.gz > actual_read_counts.txt

grep "Observed\|Counts" geo/slurmOut/geo_gather_* > expected_read_counts.txt

md5sum geo/*.fastq.gz > fastq_md5sum.txt

md5sum geo/proc_data/*.tar.gz > proc_data_md5sum.txt

