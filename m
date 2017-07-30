Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.132]:49102 "EHLO mail.arhont.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751360AbdG3NnN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Jul 2017 09:43:13 -0400
Date: Sun, 30 Jul 2017 14:42:41 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.UK>
Message-ID: <19527869.26.1501422186960.JavaMail.gkos@dynomob>
In-Reply-To: <22907.32175.311827.10738@tree.ty.sabi.co.uk>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob> <8446582.541.1501260065690.JavaMail.gkos@dynomob> <22907.32175.311827.10738@tree.ty.sabi.co.uk>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the comments. Initially the system performed well, I don't have the benchmark details written, but the compressed vs non compressed speeds were more or less similar. However, after several weeks of usage, the system started experiencing the described slowdowns, thus I started investigating the problem. This indeed is a backup drive, but it predominantly contains large files.

# ls -lahR | awk '/^-/ {print $5}' | sort | uniq -c  | sort -n | tail -n 15
      5 322
      5 396
      5 400
      6 1000G
      6 11
      6 200G
      8 24G
      8 48G
     13 500G
     20 8.0G
     25 165G
     32 20G
     57 100G
    103 50G
    201 10G


# grep 'model name' /proc/cpuinfo | sort -u 
model name      : Intel(R) Xeon(R) CPU           E5645  @ 2.40GHz

# lsscsi | grep 'sd[ae]'
[4:2:0:0]    disk    LSI      MR9260-8i        2.13  /dev/sda 


The sda device is a hardware RAID5 consisting of 4x8TB drives.

Virtual Drive: 0 (Target Id: 0)
Name                :
RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
Size                : 21.830 TB
Sector Size         : 512
Is VD emulated      : Yes
Parity Size         : 7.276 TB
State               : Optimal
Strip Size          : 256 KB
Number Of Drives    : 4
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU
Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU
Default Access Policy: Read/Write
Current Access Policy: Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
Bad Blocks Exist: No
Is VD Cached: No
Number of Spans: 1
Span: 0 - Number of PDs: 4


I have changed the mount flags as suggested, and I don't see the previously reported behaviour of one of the kworker consuming 100% of the cputime, but the write speed difference between the compression ON vs OFF is pretty large. 
Have run several tests under with zlib, lzo and no compression and the results are rather strange.

mountflags: (rw,relatime,compress-force=zlib,space_cache=v2,subvolid=5,subvol=/)
dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress 
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 93.3418 s, 57.5 MB/s

dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress oflag=direct
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 26.0685 s, 206 MB/s

dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress conv=fsync
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 77.4845 s, 69.3 MB/s



mountflags: (rw,relatime,compress-force=lzo,space_cache=v2,subvolid=5,subvol=/)
dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress 
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 116.246 s, 46.2 MB/s


dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress oflag=direct
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 14.704 s, 365 MB/s


dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress conv=fsync
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 122.321 s, 43.9 MB/s



mountflags: (rw,relatime,space_cache=v2,subvolid=5,subvol=/)

dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress 
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 32.2551 s, 166 MB/s

dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress oflag=direct
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 19.9464 s, 269 MB/s

dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress conv=fsync
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 10.1033 s, 531 MB/s


The CPU usage is pretty low as well. For example when the  force-compress=zlib is in effect, the cpu usage is pretty low now.

Linux 4.10.0-28-generic (ais-backup1)   30/07/17        _x86_64_        (12 CPU)

14:31:27        CPU     %user     %nice   %system   %iowait    %steal     %idle
14:31:28        all      0.00      0.00      1.50      0.00      0.00     98.50
14:31:29        all      0.00      0.00      4.78      3.52      0.00     91.69
14:31:30        all      0.08      0.00      4.92      3.75      0.00     91.25
14:31:31        all      0.00      0.00      4.76      3.76      0.00     91.49
14:31:32        all      0.00      0.00      4.76      3.76      0.00     91.48
14:31:33        all      0.08      0.00      4.67      3.76      0.00     91.49
14:31:34        all      0.00      0.00      4.76      3.68      0.00     91.56
14:31:35        all      0.08      0.00      4.76      3.76      0.00     91.40
14:31:36        all      0.00      0.00      4.60      3.77      0.00     91.63
14:31:37        all      0.00      0.00      4.68      3.68      0.00     91.64
14:31:38        all      0.08      0.00      4.52      3.76      0.00     91.64
14:31:39        all      0.08      0.00      4.68      3.76      0.00     91.48
14:31:40        all      0.08      0.00      4.52      3.76      0.00     91.64
14:31:41        all      0.00      0.00      4.61      3.77      0.00     91.62
14:31:42        all      0.08      0.00      5.07      3.74      0.00     91.10
14:31:43        all      0.00      0.00      4.68      3.68      0.00     91.64
14:31:44        all      0.00      0.00      4.84      5.09      0.00     90.08
14:31:45        all      0.17      0.00      4.67      4.75      0.00     90.42
14:31:46        all      0.00      0.00      4.60      3.76      0.00     91.64
14:31:47        all      0.08      0.00      5.07      3.66      0.00     91.18
14:31:48        all      0.00      0.00      5.01      3.68      0.00     91.31
14:31:49        all      0.00      0.00      4.76      3.68      0.00     91.56
14:31:50        all      0.08      0.00      4.59      3.59      0.00     91.73
14:31:51        all      0.00      0.00      2.67      1.92      0.00     95.41






