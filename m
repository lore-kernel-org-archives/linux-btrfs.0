Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58736 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbcBVXah (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 18:30:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aXzvx-0007nI-PU
	for linux-btrfs@vger.kernel.org; Tue, 23 Feb 2016 00:30:30 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 00:30:29 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 00:30:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Major HDD performance degradation on btrfs receive
Date: Mon, 22 Feb 2016 23:30:20 +0000 (UTC)
Message-ID: <pan$9ab32$bee891f3$832766e9$6d69ce8@cox.net>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nazar Mokrynskyi posted on Mon, 22 Feb 2016 20:58:45 +0100 as excerpted:

> What is wrong with noatime,relatime? I'm using them for a long time as
> good compromise in terms of performance.

The one option ends up canceling the other, as they're both atime related 
options that say do different things.

I'd have to actually setup a test or do some research to be sure which 
one overrides the other (but someone here probably can say without 
further research), tho I'd /guess/ the latter one overrides the earlier 
one, which would effectively make them both pretty much useless, since 
relatime is the normal kernel default and thus doesn't need to be 
specified.

Noatime is strongly recommended for btrfs, however, particularly with 
snapshots, as otherwise, the changes between snapshots can consist mostly 
of generally useless atime changes.

(FWIW, after over a decade of using noatime here (I first used it on the 
then new reiserfs, after finding a recommendation for it on that), I got 
tired of specifying the option on nearly all my fstab entries, and now 
days carry a local kernel patch that changes the default to noatime, 
allowing me to drop specifying it everywhere.  I don't claim to be a 
coder, let alone a kernel level coder, but as a gentooer used to building 
from source for over a decade, I've found that I can often find the code 
behind some behavior I'd like to tweak, and given good enough comments, I 
can often create trivial patches to accomplish that tweak, even if it's 
not exactly the code a real C coder would choose to use, which is exactly 
what I've done here.  So now, unless some other atime option is 
specified, my filesystems are all mounted noatime.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

