Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36426 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750869AbdGaLlP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 07:41:15 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:34836)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dc94T-0005cP-CV
        for linux-btrfs@vger.kernel.org; Mon, 31 Jul 2017 12:41:13 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dc94N-0001Ji-OC
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 12:41:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22911.5971.350346.969146@tree.ty.sabi.co.uk>
Date: Mon, 31 Jul 2017 12:41:07 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <19527869.26.1501422186960.JavaMail.gkos@dynomob>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
        <22907.32175.311827.10738@tree.ty.sabi.co.uk>
        <19527869.26.1501422186960.JavaMail.gkos@dynomob>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

> grep 'model name' /proc/cpuinfo | sort -u 
> model name      : Intel(R) Xeon(R) CPU           E5645  @ 2.40GHz

Good, contemporary CPU with all accelerations.

> The sda device is a hardware RAID5 consisting of 4x8TB drives.
[ ... ]
> Strip Size          : 256 KB

So the full RMW data stripe length is 768KiB.

> [ ... ] don't see the previously reported behaviour of one of
> the kworker consuming 100% of the cputime, but the write speed
> difference between the compression ON vs OFF is pretty large.

That's weird; of course 'lzo' is a lot cheaper than 'zlib', but
in my test the much higher CPU time of the latter was spread
across many CPUs, while in your case it wasn't, even if the
E5645 has 6 CPUs and can do 12 threads. That seemed to point to
some high cost of finding free blocks, that is a very fragmented
free list, or something else.

> dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress oflag=direct
> 5368709120 bytes (5.4 GB, 5.0 GiB) copied, 26.0685 s, 206 MB/s

The results with 'oflag=direct' are not relevant, because Btrfs
behaves "differently" with that.

> mountflags: (rw,relatime,compress-force=zlib,space_cache=v2,subvolid=5,subvol=/)
[ ... ]
> dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress conv=fsync
> 5368709120 bytes (5.4 GB, 5.0 GiB) copied, 77.4845 s, 69.3 MB/s
> mountflags: (rw,relatime,compress-force=lzo,space_cache=v2,subvolid=5,subvol=/)
[ ... ]
> dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress conv=fsync
> 5368709120 bytes (5.4 GB, 5.0 GiB) copied, 122.321 s, 43.9 MB/s

That's pretty good for a RAID5 with 128KiB writes and a 768KiB
stripe size, on a 3ware, and looks like that the hw host adapter
does not have a persistent cache (battery backed usually). My
guess that watching transfer rates and latencies with 'iostat
-dk -zyx 1' did not happen.

> mountflags: (rw,relatime,space_cache=v2,subvolid=5,subvol=/)
[ ... ]
> dd if=/dev/sdb  of=./testing count=5120 bs=1M status=progress conv=fsync
> 5368709120 bytes (5.4 GB, 5.0 GiB) copied, 10.1033 s, 531 MB/s

I had mentioned in my previous reply the output of 'filefrag'.
That to me seems relevant here, because of RAID5 RMW and maximum
extent size with Brfs compression and strip/stripe size.

Perhaps redoing the tests with a 128KiB 'bs' *without*
compression would be interesting, perhaps even with 'oflag=sync'
instead of 'conv=fsync'.

It is hard for me to see a speed issue here with Btrfs: for
comparison I have done a simple test with a both a 3+1 MD RAID5
set with a 256KiB chunk size and a single block device on
"contemporary" 1T/2TB drives, capable of sequential transfer
rates of 150-190MB/s:

  soft#  grep -A2 sdb3 /proc/mdstat 
  md127 : active raid5 sde3[4] sdd3[2] sdc3[1] sdb3[0]
	729808128 blocks super 1.0 level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

with compression:

  soft#  mount -t btrfs -o commit=10,compress-force=zlib /dev/md/test5 /mnt/test5                                                       
  soft#  mount -t btrfs -o commit=10,compress-force=zlib /dev/sdg3 /mnt/sdg3
  soft#  rm -f /mnt/test5/testfile /mnt/sdg3/testfile

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/test5/testfile bs=1M count=10000 conv=fsync
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 94.3605 s, 111 MB/s
  0.01user 12.59system 1:34.36elapsed 13%CPU (0avgtext+0avgdata 2932maxresident)k
  13042144inputs+20482144outputs (3major+345minor)pagefaults 0swaps

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/sdg3/testfile bs=1M count=10000 conv=fsync
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 93.5885 s, 112 MB/s
  0.03user 12.35system 1:33.59elapsed 13%CPU (0avgtext+0avgdata 2940maxresident)k
  13042144inputs+20482400outputs (3major+346minor)pagefaults 0swaps

  soft#  filefrag /mnt/test5/testfile /mnt/sdg3/testfile
  /mnt/test5/testfile: 48945 extents found
  /mnt/sdg3/testfile: 49029 extents found

  soft#  btrfs fi df /mnt/test5/ | grep Data
  Data, single: total=7.00GiB, used=6.55GiB

  soft#  btrfs fi df /mnt/sdg3 | grep Data
  Data, single: total=7.00GiB, used=6.55GiB

  soft#  sysctl vm/drop_caches=3
  vm.drop_caches = 3
  soft#  /usr/bin/time dd iflag=fullblock if=/mnt/test5/testfile bs=1M count=10000 of=/dev/zero
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 23.2975 s, 450 MB/s
  0.01user 7.59system 0:23.32elapsed 32%CPU (0avgtext+0avgdata 2932maxresident)k
  13759624inputs+0outputs (3major+344minor)pagefaults 0swaps

  soft#  sysctl vm/drop_caches=3
  vm.drop_caches = 3
  soft#  /usr/bin/time dd iflag=fullblock if=/mnt/sdg3/testfile bs=1M count=10000 of=/dev/zero                                          
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 35.0032 s, 300 MB/s
  0.01user 8.46system 0:35.03elapsed 24%CPU (0avgtext+0avgdata 2924maxresident)k
  13750568inputs+0outputs (3major+345minor)pagefaults 0swaps

