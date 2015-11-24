Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59507 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbbKXI3d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 03:29:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a18yb-0003QG-J7
	for linux-btrfs@vger.kernel.org; Tue, 24 Nov 2015 09:29:25 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 09:29:25 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 09:29:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: subvols and parents - how?
Date: Tue, 24 Nov 2015 08:29:18 +0000 (UTC)
Message-ID: <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 24 Nov 2015 05:56:00 +0100 as
excerpted:

> When I use subvolumes than these have always a parent subvolume (except
> ID5), so I can basically decide between two ways:
> 
> a) make child subvolumes, e.g.
> 5
> |
> +-root   (=subvol, mountpoint /)
>   +-boot/
>   +-root/
>   +-lib/
>   +-home/ (=subvolume)
> and soon on... perhaps the whole thing without the dedicated root-
> subovlume (although that's probably not so smart, I guess).
> 
> b) place at least some of the subvolumes directly below the top-level
> and mount them e.g. via /etc/fstab, e.g.
> 5
> |
> +-root   (=subvol, mountpoint /)
> | +-boot/
> | +-root/
> | +-lib/
> +-home/ (=subvolume, mountpoint /home)
> 
> 
> Now I wondered whether this has any technical implications, but neither
> the wiki, nor the manpages seem to explain a lot here.

Very astute question! =:^)

Somewhere on the wiki I believe there's a recommendation to use (b) 
layout, but to some extent it depends on why you're actually doing 
subvolumes.  

OK, found it on the wiki.  It wasn't under use-cases, where I initially 
thought to look, but under sysadmin guide.  Specifically, see section 
4.2, managing snapshots, but I'd suggest reading the entire subvolumes 
discussion, section 4, or even most/all of the page.

https://btrfs.wiki.kernel.org/index.php/SysadminGuide

(More below.)

> The "differences", AFAIU, are the follows:
> - When I mount a given subvolume,.. it's childs are automatically
>   "there".
>   Whereas when I don't have them as childs (as in (b)) I must of course
>   mount them somehow manually.
> - Analogously for umounting.
> - I can move existing subvols to higher/lower levels, and the parent
>   IDs will change accordingly.
> 
> So basically it makes no difference, right? Or is there anything more
> technical going on? E.g. with the ref-links or so?
> Right now, there are, AFAIK, neither recursive snapshots (and especially
> not atomic ones) nor recursive send/receive, right?
> If that should ever be implemented, would I perhaps have problems with
> (a) or (b)?

If you're doing subvolumes for snapshotting and potential rollback 
purposes, layout (b) can be preferable as it allows a more direct mix and 
match rollback.

Suppose you only want to rollback /, because some update screwed you up, 
but not /home, which is fine.  If /home is a nested subvolume, then 
you're now mounting the nested home subvolume from some other nesting 
tree entirely, whereas if they're all under top-level, you simply mount 
the /home subvolume under whatever snapshot of / you are currently 
booting.

Of course the reverse applies as well, if / is fine but you want to 
rollback /home.  Again, with nesting you're reaching into some other 
nesting to mount what you want, and it can get a bit unintuitive and 
difficult to track, particularly if you go more than the two levels deep, 
but if all the snapshots are direct children of the top level ID 5, it's 
a lot easier.

Tho I'd actually suggest a variant of the flat layout they suggest in the 
sysadmin's guide.  What I'd do is something like this (using your tree 
drawing style):

5
|
+-roots (dir not subvol, note the s, rootS, plural)
| +-root (subvol, mountpoint /)
| | +-boot/ (dir)
| | +-root/ (dir)
| | +-lib/  (dir)
| | +-home/ (empty dir as mountpoint)
| +-root-snapshot-2015.0301 (dated snapshot of root)
| +-root-snapshot-2015.0601 (dated snapshot of root)
| +-root-snapshot-2015.0901 (dated snapshot of root)
+-homes (dir not subvol)
| +-home (subvol, mountpoint /home)
| +-home-snapshot-2015.0301 (dated snapshot of home)
...


Of course, you might also organize by date instead of subvol...

5
|
+- heads (dir, headS plural)
| +-root (subvol)
| +-home (subvol)
| +-whatever (subvol)
+-snapshots-2015.0301 (dir, snapshotS plural)
| +-root-2015.0301 (snapshot of heads/root)
| +-home-2015.0301 (snapshot of heads/home)
| ...
+-snapshots-2015.0601 (dir)
| +-root-2015.0601 (snapshot)
| ...
+-snapshots-2015.0901 (dir)
| +-root-2015.0901 (snapshot)
...


Either of these would make finding a desired snapshot to rollback to much 
easier than a pure flat subvols/snapshots layout, with the preferred one 
depending on whether you want subvols/snapshots grouped by date or by 
snapshotted mountpoint.

The dates organization would make cleaning up old snapshots by date, and 
visually checking that the snapshot cleanup script (if automated) is 
working as intended, somewhat easier, however.


Meanwhile, if the intention for a subvolume is simply to exclude that 
subtree from snapshotting of the parent, as might be the case for example 
if you have a VMs subvol, with the VM image files set NOCOW to avoid 
fragmentation, since snapshotting nocow files forces cow1 (a cow at the 
first write of that block, before returning to nocow, because a snapshot 
locks the existing extents in place for the snapshot, so initial writes 
to a block after a snapshot /can't be nocow or it'd change the snapshot 
too...), and it's not going to be snapshotted on perhaps a different 
schedule than the parent...

... then it can make more sense to use a nested subvolume, as the primary 
and perhaps only reason for the subvolume at all is to prevent the 
subtree from being included in the parent snapshot, and as such, it's 
unlikely to be separately mounted.

OTOH, if there's a chance you might want to mount that subvolume in a 
roll-back scenario, under the snapshot you're rolling back to, then it 
makes sense to put it directly under ID 5 again, and mount it in any case.


Then there's the security angle to consider.  With the (basically, 
possibly modified as I suggested) flat layout, mounting something doesn't 
automatically give people in-tree access to nested subvolumes (subject to 
normal file permissions, of course), like nested layout does.  And with 
(possibly modified) flat layout, the whole subvolume tree doesn't need to 
be mounted all the time either, only when you're actually working with 
subvolumes.


In general, I believe the nested layout is easier to setup initially, 
because you don't have to worry about actually mounting the subvolumes to 
make them accessible.  But flat (or modified flat, as I suggest) is 
easier for continued administration, particularly if you're doing 
snapshots and potentially rollbacks, because while doing the initial 
mount setup is more work, once the mount layout is established, mixing 
and matching various heads with snapshots of varying ages is a relatively 
simple matter of pointing each mount at the appropriate snapshot instead 
of head.  Additionally, (possibly modified) flat layout is easier to do 
subvolume/snapshot management on, because they're all in the same place, 
instead of scattered at random places within the tree.  In my quarterly 
snapshots example, for instance, suppose 2016 rolls around and you decide 
you don't need 2014's snapshots any longer.  Which layout is going to 
make it easiest to delete them all, while conversely, making it least 
likely to fat-finger things and delete the wrong ones?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

