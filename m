Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36302 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752492AbdG1SIz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 14:08:55 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:35331)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1db9gz-0001DD-9S
        for linux-btrfs@vger.kernel.org; Fri, 28 Jul 2017 19:08:53 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1db9gt-0006Tf-Lt
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 19:08:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22907.32175.311827.10738@tree.ty.sabi.co.uk>
Date: Fri, 28 Jul 2017 19:08:47 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <8446582.541.1501260065690.JavaMail.gkos@dynomob>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
