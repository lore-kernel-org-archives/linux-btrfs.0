Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51320 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186AbbIWEtr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 00:49:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zec00-0006cx-3F
	for linux-btrfs@vger.kernel.org; Wed, 23 Sep 2015 06:49:44 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 06:49:44 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 06:49:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Date: Wed, 23 Sep 2015 04:49:37 +0000 (UTC)
Message-ID: <pan$39d79$476d5a75$50a7f466$256bcde5@cox.net>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
	<560150CD.6070301@suse.com> <5601596B.1020607@googlemail.com>
	<20150922134131.GH5918@carfax.org.uk>
	<20150922142333.GH12815@twin.jikos.cz>
	<20150922143602.GI5918@carfax.org.uk> <56016BB5.6060101@gmail.com>
	<20150922153930.GK5918@carfax.org.uk> <560190CA.7060606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Tue, 22 Sep 2015 13:32:58 -0400 as
excerpted:

>> Of course, you shouldn't be nesting subvolumes anyway. It makes
>> it much harder to manage them.
> 
> That depends though, I only ever do single nesting (ie, a subvolume in a
> subvolume), and I use it to exclude stuff from getting saved in
> snapshots

Good point.

Such snapshot-exclusion-via-subvolume-boundary is a frequently 
recommended use-case for nocow files, of course, to keep them from 
fragmenting due to snapshot-provoked cow1.

If there's no (other) reason to mount the subvolumes separately, either 
because they're primarily snapshot-exclusion subvolumes or for whatever 
other reason they aren't intended to be specifically mounted, but 
instead, simply used as ordinary subdirs for most purposes, then nesting 
really /does/ make sense, because relying on the normal subdir behavior, 
that does avoid the otherwise necessary separate mount.


Which, meanwhile, brings up a particular bone I have to pick with 
systemd's use of btrfs subvolumes in various cases, particularly in 
tmpfiles.d usage, as well.  Since IIRC systemd 219, various previously 
created directories, including the (virtual-) machines tree, are by 
default subvolume-creations, now, of course only if they don't already 
exist.

These subvolumes are explicitly nested at whatever location they happen 
to appear in the subtree, as tmpfiles.d simply creates them as subvolumes, 
with a fallback to the standard subdirs they were created as in earlier 
versions on filesystems other than btrfs.  Other than the standard mount 
processing, which involves admins specifically setting up the appropriate 
subvolumes and mounts for them ahead of time, there's no provision made 
for creating them in a standard subvolume location at root level, and 
mounting them at whatever tree location their final destination is, as is 
standard recommended practice for btrfs "upstream".

Tho personally, I just prefer that they stay as subdirs, since I don't 
have any particular need to and therefore don't want to complicate my 
btrfs use-case with subvolumes, when I already break my tree up into 
multiple independent btrfs /filesystems/ using standard partitioning, 
etc, specifically in ordered to avoid having so many data eggs in one 
filesystem basket, and thus avoid the risk of losing them all should the 
bottom of that single basket fall out with the filesystem going bad on 
me.  I know from hard learned experience with much-too-big-mdraid arrays 
how painful maintenance operations can be when they take hours or days, 
compared to the seconds (due to ssd) or minutes (were they on spinning 
rust) maintenance such as balance or scrub now takes me on each of my all 
well under hundred-gig separate btrfs, with the difference even more 
pronounced since most of the time there's only one or two filesystems I 
need to do maintenance on, instead of the whole tree.

So I use multiple small independent btrfs, and don't want or need 
subvolumes, which would only complicate my use-case.  Fortunately, I can 
avoid systemd creating those subvolumes even tho I'm on btrfs, the normal 
target for them, by simply already having the subdirs created... as 
subdirs.  Tho the initial 219 implementation bugged out on them 
(subvolume-create error because my root filesystem is deliberately left 
read-only by default, which propagated thru to a tmpfiles.d service 
failure), I filed a bug, and by 221 (IIRC) tmpfiles.d was working 
correctly, leaving my existing subdirs alone.

Unfortunately, now I have to worry about manual subdir creation to avoid 
the automated subvolume creation on a new install, or should I forget, 
worry about discovering and undoing the automated subvolume create.

Oh, well...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

