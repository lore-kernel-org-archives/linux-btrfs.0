Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60512 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdGRGvp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 02:51:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dXMLz-0008HA-Tk
        for linux-btrfs@vger.kernel.org; Tue, 18 Jul 2017 08:51:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-cleaner causing heavy load
Date: Tue, 18 Jul 2017 06:51:23 +0000 (UTC)
Message-ID: <pan$353c4$27c16fdf$380479ed$1d3824d4@cox.net>
References: <64e68f94963a441db087e660e167a2f4@sap.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brennecke, Simon posted on Mon, 17 Jul 2017 08:03:33 +0000 as excerpted:


> I understand that purging snapshots is a complex operation, but we
> somehow need to reduce the load this causes during working hours.
> Are there any ways to tell btrfs-cleaner to suspend or reduce its
> operations?
> 
> Background:
> 	The file-server runs inside a XEN domU The backing disk is a Ceph 
RDB
> 	with 50TiB capacity We employ a bcache with a local SSD to improve
> 	latency Files are served via NFS and Samba to a couple of hundred
> 	clients.
> 
> Thanks & regards Simon
> 
> uname -a
> 	Linux v2-fs 4.1.42-xen #2 SMP Wed Jul 12 14:06:37 CEST 2017 x86_64
> 	GNU/Linux
> 
> btrfs --version
> 	Btrfs v3.17

Just another user and list regular here, and one that doesn't use either 
ceph or btrfs snapshots so my ability to help will be limited, but some 
things to try based on what I've seen go by on the list, the low hanging 
fruit, if you will...

* If at all possible and you have it on, try turning off the btrfs quota 
machinery when deleting snapshots.  Attempting to keep quotas in sync 
while deleting snapshots increases the load *tremendously* and it simply 
doesn't scale well.  Based on list reports, turning them off during 
snapshot deletion can be like night and day, result-wise.

If you need quotas you can of course turn them back on when you're done 
with the deletes, and it's quite possible that it's the big deletion 
backlog that's the problem and deleting just one snapshot at a time with 
quotas on may work at least tolerably well once you've caught up with the 
backlog.

OTOH, quotas do dramatically increase scaling issues for a number of 
btrfs maintenance tasks, and until recently, they were too buggy to be 
reliable anyway, so if you don't really need them, keeping them off will 
likely improve btrfs responsiveness for you, particularly when doing 
snapshot deletion, balances or checks.  And as buggy as quotas were in 
4.1, I'd suggest either upgrading, or just leaving them off, as they're 
just not worth the bother, in 4.1.

* Talking about "recently", on the LTS side this list does try to support 
the last two LTS kernel series, but not really beyond that... as is 
understandable for a forward focused development list covering a still 
stabilizing filesystem such as btrfs.  The two currently supported LTS 
series are thus now 4.9 and 4.4, with the 4.1 you're running now off in 
long ago btrfs development history.

Basically, while there are valid reasons to run kernels that old, in 
general they tend to be incompatible with the reasons one may choose to 
run a still stabilizing, not fully stable and mature filesystem like 
btrfs.  So the list recommendation tends to be to choose one or the 
other, a more current kernel in keeping with a not yet fully stabilized 
btrfs, or a different, fully  stable filesystem, in keeping with the 
reasons people usually give for choosing to run such old kernels.

Alternatively, some distros support btrfs on older kernels, but in that 
case you're better off getting support from them, because theyknow what 
changes they've backported and which ones they haven't, and are thus 
better positioned to provide support for those kernels and what's running 
in them.

Or you can stay with what you have and try to do the best with the 
support you can get from this list, and we'll try to do our best too, but 
realize there's a serious limit to how much work people are going to be 
putting into stuff that old, is all.

Meanwhile, as hinted, quotas are one area that has had dramatic fixes 
since 4.1, where they were definitely known to still be buggy.  Tho 
they'll still kill snapshot deletion performance in current kernels, but 
at least you should be getting more reliable numbers with them in current 
kernels.  So if you use quotas, you _definitely_ want to upgrade... 
unless of course your distro has backported those fixes, but then we're 
back to them being in a better position to provide support as they know 
what they've backported.

As for btrfs-tools, while in normal operation they're not as critical as 
the kernel (since in normal operation most of the work is done by the 
kernel, with userspace only calling the appropriate kernel 
functionality), if there's problems, you want a newer userspace as well, 
because then it's the userspace code doing the work.  Regardless, 3.17 is 
a /very/ long time ago in btrfs terms, and an upgrade to something even 
/half/ modern, perhaps a 4.4 userspace to match a 4.4 LTS kernel upgrade, 
should be considered.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

