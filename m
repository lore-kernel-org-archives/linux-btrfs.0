From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: RE: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 17:28:44 +0200
Message-ID: <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5C6@mail.corp.imt-systems.com>
References: <4C6BB21E.3000809@cn.fujitsu.com>
 <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5C5@mail.corp.imt-systems.com>
 <20100818142541.GP5854@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100818142541.GP5854@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Your compilebench results are very interesting.

Here are my results with exactly the same benchmark:

Btrfs:

[root@fc13 compilebench-0.6]# ./compilebench -D /mnt/btrfs -i 30 --makej
using working directory /mnt/btrfs, 30 intial dirs 100 runs
native unpatched native-0 222MB in 3.14 seconds (70.82 MB/s)
native patched native-0 109MB in 0.69 seconds (158.94 MB/s)
native patched compiled native-0 691MB in 1.86 seconds (371.83 MB/s)
create dir kernel-0 222MB in 2.28 seconds (97.53 MB/s)
create dir kernel-1 222MB in 3.45 seconds (64.46 MB/s)
create dir kernel-2 222MB in 5.37 seconds (41.41 MB/s)
create dir kernel-3 222MB in 3.37 seconds (65.99 MB/s)
create dir kernel-4 222MB in 3.33 seconds (66.78 MB/s)
create dir kernel-5 222MB in 3.56 seconds (62.46 MB/s)
create dir kernel-6 222MB in 3.39 seconds (65.60 MB/s)
create dir kernel-7 222MB in 3.76 seconds (59.14 MB/s)
create dir kernel-8 222MB in 3.52 seconds (63.17 MB/s)
create dir kernel-9 222MB in 3.62 seconds (61.43 MB/s)
create dir kernel-10 222MB in 3.48 seconds (63.90 MB/s)
create dir kernel-11 222MB in 3.32 seconds (66.98 MB/s)
create dir kernel-12 222MB in 3.06 seconds (72.67 MB/s)
create dir kernel-13 222MB in 2.64 seconds (84.23 MB/s)
create dir kernel-14 222MB in 2.91 seconds (76.42 MB/s)
create dir kernel-15 222MB in 3.25 seconds (68.42 MB/s)
create dir kernel-16 222MB in 3.00 seconds (74.12 MB/s)
create dir kernel-17 222MB in 3.14 seconds (70.82 MB/s)
create dir kernel-18 222MB in 4.90 seconds (45.38 MB/s)
create dir kernel-19 222MB in 3.14 seconds (70.82 MB/s)
create dir kernel-20 222MB in 3.26 seconds (68.21 MB/s)
create dir kernel-21 222MB in 3.10 seconds (71.73 MB/s)
create dir kernel-22 222MB in 3.18 seconds (69.93 MB/s)
create dir kernel-23 222MB in 2.97 seconds (74.87 MB/s)
create dir kernel-24 222MB in 2.69 seconds (82.67 MB/s)
create dir kernel-25 222MB in 2.90 seconds (76.68 MB/s)
create dir kernel-26 222MB in 2.96 seconds (75.13 MB/s)
create dir kernel-27 222MB in 2.94 seconds (75.64 MB/s)
create dir kernel-28 222MB in 2.86 seconds (77.75 MB/s)
create dir kernel-29 222MB in 3.09 seconds (71.97 MB/s)
compile dir kernel-6 680MB in 1.35 seconds (504.17 MB/s)
compile dir kernel-29 680MB in 2.93 seconds (232.30 MB/s)
compile dir kernel-11 680MB in 3.24 seconds (210.07 MB/s)
compile dir kernel-22 680MB in 3.12 seconds (218.15 MB/s)
compile dir kernel-15 680MB in 3.25 seconds (209.43 MB/s)
compile dir kernel-13 680MB in 3.23 seconds (210.72 MB/s)
compile dir kernel-17 680MB in 3.19 seconds (213.36 MB/s)
compile dir kernel-3 680MB in 3.35 seconds (203.17 MB/s)
compile dir kernel-10 680MB in 3.25 seconds (209.43 MB/s)
compile dir kernel-12 680MB in 3.59 seconds (189.59 MB/s)
compile dir kernel-27 680MB in 4.05 seconds (168.06 MB/s)
compile dir kernel-14 680MB in 3.29 seconds (206.88 MB/s)
compile dir kernel-9 680MB in 3.22 seconds (211.38 MB/s)
compile dir kernel-4 680MB in 3.29 seconds (206.88 MB/s)
compile dir kernel-0 680MB in 3.25 seconds (209.43 MB/s)
compile dir kernel-23 680MB in 3.20 seconds (212.70 MB/s)
compile dir kernel-1 680MB in 3.23 seconds (210.72 MB/s)
compile dir kernel-28 680MB in 3.42 seconds (199.02 MB/s)
compile dir kernel-21 680MB in 3.33 seconds (204.39 MB/s)
compile dir kernel-8 680MB in 3.90 seconds (174.52 MB/s)
compile dir kernel-26 680MB in 4.07 seconds (167.23 MB/s)
compile dir kernel-25 680MB in 3.20 seconds (212.70 MB/s)
compile dir kernel-2 680MB in 3.22 seconds (211.38 MB/s)
compile dir kernel-16 680MB in 3.27 seconds (208.15 MB/s)
compile dir kernel-5 680MB in 3.30 seconds (206.25 MB/s)
compile dir kernel-18 680MB in 3.45 seconds (197.29 MB/s)
compile dir kernel-7 680MB in 3.66 seconds (185.97 MB/s)
compile dir kernel-20 680MB in 3.40 seconds (200.19 MB/s)
compile dir kernel-24 680MB in 3.51 seconds (193.91 MB/s)
compile dir kernel-19 680MB in 4.38 seconds (155.40 MB/s)
read dir kernel-11 in 36.13 24.99 MB/s
read dir kernel-19 in 36.00 25.08 MB/s
read dir kernel-8 in 37.51 24.07 MB/s
delete kernel-6 in 7.11 seconds
delete kernel-13 in 6.14 seconds
delete kernel-27 in 6.56 seconds
delete kernel-26 in 6.08 seconds
delete kernel-1 in 6.08 seconds
delete kernel-15 in 8.09 seconds
delete kernel-14 in 5.33 seconds
delete kernel-0 in 6.14 seconds
delete kernel-20 in 5.96 seconds
delete kernel-8 in 6.34 seconds
delete kernel-22 in 5.50 seconds
delete kernel-18 in 6.36 seconds
delete kernel-17 in 6.23 seconds
delete kernel-25 in 5.50 seconds
delete kernel-9 in 5.83 seconds
delete kernel-19 in 7.28 seconds
delete kernel-21 in 6.05 seconds
delete kernel-10 in 5.75 seconds
delete kernel-29 in 6.28 seconds
delete kernel-11 in 6.35 seconds
delete kernel-4 in 5.55 seconds
delete kernel-28 in 5.91 seconds
delete kernel-3 in 5.56 seconds
delete kernel-7 in 6.54 seconds
delete kernel-23 in 5.22 seconds
delete kernel-16 in 5.30 seconds
delete kernel-2 in 5.62 seconds
delete kernel-12 in 4.88 seconds
delete kernel-5 in 5.65 seconds
delete kernel-24 in 5.36 seconds

