Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:42161 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbDQTwX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 15:52:23 -0400
Message-ID: <553162E3.3050907@friendlyvirus.org>
Date: Fri, 17 Apr 2015 20:45:39 +0100
From: =?windows-1252?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: corruption in USB harddrive - backup via send/receive - question
References: <loom.20150416T202016-456@post.gmane.org> <5530EF28.4060209@gmail.com>
In-Reply-To: <5530EF28.4060209@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Austin,

On 17-04-2015 12:31, Austin S Hemmelgarn wrote:
> 
> First, as mentioned in another reply to this, you should update your
> kernel.  I don't think that the kernel is what is causing the issue, but
> it is an old kernel by BTRFS standards, and keeping up to date is
> important with a filesystem under such heavy development.  The same
> actually goes for the userspace components as well, although that is
> less critical than the kernel side.

Ubuntu 15.04 is coming out next week with 3.19, I will try to update to
that soon. Unfortunatelly using a linux machine as a music instrument
requires a stable setup which means not getting always the latest
updates. I guess using btrfs for my setup might have been a bad decision.

> As to the corruption, this sounds like some kind of hardware issue to
> me.  Assuming that you can afford to wipe the filesystems, I would
> suggest running some tests on the disks with the program 'badblocks'
> (found in the e2fsutils).  The fact that it is only the first disk that
> is having issues would seem to indicate that either that port on the
> enclosure is intermitently bad, or the disk itself is having issues. The
> SMART tests passing just indicate that the disk doesn't think it is
> failing, not that it is perfectly reliable (I've had disks that pass all
> the SMART tests, and then just randomly reset themselves from time to
> time).  I would also look into what manufacturer and firmware version
> the drives are, as I do know that some of the early Seagate and WD
> multi-terabyte drives had some serious firmware bugs that could cause
> data corruption similar to this.

Thank you for the advice. At the moment it would be highly inconvenient
to erase one of the disks because I have almost 2 years of snapshots
sent with send/receive on the backup disk to which I could no longer
send just the diff, since erasing the original disk and copying from
backup would create different ids. I guess after a new backup I could
make the old snapshots again share the same blocks by using bedup or
something like that, although I'm not familiar with that tool and I
think two copies of the same data would not fit on that drive.
The drives are western digital green drives, the website doesn't list
any firmware update for those.

I have compared the results of the latest scrub with the results from a
previous scrub 2 month ago and all the damaged files were not damaged
two months ago, and were already in the backup by then (which doesn't
have any errors now or two months ago), so I guess it's safe to recover
those files from the backup. I guess will start running scrubs every few
weeks to check if the corruption continues to happen.

Thank you !
Miguel
