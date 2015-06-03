Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbbFCOsC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jun 2015 10:48:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AFCADAC69
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2015 14:48:00 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: fix automatic blockgroup remove + discard
Date: Wed,  3 Jun 2015 10:47:51 -0400
Message-Id: <1433342874-7099-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
 - Fix ordering to ensure that we dont' discard extents freed in an
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

Please apply.

Thanks,

-Jeff

