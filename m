Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36852 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbdGaMuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 08:50:18 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:34876)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dcA9I-0008JI-DO
        for linux-btrfs@vger.kernel.org; Mon, 31 Jul 2017 13:50:16 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dc9tW-0001UR-Pz
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 13:33:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22911.9142.450242.405693@tree.ty.sabi.co.uk>
Date: Mon, 31 Jul 2017 13:33:58 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <22911.5971.350346.969146@tree.ty.sabi.co.uk>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
        <22907.32175.311827.10738@tree.ty.sabi.co.uk>
        <19527869.26.1501422186960.JavaMail.gkos@dynomob>
        <22911.5971.350346.969146@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] It is hard for me to see a speed issue here with
> Btrfs: for comparison I have done a simple test with a both a
> 3+1 MD RAID5 set with a 256KiB chunk size and a single block
> device on "contemporary" 1T/2TB drives, capable of sequential
> transfer rates of 150-190MB/s: [ ... ]

The figures after this are a bit on the low side because I
realized looking at 'vmstat' that the source block device 'sda6'
was being a bottleneck, as the host has only 8GiB instead of the
16GiB I misremembered, and also 'sda' is a relatively slow flash
SSD that reads are most at around 220MB/s. So I have redone the
simple tests with a transfer size of 3GB, which ensures that
all reads are from memory cache:

with compression:

  soft#  mount -t btrfs -o commit=10,compress-force=zlib /dev/md/test5 /mnt/test5
  soft#  mount -t btrfs -o commit=10,compress-force=zlib /dev/sdg3 /mnt/sdg3
  soft#  rm -f /mnt/test5/testfile /mnt/sdg3/testfile                                                                                   

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/test5/testfile bs=1M count=3000 conv=fsync
  3000+0 records in
  3000+0 records out
  3145728000 bytes (3.1 GB) copied, 15.8869 s, 198 MB/s
  0.00user 2.80system 0:15.88elapsed 17%CPU (0avgtext+0avgdata 3056maxresident)k
  0inputs+6148256outputs (0major+346minor)pagefaults 0swaps

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/sdg3/testfile bs=1M count=3000 conv=fsync
  3000+0 records in
  3000+0 records out
  3145728000 bytes (3.1 GB) copied, 16.9663 s, 185 MB/s
  0.00user 2.61system 0:16.96elapsed 15%CPU (0avgtext+0avgdata 3056maxresident)k
  0inputs+6144672outputs (0major+346minor)pagefaults 0swaps

  soft#  btrfs fi df /mnt/test5/ | grep Data                                                                
  Data, single: total=3.00GiB, used=2.28GiB
  soft#  btrfs fi df /mnt/sdg3 | grep Data
  Data, single: total=3.00GiB, used=2.28GiB

  soft#  filefrag /mnt/test5/testfile /mnt/sdg3/testfile
  /mnt/test5/testfile: 8811 extents found
  /mnt/sdg3/testfile: 8759 extents found

Slightly weird that with a 3GB size the number of extents is
almost double that for the 10GB, but I guess that depends on
speed.

Then without compression:

  soft#  mount -t btrfs -o commit=10 /dev/md/test5 /mnt/test5
  soft#  mount -t btrfs -o commit=10 /dev/sdg3 /mnt/sdg3
  soft#  rm -f /mnt/test5/testfile /mnt/sdg3/testfile

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/test5/testfile bs=1M count=3000 conv=fsync
  3000+0 records in
  3000+0 records out
  3145728000 bytes (3.1 GB) copied, 8.06841 s, 390 MB/s
  0.00user 3.90system 0:08.80elapsed 44%CPU (0avgtext+0avgdata 2880maxresident)k
  0inputs+6153856outputs (0major+345minor)pagefaults 0swaps

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/sdg3/testfile bs=1M count=3000 conv=fsync
  3000+0 records in
  3000+0 records out
  3145728000 bytes (3.1 GB) copied, 30.215 s, 104 MB/s
  0.00user 4.82system 0:30.93elapsed 15%CPU (0avgtext+0avgdata 2888maxresident)k
  0inputs+6152128outputs (0major+347minor)pagefaults 0swaps

  soft#  filefrag /mnt/test5/testfile /mnt/sdg3/testfile                                                                                
  /mnt/test5/testfile: 5 extents found
  /mnt/sdg3/testfile: 3 extents found

Also added:

  soft#  rm -f /mnt/test5/testfile /mnt/sdg3/testfile                                                                                                          

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 bs=128k count=3000 | dd iflag=fullblock of=/mnt/test5/testfile bs=128k oflag=sync
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 160.315 s, 2.5 MB/s
  0.02user 0.46system 2:40.31elapsed 0%CPU (0avgtext+0avgdata 1992maxresident)k
  0inputs+0outputs (0major+124minor)pagefaults 0swaps
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 160.365 s, 2.5 MB/s

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 bs=128k count=3000 | dd iflag=fullblock of=/mnt/sdg3/testfile bs=128k oflag=sync                        
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 113.51 s, 3.5 MB/s
  0.02user 0.56system 1:53.51elapsed 0%CPU (0avgtext+0avgdata 2156maxresident)k
  0inputs+0outputs (0major+120minor)pagefaults 0swaps
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 113.544 s, 3.5 MB/s

  soft#  filefrag /mnt/test5/testfile /mnt/sdg3/testfile                                                                                                       
  /mnt/test5/testfile: 1 extent found
  /mnt/sdg3/testfile: 22 extents found

  soft#  rm -f /mnt/test5/testfile /mnt/sdg3/testfile                                                                                                          

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 bs=1M count=1000 | dd iflag=fullblock of=/mnt/test5/testfile bs=1M oflag=sync                           
  1000+0 records in
  1000+0 records out
  1048576000 bytes (1.0 GB) copied, 68.5037 s, 15.3 MB/s
  0.00user 1.16system 1:08.50elapsed 1%CPU (0avgtext+0avgdata 2888maxresident)k
  0inputs+0outputs (0major+347minor)pagefaults 0swaps
  1000+0 records in
  1000+0 records out
  1048576000 bytes (1.0 GB) copied, 68.5859 s, 15.3 MB/s

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 bs=1M count=1000 | dd iflag=fullblock of=/mnt/sdg3/testfile bs=1M oflag=sync                            
  1000+0 records in
  1000+0 records out
  1048576000 bytes (1.0 GB) copied, 56.6714 s, 18.5 MB/s
  0.00user 1.21system 0:56.67elapsed 2%CPU (0avgtext+0avgdata 3056maxresident)k
  0inputs+0outputs (0major+345minor)pagefaults 0swaps
  1000+0 records in
  1000+0 records out
  1048576000 bytes (1.0 GB) copied, 56.7116 s, 18.5 MB/s
