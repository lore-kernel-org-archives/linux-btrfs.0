Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35153 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbcAVEhG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 23:37:06 -0500
Received: by mail-io0-f174.google.com with SMTP id 77so76801240ioc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 20:37:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160122034538.GA25196@coach.student.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
Date: Thu, 21 Jan 2016 21:37:05 -0700
Message-ID: <CAJCQCtSiMV6uhNK1UtZSbPu9JBF4UrPc+4=wU3FPGxiu3inTKA@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 8:45 PM, Sean Greenslade
<sean@seangreenslade.com> wrote:

> I have the ability (through shuffling other drive bays around) to mount
> the 2 existing drives + one new drive all at once. So my first blush
> thought would be to mount one of the new drives, partition it, then
> "btrfs replace" the worse existing drive.

Yes if there are many bad sectors you can use -r which will cause
reads to happen from the drive you're not replacing, and only read
from the "bad" drive if there's a checksum mismatch or a read error on
the "good" drive.

Just like in other threads though, it's still important to make sure
that you don't have an all too common misconfiguration for RAID
setups. The drive's error timeout needs to be shorter than the
kernel's. To check it, on each drive:


# smartctl -l scterc /dev/sdX
# cat /sys/block/sdX/device/timeout

If SCT ERC is not enabled, use -l scterc,70,70 to make it 7 seconds.
That's per drive and it's not persistent through reboots.

If SCT ERC is not supported then you need to increase the SCSI command
timer setting by writing a value such as 160 to that timeout path, per
drive, also not a persistent setting.



> Another possibility is to "btrfs add" the new drive, balance, then
> "btrfs device delete" the old drive. Would that make more sense if the
> old drive is still (mostly) good?

No just use 'btrfs replace start' without -r option if the old drive
is mostly good.

add then delete is necessary if the replacement is smaller in size. So
make sure the partition you use for replace is at least as large or
larger than the device (partition) being replaced.



> Or maybe I could just create a new btrfs partiton on the new device,
> copy over the data, then shuffle the disks around and balance the new
> single partition into raid1.

Oh you mean make a new file system, and use btrfs send/receive (or
rsync or cp)? That's all OK also, and then later you can wipe the good
old drive and add it, then do a -dconvert -mconvert raid 1 balance to
convert to raid1.

There's an advantage if there are features not being used by the older
formatting from the 2013 btrfs-progs. I forget when skinny extents
became default. While that can be set with btrfstune I'm not sure how
to cause all data to get rewritten to use it (?)



-- 
Chris Murphy
