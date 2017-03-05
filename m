Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:53069 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbdCEQel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Mar 2017 11:34:41 -0500
Received: from 244.79-160-162.customer.lyse.net ([79.160.162.244]:61413 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1ckYzY-0007Ih-Kv
        for linux-btrfs@vger.kernel.org; Sun, 05 Mar 2017 17:26:40 +0100
To: linux-btrfs@vger.kernel.org
Reply-To: waxhead@dirtcellar.net
From: waxhead <waxhead@dirtcellar.net>
Subject: Why do BTRFS (still) forgets what device to write to?
Message-ID: <0fe88cf0-7c51-e2b1-e50a-33d141d1862c@dirtcellar.net>
Date: Sun, 5 Mar 2017 17:26:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am doing some test on BTRFS with both data and metadata in raid1.

uname -a
Linux daffy 4.9.0-1-amd64 #1 SMP Debian 4.9.6-3 (2017-01-28) x86_64 
GNU/Linux

btrfs--version
btrfs-progs v4.7.3


01. mkfs.btrfs /dev/sd[fgh]1
02. mount /dev/sdf1 /btrfs_test/
03. btrfs balance start -dconvert=raid1 /btrfs_test/
04. copied a lots of 3-4MB files to it (about 40GB)...
05. Started to compress some of the files to create one larger file...
06. Pulled the (sata) plug on one of the drives... (sdf1)
07. dmesg shows that the kernel is rejecting I/O to offline device + 
[sdf] killing request]
08. BTRS error (device sdf1) bdev /dev/sdf1 errs: wr 0, rd 1, flush 0, 
corrupt 0, gen 0
09. the previous line repeats - increasing rd count
10. Reconnecting the sdf1 drive again makes it show up as sdi1
11. btrfs fi sh /btrfs_test shows sd1 as the correct device id (1).
12. Yet dmesg shows tons of errors like this: BTRFS error (device sdf1) 
: bdev /dev/sdi1 errs wr 37182, rd 39851, flush 1, corrupt 0, gen 0....
13. and the above line repeats increasing wr, and rd errors.
14. BTRFS never seems to "get in tune again" while the filesystem is 
mounted.

The conclusion appears to be that the device ID is back again in the 
btrfs pool so why does btrfs still try to write to the wrong device (or 
does it?!).

The good thing here is that BTRFS does still work fine after a unmount 
and mount again. Running a scrub on the filesystem cleans up tons of 
errors , but no uncorrectable errors.

However it says total bytes scrubbed 94.21GB with 75 errors ... and 
further down it says corrected errors: 72, uncorrectable errors: 0 , 
unverified errors: 0

Why 75 vs 72 errors?! did it correct all or not?

I have recently lost 1x 5 device BTRFS filesystem as well as 2x 3 device 
BTRFS filesystems set up in RAID1 (both data and medata) by toying 
around with them. The 2x filesystems I lost was using all bad disks (all 
3 of them) but the one mentioned here uses good (but old) 400GB drives 
just for the record.

By lost I mean that mount does not recognize the filesystem, but BTRFS 
fi sh does show that all devices are present. I did not make notes for 
those filesystems , but it appears that RAID1 is a bit fragile.

I don't need to recover anything. This is just a "toy system" for 
playing around with btrfs and doing some tests.
