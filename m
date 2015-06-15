Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbbFONpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 09:45:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D7E44AC7C
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 13:45:02 +0000 (UTC)
Message-ID: <557ED6DC.6070900@suse.com>
Date: Mon, 15 Jun 2015 09:45:00 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v5] btrfs: fix automatic blockgroup remove + discard
In-Reply-To: <1434375680-4115-1-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1434375680-4115-1-git-send-email-jeffm@suse.com>

Apologies for the out-of-order post. git send-email caught ^C
at just the right time and send them without my confirmation. That's
also why the map->lookup casting patch got mixed in here.

The automatic block group removal patch introduced some regressions
in how discards are handled.

1/ FITRIM only iterates over block groups on disk - removed block groups
   won't be trimmed.
2/ Clearing the dirty bit from extents in removed block groups means that
   those extents won't be discarded when the block group is removed.
3/ More of a UI wart: We don't wait on block groups to be removed during
   read-only remount or fs umount. This results in block groups that
   /should/ have been discarded on thin provisioned storage hanging around
   until the file system is mounted read-write again.

The following patches address these problems by:
1/ Iterating over block groups on disk and then iterating over free space.
   This is consistent with how other file systems handle FITRIM.
2/ Putting removed block groups on a list so that they are automatically
   discarded during btrfs_finish_extent_commit after transaction commit.
   Note: This may still leave undiscarded space on disk if the system
   crashes after transaction commit but before discard. The file system
   itself will be compeltely consistent, but the user will need to trim
   manually.
3/ Simple: We call btrfs_delete_unused_bgs explicitly during ro-remount
   and umount.
Changelog:
v1->v2
- -odiscard
 - Fix ordering to ensure that we don't discard extents freed in an
    uncommitted transaction.
- FITRIM
  - Don't start a transaction so the entire run is transactionless
  - The loop can be interrupted while waiting on the chunk mutex and
    after the discard has completed.
  - The only lock held for the duration is the device_list_mutex.  The
    chunk mutex is take per loop iteration so normal operations should
    continue while we're running, even on large file systems.

v2->v3
- -odiscard
 - Factor out get/put block_group->trimming to ensure that cleanup always
   happens at the last reference drop.
 - Cleanup the free space cache on the last reference drop.
 - Use list_move instead of list_add in case of multiple adds.  We still
   issue a warning but we shouldn't fall over.
 - Explicitly delete unused block groups in close_ctree and ro-remount.
- FITRIM
 - Cleaned up pointer tricks that abused &NULL->member.
 - Take the commit_root_sem across loop iteration to protect against
   transaction commit moving the commit root.

v3->v4
- new: skip superblocks during discard
- new: btrfs_issue_discard passes back discarded_bytes on success

v4->v5
- new: check/align/warn on unaligned starting offset in btrfs_issue_discard
- new: handle case where superblock begins before the range on <4k filesystems
- no changes to other patches

Thanks,

-Jeff-- 
Jeff Mahoney
SUSE Labs
