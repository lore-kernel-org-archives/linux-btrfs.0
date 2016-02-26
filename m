Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54558 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbcBZVIB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 16:08:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aZPcF-0005ri-34
	for linux-btrfs@vger.kernel.org; Fri, 26 Feb 2016 22:07:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Feb 2016 22:07:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Feb 2016 22:07:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: upgrading kernel 3.13 to 3.16
Date: Fri, 26 Feb 2016 21:07:51 +0000 (UTC)
Message-ID: <pan$d537a$6926bb47$68b136e2$e457895a@cox.net>
References: <CAO5K3OdzXgXpSNqCOqvMwVgQWiEF9p91ymB+uXjFRCCK24QWZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vytautas D posted on Fri, 26 Feb 2016 10:50:12 +0000 as excerpted:

> Hi all,
> 
> Are there any known issues upgrading btrfs running ubuntu kernel 3.13 to
> 3.16 ? System was once converted from ext4 using btrfs-convert (
> btrfs-progs 3.17 ).
> 
> The commit that worries me is following:
> *  Btrfs: incompatible format change to remove hole extents (+373/-56)
> (
> http://linux-btrfs.vger.kernel.narkive.com/syNRZbHS/patch-btrfs-
incompatible-format-change-to-remove-hole-extents-v3#post1
> )
> 
> would this block me from reverting system with a snapshot back to kernel
> 3.13 ?
> After upgrade would the system continue writing more metadata ?

As Austin H says about that commit, but in the broader sense as well, 
btrfs policy since inclusion in the mainline kernel (with one exception 
in the first kernel series after that, which Linus made *very* clear he 
didn't appreciate as he was actually running btrfs on something and it 
made switching kernels back and forth across that exception, for testing, 
nearly impossible), has been that on existing btrfs, new features that 
affect the on-device format must be specifically enabled.

IOW, no worries about incompatible upgrades on existing filesystems -- if 
such bugs happen at all they're treated exactly as that, regression bugs, 
and are fixed at high priority, with enough people running btrfs now that 
such bugs are likely to be found rather fast and a *BIG* stink raised 
about them not being found and fixed before they even reached mainline.

/New/ btrfs, or fresh conversions from ext* using the converter when the 
creation/conversion is done from a newer kernel with intent to use an 
older kernel, are different.  In that case, the creation/conversion 
options will often enable new features and old kernels won't be able to 
mount the filesystem.  However, there are options available to create 
older on-device formats as well, when the filesystems are intended to be 
mounted on older kernels.


All that said, you are **WAY** behind list-recommended kernels, even with 
kernel 3.16.  Btrfs is considered "stabilizing, but not yet entirely 
stable and mature."  As such, the strong on-list recommendation is to 
choose either the current or mainline LTS kernel series, and to run no 
further back than next to last kernel series in either.  With the current 
4.4 kernel also being LTS, that would be 4.4 or 4.3 if you choose the 
current kernels, and the LTS 4.4 or 4.1 series if you're doing LTS.  With 
4.4 reasonably new, it's understood if you're still on the previous LTS 
before that, 3.18, but if you're on 3.18, you'd be strongly encouraged to 
upgrade to at least 4.1 and preferably 4.4 ASAP.

Older kernels, at least back to 3.12 where the "experimental" label was 
officially pealed off and btrfs (semi-)officially reached its current 
status of "stabilizing, but not entirely stable or mature", are "best 
effort" support.  We do still try to help as best we can, but the first 
recommendation you'll get upon posting to the list is "please upgrade to 
a kernel more in line with btrfs' 'stabilizing but not fully stable' 
status."

Yes there are reasons people may wish to run really old kernels.  
However, such reasons really aren't compatible with running a still 
stablizing filesystem like btrfs in the first place, and so many bugs 
have been fixed and development focus has simply moved on since then, 
that supporting btrfs on such old kernels really isn't practical, as for 
us it really is ancient, and buggy, history.  So the recommendation is, 
if you /do/ have a reason to run such old kernels, generally, a wish for 
stability and lack of change, then you really should consider running 
something other than btrfs, because the fact of the matter is, it's still 
changing fast, and simply doesn't yet reach the level of stability that 
running such old kernels indicates you want/need.  So choose one or the 
other, btrfs on reasonably current kernels if you want it, or stability 
on older kernels, without btrfs, if you want/need that.

All /that/ said, yes, some distros do claim support on older kernels, and 
indeed, they may well be backporting bug patches as appropriate to 
properly support that claim.  But that's their claim and their support.  
On the list we're focused on newer kernels and features, and while we try 
not to break older and doing so is a bug we'll patch if we find it, as a 
rule we don't track those distros and what patches they may or may not 
have backported, and thus have no way of properly supporting them.  So if 
you're relying on distro support for btrfs on such old kernels, you 
really should be looking to them for that support, not to this list, as 
we'll still do our best effort, but the fact is, it's not going to be to 
the level of support we'd be able to give if you were running kernels 
within our recommended kernel support time frame, the last two of either 
current or LTS kernel series, and often, the best we'll be able to do 
with such old kernels is recommend you either try a newer kernel, or look 
to your distro, not to us, if trying a newer kernel isn't feasible for 
you.  /Or/, simply choose a filesystem more appropriate to your stability 
and support needs, which wouldn't be btrfs, as it's simply not a 
recommended choice, at least here on-list, if you're not planning to keep 
to the recommended last two kernel release series of either current or 
LTS.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

