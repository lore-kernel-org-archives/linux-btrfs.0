Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42299 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2GVS6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 14:58:52 -0400
Date: Sun, 22 Jul 2012 11:58:48 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        jeff@deserettechnology.com
Subject: Re: brtfs on top of dmcrypt with SSD -> ssd or nossd + crypt
 performance?
Message-ID: <20120722185848.GA10089@merlins.org>
References: <20120202124241.GW16796@shiny>
 <20120130003754.GD4380@merlins.org>
 <20120718181316.GD16899@merlins.org>
 <201207182349.36798.Martin@lichtvoll.de>
 <20120718220446.GB3888@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120718220446.GB3888@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm still getting a bit more data before updating the btrfs wiki with
my best recommendations for today.

First, everything I've read so far says that the ssd btrfs mount option
makes btrfs slower in benchmarks.
What gives? 
Anyone using it or know of a reason not to mount my ssd with nossd?


Next, I got a new Samsumg 830 512GB SSD which is supposed to be very
high performance.
The raw device seems fast enough on a quick hdparm test:


But once I encrypt it, it drops to 5 times slower than my 1TB spinning
disk in the same laptop:
gandalfthegreat:~# hdparm -tT /dev/mapper/ssdcrypt 
/dev/mapper/ssdcrypt:
 Timing cached reads:   15412 MB in  2.00 seconds = 7715.37 MB/sec
 Timing buffered disk reads:  70 MB in  3.06 seconds =  22.91 MB/sec <<<<

gandalfthegreat:~# hdparm -tT /dev/mapper/cryptroot (spinning disk)
/dev/mapper/cryptroot:
 Timing cached reads:   16222 MB in  2.00 seconds = 8121.03 MB/sec
 Timing buffered disk reads: 308 MB in  3.01 seconds = 102.24 MB/sec <<<<


The non encrypted SSD device gives me:
/dev/sda4:
 Timing cached reads:   14258 MB in  2.00 seconds = 7136.70 MB/sec
 Timing buffered disk reads: 1392 MB in  3.00 seconds = 463.45 MB/sec

which is 4x faster than my non encrypted spinning disk, as expected.
I used aes-xts-plain as recommended on
http://www.mayrhofer.eu.org/ssd-linux-benchmark

gandalfthegreat:~# cryptsetup status /dev/mapper/ssdcrypt
/dev/mapper/ssdcrypt is active.
  type:    LUKS1
  cipher:  aes-xts-plain
  keysize: 256 bits
  device:  /dev/sda4
  offset:  4096 sectors
  size:    926308752 sectors
  mode:    read/write
gandalfthegreat:~# lsmod |grep -e aes
aesni_intel            50443  66 
cryptd                 14517  18 ghash_clmulni_intel,aesni_intel
aes_x86_64             16796  1 aesni_intel

I realize this is not btrfs' fault :) although I'm a bit stuck
as to how to benchmark btrfs if the underlying encrypted device is so
slow :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
