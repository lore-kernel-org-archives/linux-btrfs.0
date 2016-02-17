Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51624 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169AbcBQEto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 23:49:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aVu3a-0007Eg-Jz
	for linux-btrfs@vger.kernel.org; Wed, 17 Feb 2016 05:49:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 05:49:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 05:49:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Docs]? Only one Subvolume with DUP (or different parameters)?
Date: Wed, 17 Feb 2016 04:49:37 +0000 (UTC)
Message-ID: <pan$17e03$37c598a8$93a246ff$ae65c0fd@cox.net>
References: <56C377BB.9020101@knebb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Völker posted on Tue, 16 Feb 2016 20:25:47 +0100 as excerpted:

> sorry for the simple question and I assume every developer here laughs
> about this question.
> 
> Anyway:
> 
> I have read loads of documents but did not find an answer for sure. Even
> though I assume I am right.
> 
> On a btrfs filesystem created; is it possible to have subvolumes with
> data duplication and another subvolume without (resp. with just metadata
> duplication)?
> 
> I have some large filesystems currently with ext4 and I am thinking of
> changing to btrfs. Some of the data is more important than others. So I
> want to have data duplication on the important files (sorted in a mount
> point) and without for the other subvolume.
> 
> So I want to have the advantage of redundancy of important files
> combined with the flexibility of the volume manager and shared disk
> space.

As Hugo mentions, that's not possible at this point, tho the plan is to 
make replication mode a per-subvolume or even per-file property at some 
still-future point.  Given the rate of progress, however, that future 
point is extremely likely to be at least two years out and could well be 5
+ years out -- IOW, it's nothing you could plan for at this point.

However, it's quite possible to do multiple separate btrfs, with each one 
having its own replication mode.  That is, in fact, what I do here, tho 
in my case it's more to keep all my data eggs from being in the same 
filesystem basket, in case btrfs decides to eat a filesystem, than it is 
for different replication (most of mine are raid1 across partitions on 
two devices).  If the filesystem goes, being on a different subvolume 
from whatever triggered the problem isn't going to help much, while being 
on a different filesystem entirely, which might have been mounted
read-only or not even mounted at all at the time, very likely will, and I 
prefer not having all my data eggs in the same filesystem basket, 
particularly when that filesystem basket is btrfs, which while 
stabilizing, isn't yet full stable and mature yet, even if it means a bit 
more hands-on administration than would simply shoving everything in the 
same basket and hoping the bottom doesn't drop out of it.

Tho that might be just me...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

