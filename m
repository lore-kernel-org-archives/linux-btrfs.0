Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59897 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbbLVBxR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 20:53:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBC8Z-0006Jj-2u
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 02:53:15 +0100
Received: from ip5f5ae08a.dynamic.kabel-deutschland.de ([95.90.224.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 02:53:15 +0100
Received: from hurikhan77 by ip5f5ae08a.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 02:53:15 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs check inconsistency with raid1, part 1
Date: Tue, 22 Dec 2015 02:48:04 +0100
Message-ID: <20151222024804.5c4f7da2@jupiter.sol.kaishome.de>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
	<CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
	<566E77FA.3050405@cn.fujitsu.com>
	<CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
	<CAJCQCtSEx_wYPkfazik0bcpQwXxJCA=O5f0o6RbxON4jjB4q7A@mail.gmail.com>
	<5677592F.5000202@cn.fujitsu.com>
	<CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
	<567762A3.9060007@cn.fujitsu.com>
	<20151222020529.1ac0c913@jupiter.sol.kaishome.de>
	<5678A5CC.7050900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 22 Dec 2015 09:22:20 +0800
schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:

> 
> 
> Kai Krakow wrote on 2015/12/22 02:05 +0100:
> > Am Mon, 21 Dec 2015 10:23:31 +0800
> > schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
> >
> >>
> >>
> >> Chris Murphy wrote on 2015/12/20 19:12 -0700:
> >>> On Sun, Dec 20, 2015 at 6:43 PM, Qu Wenruo
> >>> <quwenruo@cn.fujitsu.com> wrote:
> >>>>
> >>>>
> >>>> Chris Murphy wrote on 2015/12/20 15:31 -0700:
> >>>
> >>>>> I think the cause is related to bus power with buggy USB 3 LPM
> >>>>> firmware (these enclosures are cheap maybe $6). I've found some
> >>>>> threads about this being a problem, but it's not expected to
> >>>>> cause any corruptions. So, the fact Btrfs picks up one some
> >>>>> problems might prove that (somewhat) incorrect.
> >>>>
> >>>>
> >>>> Seems possible. Maybe some metadata just failed to reach disk.
> >>>> BTW, did I asked for a btrfs-show-super output?
> >>>
> >>> Nope. I will attach to this email below for both devices.
> >>>
> >>>> If that's the case, superblock on device 2 maybe older than
> >>>> superblock on device 1.
> >>>
> >>> Yes, looks iike devid 1 transid 4924, and devid 2 transid 4923.
> >>> And it's devid 2 that had device reset and write errors when it
> >>> vanished and reappeared as a different block device.
> >>>
> >>
> >> Now all the problem is explained.
> >>
> >> You should be good to mount it rw, as RAID1 will handle all the
> >> problem.
> >
> > How should RAID1 handle this if both copies have valid checksums
> > (as I would assume here unless shown otherwise)? This is an even
> > bigger problem with block based RAID1 which does not have checksums
> > at all. Luckily, btrfs works different here.
> 
> No, these two devices don't have the same generation, which means
> they point to *different* bytenr.
> 
> Like the following:
> 
> Super of Dev1:
> gen: X + 1
> root bytenr: A (Btrfs logical)
> logical A is mapped to A1 on dev1 and A2 on dev2.
> 
> Super of Dev2:
> gen: X
> root bytenr: B
> Here we don't need to bother bytenr B though.
> 
> Due to the power bug, A2 and super of dev2 is not written to dev2.
> 
> So you should see the problem now.
> A1 on dev1 contains *valid* tree block, but A2 on dev2 doesn't(empty 
> data only).
> 
> And your assumption on "both have valid copies" is wrong.
> 
> Check all the 4 attachment in previous mail.

I did only see those attachments at a second glance. Sry.

Primarily I just wanted to note that RAID1 per-se doesn't mean anything
more than: we have two readable copies but we don't know which one is
correct. As in: let the admin think twice about it before blindly
following a guide.

This is why I pointed out btrfs csums which make this a little better
which in turn has further consequences as you describe (for the
treeblock).

In contrast to block-level RAID btrfs usually has the knowledge which
block is correct and which is not.

I just wondered if btrfs allows for the case where both stripes could
have valid checksums despite of btrfs-RAID - just because a failure
occurred right on the spot.

Is this possible? What happens then? If yes, it would mean not to
blindly trust the RAID without doing the homeworks.

> >> Then you can either use scrub on dev2 to fix all the
> >> generation mismatch.
> >
> > I better understand why this could fix a problem...
> 
> Why not?
> 
> Tree block/data copy on dev1 is valid, but tree block/data copy on
> dev2 is empty(not written), so btrfs detects the csum error, and
> scrub will try to rewrite it.
> 
> After rewrite, both copy on dev1 and dev2 with match and fix the
> problem.

Exactly. ;-) Didn't say anything against it.


-- 
Regards,
Kai

Replies to list-only preferred.

