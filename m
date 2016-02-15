Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42462 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbcBOHLG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 02:11:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aVDJG-0004S9-QD
	for linux-btrfs@vger.kernel.org; Mon, 15 Feb 2016 08:11:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 08:11:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 08:11:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Out of memory purging snapshots
Date: Mon, 15 Feb 2016 07:10:52 +0000 (UTC)
Message-ID: <pan$1b010$c651caa5$f078703a$46090ad1@cox.net>
References: <CALJXSJpwmOqXq07s_7N7shMCppTm4Kz80rOEAei_jW_XjP5KpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jérôme Poulin posted on Sun, 14 Feb 2016 23:52:18 -0500 as excerpted:

> I have encountered a weird out of memory problem using BTRFS,
> snapshots and duperemove.
> The workload is described as:
> - Lots of static (400G/1T) data which was deduplicated using duperemove
> which saved about 50GB.
> - Backups are saved to the BTRFS every 2 days, backup take about 2
> hours.
> - Backups are deduped every weeks.
> - Snapshots are taken every hour for 10 days.

10 days of hourly snapshots = 240 snapshots.  That's within the 
recommended range of 250 snapshots per subvolume, as long as you aren't 
snapshotting too many subvolumes -- the total snapshots per filesystem 
should be kept under 2000 if possible, preferably 1000 and no more than 
3000 or you /will/ start seeing scaling issues.

But if it's all snapshots of a single subvolume, then 240-ish snapshots 
is well within recommended range and shouldn't be a problem.

> After about 10 days worth of snapshot and 8 days worth of dedupe, the
> system started slowing down after each snapshot removal.
> 
> I decided to wipe all snapshots and stop de-duping data, I proceeded and
> removed snapshots 8 at a time, waiting for btrfs-transaction to stop.
> After some time, PC locked up and I could not do anything else but
> restart, reboot was caused because of the free memory and cache being
> all used up. It seems the kernel module could not use any swap and out
> of memory killer had no victim.

There was a recent memory leak patch, I believe related to snapshot 
removal.  I'd guess that's what you may be running into.  I'm not sure of 
patch status, tho I'd guess it's in the 4.5-rcs.

> I was able to start the operation again by mounting using thread_pool=1
> and stopping all services, it went well for the first ~100 snapshots but
> then the condition appeared again, after multiple attemps I tried
> mounting R/O and it worked.
> 
> I currently have a VM up on this machine which has 3GB RAM, the VM has
> now 4GB RAM and the host has 4GB additional swap. It is currently making
> progress but I think this might be considered as a bug. I have some
> dmesg logs showing the problem.
> 
> [   68.040380] BTRFS info (device dm-6): disk space caching is enabled
> [   68.040385] BTRFS: has skinny extents
> [  240.112032] INFO: task kworker/u8:6:162 blocked for more than
> 120 seconds.
> [  240.112086]       Not tainted 4.2.0-27-generic #32-Ubuntu

That kernel's a potential issue.  Given that btrfs is still stabilizing, 
not fully stable, the general on-list recommendation is to keep to the 
last couple kernel releases of either the current kernel, or the mainline 
LTS kernel series.  With the latest 4.4 release being an LTS and 4.1 
being the previous LTS series, those would be the LTS track kernels, with 
4.4 and 4.3 being the current track kernels.

4.2 is not an LTS kernel series and is already out of upstream current-
stable support.  As such, the recommendation would be to either upgrade 
to the latest current and LTS 4.4 series kernel, or drop back to the 
latest LTS 4.1 series kernel.

However, that memory-leak patch is new enough it's unlikely to have made 
it to any release series yet, tho they'll almost certainly get it in a 
week or two, so you may need to either dig it up and apply it yourself, 
or try the latest 4.5-rc (rc4 at the moment of writing, released on 
Valentine's Day), as if it's applied to anything yet, it'd be applied 
there.

It's likely someone else tracking that bug and patch closer than I am (my 
use-case doesn't involve snapshotting or subvolumes) will be along 
shortly with further details and likely a link to the patch, but 
meanwhile, yes, I think that's the bug that has already been tracked and 
patched, and it only remains to get that patch out on what people are 
actually running. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