----- Original Message -----
From: "Peter Grandi" <pg@btrfs.list.sabi.co.UK>
To: "Linux fs Btrfs" <linux-btrfs@vger.kernel.org>
Sent: Friday, 28 July, 2017 8:08:47 PM
Subject: Re: Btrfs + compression = slow performance and high cpu usage

> I am stuck with a problem of btrfs slow performance when using
> compression. [ ... ]

That to me looks like an issue with speed, not performance, and
in particular with PEBCAK issues.

As to high CPU usage, when you find a way to do both compression
and checksumming without using much CPU time, please send patches
urgently :-).

In your case the increase in CPU time is bizarre. I have the
Ubuntu 4.4 "lts-xenial" kernel and what you report does not
happen here (with a few little changes):

  soft#  grep 'model name' /proc/cpuinfo | sort -u
  model name      : AMD FX(tm)-6100 Six-Core Processor
  soft#  cpufreq-info | grep 'current CPU frequency'
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).

  soft#  lsscsi | grep 'sd[ae]'
  [0:0:0:0]    disk    ATA      HFS256G32MNB-220 3L00  /dev/sda
  [5:0:0:0]    disk    ATA      ST2000DM001-1CH1 CC44  /dev/sde

  soft#  mkfs.btrfs -f /dev/sde3
  [ ... ]
  soft#  mount -t btrfs -o discard,autodefrag,compress=lzo,compress-force,commit=10 /dev/sde3 /mnt/sde3

  soft#  df /dev/sda6 /mnt/sde3
  Filesystem     1M-blocks  Used Available Use% Mounted on
  /dev/sda6          90048 76046     14003  85% /
  /dev/sde3         237568    19    235501   1% /mnt/sde3

The above is useful context information that was "amazingly"
omitted from your reported.

In dmesg I see (not the "force zlib compression"):

  [327730.917285] BTRFS info (device sde3): turning on discard
  [327730.917294] BTRFS info (device sde3): enabling auto defrag
  [327730.917300] BTRFS info (device sde3): setting 8 feature flag
  [327730.917304] BTRFS info (device sde3): force zlib compression
  [327730.917313] BTRFS info (device sde3): disk space caching is enabled
  [327730.917315] BTRFS: has skinny extents
  [327730.917317] BTRFS: flagging fs with big metadata feature
  [327730.920740] BTRFS: creating UUID tree

and the result is:

  soft#  pv -tpreb /dev/sda6 | time dd iflag=fullblock of=/mnt/sde3/testfile bs=1M count=10000 oflag=direct
  10000+0 records in17MB/s] [==>                                ] 11% ETA 0:15:06
  10000+0 records out
  10485760000 bytes (10 GB) copied, 112.845 s, 92.9 MB/s
  0.05user 9.93system 1:53.20elapsed 8%CPU (0avgtext+0avgdata 3016maxresident)k
  120inputs+20496000outputs (1major+346minor)pagefaults 0swaps
  9.77GB 0:01:53 [88.3MB/s] [==>                                ]
  11%

  soft#  btrfs fi df /mnt/sde3/
  Data, single: total=10.01GiB, used=9.77GiB
  System, DUP: total=8.00MiB, used=16.00KiB
  Metadata, DUP: total=1.00GiB, used=11.66MiB
  GlobalReserve, single: total=16.00MiB, used=0.00B

As it was running system CPU time was under 20% of one CPU:

  top - 18:57:29 up 3 days, 19:27,  4 users,  load average: 5.44, 2.82, 1.45
  Tasks: 325 total,   1 running, 324 sleeping,   0 stopped,   0 zombie
  %Cpu0  :  0.0 us,  2.3 sy,  0.0 ni, 91.3 id,  6.3 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu1  :  0.0 us,  1.3 sy,  0.0 ni, 78.5 id, 20.2 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu2  :  0.3 us,  5.8 sy,  0.0 ni, 81.0 id, 12.5 wa,  0.0 hi,  0.3 si,  0.0 st
  %Cpu3  :  0.3 us,  3.4 sy,  0.0 ni, 91.9 id,  4.4 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu4  :  0.3 us, 10.6 sy,  0.0 ni, 55.4 id, 33.7 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu5  :  0.0 us,  0.3 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
  KiB Mem:   8120660 total,  5162236 used,  2958424 free,  4440100 buffers
  KiB Swap:        0 total,        0 used,        0 free.   351848 cached Mem

    PID  PPID USER      PR  NI    VIRT    RES    DATA  %CPU %MEM     TIME+ TTY      COMMAND
  21047 21046 root      20   0    8872   2616    1364  12.9  0.0   0:02.31 pts/3    dd iflag=fullblo+
  21045  3535 root      20   0    7928   1948     460  12.3  0.0   0:00.72 pts/3    pv -tpreb /dev/s+
  21019     2 root      20   0       0      0       0   1.3  0.0   0:42.88 ?        [kworker/u16:1]

