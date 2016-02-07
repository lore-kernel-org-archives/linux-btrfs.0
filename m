Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38401 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbcBGUHY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Feb 2016 15:07:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aSVc8-0006un-PB
	for linux-btrfs@vger.kernel.org; Sun, 07 Feb 2016 21:07:20 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 21:07:20 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 21:07:20 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Use fast device only for metadata?
Date: Sun, 7 Feb 2016 21:07:13 +0100
Message-ID: <20160207210713.7e4661a8@jupiter.sol.kaishome.de>
References: <874mdktk4t.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 07 Feb 2016 11:06:58 -0800
schrieb Nikolaus Rath <Nikolaus@rath.org>:

> Hello,
> 
> I have a large home directory on a spinning disk that I regularly
> synchronize between different computers using unison. That takes ages,
> even though the amount of changed files is typically small. I suspect
> most if the time is spend walking through the file system and checking
> mtimes.
> 
> So I was wondering if I could possibly speed-up this operation by
> storing all btrfs metadata on a fast, SSD drive. It seems that
> mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and the
> file contents in single mode. However, I could not find a way to tell
> btrfs to use a device *only* for metadata. Is there a way to do that?
> 
> Also, what is the difference between using "dup" and "raid1" for the
> metadata? 

You may want to try bcache. It will speedup random access which is
probably the main cause for your slow sync. Unfortunately it requires
you to reformat your btrfs partitions to add a bcache superblock. But
it's worth the efforts.

I use a nightly rsync to USB3 disk, and bcache reduced it from 5+ hours
to typically 1.5-3 depending on how much data changed.

-- 
Regards,
Kai

Replies to list-only preferred.

