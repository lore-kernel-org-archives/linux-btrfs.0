Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:15976 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752720Ab3IWWf6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 18:35:58 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49252 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VOEjW-001Bhk-2P
	for linux-btrfs@vger.kernel.org; Mon, 23 Sep 2013 16:35:58 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: balance induced csum errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com>
Date: Mon, 23 Sep 2013 16:35:56 -0600
Message-Id: <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Result of btrfsck (without --repair) on the fs.

Checking filesystem on /dev/sda6
UUID: d505bdee-ba7c-4a64-9481-d5cd76ab8b3e
checking extents
checking fs roots
root 257 inode 37693 errors 1800
found 3938304000 bytes used err is 1
total csum bytes: 3557972
total tree bytes: 271794176
total fs tree bytes: 253009920
btree space waste bytes: 79371605
file data blocks allocated: 4546076672
 referenced 3631865856
Btrfs v0.20-rc1

Console result of subsequence scrub on the mounted fs:

scrub status for d505bdee-ba7c-4a64-9481-d5cd76ab8b3e
	scrub started at Mon Sep 23 16:23:33 2013 and finished after 8 seconds
	total bytes scrubbed: 3.67GB with 10 errors
	error details: csum=10
	corrected errors: 0, uncorrectable errors: 10, unverified errors: 0

dmesg result of a subsequent scrub on the mounted file system:

[   30.682058] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[   30.682095] btrfs: unable to fixup (regular) error at logical 461914112 on dev /dev/sda6
[   30.682141] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[   30.682174] btrfs: unable to fixup (regular) error at logical 460079104 on dev /dev/sda6
[   30.689792] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
[   30.689823] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
[   30.689824] btrfs: unable to fixup (regular) error at logical 456085504 on dev /dev/sda6
[   30.689896] btrfs: unable to fixup (regular) error at logical 457531392 on dev /dev/sda6
[   30.743222] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
[   30.743260] btrfs: unable to fixup (regular) error at logical 460230656 on dev /dev/sda6
[   30.970989] btrfs: checksum error at logical 462082048 on dev /dev/sda6, sector 902504, root 257, inode 37693, offset 22282240, length 4096, links 1 (path: var/log/journal/180d14c18233452d9918c3aec1c6c68b/system.journal)
[   30.970993] btrfs: checksum error at logical 464195584 on dev /dev/sda6, sector 906632, root 257, inode 37693, offset 22638592, length 4096, links 1 (path: var/log/journal/180d14c18233452d9918c3aec1c6c68b/system.journal)
[   30.970997] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
[   30.970998] btrfs: unable to fixup (regular) error at logical 464195584 on dev /dev/sda6
[   30.971270] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[   30.971300] btrfs: unable to fixup (regular) error at logical 462082048 on dev /dev/sda6
[   31.047120] btrfs: checksum error at logical 462123008 on dev /dev/sda6, sector 902584, root 257, inode 37693, offset 22360064, length 4096, links 1 (path: var/log/journal/180d14c18233452d9918c3aec1c6c68b/system.journal)
[   31.047206] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 8, gen 0
[   31.047235] btrfs: unable to fixup (regular) error at logical 462123008 on dev /dev/sda6
[   36.290269] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 9, gen 0
[   36.290305] btrfs: unable to fixup (regular) error at logical 4744409088 on dev /dev/sda6
[   37.882830] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
[   37.882867] btrfs: unable to fixup (regular) error at logical 6730518528 on dev /dev/sda6



Also, there have been no crashes, panics, or power cuts to this system. Thus far it seems like the balance itself is what has caused the csum corruption. Prior to balance, scrub finds no problems. After balance there is some corruption. But isn't it ambiguous whether the data or the metadata have been corrupted since there is only a single copy of each? In which case is it wise to init-csum-tree?


Chris Murphy