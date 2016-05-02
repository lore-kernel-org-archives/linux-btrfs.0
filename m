Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43083 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbcEBAiR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 20:38:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ax1sM-0001tg-6l
	for linux-btrfs@vger.kernel.org; Mon, 02 May 2016 02:38:14 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 02:38:14 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 02:38:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: apt taints kernel - btrfs destroys inode
Date: Mon, 2 May 2016 00:38:08 +0000 (UTC)
Message-ID: <pan$a8e59$e73b6bd3$47d0e1e7$4518553f@cox.net>
References: <efdhvc-3p8.ln1@aldebaran.xundeenergie.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jakob Schürz posted on Sun, 01 May 2016 15:38:22 +0200 as excerpted:

> What does this mean???
> 
> Mai 01 15:36:42 aldebaran kernel: ------------[ cut here ]------------
> Mai 01 15:36:42 aldebaran kernel: WARNING: CPU: 3 PID: 8937 at
> /build/linux-aGlcVo/linux-4.6~rc3/fs/btrfs/inode.c:9261
> btrfs_destroy_inode+0x234/0x2a0 [btrfs]


That's a known apparent false-positive warning on current 4.6-rc kernel 
btrfs.  The destroy-inode bit is related to a file deletion happening in 
the normal order of things, where this warning code is run, and 
apparently triggers even under normal operations.

It's related to some btrfs feature (I think either snapshotting or 
quotas, but don't recall which) I don't use here so I don't seem the 
warnings, but there's several threads where people have reported the 
warnings, so it's apparently quite commonly triggered, but nobody has 
reported any further problems even where the warnings are coming in the 
hundreds due to their use-case, so as I said, apparently a false-positive 
induced by normal operations.

I'd expect the warning to be either fixed to only warn when there's an 
actual issue, or be silenced, by 4.6 release.

If you want further details, as I said, there's at least two other 
threads with people reporting and discussing it, so read the last week or 
two of the list archive (or even just the non-patch original thread 
starter posts) and you'll find them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

