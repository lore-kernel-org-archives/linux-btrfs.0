Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35957 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbcAYWay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 17:30:54 -0500
Received: by mail-ig0-f174.google.com with SMTP id z14so46401877igp.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 14:30:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160125212929.GD6110@pontus.sran>
References: <20160125212929.GD6110@pontus.sran>
Date: Mon, 25 Jan 2016 15:30:53 -0700
Message-ID: <CAJCQCtQDs-VpvdnP1iTLzLZKkE+5KeO1WSq_VTfYTqetWj2mdw@mail.gmail.com>
Subject: Re: suspected BTRFS errors resulting in file system becoming unrecovable
From: Chris Murphy <lists@colorremedies.com>
To: Piotr Szymaniak <szarpaj@grubelek.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Error 64 [15] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

This is an unrecoverable read or write error. I'm not having much luck
figuring out if 40 or 51 refers to a read or a write. A write failure
is fatal, the drive needs to be replaced under warranty. A read
failure is more of a soft fail, it needs to be written over for the
problem to get fixed by the drive firmware, but there's no indication
there are pending (bad) sectors.


>
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:50.583  READ DMA EXT


Huh and this is a read error.

So I wonder if what's really going on is a bad sector is just taking a
long time to recover, and we're getting the USB equivalent of libata's
link reset due to SCSI command timer (the topic of the month
apparently)? And that's cause writes to "fail" possibly because they
were lost in the command queue in the drive when the reset happened.

Does this drive contain vital information or can it be destructively
written to? If you can destructively write to it you could set it to
do

badblocks -b 4096 -c 256 -svw /dev/sdX

Use whole block device *OR* if it's a partition, make sure the start
LBA is divisible by 8 (it needs to be 4096 byte aligned on any recent
drive, which will be a 512e AF drive).

Again this is destructive, data will be lost on this drive. And it
shouldn't be mounted at the time you do this (badblocks should fail).

If you can't do a destructive write to this drive just yet, this is
non-destructive:

smartctl -t long /dev/sdX

That starts an extended offline (readonly) test for bad sectors which
will be aborted at the first bad sector it finds. You can check with
smartctl -a, and look in the section "SMART Self-test log" for the
first line.



-- 
Chris Murphy
