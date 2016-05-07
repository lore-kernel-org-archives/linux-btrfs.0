Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:58376 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbcEGXLZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 May 2016 19:11:25 -0400
Date: Sun, 8 May 2016 01:11:18 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>
Subject: Re: apt taints kernel - btrfs destroys inode
Message-ID: <20160507231118.GA19573@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$a8e59$e73b6bd3$47d0e1e7$4518553f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan wrote:
> > btrfs_destroy_inode

> That's a known apparent false-positive warning on current 4.6-rc kernel 
> btrfs.  The destroy-inode bit is related to a file deletion happening in 
> the normal order of things, where this warning code is run, and 
> apparently triggers even under normal operations.

Are you guys reasonably certain it's false-positive?  If so, you _really_
want to disable the warning for 4.6, less than a week from now.  Any
reasonable user of a stable kernel who notices such a warning and stack
dumps will assume something is broken, rightfully panic and consider the
filesystem unsound.

> It's related to some btrfs feature (I think either snapshotting or 
> quotas, but don't recall which) I don't use here so I don't seem the 
> warnings, but there's several threads where people have reported the 
> warnings, so it's apparently quite commonly triggered, but nobody has 
> reported any further problems even where the warnings are coming in the 
> hundreds due to their use-case, so as I said, apparently a false-positive 
> induced by normal operations.

A data point: I've been running for a week with this WARN_ON replaced by a
printk:

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9258,7 +9258,8 @@ void btrfs_destroy_inode(struct inode *inode)
        WARN_ON(BTRFS_I(inode)->outstanding_extents);
        WARN_ON(BTRFS_I(inode)->reserved_extents);
        WARN_ON(BTRFS_I(inode)->delalloc_bytes);
-       WARN_ON(BTRFS_I(inode)->csum_bytes);
+       if (BTRFS_I(inode)->csum_bytes)
+               printk("btrfs: btrfs_destroy_inode: WARN csum_bytes\n");
        WARN_ON(BTRFS_I(inode)->defrag_bytes);
 
        /*

and no data loss or anything suspicious so far.  This box has a SSD
(moderate use) and HDD (light use), no RAID, no quotas, compress=lzo, many
subvolumes, 20ish snapshots daily (mostly sbuild for Debian packages).

[~]$ dmesg|grep btrfs_destroy_inode|wc -l
50
[~]$ uptime
 00:17:47 up 1 day, 18:44, 19 users,  load average: 0.23, 0.35, 0.61
[~]$ cat /proc/version 
Linux version 4.6.0-rc6-debug+ (kilobyte@umbar) (gcc version 6.1.1 20160430 (Debian 6.1.1-1) ) #1 SMP Fri May 6 00:33:44 CEST 2016

> I'd expect the warning to be either fixed to only warn when there's an 
> actual issue, or be silenced, by 4.6 release.

In order to get to 4.6 such a commit would need to hit Linus about right
now...


Meow!
-- 
How to exploit the Bible for weight loss:
Pr28:25: he that putteth his trust in the ʟᴏʀᴅ shall be made fat.
