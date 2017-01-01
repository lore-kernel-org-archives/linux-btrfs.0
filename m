Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60685 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755136AbdAARZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Jan 2017 12:25:00 -0500
From: Jan Koester <jan.koester@gmx.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mounting failed any file on my filesystem
Date: Sun, 01 Jan 2017 18:24:53 +0100
Message-ID: <2674218.ScDppde5Xv@dibsi>
In-Reply-To: <pan$bd7c7$afa10b63$6e7887fc$c8620080@cox.net>
References: <1707774.BW2KGqTm4d@dibsi> <2145119.sEvPFsN8jE@dibsi> <pan$bd7c7$afa10b63$6e7887fc$c8620080@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Samstag, 31. Dezember 2016 05:05:03 CET Duncan wrote:
> Jan Koester posted on Fri, 30 Dec 2016 13:17:37 +0100 as excerpted:
> > sudo btrfs filesystem df /mnt
> > Data, RAID6: total=1.22TiB, used=0.00B
> > System, RAID6: total=96.00MiB, used=0.00B
> > Metadata, RAID6: total=8.25GiB, used=80.00KiB
> > GlobalReserve, single: total=512.00MiB, used=8.00KiB
> 
> Expanding on what I already mentioned in passing (hoping it wasn't the
> case), raid56 mode (so including your raid6) remains quite unstable, with
> known problems that make it unsuitable for the sort of purposes people
> normally run parity-raid for.  So it's actively negatively recommended
> unless you're running it for the specific purpose of trying to help the
> devs work out the problems with it, using only throw-away-value test data
> in case those problems eat it, which unfortunately they have a
> significantly real chance of doing, with raid56 at this point.
> 
> So you need to get off of it ASAP, and hope any data that wasn't already
> throw-away-value, doesn't end up being thrown away anyway, in the process.
> 
> Unfortunately, as I said in the earlier post, I'm just a user, tho a list
> regular, myself, not a dev.  And I've been staying well away from raid56
> /because/ of these problems (as well as because it didn't fit my use-case
> in the first place), so other than noting the severity of the issues,
> I've not really been paying attention to the various threads with people
> trying to fix the problems and save at least some of their raid56 stored
> data.
> 
> So if you want to try to save the data, you'll need help from a dev or
> higher level expert, or failing that, at least to examine the last couple
> 2-3 months worth of list threads and find the raid56 ones with methods to
> try to save what can be saved, and possibly to patch at least some of the
> problems in ordered to not make the problem worse while you're doing so.
> 
> But it's going to require some reasonable technical know-how to try to do
> that, as well as the time and hassle, so honestly, unless that data's
> /really/ worth it, it may be better to simply cut and run, doing a fresh
> mkfs and being done with btrfs raid56 for now, without spending more time
> on it, only to find you can't save much anyway.  Tho if it's worth it to
> you, you may be able to save much of it, but you could spend a month's
> man-hours doing it too and possibly still come up empty.  Plus be
> careful, because stuff like scrub that would normally help, can make the
> problem much much worse in the case of raid56 ATM.  Yes, the problems
> with it ATM *are* that bad.  Unfortunately.  There's actually talk of
> scrapping the code (almost?) entirely and starting over again, as there's
> a real question as to whether it can even be properly fixed, tho I'm not
> sure it will come to that.

I have backup of this data i wan't to help the Dev's too fix this bug because i 
have enough hard drives.I can also give remote access to show what happend 
with the filesystem or other thins that could he to fix this bug. I see at the 
moment much things happened on the raid56 code.


