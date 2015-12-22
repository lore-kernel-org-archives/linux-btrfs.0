Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58465 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbbLVBFi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 20:05:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBBOS-0007k1-E1
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 02:05:36 +0100
Received: from ip5f5ae08a.dynamic.kabel-deutschland.de ([95.90.224.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 02:05:36 +0100
Received: from hurikhan77 by ip5f5ae08a.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 02:05:36 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs check inconsistency with raid1, part 1
Date: Tue, 22 Dec 2015 02:05:29 +0100
Message-ID: <20151222020529.1ac0c913@jupiter.sol.kaishome.de>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
	<CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
	<566E77FA.3050405@cn.fujitsu.com>
	<CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
	<CAJCQCtSEx_wYPkfazik0bcpQwXxJCA=O5f0o6RbxON4jjB4q7A@mail.gmail.com>
	<5677592F.5000202@cn.fujitsu.com>
	<CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
	<567762A3.9060007@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 21 Dec 2015 10:23:31 +0800
schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:

> 
> 
> Chris Murphy wrote on 2015/12/20 19:12 -0700:
> > On Sun, Dec 20, 2015 at 6:43 PM, Qu Wenruo
> > <quwenruo@cn.fujitsu.com> wrote:
> >>
> >>
> >> Chris Murphy wrote on 2015/12/20 15:31 -0700:
> >
> >>> I think the cause is related to bus power with buggy USB 3 LPM
> >>> firmware (these enclosures are cheap maybe $6). I've found some
> >>> threads about this being a problem, but it's not expected to
> >>> cause any corruptions. So, the fact Btrfs picks up one some
> >>> problems might prove that (somewhat) incorrect.
> >>
> >>
> >> Seems possible. Maybe some metadata just failed to reach disk.
> >> BTW, did I asked for a btrfs-show-super output?
> >
> > Nope. I will attach to this email below for both devices.
> >
> >> If that's the case, superblock on device 2 maybe older than
> >> superblock on device 1.
> >
> > Yes, looks iike devid 1 transid 4924, and devid 2 transid 4923. And
> > it's devid 2 that had device reset and write errors when it vanished
> > and reappeared as a different block device.
> >
> 
> Now all the problem is explained.
> 
> You should be good to mount it rw, as RAID1 will handle all the
> problem.

How should RAID1 handle this if both copies have valid checksums (as I
would assume here unless shown otherwise)? This is an even bigger
problem with block based RAID1 which does not have checksums at all.
Luckily, btrfs works different here.

> Then you can either use scrub on dev2 to fix all the
> generation mismatch.

I better understand why this could fix a problem...

> Although I prefer to wipe dev2 and mount dev1 as degraded, and
> replace the missing dev2 with a good device/usb port.

Given the assumption above I'd do that, too (but check if the
"original" has no block errors before discarding the mirror).


-- 
Regards,
Kai

Replies to list-only preferred.

