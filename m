Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55822 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaA2GX7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 01:23:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W8OZ3-0007qx-SM
	for linux-btrfs@vger.kernel.org; Wed, 29 Jan 2014 07:23:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 07:23:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 07:23:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Rapid memory exhaustion during normal operation
Date: Wed, 29 Jan 2014 06:23:33 +0000 (UTC)
Message-ID: <pan$69bed$2f1aac04$4d4239b$bd3e45ea@cox.net>
References: <52E430F7.7030801@gmail.com>
	<E429CA17-EBB7-4EA7-80EE-82FDA3D1DA05@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 28 Jan 2014 20:57:45 -0700 as excerpted:

> On Jan 25, 2014, at 2:47 PM, Dan Merillat <dan.merillat@gmail.com>
> wrote:
> 
> 
>> [ 1219.366168] ntpd invoked oom-killer: gfp_mask=0x201da, order=0,
>> oom_score_adj=0 [ 1219.366270] CPU: 1 PID: 5479 Comm: ntpd Not tainted
>> 3.12.8-00848-g97f15f1 #2
> 
> This and the whole call track don't have anything in it that's
> implicating btrfs or vfs.

While that's true, it's also likely rather beside the point.  Several 
reports here have pointed to apparently qgroups related memory usage 
growth that can't be traced to userspace at all.  Userspace ends up 
taking the hit, but only because kernelspace is squeezing it out, not due 
to anything userspace is or has done on its own.

Which is why I mentioned qgroups in my reply, tho as I indicated, I 
really do wish someone a bit more qualified would get involved, as I 
don't run qgroups here and can only point to the various reports I've 
seen onlist.

>> [ 1219.377263] Free swap  = 0kB [ 1219.377320] Total swap = 0kB
> 
> No swap?

In itself not unusual.  What I do find a bit unusual is that the OP said 
with little or no swap usage, an odd thing to say if he's running with no 
swap to use...

[timestamp on the below omitted to keep alignment at normal line width]
>> uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
>> 103  5383   138079    16199      74        0             0 mysqld
>> 
>> Out of memory: Kill process 5383 (mysqld) score 16 or sacrifice child
>> Killed process 5383 (mysqld)
>> total-vm:552316kB, anon-rss:64576kB, file-rss:220kB
> 
> It sounds like mysqld is hogging memory for whatever reason, and in the
> runaway there's no swap to fall back on so things start imploding, which
> who knows maybe it cause some file system corruption in the process or
> once the system had to be force quit.

Hogging memory??  That's only ~ 138 MB total VirtMem at first instance, a 
bit over half a gig at kill, with only ~64 MB resident set size.  That 
doesn't look unreasonable to me, particularly for what might be a large 
database.

While I don't know how much memory he has, here on a desktop/workstation 
with ntpd running but not mysql installed, I'm running 16 gig, no swap, 
total memory usage (including cache) of about 3 gig ATM.

My highest (everything over a gig) virtmem users ATM according to htop 
are privoxy @ ~2.1 gig, minitube @ ~1.5 gig, and plasma-desktop @ ~1.4 
gig, but obviously that has nothing to do with actual memory usage if 
total usage is ~3 gig including cache.  Virtmem is total requested 
allocation, but on Linux apps routinely ask for what they /might/ need 
and are generally granted it on an over-commit policy, with the memory 
actually only faulted into use when they actually try to use it.

Resident set size is a more accurate measure, altho even that isn't 
entirely accurate as it's complicated with shared libs, etc.  But with my 
current top rss users (everything over 100 meg) are minitube @ 270 meg, 
plasma-desktop @ 220 meg, X @ 217 meg, and pan (with which I'm writing 
this) @ 156 meg.

As you can see from my numbers above, half a gig virtmem is /nothing/; 
neither is 64 meg rss.  Given any reasonable memory size at all, that 
shouldn't have been an issue, meaning mysql couldn't have been the 
problem.

Bottom line, mysql was a victim, not the perp.  The perp is as I said, 
very likely btrfs qgroups, since we have other reports of just that, tho 
of course we don't have that confirmed in this case yet.  Since that 
memory usage is kernel, it simply squeezes helpless userspace out as it 
goes and the OOM-killer is the method by which it does so.

> Off hand to me it doesn't seem to be directly related to Btrfs. Try
> reproducing without running the things implicated in this event: ntpd,
> mysqld.

I bet it won't make a difference... other userspace apps will simply be 
killed in place... but it could prove the point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

