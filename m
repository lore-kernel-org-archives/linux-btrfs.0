Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:59746 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLWWXP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 17:23:15 -0500
Received: by mail-yk0-f170.google.com with SMTP id q200so3482259ykb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 14:23:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
	<20141223211605.GC436@hungrycats.org>
	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
Date: Tue, 23 Dec 2014 15:23:13 -0700
Message-ID: <CAJCQCtQebXga2NEEgMgCc9Oxx4OD86_L59b1qZ1BE8Kr=WEpRw@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The other thing to note, is that the scsi command timer timeout is a
maximum. So at 30 seconds if a command to the drive hasn't completed,
then consider the drive hung up and do a link reset. And whatever
error recovery is in the drive, is also a maximum. If the sector is
really immediately bad, the drive will produce a read error
immediately. The case where you get these long recoveries where the
drive keeps retrying beyond the 30 second scsi command timer value, is
when the drive firmware ECC thinks it can recover (or reconstruct) the
data instead of producing a read error.

A gotcha with changing the scsi command timer to a much larger value
is that it possibly gives the drive enough time to recover the data,
report it back to the kernel, and then everything goes on normally.
The "slow sector" doesn't get fixed. Even a scrub wouldn't fix that
unless the drive reported wrongly recovered data and Btrfs checksums
catch it.

So what you want to do with a drive that has, or is suspected of
having such slow sectors, is to balance it. Rewrite everything. That
should cause the drive firmware to map out those sectors if they
result in persistent write errors.

What ought to happen is the data from slow sectors, once recovered,
should get written to a reserve sector and the old sector removed from
use (remapping, i.e. the LBA is the same but the physical sector is
different) but every drive firmware handles this differently. I
definitely have had drives where this doesn't happen automatically.
Also, I've had drives that when ATA Secure Erased, did not test for
persistent write errors and therefore bad sectors weren't removed from
use, they'd remain persistently bad when doing smartctl -t long tests.
In those cases, using badblocks -w fixed the problem but of course
that's destructive.


-- 
Chris Murphy
