Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38453 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbaKSDiD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 22:38:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xqw5g-0000Lt-3t
	for linux-btrfs@vger.kernel.org; Wed, 19 Nov 2014 04:38:00 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 04:38:00 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 04:38:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Wed, 19 Nov 2014 03:37:50 +0000 (UTC)
Message-ID: <pan$3715b$a39c802c$7c739200$ccd1cef0@cox.net>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
	<54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com> <546BF268.5050706@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Tue, 18 Nov 2014 17:29:12 -0800 as excerpted:

> On 11/18/2014 07:42 AM, Phillip Susi wrote:
> 
>> On 11/18/2014 1:16 AM, Chris Murphy wrote:
>>> (stuff about UUIDs and LVM snapshots).
>  > (suggestion to use LVM paths instead).
> 
> This is also an XFS+LVM+LVM_Snapshot problem going back to at least
> 2009. It's inherent to the block-device-level snapshot phenomonia.
> 
> q.v. http://www.miljan.org/main/2009/11/16/lvm-snapshots-and-xfs/ et al
> 
> In XFS you attack the snapshot with a command to regenerate the UUID as
> soon as you take the snapshot. I don't think there is a "regenerate all
> my UUIDs" command for BTRFS.

Which was part of my point in my reply.  Btrfs embeds the UUID in the 
metadata deeply enough that it's no simple task to simply change it to 
something else and be done.  It's quite a complicated operation for any 
(future, none current) tool that attempts it, with the most likely 
candidate being an option to btrfs balance or the like, but even then, 
we're looking at a timescale of hours for spinning rust.

So while it's possible in theory, in practice such a regenerate-all UUIDs 
command for btrfs isn't available yet, and given the time involved in 
rewriting all those metadata UUIDs to something else, during which the 
filesystem's in a critically unstable state, and the limited use-case 
with other alternatives, such a tool isn't all /that/ practical in any 
case.

Making an entirely new btrfs and doing a btrfs send/receive for the 
duplicate, or using btrfs snapshots, is a more practical way to go.  (Tho 
watch out for the implications of btrfs snapshots on nocow files!)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

