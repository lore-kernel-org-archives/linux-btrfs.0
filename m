Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57358 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbaCCSQ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 13:16:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WKXPg-0000Zc-7I
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 19:16:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 19:16:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 19:16:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Mon, 3 Mar 2014 18:16:01 +0000 (UTC)
Message-ID: <pan$b5b02$85505b$f53ee629$e32b9776@cox.net>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike Russo posted on Mon, 03 Mar 2014 17:23:43 +0000 as excerpted:

> I'm trying to convert a disk from single (/dev/sdc1) to RAID1
> (dev/sdd1), and the filesystem was previously ext4 but the conversion
> seemed to go just fine, and I have no snapshots. System and metadata
> convert, and almost all my data converts, but there are 70 stubborn GB
> (14 blocks of 5GB each) that refuse to convert and I get ENOSPC errors
> when trying to reallocate them.

While I created entirely new btrfs filesystems here and copied everything 
over rather than converting so I've not had personal experience with the 
conversion process...

The wiki[1] says[2] that while the conversion process uses the same data 
blocks for both ext3/4 and btrfs, it duplicates the ext3/4 metadata, 
creating a new btrfs copy (or two, for default metadata dup mode), 
leaving the original ext3/4 copy untouched.  Btrfs modifications are then 
done using standard btrfs COW (copy-on-write) methods, so the ext3/4 
data, while originally shared, remains untouched as well.

That allows rollback if desired, but does tie up some some space with the 
automatically created btrfs "snapshot" that contains the ext3/4 metadata 
and untouched data.  While you say you have no snapshots, it's unclear 
whether you mean none that you've created /since/ the conversion, but you 
didn't delete that original snapshot so still have it, or whether you 
deleted that automatically created btrfs snapshot of the old ext3/4 
filesystem and simply didn't specifically mention it.

I'm guessing that it's the former, and that btrfs is refusing to balance/
restripe that old ext3/4 snapshot albeit with a very confusing ENOSPC 
error message, since it'd kill the old ext3/4 filesystem and you could no 
longer rollback.

If that's the case, the page at [2] explains how you get rid of the old 
ext3/4 snapshot once you're sure you won't be rolling back and thus no 
longer need it.  With a bit of luck, that's all you need to do, and after 
deleting that, you can finish your balance/restripe. =:^)

If you've already btrfs subvol delete-ed the ext2_saved subvolume, or if 
you hadn't but doing so doesn't solve the problem, well, I went for the 
low-hanging-fruit solution but obviously that wasn't it. =:^(  Hopefully 
someone else can help further.

---
[1] https://btrfs.wiki.kernel.org  Bookmark it! =:^)

[2] https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

