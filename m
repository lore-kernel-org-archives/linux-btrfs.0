Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44641 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbcKYMC2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 07:02:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cAFCQ-0000s2-RO
        for linux-btrfs@vger.kernel.org; Fri, 25 Nov 2016 13:01:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount option nodatacow for VMs on SSD?
Date: Fri, 25 Nov 2016 12:01:37 +0000 (UTC)
Message-ID: <pan$c85ad$dae9ebf5$a0482059$7c135fb1@cox.net>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ulli Horlacher posted on Fri, 25 Nov 2016 09:28:40 +0100 as excerpted:

> I have vmware and virtualbox VMs on btrfs SSD.
> 
> I read in
> https://btrfs.wiki.kernel.org/index.php/SysadminGuide
#When_To_Make_Subvolumes
> 
>      certain types of data (databases, VM images and similar typically
>      big files that are randomly written internally) may require CoW to
>      be disabled for them.  So for example such areas could be placed in
>      a subvolume, that is always mounted with the option "nodatacow".
> 
> Does this apply to SSDs, too?

It can, because the root issue is the same, the COW-based fragmentation 
that's always a problem with this sort of frequently randomly partially 
rewritten file on COW-based filesystems, but the symptoms tend to be much 
less of a problem on ssd, so it doesn't tend to be as big of an issue 
there.

On multi-gig database files or VM images, files can end up with 100K 
extents due to COW-based rewriting.  Obviously this can be a HUGE problem 
on spinning rust due to its seek times, a problem zero-seek-time ssds 
don't have, but the sheer amount of metadata overhead due to tracking all 
those tiny extents can be a problem of its own, particularly when doing 
maintenance such as btrfs balance or btrfs check.  Both snapshotting and 
quota tracking amplify this overhead tracking problem as well, and it's 
this problem that can still be an issue on ssds.

That said, the autodefrag mount option, used to eliminate some of the 
heavy fragmentation due to copy-on-write (COW) that's the root problem, 
tends to be faster on ssd, and can often be all that's needed on ssd as 
between it ameliorating the root problem to a large extent and the faster 
speed of ssds, often that's all that's needed, particularly if you don't 
need quotas so have them off and only do relatively limited snapshotting.

The problem with both the nodatacow mount option and the nocow file 
attribute is that they disable some of the btrfs features and are 
weakened by other features that may well be a big part of the reason 
behind your choice of btrfs in the first place.  Both btrfs compression, 
if otherwise enabled, and checksuming and thus file integrity checking 
(and repair in the case of btrfs raid1/10), would be complicated or 
impossible to implement without COW, and thus are disabled in the NOCOW 
case.  Similarly, btrfs snapshotting depends on COW because the snapshot 
locks in place the existing version so a rewrite must be written 
elsewhere.  As a result, snapshotting weakens NOCOW to what has been 
called COW1, COW the first time a block is rewritten after a snapshot, 
but after that further writes to the same block will be rewritten into 
the (new) existing block location.  If you only do very occasional 
snapshots that may not be a problem, but if you're doing regular 
snapshots, particularly automated and multiple per day, the effect of the 
snapshotting forced COW1s may be fragmentation as bad as if NOCOW wasn't 
in place in the first place.

So to some degree, if you're going to be setting the nocow attribute or 
using the nodatacow mount option, you might as well just setup a 
different partition/volume and mkfs to something other than btrfs for 
those files.  OTOH, the btrfs multi-device and storage pool features 
aren't affected, so if they are big reasons you're doing btrfs, then 
there's some reason to keep using btrfs and simply do the nodatacow mount 
or nocow attribute if autodefrag isn't enough on its own to handle it.

Bottom line, the fragmentation is much less of a problem on ssds, 
particularly with autodefrag which may well be enough, but as always, it 
can be installation and task dependent, so if it's going to be a 
production system, do your own testing and make your own decisions based 
on the results. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

