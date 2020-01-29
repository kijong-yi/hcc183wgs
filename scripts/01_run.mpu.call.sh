mkdir -p /home/users/kjyi/Projects/cocult/WGS/hcc183/mpileup/merged
for chr in 5 6 7 8 9 10 11 12 13 4 14 15 16 17 3 18 19 20 21 2 22 X Y MT 1; do
cat << EOF | qsub -l nodes=1:ppn=2 -q month -N mpileup -o /dev/null -e /dev/null
cd /home/users/kjyi/Projects/cocult/WGS/hcc183/mpileup/merged
(samtools mpileup \
	-AB \
	-d 10000\
	-q 20 \
	-Q 20 \
	-f /home/users/data/01_reference/human_g1k_v37/human_g1k_v37.fasta \
	-r ${chr} \
	/home/users/kjyi/Projects/cocult/WGS/hcc183/mapping/*.bam | \
	gzip > hcc183orgs.22s.q20Q20.chr${chr}.mpileup.gz) 2> hcc183orgs.mpu.chr${chr}.log &&\
	 mv hcc183orgs.mpu.chr${chr}.log hcc183orgs.mpu.chr${chr}.success && \
	 python /home/users/sypark/01_Python_files/normal_matrix/pileup_calling_snv.py \
	 hcc183orgs.22s.q20Q20.chr${chr}.mpileup.gz 22 &> hcc183orgs.chr${chr}.snv_call.log && \
	 mv hcc183orgs.chr${chr}.snv_call.log hcc183orgs.chr${chr}.snv_call.success && \
	 python /home/users/sypark/01_Python_files/normal_matrix/pileup_calling_indel_190705.py \
	 hcc183orgs.22s.q20Q20.chr${chr}.mpileup.gz 22 &> hcc183orgs.chr${chr}.indel_call.log && \
	 mv hcc183orgs.chr${chr}.indel_call.log hcc183orgs.chr${chr}.indel_call.success
EOF
done