Ext4:

[root@fc13 compilebench-0.6]# ./compilebench -D /mnt/ext4 -i 30 --makej
using working directory /mnt/ext4, 30 intial dirs 100 runs
native unpatched native-0 222MB in 2.34 seconds (95.03 MB/s)
native patched native-0 109MB in 0.60 seconds (182.78 MB/s)
native patched compiled native-0 691MB in 2.00 seconds (345.80 MB/s)
create dir kernel-0 222MB in 2.16 seconds (102.95 MB/s)
create dir kernel-1 222MB in 2.37 seconds (93.83 MB/s)
create dir kernel-2 222MB in 3.11 seconds (71.50 MB/s)
create dir kernel-3 222MB in 3.71 seconds (59.94 MB/s)
create dir kernel-4 222MB in 3.55 seconds (62.64 MB/s)
create dir kernel-5 222MB in 3.61 seconds (61.60 MB/s)
create dir kernel-6 222MB in 3.34 seconds (66.58 MB/s)
create dir kernel-7 222MB in 3.72 seconds (59.78 MB/s)
create dir kernel-8 222MB in 2.66 seconds (83.60 MB/s)
create dir kernel-9 222MB in 2.74 seconds (81.16 MB/s)
create dir kernel-10 222MB in 2.67 seconds (83.29 MB/s)
create dir kernel-11 222MB in 2.85 seconds (78.03 MB/s)
create dir kernel-12 222MB in 2.21 seconds (100.62 MB/s)
create dir kernel-13 222MB in 2.39 seconds (93.04 MB/s)
create dir kernel-14 222MB in 2.18 seconds (102.01 MB/s)
create dir kernel-15 222MB in 2.27 seconds (97.96 MB/s)
create dir kernel-16 222MB in 2.45 seconds (90.76 MB/s)
create dir kernel-17 222MB in 2.35 seconds (94.63 MB/s)
create dir kernel-18 222MB in 2.37 seconds (93.83 MB/s)
create dir kernel-19 222MB in 4.00 seconds (55.59 MB/s)
create dir kernel-20 222MB in 2.38 seconds (93.43 MB/s)
create dir kernel-21 222MB in 2.39 seconds (93.04 MB/s)
create dir kernel-22 222MB in 2.31 seconds (96.27 MB/s)
create dir kernel-23 222MB in 2.58 seconds (86.19 MB/s)
create dir kernel-24 222MB in 2.56 seconds (86.86 MB/s)
create dir kernel-25 222MB in 2.42 seconds (91.89 MB/s)
create dir kernel-26 222MB in 2.51 seconds (88.60 MB/s)
create dir kernel-27 222MB in 2.45 seconds (90.76 MB/s)
create dir kernel-28 222MB in 2.53 seconds (87.89 MB/s)
create dir kernel-29 222MB in 2.46 seconds (90.40 MB/s)
compile dir kernel-6 680MB in 1.23 seconds (553.36 MB/s)
compile dir kernel-29 680MB in 4.10 seconds (166.01 MB/s)
compile dir kernel-11 680MB in 4.35 seconds (156.47 MB/s)
compile dir kernel-22 680MB in 4.42 seconds (153.99 MB/s)
compile dir kernel-15 680MB in 4.59 seconds (148.29 MB/s)
compile dir kernel-13 680MB in 4.31 seconds (157.92 MB/s)
compile dir kernel-17 680MB in 5.15 seconds (132.16 MB/s)
compile dir kernel-3 680MB in 4.40 seconds (154.69 MB/s)
compile dir kernel-10 680MB in 4.47 seconds (152.27 MB/s)
compile dir kernel-12 680MB in 4.51 seconds (150.92 MB/s)
compile dir kernel-27 680MB in 4.69 seconds (145.12 MB/s)
compile dir kernel-14 680MB in 4.75 seconds (143.29 MB/s)
compile dir kernel-9 680MB in 4.34 seconds (156.83 MB/s)
compile dir kernel-4 680MB in 4.49 seconds (151.59 MB/s)
compile dir kernel-0 680MB in 4.53 seconds (150.25 MB/s)
compile dir kernel-23 680MB in 4.62 seconds (147.32 MB/s)
compile dir kernel-1 680MB in 4.54 seconds (149.92 MB/s)
compile dir kernel-28 680MB in 4.32 seconds (157.55 MB/s)
compile dir kernel-21 680MB in 4.92 seconds (138.34 MB/s)
compile dir kernel-8 680MB in 4.63 seconds (147.01 MB/s)
compile dir kernel-26 680MB in 4.45 seconds (152.95 MB/s)
compile dir kernel-25 680MB in 4.66 seconds (146.06 MB/s)
compile dir kernel-2 680MB in 4.34 seconds (156.83 MB/s)
compile dir kernel-16 680MB in 4.66 seconds (146.06 MB/s)
compile dir kernel-5 680MB in 4.63 seconds (147.01 MB/s)
compile dir kernel-18 680MB in 4.41 seconds (154.34 MB/s)
compile dir kernel-7 680MB in 5.06 seconds (134.51 MB/s)
compile dir kernel-20 680MB in 4.85 seconds (140.34 MB/s)
compile dir kernel-24 680MB in 4.40 seconds (154.69 MB/s)
compile dir kernel-19 680MB in 4.48 seconds (151.93 MB/s)
read dir kernel-11 in 31.82 28.38 MB/s
read dir kernel-19 in 35.85 25.19 MB/s
read dir kernel-8 in 38.25 23.61 MB/s
delete kernel-6 in 1.46 seconds
delete kernel-13 in 1.43 seconds
delete kernel-27 in 1.49 seconds
delete kernel-26 in 1.59 seconds
delete kernel-1 in 1.50 seconds
delete kernel-15 in 1.52 seconds
delete kernel-14 in 1.64 seconds
delete kernel-0 in 1.50 seconds
delete kernel-20 in 1.47 seconds
delete kernel-8 in 1.60 seconds
delete kernel-22 in 1.54 seconds
delete kernel-18 in 1.50 seconds
delete kernel-17 in 1.46 seconds
delete kernel-25 in 1.88 seconds
delete kernel-9 in 1.49 seconds
delete kernel-19 in 1.51 seconds
delete kernel-21 in 1.63 seconds
delete kernel-10 in 1.47 seconds
delete kernel-29 in 1.50 seconds
delete kernel-11 in 1.83 seconds
delete kernel-4 in 1.51 seconds
delete kernel-28 in 1.51 seconds
delete kernel-3 in 1.89 seconds
delete kernel-7 in 1.54 seconds
delete kernel-23 in 1.46 seconds
delete kernel-16 in 2.88 seconds
delete kernel-2 in 1.48 seconds
delete kernel-12 in 1.51 seconds
delete kernel-5 in 1.57 seconds
delete kernel-24 in 1.52 seconds

