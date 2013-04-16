Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46400 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935693Ab3DPQ4t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 12:56:49 -0400
Received: by mail-oa0-f52.google.com with SMTP id k18so728771oag.11
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 09:56:49 -0700 (PDT)
MIME-Version: 1.0
From: Matt Pursley <mpursley@gmail.com>
Date: Tue, 16 Apr 2013 09:56:08 -0700
Message-ID: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
Subject: One random read streaming is fast (~1200MB/s), but two or more are
 slower (~750MB/s)?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I have an LSI HBA card (LSI SAS 9207-8i) with 12 7200rpm SAS drives
attached.  When it's formated with mdraid6+ext4 I get about 1200MB/s
for multiple streaming random reads with iozone.  With btrfs in
3.9.0-rc4 I can also get about 1200MB/s, but only with one stream at a
time.

As soon as I add a second (or more), the speed will drop to about
750MB/s.  If I add more streams (10, 20, etc), the total throughput
stays at around 750MB/s.  I only see the full 1200MB/s in btrfs when
I'm running a single read at a time (e.g. sequential reads with dd,
random reads with iozone, etc).

This feel like a bug or mis-configuration on my system.   As if can
read at the full speed, but just only with one stream running at a
time.  The options I have tried varying are "-l 64k" with mkfs.btrfs,
and "-o thread_pool=16" when mounting.  But, neither of those options
seem to change the behaviour.



Anyone know any reasons why I would see the speed drop when going from
one to more then one stream at a time with btrfs raid6?  We would like
to use btrfs (mostly for snapshots), but we do need to get the full
1200MB/s streaming speeds too..





Thanks,
Matt



___
Here's some example output..



Single thread = ~1.1GB/s
_____
kura1 persist # sysctl vm.drop_caches=1 ; dd if=/dev/zero
of=/var/data/persist/testfile bs=640k count=20000
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 7.14139 s, 1.8 GB/s

kura1 persist # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 11.2666 s, 1.2 GB/s

kura1 persist # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 11.5005 s, 1.1 GB/s

____



1 thread = ~1000MB/s ...
___
kura1 scripts # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/var/data/persist/testfile_$j bs=640k ; done
vm.drop_caches = 1
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 6.52018 s, 1.0 GB/s
kura1 scripts # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/var/data/persist/testfile_$j bs=640k ; done
vm.drop_caches = 1
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 6.55731 s, 999 MB/s
___


2 threads = ~750MB/s combined...
___
# sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd of=/dev/null
if=/var/data/persist/testfile_$j bs=640k & done
vm.drop_caches = 1
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 17.5068 s, 374 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 17.7599 s, 369 MB/s
___



20 threads = ~750MB/s combined...
___
# sysctl vm.drop_caches=1 ; for j in {1..20} ; do dd of=/dev/null
if=/var/data/persist/testfile_$j bs=640k & done
vm.drop_caches = 1
kura1 scripts # 10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 168.223 s, 39.0 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 168.275 s, 38.9 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 169.466 s, 38.7 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 169.606 s, 38.6 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 170.503 s, 38.4 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 170.629 s, 38.4 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 170.633 s, 38.4 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 170.744 s, 38.4 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 170.844 s, 38.4 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 170.896 s, 38.3 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.027 s, 38.3 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.135 s, 38.3 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.389 s, 38.2 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.414 s, 38.2 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.674 s, 38.2 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.897 s, 38.1 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.956 s, 38.1 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 171.995 s, 38.1 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 172.044 s, 38.1 MB/s
10000+0 records in
10000+0 records out
6553600000 bytes (6.6 GB) copied, 172.08 s, 38.1 MB/s
____



### Similar results with random reads in iozone...

1 thread = ~1000MB/s
_____
kura1 scripts # for j in {1..1} ; do sysctl vm.drop_caches=1 ; iozone
-f /var/data/10GBfolders/folder$j/iozone.DUMMY.1 -c -M -r 5120k -s 2g
-i 1 -w -+A 1 | tail -n 5 & done
vm.drop_caches = 1
[1] 22298
kura1 scripts #
     random  random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                  1077376  7288014

iozone test complete.
____



