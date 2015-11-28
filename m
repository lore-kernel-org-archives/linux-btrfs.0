Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44061 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbbK1HfJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 02:35:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a2a2B-0003lG-Ro
	for linux-btrfs@vger.kernel.org; Sat, 28 Nov 2015 08:35:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 08:35:03 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 08:35:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: fix unprotected list move from unused_bgs to
 deleted_bgs list
Date: Sat, 28 Nov 2015 07:34:57 +0000 (UTC)
Message-ID: <pan$74d49$6dea473f$1e446cbc$abd9cb3c@cox.net>
References: <1448642305-26199-1-git-send-email-fdmanana@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fdmanana posted on Fri, 27 Nov 2015 16:38:25 +0000 as excerpted:

> As of my previous change titled "Btrfs: fix scrub preventing unused
> block groups from being deleted", the following warning at
> extent-tree.c:btrfs_delete_unused_bgs() can be hit when we mount the a
> filesysten with "-o discard":

This set of questions doesn't have anything directly to do with your 
patch, but it does have to do with unused blockgroup deletion, which of 
course your patch does too.

When does unused blockgroup deletion occur?  Is there a waiting period 
after a new block group is created before it's deleted?  (I'd suppose so, 
so there's no race between creation in ordered to actually use it, and 
immediate deletion before it can be used.)  How long?

I suppose you've seen the discussion on defrag apparently not having as 
many uncongested data chunks to work with now, as they're all deleted, 
making it less effective since the available blocks of free space are 
likely to be much smaller now, whereas previously it could very 
frequently find whole gigs free to use at a time.  First of all, I've not 
seen a direct confirmation from a dev on that theory yet, tho IIRC Hugo 
said it made sense, so that'd be useful.  Second, how trivial/major is 
patching defrag to be rather greeder with chunk allocation, when it can't 
find existing free space blocks of sufficient size?  Is that going to 
have to wait for the eventual defrag rewrite to enable reflink/snapshot 
awareness again?

And while waiting for that, is my suggested but as yet untested 
workaround of doing a bunch of 1 GiB file truncates to force data chunk 
allocation, syncing, then either deleting them (if the wait before empty-
chunk deletion will allow time for the defrag to claim them), or 
truncating them to say 3.9 KiB (just under a single 4 KiB block) to keep 
the chunks claimed while freeing most of them (if the wait before empty-
chunk deletion is too short to allow defrag to claim entirely empty 
chunks), followed by another sync, before the defrag, likely to work?  If 
not, is there some other way to force data chunk allocation and/or 
temporarily suspend empty-data-chunk deletion to give defrag some 
uncongested free space to work with?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

