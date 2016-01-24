Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36290 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbcAXRxC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 12:53:02 -0500
Received: by mail-oi0-f54.google.com with SMTP id o124so75310145oia.3
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 09:53:01 -0800 (PST)
Received: from breitenfeld.lan (c-71-196-152-158.hsd1.co.comcast.net. [71.196.152.158])
        by smtp.gmail.com with ESMTPSA id e4sm8713263oic.1.2016.01.24.09.53.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Jan 2016 09:53:00 -0800 (PST)
Date: Sun, 24 Jan 2016 10:52:58 -0700
From: Tom Hunt <tomdicksonhunt@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Chicken-egg: uncorrectable checksum error prevents RAID1 rebalancing
Message-ID: <20160124175258.GD908@breitenfeld.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been running for a week or two using a single-drive 6TB btrfs
volume. For some of this time, the machine running had bad memory,
which led to various checksum errors. For most of these, I just
deleted the relevant file and reacquired it (the errors fortuitously
never occurring in files which were not easily replaceable). However,
there currently remains a single error which does not appear to be in
any file:

# btrfs scrub status /
scrub status for 85f5b744-f68c-4194-aa90-d6fe238115a3
      scrub started at Fri Jan 22 09:49:02 2016 and finished after 11:55:08
      total bytes scrubbed: 4.27TiB with 1 errors
      error details: csum=1
      corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

# dmesg
(...)
[52841.310422] BTRFS warning (device dm-0): csum failed ino 515 off 15118336 csum 2629660496 expected csum 54021641
[52841.335656] BTRFS warning (device dm-0): csum failed ino 515 off 15118336 csum 2629660496 expected csum 54021641
[95071.256448] BTRFS: bdev /dev/mapper/rootvol_1 errs: wr 0, rd 0, flush 0, corrupt 11, gen 0
[95071.256532] BTRFS: unable to fixup (regular) error at logical 4450167468032 on dev /dev/mapper/rootvol_1

I've searched for ino 515, and the file there does not have any
apparent error (can read the whole thing without problem; deleting and
recreating it does not make the error go away). The error is, of
course, uncorrectable, because it's a single-drive volume. However,
having put in a second drive, the balance filter to convert to raid1
fails because of the I/O error.

How do I deal with this?

-- 
Tom Hunt
