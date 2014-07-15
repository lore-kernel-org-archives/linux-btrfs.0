Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaGOVHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 17:07:44 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/4] btrfs: qgroup fixes for btrfs_drop_snapshot V4
Date: Tue, 15 Jul 2014 14:06:20 -0700
Message-Id: <1405458384-17516-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, the following patches try to fix a long outstanding issue with qgroups
and snapshot deletion. The core problem is that btrfs_drop_snapshot will
skip shared extents during it's tree walk. This results in an inconsistent
qgroup state once the drop is processed. We also have a bug where qgroup
items are not deleted after drop_snapshot. The orphaned items will cause
btrfs to go readonly when a snapshot is created with the same id as the
deleted one.

The first patch adds some tracing which I found very useful in debugging
qgroup operations. The second patch is an actual fix to the problem. A third
patch, from Josef is also added. We need this because it fixes at least one
set of inconsistencies qgroups can get to via drop_snapshot. The fourth
patch adds code to delete qgroup items from disk once drop_snapshot has
completed.

With this version of the patch series, I can no longer reproduce
qgroup inconsistencies via drop_snapshot on my test disks.

Change from last patch set:

- Added patch 'btrfs: delete qgroup items in drop_snapshot'

Changes from V2-V3:

- search on bytenr and root, but not seq in btrfs_record_ref when
  we're looking for existing qgroup operations.

Changes before that (V1-V2):

- remove extra extent_buffer_uptodate call from account_shared_subtree()

- catch return values for the accounting calls now and do the right thing
  (log an error and tell the user to rescan)

- remove the loop on roots in qgroup_subtree_accounting and just use the
  nnodes member to make our first decision.

- Don't queue up the subtree root for a change (the code in drop_snapshot
  handkles qgroup updates for this block).

- only walk subtrees if we're actually in DROP_REFERENCE stage and we're
  going to call free_extent

- account leaf items for level zero blocks that we are dropping in
  walk_up_proc

Please review, thanks. Diffstat follows,
	--Mark

 fs/btrfs/ctree.c             |   20 +-
 fs/btrfs/ctree.h             |    4 
 fs/btrfs/extent-tree.c       |  291 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/qgroup.c            |  282 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h            |    4 
 fs/btrfs/super.c             |    1 
 include/trace/events/btrfs.h |   57 ++++++++
 7 files changed, 631 insertions(+), 28 deletions(-)