and without compression:

  soft#  mount -t btrfs -o commit=10 /dev/sdg3 /mnt/sdg3                                                                                
  soft#  rm -f /mnt/test5/testfile /mnt/sdg3/testfile

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/test5/testfile bs=1M count=10000 conv=fsync
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 74.7256 s, 140 MB/s
  0.02user 13.31system 1:14.72elapsed 17%CPU (0avgtext+0avgdata 2936maxresident)k
  13047640inputs+20483808outputs (3major+345minor)pagefaults 0swaps

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/sdg3/testfile bs=1M count=10000 conv=fsync
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 102.002 s, 103 MB/s
  0.02user 14.49system 1:42.00elapsed 14%CPU (0avgtext+0avgdata 2972maxresident)k
  13030592inputs+20484032outputs (3major+345minor)pagefaults 0swaps

  soft#  filefrag /mnt/test5/testfile /mnt/sdg3/testfile
  /mnt/test5/testfile: 23 extents found
  /mnt/sdg3/testfile: 13 extents found

> The CPU usage is pretty low as well. For example when the
> force-compress=zlib is in effect, the cpu usage is pretty low
> now.

That's 24 threads around 4-5% CPU each, that's around a 100% CPU
of system time spread around, for 70MB/s.

That's quite low. My report, which is mirrored by using 'pigz'
at the user level (very similar algorithms), was that 90MB/s
took 300% of an FX-6100 CPU at 3.3Ghz, and it is not that much
less efficient than a Xeon-E5645 at 2.4Ghz.

I have redone the test on a faster CPU:

  base#  grep 'model name' /proc/cpuinfo | sort -u
  model name      : AMD FX-8370E Eight-Core Processor
  base#  cpufreq-info | grep 'current CPU frequency'
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).
    current CPU frequency is 3.30 GHz (asserted by call to hardware).

And the result is (from a fast flash Samsung SSD to a fast 2TB
Toshiba drive):

  base#  mount -t btrfs -o commit=10,compress-force=zlib /dev/sdb6 /mnt/sdb6
  base#  /usr/bin/time dd iflag=fullblock if=/dev/sde6 of=/mnt/sdb6/testfile bs=1M count=10000 conv=fsync
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 41.7702 s, 251 MB/s
  0.00user 11.41system 0:43.41elapsed 26%CPU (0avgtext+0avgdata 3132maxresident)k
  20482288inputs+20503368outputs (1major+339minor)pagefaults 0swaps

With CPU usage as:

  top - 09:20:38 up 20:48,  4 users,  load average: 5.04, 2.03, 2.06
  Tasks: 576 total,  10 running, 566 sleeping,   0 stopped,   0 zombie
  %Cpu0  :  0.0 us, 94.0 sy,  0.7 ni,  0.0 id,  2.0 wa,  0.0 hi,  3.3 si,  0.0 st
  %Cpu1  :  0.3 us, 97.0 sy,  0.0 ni,  2.0 id,  0.7 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu2  :  3.0 us, 94.4 sy,  0.0 ni,  1.7 id,  1.0 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu3  :  0.7 us, 95.4 sy,  0.0 ni,  2.3 id,  1.3 wa,  0.0 hi,  0.3 si,  0.0 st
  %Cpu4  :  1.0 us, 95.7 sy,  0.3 ni,  2.6 id,  0.3 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu5  :  0.3 us, 94.7 sy,  0.0 ni,  4.3 id,  0.7 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu6  :  1.7 us, 94.3 sy,  0.0 ni,  3.0 id,  1.0 wa,  0.0 hi,  0.0 si,  0.0 st
  %Cpu7  :  0.0 us, 97.3 sy,  0.0 ni,  2.3 id,  0.3 wa,  0.0 hi,  0.0 si,  0.0 st
  KiB Mem:  16395076 total, 15987476 used,   407600 free,  5206304 buffers
  KiB Swap:        0 total,        0 used,        0 free.  8392648 cached Mem

so around 7 CPUs for 250MB/s, or around 35MB/s per CPU (more or
less what I also get user-level with 'pigz'), and it is hard for
me to imagine the Xeon-E5745 being twice as fast per-CPU for
"integer" work, but that's another discussion.
