Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39033 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbcB1DpT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 22:45:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aZsIH-0002V4-Fj
	for linux-btrfs@vger.kernel.org; Sun, 28 Feb 2016 04:45:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 04:45:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 04:45:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs equivalent for zfs send -R
Date: Sun, 28 Feb 2016 03:45:10 +0000 (UTC)
Message-ID: <pan$e2074$912b63a0$272af732$4acdc80a@cox.net>
References: <56D18C3F.9000105@it.auth.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Γιώργος Πάλλας posted on Sat, 27 Feb 2016 13:45:03 +0200 
as excerpted:

> Hi all.
> 
> If I have a btrfs subvolume 'subv' and then subvolumes subv/sub1,
> subv/sub2, subv/sub3, is there a way to snapshot all the subv tree and
> then recursively send it remotely?
> 
> I think this would be the analogous of zfs snapshot -r, and then zfs
> send -R.

As a list regular and btrfs user myself, but not a dev...

No idea about zfs and my own btrfs use-case doesn't use btrfs send/
receive either, so this is primarily from previous list posts, with a 
quick look at the (v4.4.1) btrfs-send manpage as well... 

Recursive send isn't yet supported, only one at a time.

Based on a previous comment from someone who apparently looked at the 
code (but isn't a btrfs dev either), there's possibly some code for -r 
(recursive) already in the repo (or maybe it's simply a comment reserving 
the -r option?), but it doesn't work yet.

However, it shouldn't be horribly difficult to hack up scripts that 
automate the otherwise manual recursive-send/receive for you, as I'd very 
likely do myself if I needed that functionality. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

