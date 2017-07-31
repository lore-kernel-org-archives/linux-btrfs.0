Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36854 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750987AbdGaMuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 08:50:18 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:34877)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dcA9J-0008JN-54
        for linux-btrfs@vger.kernel.org; Mon, 31 Jul 2017 13:50:17 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dcA8d-0001W7-UZ
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 13:49:35 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22911.10079.563227.197860@tree.ty.sabi.co.uk>
Date: Mon, 31 Jul 2017 13:49:35 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <22911.9142.450242.405693@tree.ty.sabi.co.uk>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
        <22907.32175.311827.10738@tree.ty.sabi.co.uk>
        <19527869.26.1501422186960.JavaMail.gkos@dynomob>
        <22911.5971.350346.969146@tree.ty.sabi.co.uk>
        <22911.9142.450242.405693@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

> Also added:

Feeling very generous :-) today, adding these too:

  soft#  mkfs.btrfs -mraid10 -draid10 -L test5 /dev/sd{b,c,d,e}3
  [ ... ]
  soft#  mount -t btrfs -o commit=10,compress-force=zlib /dev/sdb3 /mnt/test5

  soft#  rm -f /mnt/test5/testfile
  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/test5/testfile bs=1M count=3000 conv=fsync
  3000+0 records in
  3000+0 records out
  3145728000 bytes (3.1 GB) copied, 14.2166 s, 221 MB/s
  0.00user 2.54system 0:14.21elapsed 17%CPU (0avgtext+0avgdata 3056maxresident)k
  0inputs+6144768outputs (0major+346minor)pagefaults 0swaps

  soft#  rm -f /mnt/test5/testfile
  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/test5/testfile bs=128k count=3000 conv=fsync                                                    
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 2.05933 s, 191 MB/s
  0.00user 0.32system 0:02.06elapsed 15%CPU (0avgtext+0avgdata 1996maxresident)k
  0inputs+772512outputs (0major+124minor)pagefaults 0swaps

  soft#  rm -f /mnt/test5/testfile
  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 bs=1M count=1000 | dd iflag=fullblock of=/mnt/test5/testfile bs=1M oflag=sync                           
  1000+0 records in
  1000+0 records out
  1048576000 bytes (1.0 GB) copied, 60.6019 s, 17.3 MB/s
  0.01user 1.04system 1:00.60elapsed 1%CPU (0avgtext+0avgdata 2888maxresident)k
  0inputs+0outputs (0major+348minor)pagefaults 0swaps
  1000+0 records in
  1000+0 records out
  1048576000 bytes (1.0 GB) copied, 60.4116 s, 17.4 MB/s

  soft#  rm -f /mnt/test5/testfile
  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 bs=128k count=3000 | dd iflag=fullblock of=/mnt/test5/testfile bs=128k oflag=sync
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 148.04 s, 2.7 MB/s
  0.00user 0.62system 2:28.04elapsed 0%CPU (0avgtext+0avgdata 1996maxresident)k
  0inputs+0outputs (0major+125minor)pagefaults 0swaps
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 148.083 s, 2.7 MB/s

  soft#  sysctl vm/drop_caches=3
  vm.drop_caches = 3
  soft#  /usr/bin/time dd iflag=fullblock if=/mnt/test5/testfile bs=128k count=3000 of=/dev/zero                                                               
  3000+0 records in
  3000+0 records out
  393216000 bytes (393 MB) copied, 1.09729 s, 358 MB/s
  0.00user 0.24system 0:01.10elapsed 23%CPU (0avgtext+0avgdata 2164maxresident)k
  459768inputs+0outputs (3major+121minor)pagefaults 0swaps
