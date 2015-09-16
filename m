Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60874 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbbIPFCe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 01:02:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zc4rY-0006Jn-4u
	for linux-btrfs@vger.kernel.org; Wed, 16 Sep 2015 07:02:32 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 07:02:32 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 07:02:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel BUG at
 =?us-ascii?Q?linux-4=2E2=2E0=2Ffs=2Fbtrfs=2Fextent-tree=2Ec=3A183?=
 =?us-ascii?Q?3?= on rebalance
Date: Wed, 16 Sep 2015 05:02:26 +0000 (UTC)
Message-ID: <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
	<2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
	<532aadf0f92d08d3d2b274173548aee1@all.all>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stéphane Lesimple posted on Tue, 15 Sep 2015 23:47:01 +0200 as excerpted:

> Le 2015-09-15 16:56, Josef Bacik a écrit :
>> On 09/15/2015 10:47 AM, Stéphane Lesimple wrote:
>>>> I've been experiencing repetitive "kernel BUG" occurences in the past
>>>> few days trying to balance a raid5 filesystem after adding a new
>>>> drive.
>>>> It occurs on both 4.2.0 and 4.1.7, using 4.2 userspace tools.
>>> 
>>> I've ran a scrub on this filesystem after the crash happened twice,
>>> and if found no errors.
>>> 
>>> The BUG_ON() condition that my filesystem triggers is the following :
>>> 
>>> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
>>> // in insert_inline_extent_backref() of extent-tree.c.
>>> 
>> Does btrfsck complain at all?

Just to elucidate a bit...

Scrub is designed to detect, and where there's a second copy available 
(dup or raid1/10 modes, raid5/6 modes can reconstruct from parity) 
correct, exactly one problem, corruption where the checksum stored at 
data write doesn't match that computed on data read back from storage.  
As such, it detects/corrects media errors and (perhaps more commonly) 
corrupted data due to crashes in the middle of the write, but if the data 
was bad when it was written in the first place and thus the checksum 
covering it simply validates what was already bad before the write 
happened, scrub will be none the wiser and will happily validate the 
incorrect data, since it's a totally valid checksum covering data that 
was bad before the checksum was ever created.

Which is where btrfs check comes in and why JB asked you to run it, since 
unlike scrub, check is designed to catch filesystem logic errors.

> Thanks for your suggestion.
> You're right, even if btrfs scrub didn't complain, btrfsck does :
> 
> checking extents
> bad metadata [4179166806016, 4179166822400) crossing stripe boundary
> bad metadata [4179166871552, 4179166887936) crossing stripe boundary
> bad metadata [4179166937088, 4179166953472) crossing stripe boundary

This is an actively in-focus bug ATM, and while I'm not a dev and can't 
tell you for sure that it's behind the specific balance-related crash and 
traces you posted (tho I believe it so), it certainly has the potential 
to be that serious, yes.

The most common cause is a buggy btrfs-convert that was creating invalid 
btrfs when converting from ext* at one point.  AFAIK they've hotfixed the 
immediate convert issue, but are still actively working on a longer term 
proper fix.  Meanwhile, while btrfs check does now detect the issue (and 
even that is quite new code, added in 4.2 I believe), there's still no 
real fix for what was after all a defective btrfs from the moment the 
convert was done.

So where that's the cause, the filesystem was created from an ext* fs 
using a buggy btrfs-convert and is thus actually invalid due to this 
cross-stripe-metadata, the current fix is to back up the files you want 
to keep (and FWIW, as any good sysadmin will tell you, a backup that 
hasn't been tested restorable isn't yet a backup, as the job isn't 
complete), then blow away and recreate the filesystem properly, using 
mkfs.btrfs, and of course then restore to the new filesystem.

If, however, you created the filesystem using mkfs.btrfs, then the 
problem must have occurred some other way.  Whether there's some other 
cause beyond the known cause, a buggy btrfs-convert, has in fact been in 
question, so in this case the devs are likely to be quite interested 
indeed in your case and perhaps the filesystem history that brought you 
to this point.  The ultimate fix is likely to be the same (unless the 
devs have you test new fix code for btrfs check --repair), but I'd 
strongly urge you to delay blowing away the filesystem, if possible, 
until the devs have a chance to ask you to run other diagnostics and 
perhaps even get a btrfs-image for them, since you may well have 
accidentally found a corner-case they'll have trouble reproducing, 
without your information.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

