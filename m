Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48766 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab2LILM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 06:12:28 -0500
Received: from merkaba.localnet (ppp-93-104-144-117.dynamic.mnet-online.de [93.104.144.117])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 34C91F8
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Dec 2012 12:11:09 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: How to refresh degraded BTRFS? free space fragmentation, file fragmentation...
Date: Sun, 9 Dec 2012 12:12:26 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201212091212.26248.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I have BTRFS on some systems since more than two years. My experience so
far is: Performance at the beginning is pretty good, but some of my more 
often used BTRFS filesystem degrade badly in different areas. On some
workloads pretty quickly.

There are also some fs however that did not degrade that badly. These were
some that have way more free space left than the ones that degraded
badly. About 900 GB freespace left on my eSATA backup disk with BTRFS
that is also quite new. About 80 GB left on my BTRFS RAID 1 local home disk
where I can build debian packages or kernels and such without the restrictions
NFS brings (root squash). These still appear to be fine, but I redid the local
home one with mkfs.btrfs -n 32768 and -l 32768 not to long ago, but I
think it was quite fine before anyway, so I might have overdone it here.
This already points at a way to prevent some degradation BTRFS filesystems:
Leave more free space.


1) fsync speed on my ThinkPad T23 has gone down that much that I use
eatmydata with apt-get dist-upgrade and Co. For that I intend to try out
3.7 kernel as soon as its packaged for Debian Experimental. (And hope
that it resumes nicely again, all kernels since 3.3 didn´t and I do not
really feel like bisecting this.) So I put this aside for now cause it may
not be applicable with most recent kernel. And fsync performance hasn´t
been good in the beginning. I think it degraded, but I am not completely
sure.


2) File fragmentation: Example with a SUSE Manager VirtualBox on an
BTRFS filesystem. The SUSE Manager box received packages for the software
channels and put the metadata inside a PostgreSQL database. A SLES Client
just installed.

filefrag showed fragments to go up quickly to 20000, 30000, 40000 and more.
The performance in the VMs was abysmal. I tried mount -o remount,autodefrag
and then BTRFS got down the fragments to some thousands instead of
ten thousands while raising disk activity quite a lot. The 2,5 inch external
eSATA disk was almost all the time completely in use. But the VM performance
was better. Not nice, but better.

I do not have more exact data right now.


3) Freespace fragmentation on the / filesystem on this ThinkPad T520 with
Intel SSD 320:

=== fstrim ===

merkaba:~> /usr/bin/time fstrim -v /
/: 6849871872 bytes were trimmed
0.00user 5.99system 0:44.69elapsed 13%CPU (0avgtext+0avgdata 752maxresident)k
0inputs+0outputs (0major+237minor)pagefaults 0swaps

It took a second or two in the beginning.


atop:

LVM |  rkaba-debian  |  busy     91%  |  read       0  |   write  10313  |  MBw/s  67.48  |  avio 0.20 ms  |
[…]
DSK |           sda  |  busy     90%  |  read       0  |   write  10319  |  MBw/s  67.54  |  avio 0.19 ms  |
[…]

  PID   TID RUID      THR   SYSCPU  USRCPU  VGROW  RGROW   RDDSK  WRDSK ST EXC  S CPUNR  CPU CMD         1/2
 6085     - root        1    0.29s   0.00s     0K     0K      0K     0K --   -  D     0  13% fstrim


10000 write requests in 10 seconds.