2 threads = ~750 MB/s combined...
___
# for j in {1..2} ; do sysctl vm.drop_caches=1 ; iozone -f
/var/data/10GBfolders/folder$j/iozone.DUMMY.1 -c -M -r 5120k -s 2g -i
1 -w -+A 1 | tail -n 5 & done
vm.drop_caches = 1
[1] 22302
vm.drop_caches = 1
[2] 22305
kura1 scripts #
     random  random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                   368864  5090095

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                   366834  5105457

iozone test complete.


20 threads = ~750MB/s combined...
___
# for j in {1..20} ; do sysctl vm.drop_caches=1 ; iozone -f
/var/data/10GBfolders/folder$j/iozone.DUMMY.1 -c -M -r 5120k -s 2g -i
1 -w -+A 1 | tail -n 5 & done

                                                             random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    40424  6459500

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    39678  5749776

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    39548  5417189

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38988  5924904

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38484  1963969

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38556  1793398

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38610  1343518

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38346  1394609

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38367  1163930

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38375  1143491

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38647  1046416

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38180  1115287

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38086  1192537

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38356  1120244

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38293  1138119

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    37966  1273741

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    38059  1201688

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    37947  1243573

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    37965  1245834

iozone test complete.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         2097152    5120                    37840  1354806

iozone test complete.
___



### Typical dstat output during multi-thread read running and then
finish and go idle...
___
----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
0  10  28  62   0   0| 716M    0 | 582B  870B|   0     0 |4398    16k
  0  12  28  59   0   0| 728M    0 | 454B  982B|   0     0 |4665    16k
  0  12  25  63   0   0| 761M    0 | 454B 1112B|   0     0 |4661    16k
  0  11  22  66   0   0| 719M    0 | 390B  742B|   0     0 |4519    16k
  0  13  21  65   0   0| 741M    0 | 524B 1036B|   0     0 |4706    16k
  0  17  19  63   0   0| 706M    0 |3302B 3558B|   0     0 |4638    15k
  0  16  17  67   0   0| 721M    0 |  16k   15k|   0     0 |5002    17k
  2  72   7  19   0   0| 514M    0 | 454B  486B|   0     0 |4174  8591
  3  97   0   0   0   0|   0     0 | 788B 2884B|   0     0 |1280   380
  1  38  61   0   0   0|   0     0 |1428B 7460B|   0     0 | 888   346
  0   0 100   0   0   0|   0     0 | 582B  678B|   0     0 |  92   106
  0   0 100   0   0   0|   0     0 |1606B 1766B|   0     0 |  66    59
  0   0 100   0   0   0|   0  4096B| 390B  742B|   0     0 |  90   112
  0   0 100   0   0   0|   0     0 | 454B  486B|   0     0 |  45    65
  0   0 100   0   0   0|   0     0 | 454B  614B|   0     0 |  56    77
___



### Some system info...
____
## Kernel = 3.9.0-rc4
# uname -a
Linux server 3.9.0-rc4 #4 SMP Fri Apr 5 00:58:28 UTC 2013 x86_64
Intel(R) Xeon(R) CPU E5-2630 0 @ 2.30GHz GenuineIntel GNU/Linux
# grep MemTotal /proc/meminfo
MemTotal:       65975896 kB

___
## 12 2.3 GHz Xeon cores...
kura1 scripts # head -n 26 /proc/cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 45
model name : Intel(R) Xeon(R) CPU E5-2630 0 @ 2.30GHz
stepping : 6
microcode : 0x616
cpu MHz : 2301.000
cache size : 15360 KB
physical id : 0
siblings : 12
core id : 0
cpu cores : 6
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2
x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4600.26
clflush size : 64
cache_alignment : 64
address sizes : 46 bits physical, 48 bits virtual
power management:
___
## Asus Z9PA-U8 MB
# dmidecode --type 1
# dmidecode 2.11
SMBIOS 2.7 present.

Handle 0x0001, DMI type 1, 27 bytes
System Information
Manufacturer: ASUSTeK COMPUTER INC.
Product Name: Z9PA-U8 Series
Version: 1.0X
Serial Number: To be filled by O.E.M.
UUID: 598C1800-5BCB-11D9-8F58-3085A9A7CBC7
Wake-up Type: Power Switch
SKU Number: SKU
Family: To be filled by O.E.M.
____
