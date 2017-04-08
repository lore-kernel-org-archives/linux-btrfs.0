Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33925 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdDHHv6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 03:51:58 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cwl9r-0005TU-PZ
        for linux-btrfs@vger.kernel.org; Sat, 08 Apr 2017 09:51:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: During a btrfs balance nearly all quotas of the subvolumes became
 exceeded
Date: Sat, 8 Apr 2017 07:51:37 +0000 (UTC)
Message-ID: <pan$703e7$574c02f3$176e5cc9$83b4f1bd@cox.net>
References: <9221e88f-4a4b-de8f-e1dc-aff90c732ded@bcs.tu-darmstadt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Markus Baier posted on Fri, 07 Apr 2017 16:17:10 +0200 as excerpted:

> Hello btrfs-list,
> 
> today a strange behaviour appered during the btrfs balance process.
> 
> I started a btrfs balance operation on the /home subvolume that
> contains, as childs, all the subvolumes for the home directories of the
> users, every subvolume with it's own quota.
> 
> A short time after the start of the balance process no user was able to
> write into his homedirectory anymore.
> All users got the "your disc quota exceeded" message.
> 
> The I checked the qgroups and got the following result:
> 
> btrfs qgroup show -r /home/
> qgroupid        rfer        excl     max_rfer
> --------        ----        ----     --------
> 0/5         16.00KiB    16.00KiB    none
> 0/257	      16.00KiB    16.00KiB    none
> 0/258	      16.00EiB    16.00EiB    200.00GiB
> 0/259	      16.00EiB    16.00EiB    200.00GiB
> 0/260	      16.00EiB    16.00EiB    200.00GiB
> 0/261	      16.00EiB    16.00EiB    200.00GiB
> 0/267	      28.00KiB    28.00KiB    200.00GiB
> ....
> 1/1	      16.00EiB    16.00EiB    900.00GiB
> 
> For most of the subvolumes btrfs calculated 16.00EiB (I think this is
> the maximum possible size of the filesystem)
> as the amount of used space.
> A few subvolumes, all of them are nearly empty like the 0/267,
> were not afected and showed the normal size of 28.00KiB
> 
> I was able to fix the problem with the:
> btrfs quota rescan /home command.
> But my question is, is this a already known bug and what can I do to
> prevent this problem during the next balance run?
> 
> uname -a
> Linux condor-control 4.4.39-gentoo [...]

Known bug.  The btrfs quota subsystem remains somewhat buggy and 
unstable, with negative quota (IIRC, 16 EiB is the unsigned 64-bit 
integer representation of a signed-int negative, I believe -1) issues 
being one of the continuing problems.  Tho it's actively being worked on 
and you may well find that the latest current kernel release (4.10) is 
better in this regard, tho I'd still not entirely trust it and there 
remain quota-fix patches in the active submission queue (just check the 
list).

Note that quotas seriously increase btrfs scaling issues as well, 
typically increasing balance times multi-fold, particularly as they 
interact with snapshots, which have scaling issues of their own, such 
that a cap of a couple hundred snapshots per subvolume is strongly 
recommended, even without quotas on top of it.  Both memory usage and 
processing time are affected, primarily for balance and check.

As a result of btrfs-quota's long continuing accuracy issues in addition 
to the scaling issues, my recommendation has long been the following:

Generally, quota users fall into three categories, described here with my 
recommendations for each:

1) Those who know the quota issues and are actively working with the devs 
to test and correct them, helping to eventually stabilize this feature 
into practical usability, tho it has taken some years and the job, while 
getting closer to finished, remains yet unfinished.

Bless them!  Keep it up! =:^)

2) Those who may find the quota feature generally useful, but don't 
actually require it for their use-case.

I recommend that these users turn off quotas until such time as they've 
been generally demonstrated to be reliable and stable.  At this point 
they're simply not worth the hassle.  Even then, the scaling issues may 
remain.

3) Those who actually depend on quotas working correctly as a part of 
their use-case.

These users should really consider a more mature and stable filesystem 
where the quota feature is known to work as reliably as their use-case 
requires.  Btrfs is certainly stabilizing and maturing, but it's simply 
not there yet for this use-case.

One /possible/ alternative if staying with btrfs for its other features 
is desired, is the pre-quota solution of creating multiple independent 
filesystems on top of lvm or partitions, and using the size of the 
filesystems to enforce restrictions that quotas would otherwise be used 
for.  Of course independent VM images is a more complicated variant of 
this.


Unfortunately, given that you apparently have multiple users and are 
using quotas as resource-sharing enforcement, you may well fall into this 
third category. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