vmstat 1:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 3  0 1963688 3943380 156972 1827836    0    0     0     0 5421 15781  6  6 88  0
 0  0 1963688 3943132 156972 1827852    0    0     0     0 5733 16478  9  7 83  0
 1  0 1963688 3943008 156972 1827992    0    0     0     0 5050 14434  0  4 96  0
 1  0 1963688 3949768 156972 1826708    0    0     0     0 5246 14960  2  5 93  0
 0  0 1963688 3949644 156980 1826712    0    0     0    36 5104 14996  1  4 94  0
 0  0 1963688 3949768 156980 1826720    0    0     0     0 5102 15210  2  4 94  0
 3  0 1963688 3949644 156980 1826720    0    0     0     0 5321 15995  4  7 89  0
 0  0 1963688 3949396 156980 1827188    0    0     0     0 5316 15616  6  5 88  0
 1  0 1963688 3949148 156980 1827188    0    0     0     0 5102 14944  1  4 95  0
 1  0 1963688 3949272 156980 1827188    0    0     0     0 5510 15928  5  6 89  0
 1  0 1963688 3949272 156980 1827188    0    0     0    52 5107 15054  2  4 94  0
 0  0 1963688 3949396 156980 1826868    0    0     0     4 4930 14567  1  4 95  0
 1  0 1963688 3949396 156988 1826828    0    0     0    52 5132 15014  2  5 93  0
 3  0 1963688 3949396 156988 1826836    0    0     0     0 5015 14447  1  4 95  0
 0  0 1963688 3949520 156988 1826836    0    0     0     0 5233 15652  3  6 91  0
 1  0 1963684 3949612 156988 1827172    0    0     0  3032 2546 7555  6  4 84  6

After fstrim:

 0  0 1963684 3944244 157016 1827752    0    0     0     0  357 1018  2  1 97  0
 1  0 1963684 3943776 157024 1827776    0    0     0    64  634 1660  4  2 93  0
 0  0 1963684 3943872 157024 1827784    0    0     0     0  180  473  0  0 99  0


The I/O activity does not seem to be reflected in vmstat, I bet due to page
cache not involved.



=== fallocate ===

merkaba:/var/tmp> /usr/bin/time fallocate -l 2G fallocate-test
0.00user 118.85system 2:00.50elapsed 98%CPU (0avgtext+0avgdata 720maxresident)k
14912inputs+49112outputs (0major+227minor)pagefaults 0swaps


Peaks or CPU usage:

cpu |  sys      98%  |  user      0%  |  irq       0%  |   idle      0%  |  cpu002 w  2%  |  avgscal 100%  |

CPU |  sys     102%  |  user      3%  |  irq       0%  |   idle    295%  |  wait      1%  |  avgscal  52%  |
cpu |  sys      46%  |  user      1%  |  irq       0%  |   idle     53%  |  cpu001 w  0%  |  avgscal  63%  |
cpu |  sys      29%  |  user      1%  |  irq       0%  |   idle     70%  |  cpu003 w  0%  |  avgscal  57%  |
cpu |  sys      26%  |  user      1%  |  irq       0%  |   idle     73%  |  cpu002 w  0%  |  avgscal  55%  |
cpu |  sys       1%  |  user      1%  |  irq       0%  |   idle     99%  |  cpu000 w  0%  |  avgscal  32%  |

  PID   TID RUID      THR   SYSCPU  USRCPU  VGROW  RGROW   RDDSK  WRDSK ST EXC  S CPUNR  CPU CMD         1/3
 6458     - root        0    2m00s   0.00s     0K     0K       -      - NE   0  E     - 100% <fallocate>


martin@merkaba:~> vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0 1963676 3949112 157168 1827504   14   30   137    47   93   28 11  5 83  0
 0  0 1963676 3943148 157168 1828228    0    0     0     0  508 1177  4  2 94  0
 1  0 1963676 3943088 157168 1828164    0    0     0     0  584 1381  4  2 94  0
 0  0 1963676 3942892 157168 1828164    0    0     0     0  712 1627  6  3 91  0
 1  0 1963676 3942508 157168 1828420    0    0   168     0 1252 1432  0 17 82  0
 1  0 1963676 3941800 157168 1829012    0    0   136     0 1661 1700  1 26 73  0
 1  0 1963676 3940980 157176 1829796    0    0   172    44 1800 1842  1 25 74  0
 1  0 1963676 3941088 157176 1829656    0    0    92     0 1701 1101  0 25 75  0
 1  0 1963676 3945848 157176 1830092    0    0   140     0 1715 1300  0 25 75  0
 1  0 1963676 3945848 157176 1829912    0    0    76     0 1506 1163  0 25 75  0
 1  0 1963676 3939168 157176 1831120    0    0    40     0 1840 1164  1 25 74  0
 1  0 1963676 3938528 157176 1831440    0    0   172     0 1652 1617  1 25 74  0
 1  0 1963676 3939056 157176 1831224    0    0    44    48 1698 1798  1 27 73  0
 1  0 1963676 3944452 157176 1831264    0    0   104     0 1383 1106  1 25 74  0
 2  0 1963676 3944064 157176 1831644    0    0    88     0 1597 1301  1 26 74  0
 1  0 1963676 3943816 157176 1831832    0    0    64     0 1572 1179  1 26 74  0
 1  0 1963676 3943304 157176 1832232    0    0   148     0 2009 2600  1 25 74  0
 1  0 1963676 3942932 157176 1832752    0    0     8     0 1917 2300  1 26 73  0
 2  0 1963668 3942932 157184 1832816    0    0    36   148 1885 2269  2 26 72  0
 1  0 1963668 3942428 157184 1833076    0    0   136     0 2063 2823  1 26 73  0
 2  0 1963668 3942172 157184 1833628    0    0    84     0 2037 3236  4 26 69  0
 1  0 1963668 3941924 157184 1833692    0    0    56     0 1982 2167  1 26 73  0
 2  0 1963668 3927648 157184 1835672    0    0   124     0 2214 2734  6 26 68  0
 1  0 1963668 3927648 157184 1835756    0    0    80    72 1638 1668  1 25 74  0


