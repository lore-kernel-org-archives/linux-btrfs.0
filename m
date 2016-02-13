Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38324 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbcBMM2X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 07:28:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aUZJD-0007lO-JK
	for linux-btrfs@vger.kernel.org; Sat, 13 Feb 2016 13:28:19 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Feb 2016 13:28:19 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Feb 2016 13:28:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is there now a way to migrate FS without losing shared COW
 blocks between subvolumes?
Date: Sat, 13 Feb 2016 12:28:13 +0000 (UTC)
Message-ID: <pan$d18dd$d9074a4a$a174d451$aaf0a831@cox.net>
References: <20160213032846.GB6717@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 12 Feb 2016 19:28:46 -0800 as excerpted:

> btrfs send lets you keep COW blocks within a subvolume.
> But if I have lots of backups where subvolumes have shared data, and I
> need to migrate this to a new filesystem, is there a decent way?
> 
> I know I can btrfs device add new drive as raid1, but I'm trying to
> migrate off an old filesystem that likely wasn't created well. Is there
> a way to do that?
> I guess ideally I'd need btrfs send on a volume level, not subvolume
> level.

Unless I'm mistaken, what you're looking for is btrfs send -c.  You're 
still sending a subvolume, but the -c says to consider the supplied clone-
src parameter for just that, cloned, aka shared, sources, and unlike
-p parent, multiple such -c cloned-src options are allowed, so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

