Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37610 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaBXHaZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 02:30:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WHpzb-00023t-0m
	for linux-btrfs@vger.kernel.org; Mon, 24 Feb 2014 08:30:23 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 08:30:23 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 08:30:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
Date: Mon, 24 Feb 2014 07:29:58 +0000 (UTC)
Message-ID: <pan$2c66d$b9df9232$d5e4e0c4$992cc0f6@cox.net>
References: <20140224061426.GB15937@merlins.org>
	<20140224061714.GC15937@merlins.org>
	<pan$5eb48$855696ce$5bb0f0dc$b9ce161e@cox.net>
	<20140224065847.GE15937@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 23 Feb 2014 22:58:47 -0800 as excerpted:

> On Mon, Feb 24, 2014 at 06:42:30AM +0000, Duncan wrote:
>> [S]ee the /var/lib/btrfs/scrub.status.* files.  That's
>> where scrub state is stored, and manually blowing away the appropriate
>> file should clear btrfs' memory of the aborted scrub, so you can scrub
>> start properly.
> 
> Ah, silly me, I thought this was all in the kernel and not in userspace.

That was a bit eye opening for me too. =:^)

> Yep, I cleared the stats, and that part is back to ok, thanks.

=:^)

> But I'm still seeing these, albeit less often.
> Any idea what they could be linked to?
> (I have a btrs send/receive going right now, it could hanging
> /mnt/btrfs_pool1 in a way that affects smbd, but the array feels ok
> otherwise, weird...)
> 
> [ 1332.548370] INFO: task smbd:21882 blocked for more than 120 seconds.
> [ 1332.587455]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
> [ 1332.625478] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.

I've not seen anything like that here, but there are several kernel 
3.13/3.14-rc reports of similar behavior on the list.

>From what I've seen reported, the problem /might/ be large-internal-write-
file related, multi-gig vm images, database files, etc, actively being 
written, the sort of thing NOCOW *SHOULD* fix, at least in the absence of 
frequent snapshots, but in at least one case, NOCOW had been properly 
activated before the file content was written and the user was NOT doing 
major snapshotting of any kind, so that rules out those triggers.

So I've no idea, except that in every reported case I've seen, people did 
have large VMs or the like going as well, so that's a possible connection 
despite the above.

Hopefully the devs are having more success at assembling this puzzle than 
I am, but I've no suggestions for fixing it ATM, except the possibility 
of putting your VMs, etc, on a dedicated non-btrfs filesystem for the 
time being, assuming of course that apparent connection is a valid one.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