Best regards,

Morten



On Wed, Aug 18, 2010 at 4:25 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Wed, Aug 18, 2010 at 12:49:05PM +0200, Morten P.D. Stevens wrote:
>> Hi,
>>
>> i can confirm this issue with poor create and delete performance.
>>
>> For example with unpacking and deleting the linux kernel:
>>
>> Btrfs:
>>
>> [root@fc13 btrfs]# time tar xfj linux-2.6.36-rc1.tar.bz2
>>
>> real    0m18.794s
>> user    0m12.045s
>> sys     0m8.241s
>> [root@fc13 btrfs]# time rm -rf linux-2.6.36-rc1
>>
>> real    0m2.156s
>> user    0m0.028s
>> sys     0m2.118s
>>
>> ext4:
>>
>> [root@fc13 ext4]# time tar xfj linux-2.6.36-rc1.tar.bz2
>>
>> real    0m13.140s
>> user    0m9.074s
>> sys     0m6.327s
>> [root@fc13 ext4]# time rm -rf linux-2.6.36-rc1
>>
>> real    0m0.781s
>> user    0m0.031s
>> sys     0m0.735s
>>
>> In all of our benchmarks, ext4 is still faster than btrfs.
>
> For this kind of benchmark, I use my compilebench program.  We want to
> time just the file creation and not how long it takes to uncompress or
> read in the .tar.gz from the disk.
>
> The results from 2.6.35 on a single sata drive are not good for ext4 at
> all.  Btrfs is on par with where it always has been, but I'm
> experimenting with other benchmarks to find the regression.  Basically
> when you are benchmarking this kind of thing you want to make sure
> you're benchmarking how quickly you can write to the disk, and not to
> cache.
>
> compilebench simulates this by creating files with the same size and
> names as what you get from untarring kernel trees, and then it has a
> phase where it creates files with the same size and names as the .o
> files from compiling the kernel.
>
> Btrfs:
>
> # ./compilebench -i 30 --makej
> creating /mnt/default
> using working directory /mnt/default, 30 intial dirs 100 runs
> native unpatched native-0 222MB in 1.76 seconds (126.35 MB/s)
> native patched native-0 109MB in 0.51 seconds (215.04 MB/s)
> native patched compiled native-0 691MB in 5.69 seconds (121.55 MB/s)
> create dir kernel-0 222MB in 2.94 seconds (75.64 MB/s)
> create dir kernel-1 222MB in 3.16 seconds (70.37 MB/s)
> create dir kernel-2 222MB in 3.05 seconds (72.91 MB/s)
> create dir kernel-3 222MB in 3.11 seconds (71.50 MB/s)
> create dir kernel-4 222MB in 3.88 seconds (57.31 MB/s)
> create dir kernel-5 222MB in 3.58 seconds (62.12 MB/s)
> create dir kernel-6 222MB in 6.11 seconds (36.40 MB/s)
> create dir kernel-7 222MB in 2.28 seconds (97.53 MB/s)
> create dir kernel-8 222MB in 3.12 seconds (71.27 MB/s)
> create dir kernel-9 222MB in 2.86 seconds (77.75 MB/s)
> create dir kernel-10 222MB in 4.46 seconds (49.86 MB/s)
> create dir kernel-11 222MB in 2.96 seconds (75.13 MB/s)
> create dir kernel-12 222MB in 3.86 seconds (57.61 MB/s)
> create dir kernel-13 222MB in 3.96 seconds (56.16 MB/s)
> create dir kernel-14 222MB in 3.79 seconds (58.67 MB/s)
> create dir kernel-15 222MB in 6.58 seconds (33.80 MB/s)
> create dir kernel-16 222MB in 2.09 seconds (106.40 MB/s)
> create dir kernel-17 222MB in 2.71 seconds (82.06 MB/s)
> create dir kernel-18 222MB in 3.40 seconds (65.40 MB/s)
> create dir kernel-19 222MB in 3.25 seconds (68.42 MB/s)
> create dir kernel-20 222MB in 3.79 seconds (58.67 MB/s)
> create dir kernel-21 222MB in 3.86 seconds (57.61 MB/s)
> create dir kernel-22 222MB in 3.59 seconds (61.94 MB/s)
> create dir kernel-23 222MB in 4.02 seconds (55.32 MB/s)
> create dir kernel-24 222MB in 7.68 seconds (28.95 MB/s)
> create dir kernel-25 222MB in 1.99 seconds (111.75 MB/s)
> create dir kernel-26 222MB in 2.77 seconds (80.28 MB/s)
> create dir kernel-27 222MB in 2.97 seconds (74.87 MB/s)
> create dir kernel-28 222MB in 3.22 seconds (69.06 MB/s)
> create dir kernel-29 222MB in 3.94 seconds (56.44 MB/s)
> compile dir kernel-6 680MB in 3.78 seconds (180.06 MB/s)
> compile dir kernel-29 680MB in 9.21 seconds (73.90 MB/s)
> compile dir kernel-11 680MB in 9.38 seconds (72.56 MB/s)
> compile dir kernel-22 680MB in 10.57 seconds (64.39 MB/s)
> compile dir kernel-15 680MB in 7.68 seconds (88.62 MB/s)
> compile dir kernel-13 680MB in 9.26 seconds (73.50 MB/s)
> compile dir kernel-17 680MB in 9.44 seconds (72.10 MB/s)
> compile dir kernel-3 680MB in 9.03 seconds (75.37 MB/s)
> compile dir kernel-10 680MB in 9.30 seconds (73.19 MB/s)
> compile dir kernel-12 680MB in 9.29 seconds (73.27 MB/s)
> compile dir kernel-27 680MB in 10.84 seconds (62.79 MB/s)
> compile dir kernel-14 680MB in 7.65 seconds (88.97 MB/s)
> compile dir kernel-9 680MB in 9.55 seconds (71.27 MB/s)
> compile dir kernel-4 680MB in 9.20 seconds (73.98 MB/s)
> compile dir kernel-0 680MB in 12.06 seconds (56.44 MB/s)
> compile dir kernel-23 680MB in 9.39 seconds (72.49 MB/s)
> compile dir kernel-1 680MB in 9.06 seconds (75.13 MB/s)
>
> Ext4:
>
> ./compilebench -i 30 --makej
> creating /mnt/default
> using working directory /mnt/default, 30 intial dirs 100 runs
> native unpatched native-0 222MB in 1.11 seconds (200.34 MB/s)
> native patched native-0 109MB in 0.33 seconds (332.33 MB/s)
> native patched compiled native-0 691MB in 5.38 seconds (128.55 MB/s)
> create dir kernel-0 222MB in 1.05 seconds (211.78 MB/s)
> create dir kernel-1 222MB in 4.60 seconds (48.34 MB/s)
> create dir kernel-2 222MB in 4.30 seconds (51.71 MB/s)
> create dir kernel-3 222MB in 5.71 seconds (38.94 MB/s)
> create dir kernel-4 222MB in 4.82 seconds (46.14 MB/s)
> create dir kernel-5 222MB in 4.91 seconds (45.29 MB/s)
> create dir kernel-6 222MB in 5.70 seconds (39.01 MB/s)
> create dir kernel-7 222MB in 4.76 seconds (46.72 MB/s)
> create dir kernel-8 222MB in 6.40 seconds (34.75 MB/s)
> create dir kernel-9 222MB in 5.37 seconds (41.41 MB/s)
> create dir kernel-10 222MB in 5.51 seconds (40.36 MB/s)
> create dir kernel-11 222MB in 6.77 seconds (32.85 MB/s)
> create dir kernel-12 222MB in 5.88 seconds (37.82 MB/s)
> create dir kernel-13 222MB in 8.92 seconds (24.93 MB/s)
> create dir kernel-14 222MB in 5.44 seconds (40.88 MB/s)
> create dir kernel-15 222MB in 6.21 seconds (35.81 MB/s)
> create dir kernel-16 222MB in 4.85 seconds (45.85 MB/s)
> create dir kernel-17 222MB in 8.83 seconds (25.18 MB/s)
> create dir kernel-18 222MB in 6.82 seconds (32.61 MB/s)
> create dir kernel-19 222MB in 4.86 seconds (45.76 MB/s)
> create dir kernel-20 222MB in 10.48 seconds (21.22 MB/s)
> create dir kernel-21 222MB in 4.85 seconds (45.85 MB/s)
> create dir kernel-22 222MB in 8.30 seconds (26.79 MB/s)
> create dir kernel-23 222MB in 6.38 seconds (34.85 MB/s)
> create dir kernel-24 222MB in 7.30 seconds (30.46 MB/s)
> create dir kernel-25 222MB in 3.83 seconds (58.06 MB/s)
> create dir kernel-26 222MB in 9.70 seconds (22.93 MB/s)
> create dir kernel-27 222MB in 5.39 seconds (41.26 MB/s)
> create dir kernel-28 222MB in 6.96 seconds (31.95 MB/s)
> create dir kernel-29 222MB in 8.16 seconds (27.25 MB/s)
> compile dir kernel-6 680MB in 7.47 seconds (91.12 MB/s)
> compile dir kernel-29 680MB in 16.37 seconds (41.58 MB/s)
> compile dir kernel-11 680MB in 19.57 seconds (34.78 MB/s)
> compile dir kernel-22 680MB in 17.17 seconds (39.64 MB/s)
> compile dir kernel-15 680MB in 17.40 seconds (39.12 MB/s)
> compile dir kernel-13 680MB in 17.87 seconds (38.09 MB/s)
> compile dir kernel-17 680MB in 18.14 seconds (37.52 MB/s)
> compile dir kernel-3 680MB in 17.43 seconds (39.05 MB/s)
> compile dir kernel-10 680MB in 15.18 seconds (44.84 MB/s)
> compile dir kernel-12 680MB in 17.14 seconds (39.71 MB/s)
> compile dir kernel-27 680MB in 18.71 seconds (36.38 MB/s)
> compile dir kernel-14 680MB in 17.47 seconds (38.96 MB/s)
> compile dir kernel-9 680MB in 19.76 seconds (34.45 MB/s)
> compile dir kernel-4 680MB in 17.53 seconds (38.83 MB/s)
> compile dir kernel-0 680MB in 17.20 seconds (39.57 MB/s)
> compile dir kernel-23 680MB in 17.31 seconds (39.32 MB/s)
> compile dir kernel-1 680MB in 18.19 seconds (37.42 MB/s)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
