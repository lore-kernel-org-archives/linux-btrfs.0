Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43459 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbbK1Gtg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 01:49:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a2ZK6-00038X-Iz
	for linux-btrfs@vger.kernel.org; Sat, 28 Nov 2015 07:49:30 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 07:49:30 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 07:49:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Sat, 28 Nov 2015 06:49:23 +0000 (UTC)
Message-ID: <pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
	<pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
	<1448582805.11377.9.camel@scientia.net>
	<pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
	<1448683025.6837.4.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sat, 28 Nov 2015 04:57:05 +0100 as
excerpted:

> On Fri, 2015-11-27 at 03:38 +0000, Duncan wrote:
>> AFAIK, per-subvolume *atime mounts should already be working.
> Ah I see. :)
> 
> Still, specifically for snapshots that's a bit unhandy, as one typically
> doesn't mount each of them... one rather mount e.g. the top level subvol
> and has a subdir snapshots there...
> So perhaps the idea of having snapshots that are per se noatime is still
> not too bad.

Read-only snapshots?  That'd do it, and of course you can toggle the read-
only property (see btrfs property and its btrfs-property manpage).

Alternatively, mount the toplevel subvol read-only or noatime on one 
mountpoint, and bind-mount it read-write or whatever other appropriate 
*atime elsewhere (or the reverse, if more appropriate).  Then use the 
noatime or read-only one unless you specifically wanted atimes updated.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