Filesystem type is: 9123683e
File size of fallocate-test is 2147483648 (524288 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  2626450            2048 
   1    2048  3215128  2628498   2040 
   2    4088  3408631  3217168   2032 
   3    6120  3430045  3410663   2024 
   4    8144  3439999  3432069   2016 
   5   10160  3474610  3442015   1004 
   6   11164  3743715  3475614   1002 
   7   12166  2108412  3744717   1000 
   8   13166  2943991  2109412    998 
   9   14164  3107711  2944989    996 
  10   15160  3217168  3108707    994 
  11   16154  3324557  3218162    496 
  12   16650  3349504  3325053    495 
  13   17145  3350737  3349999    495 
  14   17640  3352158  3351232    494 
  15   18134  3355223  3352652    494 
  16   18628  3359558  3355717    493 
  17   19121  3367645  3360051    493 
  18   19614  3369156  3368138    492 
  19   20106  3382494  3369648    492 
  20   20598  3383027  3382986    491 
  21   21089  3385838  3383518    491 
  22   21580  3442449  3386329    490 
  23   22070  3470434  3442939    490 
  24   22560  3500244  3470924    489 
  25   23049  3532609  3500733    489 
  26   23538  3559176  3533098    489 
  27   24027  3561437  3559665    488 
  28   24515  3565004  3561925    488 
  29   25003  3569963  3565492    487 
  30   25490  3573446  3570450    487 
  31   25977  3735991  3573933    486 
  32   26463  3745098  3736477    486 
  33   26949  3901106  3745584    485 
  34   27434  3901681  3901591    485 
  35   27919   956052  3902166    484 
  36   28403   984140   956536    484 
  37   28887  1017986   984624    483 
  38   29370  1032244  1018469    483 
  39   29853  1478810  1032727    482 
  40   30335  1479480  1479292    482 
  41   30817  1480016  1479962    481 
  42   31298  1512813  1480497    481 
  43   31779  1515627  1513294    480 
  44   32259  1759660  1516107    480 
  45   32739  1866977  1760140    480 
  46   33219  2025589  1867457    479 
  47   33698  2044003  2026068    479 
  48   34177  2233664  2044482    478 
  49   34655  2246706  2234142    478 
  50   35133  2336760  2247184    477 
  51   35610  2348377  2337237    477 
  52   36087  2396156  2348854    476 
  53   36563  2453672  2396632    476 
  54   37039  2505829  2454148    475 
  55   37514  2559971  2506304    475 
  56   37989  2568049  2560446    474 
  57   38463  2569417  2568523    474 
  58   38937  2575922  2569891    473 
  59   39410  2578488  2576395    473 
  60   39883  2989056  2578961    946 
  61   40829  2995464  2990002    472 
  62   41301  3197446  2995936    471 
  63   41772  3206085  3197917    471 
  64   42243  3467053  3206556    470 
  65   42713  2579027  3467523    470 
  66   43183  2727531  2579497    469 
  67   43652  2729381  2728000    469 
  68   44121  2730137  2729850    468 
  69   44589  2875164  2730605    468 
  70   45057  2902010  2875632    467 
  71   45524  2917719  2902477    467 
  72   45991  2920037  2918186    467 
  73   46458  2930483  2920504    466 
  74   46924  2931689  2930949    466 
  75   47390  2941544  2932155    465 
  76   47855  2943422  2942009    465 
  77   48320  2955072  2943887    464 
  78   48784  2962691  2955536    464 
  79   49248  2964241  2963155    463 
  80   49711  2965864  2964704    463 
  81   50174  2979347  2966327    463 
  82   50637  2985719  2979810    462 
  83   51099  3033228  2986181    462 
  84   51561  4096111  3033690    461 
  85   52022  2913433  4096572    461 
  86   52483  2914231  2913894    230 
  87   52713  2915298  2914461    230 
  88   52943  2917405  2915528    230 
  89   53173  2918359  2917635    230 
  90   53403  2087430  2918589    459 
  91   53862  2109512  2087889    229 
  92   54091  2110584  2109741    229 
  93   54320  2111695  2110813    229 
  94   54549  2157184  2111924    229 
  95   54778  2158300  2157413    229 
  96   55007  2165613  2158529    229 
  97   55236  2167222  2165842    229 
  98   55465  2196837  2167451    228 
  99   55693  2199378  2197065    228 
 […]
 306  106611  1243376  1168146    203 
 307  106814  1245114  1243579    203 
 308  107017  1294949  1245317    203 
 309  107220  1408543  1295152    203 
 310  107423  1408788  1408746    203 
 311  107626  1448445  1408991    203 
 312  107829  1451116  1448648    203 
 313  108032  1453560  1451319    203 
 314  108235  1459015  1453763    203 
 315  108438  1460375  1459218    203 
 316  108641  1461372  1460578    202 
 317  108843  1471758  1461574    202 
[…]
4526  522694  2939615  3455932     49 
4527  522743  2517410  2939664     48 
4528  522791  2460124  2517458     46 
4529  522837  2458204  2460170     45 
4530  522882  2479853  2458249     43 
4531  522925  1687125  2479896     42 
4532  522967   646064  1687167     41 
4533  523008   497470   646105     40 
4534  523048  4111482   497510     77 
4535  523125  4097378  4111559     72 
4536  523197  3949964  4097450     68 
4537  523265  3499481  3950032     63 
4538  523328  3499660  3499544     60 
4539  523388  3495885  3499720     56 
4540  523444  3498714  3495941     52 
4541  523496  2960575  3498766     49 
4542  523545  2482351  2960624     46 
4543  523591  2481927  2482397     43 
4544  523634   532779  2481970     40 
4545  523674  4170769   532819     76 
4546  523750  3935305  4170845     67 
4547  523817  3498776  3935372     58 
4548  523875  3502955  3498834     51 
4549  523926  2489644  3503006     45 
4550  523971   338996  2489689     39 
4551  524010  4035101   339035     69 
4552  524079  3506596  4035170     52 
4553  524131   399363  3506648     39 
4554  524170  3550735   399402     59 
4555  524229  3553226  3550794     59 eof
fallocate-test: 4556 extents found

But:

merkaba:/var/tmp> /usr/bin/time rm fallocate-test
0.00user 0.24system 0:00.38elapsed 63%CPU (0avgtext+0avgdata 784maxresident)k
4464inputs+36184outputs (0major+243minor)pagefaults 0swaps





Some more information on the filesystem in question:

merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs fi sh
failed to read /dev/sr0
Label: 'debian'  uuid: […]
        Total devices 1 FS bytes used 13.56GB
        devid    1 size 18.62GB used 18.62GB path /dev/dm-0

Btrfs v0.19-239-g0155e84


merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs fi df /
Disk size:                18.62GB
Disk allocated:           18.62GB
Disk unallocated:            0.00
Used:                     13.56GB
Free (Estimated):          3.31GB       (Max: 3.31GB, min: 3.31GB)
Data to disk ratio:          91 %


merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs fi disk-usage /
Data,Single: Size:15.10GB, Used:12.94GB
   /dev/dm-0       15.10GB

Metadata,Single: Size:8.00MB, Used:0.00
   /dev/dm-0        8.00MB

Metadata,DUP: Size:1.75GB, Used:630.11MB
   /dev/dm-0        3.50GB

System,Single: Size:4.00MB, Used:0.00
   /dev/dm-0        4.00MB

System,DUP: Size:8.00MB, Used:4.00KB
   /dev/dm-0       16.00MB

Unallocated:
   /dev/dm-0          0.00
merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs dev disk-usage /
/dev/dm-0          18.62GB
   Data,Single:             15.10GB
   Metadata,Single:          8.00MB
   Metadata,DUP:             3.50GB
   System,Single:            4.00MB
   System,DUP:              16.00MB
   Unallocated:                0.00



Compared to that an Ext4 in /home on the SSD that is almost full doesn´t
show much signs aging degradation yet inspite being quite full and nepomuk
trashes it quite good at times (virtuoso database):

merkaba:/home> /usr/bin/time fallocate -l 2G fallocate-test
0.00user 0.01system 0:00.01elapsed 100%CPU (0avgtext+0avgdata 720maxresident)k
0inputs+0outputs (0major+229minor)pagefaults 0swaps

(without FL_NO_HIDE_STALE stuff of course :)

merkaba:/home> filefrag -v fallocate-test 
Filesystem type is: ef53
File size of fallocate-test is 2147483648 (524288 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0 22091776            2048 unwritten
   1    2048 22102016 22093824   2048 unwritten
   2    4096 22149120 22104064   2048 unwritten
   3    6144 22224896 22151168   2048 unwritten
   4    8192 22261760 22226944   2048 unwritten
   5   10240 22274048 22263808   2048 unwritten
   6   12288 22278144 22276096   4096 unwritten
   7   16384 22292480 22282240   2048 unwritten
   8   18432 22306816 22294528   8192 unwritten
   9   26624 22355968 22315008   4096 unwritten
  10   30720 22411264 22360064   2048 unwritten
  11   32768 22425600 22413312   4096 unwritten
  12   36864 22476800 22429696   2048 unwritten
  13   38912 22577152 22478848   2048 unwritten
  14   40960 22603776 22579200   2048 unwritten
  15   43008 22607872 22605824   2048 unwritten
  16   45056 22620160 22609920   2048 unwritten
  17   47104 22614016 22622208   4096 unwritten
  18   51200 22646784 22618112   2048 unwritten
  19   53248 22697984 22648832   2048 unwritten
  20   55296 22738944 22700032   2048 unwritten
  21   57344 22769664 22740992   4096 unwritten
  22   61440 22775808 22773760   6144 unwritten
  23   67584 22818816 22781952   4096 unwritten
  24   71680 22867968 22822912   4096 unwritten
  25   75776 22896640 22872064   8192 unwritten
[…]
 150  483328 29599744 29501440   2048 unwritten
 151  485376 29632512 29601792   2048 unwritten
 152  487424 29646848 29634560   8192 unwritten
 153  495616 29669376 29655040  10240 unwritten
 154  505856 29685760 29679616   2048 unwritten
 155  507904 29691904 29687808   2048 unwritten
 156  509952 29696000 29693952   2048 unwritten
 157  512000 29700096 29698048   2048 unwritten
 158  514048 29712384 29702144   2048 unwritten
 159  516096 29718528 29714432   2048 unwritten
 160  518144 29736960 29720576   2048 unwritten
 161  520192 29743104 29739008   2048 unwritten
 162  522240 29767680 29745152   2048 unwritten,eof
fallocate-test: 163 extents found


merkaba:/home> /usr/bin/time rm fallocate-test 
0.00user 0.00system 0:00.00elapsed 100%CPU (0avgtext+0avgdata 784maxresident)k
0inputs+0outputs (0major+244minor)pagefaults 0swaps


merkaba:~> LANG=C df -hT /home
Filesystem               Type  Size  Used Avail Use% Mounted on
/dev/mapper/merkaba-home ext4  221G  209G  8.8G  96% /home

I know this is still twice as much free space than with the BTRFS volume.
And a different workload. And the BTRFS filesystem has been a bit fuller
at times. I just do not have two filesystems that degrade by exactly the
same workload at hand.


merkaba:~> e2freefrag /dev/merkaba/home
Device: /dev/merkaba/home
Blocksize: 4096 bytes
Total blocks: 58593280
Free blocks: 2921471 (5.0%)

Min. free extent: 4 KB 
Max. free extent: 57344 KB
Avg. free extent: 224 KB
Num. free extent: 51323

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    4K...    8K-  :         12118         12118    0.41%
    8K...   16K-  :         13221         29823    1.02%
   16K...   32K-  :          8431         42289    1.45%
   32K...   64K-  :          5952         63186    2.16%
   64K...  128K-  :          3657         80646    2.76%
  128K...  256K-  :          2483        109538    3.75%
  256K...  512K-  :          1740        154664    5.29%
  512K... 1024K-  :          1404        255117    8.73%
    1M...    2M-  :          1302        468132   16.02%
    2M...    4M-  :           487        335516   11.48%
    4M...    8M-  :           255        357015   12.22%
    8M...   16M-  :           182        455025   15.58%
   16M...   32M-  :            76        385687   13.20%
   32M...   64M-  :            15        140176    4.80%


merkaba:/home> e4defrag -c /home
<Fragmented files>                             now/best       size/ext
1. /home/martin/Mail/[… some kmail index …]
                                                 7/1              4 KB
2. /home/martin/Mail/[… some kmail index …]
                                                 4/1              4 KB
3. /home/martin/[…]/.bzr/checkout/dirstate
                                                 4/1              4 KB
4. /home/martin/[… some small kexi database …].kexi
                                                 6/1              4 KB
5. /home/martin/.kde/share/apps/kraft/sqlite/kraft.db
                                                15/1              5 KB

 Total/best extents                             926792/904756
 Average size per extent                        238 KB
 Fragmentation score                            0
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This directory (/home) does not need defragmentation.
 Done.





My questions now are:

a) Are there other ways a BTRFS filesystem can degrade?


b) How to diagnose degradation of BTRFS? How to diagnose which kind of
aging slows down a given BTRFS filesystem?

