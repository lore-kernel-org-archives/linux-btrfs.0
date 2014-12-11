Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35054 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933460AbaLKDxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 22:53:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyuoX-0007lr-2T
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 04:53:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 04:53:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 04:53:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
Date: Thu, 11 Dec 2014 03:53:01 +0000 (UTC)
Message-ID: <pan$cfb2$ba6f2e5a$22f18b38$e1aba3e7@cox.net>
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<548743CE.1020403@inwind.it> <54879CFE.1090909@cn.fujitsu.com>
	<54882634.4000809@pobox.com>
	<pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net>
	<CA+qeAOo4NT5NEO97YJMq-asQVm4OZUdJECqqojTzjhmso_Jj4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dongsheng Yang posted on Wed, 10 Dec 2014 23:02:15 +0800 as excerpted:

>> And in the example, the mkfs was supplied with two devices, so there's
>> no dup metadata remaining from a formerly single-device filesystem,
>> either. (Tho there will be the small single-mode stubs, empty,
>> remaining from the mkfs process, as no balance has been run to delete
>> them yet, but those are much smaller and empty.)
> 
> Yes. One question not related here: how about delete them in the end of
> mkfs?

GB covered the old, manual balance method.  Do a btrfs balance -dusage=0
-musage=0 (or whatever, someone posted his recipe doing the same thing 
except with the single profiles instead of zero usage), and those stubs 
should disappear, as they're empty so there's nothing to rewrite when the 
balance does its thing and it simply removes them.

FWIW I actually have a mkfs helper script here that takes care of a bunch 
of site-default options such as dual-device raid1 both data/metadata, 
skinny-metadata, etc, and it actually prompts for a mountpoint (assuming 
it's already setup in fstab) and will do an immediate mount and balance 
usage=0 to eliminate the stubs if that mountpoint is filled in, again 
assuming it appears in fstab as well.  Since I keep fully separate 
filesystems to avoid putting all my data eggs in the same not-yet-fully-
stable btrfs basket, and my backup system includes periodically blowing 
away the backup and (after booting to the new backup) the working copy 
with a fresh mkfs for a clean start, the mkfs helper script is useful, 
and since I was already doing that, it was reasonably simple to extend it 
to handle the mount and stub-killing balance immediately after the mkfs.


But at least in theory, that old manual method shouldn't be necessary 
with a current (IIRC 3.18 required) kernel, since btrfs should now 
automatically detect empty chunks and automatically rebalance to remove 
them as necessary.  However, I've been busy and haven't actually tried 
3.18 yet, and thus obviously haven't done a mkfs and mount of a fresh 
filesystem to see how long it actually takes to trigger and remove those 
stubs, so for all I know it takes awhile to kick in, and if people are 
bothered by the display of the stubs before it does, they can of course 
still do it the old way.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

