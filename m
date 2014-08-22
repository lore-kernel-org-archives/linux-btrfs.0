Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34459 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753984AbaHVDTD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 23:19:03 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49239 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XKfNV-002N2u-Jg
	for linux-btrfs@vger.kernel.org; Thu, 21 Aug 2014 21:19:01 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: mkfs.btrfs vs fstrim on an SD Card (not SSD)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <3CE6F328-8757-4B7F-858F-E820DFDF97E8@colorremedies.com>
Date: Thu, 21 Aug 2014 21:19:00 -0600
Message-Id: <F5912FA1-9B5B-4E22-A9A8-EB09461F2BD4@colorremedies.com>
References: <3CE6F328-8757-4B7F-858F-E820DFDF97E8@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I may have answered my own question using strace. And for whatever reason this time fstrim worked.

fstrim
ioctl(3, FITRIM, 0x7fffbf6b87e0) 
…
write(1, "/mnt/: 13.9 MiB (14598144 bytes)"…, 41/mnt/: 13.9 MiB (14598144 bytes) trimmed

Clearly this is only erasing what the file system is aware of having been recently deleted, even though it's a bit off as I'd just deleted a 6.1MB file.



mkfs.btrs:

ioctl(3, BLKGETSIZE64, 14729330176)     = 0
ioctl(3, BLKDISCARD, {0, 7fff920ee4a0}) = 0
write(2, "Performing full device TRIM (13."..., 43Performing full device TRIM (13.72GiB) ...
) = 43
ioctl(3, BLKDISCARD, {0, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {40000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {80000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {c0000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {100000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {140000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {180000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {1c0000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {200000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {240000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {280000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {2c0000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {300000000, 7fff920ee4a0}) = 0
ioctl(3, BLKDISCARD, {340000000, 7fff920ee4a0}) = 0

And this blew away everything on that partition.

Since the SD Card spec references a completely different command than the ATA spec (TRIM), I don't think either one of these are TRIM, even if functionally equivalent. Instead the SD Card ERASE_* commands are probably being used, but I can't confirm this because writes to /dev/mmcblk0 aren't showing up with:

echo scsi:scsi_dispatch_cmd_start > /sys/kernel/debug/tracing/set_event 
echo 1 > /sys/kernel/debug/tracing/tracing_on
cat /sys/kernel/debug/tracing/trace_pipe


Chris Murphy