Of course "oflag=direct" is a rather "optimistic" option in this
context, so I tried again with something more sensible:

  soft#  pv -tpreb /dev/sda6 | time dd iflag=fullblock of=/mnt/sde3/testfile bs=1M count=10000 conv=fsync
  10000+0 records in.4MB/s] [==>                                ] 11% ETA 0:14:41
  10000+0 records out
  10485760000 bytes (10 GB) copied, 110.523 s, 94.9 MB/s
  0.03user 8.94system 1:50.71elapsed 8%CPU (0avgtext+0avgdata 3024maxresident)k
  136inputs+20499648outputs (1major+348minor)pagefaults 0swaps
  9.77GB 0:01:50 [90.3MB/s] [==>                                ] 11%

  soft#  btrfs fi df /mnt/sde3/
  Data, single: total=7.01GiB, used=6.35GiB
  System, DUP: total=8.00MiB, used=16.00KiB
  Metadata, DUP: total=1.00GiB, used=15.81MiB
  GlobalReserve, single: total=16.00MiB, used=0.00B

As it was running system as expected CPU time was around 55-60%
of each of 6 CPUs:

  top - 18:56:03 up 3 days, 19:26,  4 users,  load average: 2.31, 1.39, 0.90
  Tasks: 325 total,   5 running, 320 sleeping,   0 stopped,   0 zombie
  %Cpu0  :  0.0 us, 57.9 sy,  0.0 ni, 28.3 id, 13.8 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu1  :  0.0 us, 46.8 sy,  0.0 ni, 36.9 id, 16.3 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu2  :  0.0 us, 72.8 sy,  0.0 ni, 13.4 id, 12.8 wa,  0.0 hi,  1.0 si,  0.0 st
  %Cpu3  :  0.3 us, 63.8 sy,  0.0 ni, 17.4 id, 17.4 wa,  0.0 hi,  1.0 si,  0.0 st
  %Cpu4  :  0.0 us, 53.3 sy,  0.0 ni, 29.7 id, 17.0 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu5  :  0.0 us, 54.0 sy,  0.0 ni, 32.7 id, 13.3 wa,  0.0 hi,  0.0 si,  0.0 st
  KiB Mem:   8120660 total,  7988368 used,   132292 free,  3646496 buffers
  KiB Swap:        0 total,        0 used,        0 free.  3967692 cached Mem

    PID  PPID USER      PR  NI    VIRT    RES    DATA  %CPU %MEM     TIME+ TTY      COMMAND
  21022     2 root      20   0       0      0       0  45.2  0.0   0:19.69 ?        [kworker/u16:5]
  21028     2 root      20   0       0      0       0  39.9  0.0   0:27.84 ?        [kworker/u16:11]
  21043     2 root      20   0       0      0       0  39.9  0.0   0:04.26 ?        [kworker/u16:19]
  21009     2 root      20   0       0      0       0  38.2  0.0   0:24.50 ?        [kworker/u16:0]
  21037     2 root      20   0       0      0       0  34.2  0.0   0:17.94 ?        [kworker/u16:17]
  21021     2 root      20   0       0      0       0  19.9  0.0   0:14.83 ?        [kworker/u16:3]
  21019     2 root      20   0       0      0       0  19.3  0.0   0:29.98 ?        [kworker/u16:1]
  21034     2 root      20   0       0      0       0  19.3  0.0   0:28.18 ?        [kworker/u16:14]
  21030     2 root      20   0       0      0       0  17.9  0.0   0:24.85 ?        [kworker/u16:13]
  21035     2 root      20   0       0      0       0  17.6  0.0   0:20.75 ?        [kworker/u16:15]
  21023     2 root      20   0       0      0       0  15.0  0.0   0:28.20 ?        [kworker/u16:6]
  21020     2 root      20   0       0      0       0   9.6  0.0   0:27.02 ?        [kworker/u16:2]
  21040  3535 root      20   0    7928   1872     460   8.6  0.0   0:04.11 pts/3    pv -tpreb /dev/s+
  21042 21041 root      20   0    8872   2628    1364   8.3  0.0   0:05.19 pts/3    dd iflag=fullblo+
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