- some tool to measure free space fragmentation like e2freefrag (see
above)?

- some tool to measure file fragmentation like e4defrag -c (see above)?


I think there might be some of this already?

- btrfs-calc-size for tree diagnosing?

merkaba:~> btrfs-calc-size /dev/merkaba/debian 
Calculating size of root tree
        16.00KB total size, 0.00 inline data, 1 nodes, 3 leaves, 2 levels
Calculating size of extent tree
        53.66MB total size, 0.00 inline data, 222 nodes, 13515 leaves, 4 levels
Calculating size of csum tree
        19.58MB total size, 0.00 inline data, 76 nodes, 4936 leaves, 3 levels
Calculatin' size of fs tree
        554.04MB total size, 198.86MB inline data, 2142 nodes, 139693 leaves, 4 levels

Levels seem sane to me.

- btrfs-debug-tree? But thats too much output for a regular admin I think.



b) What do to about it?

While I understand that the fragmentation issues are quite deeply related
to the copy on write nature of BTRFS they are still an issue. Even on SSDs
as I showed above.

Granted boot speed of the filesystem and creating small files are still fast
enough on the SSD. The SSD seems to compensate over that fragmentation
quite well.

But still is there anything that can be done?


i) By enhancing BTRFS?

- insert your suggestion here


ii) By some admin tasks or filesystem maintenance? Are the safe ones that
do really improve the FS layout instead of making it worse? Once I tried
btrfs filesystem balance on the root filesystem mentioned above, and the
net result was, that boot speed doubled according to systemd-analyze.

- maybe (still) some btrfs filesystem balance run?

- maybe some btrfs filesystem defragment runs? By a script recursively,
as long as thats not implemented within btrfs command itself. I would
prefer that (along the lines of e4defrag also with option -c to first
diagnose whether defragmentation does make sense]

What kinds of degradation are important to performance and which ones
are not?


iii) And what can be done to prevent degradation?

- leave more free space, maybe lots more free space?




I then just reformatted the volume and never tried a balance again so far.
But I am ready to try suggestions on this FS, as I plan to redo it with
mkfs.btrfs -l 16384 -n 16384 (big metadata) anyway.


I think this will be questions admins will have when first production
BTRFS filesystem start to degrade. And I thought it might be a good idea to
think about good answers to them.

Feel free to split out the thread by changing subject lines into free space
fragmentation, file fragmentation ... where it makes sense.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
