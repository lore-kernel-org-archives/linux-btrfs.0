Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39263 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750737AbbDUGVi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 02:21:38 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3L6KOWC025364
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:20:24 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 00/18] New extent-oriented qgroup mechanism with minor cleanup
Date: Tue, 21 Apr 2015 14:21:16 +0800
Message-ID: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BRIEF]
This patchset mainly introduces a new qgroup mechanism, which is
originally used to fix a bug in fstest/btrfs/057.

[WORKFLOW]
The new mechanism works like the following:
0) Previous transaction is done.
   The new mechanism highly depends on commit_transaction.
   So without commit_transaction(), qgroup is not updated.

1) Record dirty extents.
   Now it has a hook in add_delayed_ref_head() which will record a
   possible dirty extent into
   trans->transaction->delayed_refs.dirty_extent_root.

2) Record old_roots for dirty extents
   old_roots is get from commit root, so it is complete accurate.

3) Record new_roots for dirty extents
   New_roots is get from current root, so we must ensure delayed_refs
   are all handled. It is quite easy done in commit_transaction().

4) Update qgroup counters with old/new_roots.

5) Transaction is committed.

[ADVANTAGES]
The advantages is obvious:
1) No more heavy/confusing ref_node operation.
   Old ref_node based qgroup makes each qgroup enabled ref_node to call
   btrfs_find_all_roots(), which is quite expensive considering the
   number of ref_nodes.
   Also we don't ever need to consider whether pass no_quota as 0 or 1,
   as dirty extents are handled automatically, no meaningful no_quota
   option any more.

2) Accuracy from design.
   Now only few things can break accuracy of new qgroup.(*)
   File clone? Leaf COW/splitting? As long as btrfs tree roots are in
   consistent status, qgroup won't be wrong.
   No more annoying and hard-to-debug btrfs/057 warning anymore.

   *: Although snapshot create/delete qgroup reassign will break the
   mechanism, but create can be handled by a small exception.
   For snapshot delete/reassign? It never works as designed.

[PATCHES]
Patch 1~3 are cleanup for delayed_refs codes, which makes the logic and
codes for merging ref_nodes more clear

Patch 4~5 are cleanup for qgroups. Just replace some open-coded functions
and reduce parameters.

Patch 6~11 are the new mechanism. Some functions like
qgroup_update_refcnt() and qgroup_update_counters() seems much like the
old functions, but for a better patch split, I have to copy some
function with new names and switch to new mechanism.
Nobody want to review a patch with 700+ inserts and 1400+ deletions,
right?

Patch 12~15 are switching to the new mechanism, and remove all the
unneeded codes. Oh yeah! Just press down 'd' !!!

Patch 16~18 are fix a btrfs/022. In theory, for the new mechanism the
best method for snapshot create/delete and qgroup reassign, is to mark
all related extent dirty and let the new mechanism to handle it.
But it's too expensive, so add a small exception for snapshot create to
resolve it.
For snapshot delete and qgroup reassign, it doesn't work now anyway.

Qu Wenruo (18):
  btrfs: backref: Don't merge refs which are not for same block.
  btrfs: delayed-ref: Use list to replace the ref_root in ref_head.
  btrfs: delayed-ref: Cleanup the unneeded functions.
  btrfs: qgroup: Cleanup open-coded old/new_refcnt update and read.
  btrfs: extent-tree: Use ref_node to replace unneeded parameters in
    __inc_extent_ref() and __free_extent()
  btrfs: qgroup: Add function qgroup_update_refcnt().
  btrfs: qgroup: Add function qgroup_update_counters().
  btrfs: qgroup: Record possible quota-related extent for qgroup.
  btrfs: qgroup: Add new function to record old_roots.
  btrfs: backref: Add special time_seq == (u64)-1 case for    
    btrfs_find_all_roots().
  btrfs: qgroup: Add new qgroup calculation function    
    btrfs_qgroup_account_extents().
  btrfs: qgroup: Switch rescan to new mechanism.
  btrfs: qgroup: Switch to new extent-oriented qgroup mechanism.
  btrfs: qgroup: Switch self test to extent-oriented qgroup mechanism.
  btrfs: qgroup: Cleanup the old ref_node-oriented mechanism.
  btrfs: ulist: Add ulist_del() function.
  btrfs: qgroup: Add the ability to skip given qgroup for old/new_roots.
  btrfs: qgroup: Make snapshot accounting work with new extent-oriented 
       qgroup.

 fs/btrfs/backref.c            |   50 +-
 fs/btrfs/ctree.h              |    2 +-
 fs/btrfs/delayed-ref.c        |  372 +++++---------
 fs/btrfs/delayed-ref.h        |   29 +-
 fs/btrfs/disk-io.c            |    8 +-
 fs/btrfs/extent-tree.c        |  203 ++------
 fs/btrfs/extent-tree.h        |    0
 fs/btrfs/qgroup.c             | 1090 ++++++++++-------------------------------
 fs/btrfs/qgroup.h             |   61 +--
 fs/btrfs/tests/qgroup-tests.c |  109 ++++-
 fs/btrfs/transaction.c        |   73 ++-
 fs/btrfs/transaction.h        |   23 +
 fs/btrfs/ulist.c              |   47 +-
 fs/btrfs/ulist.h              |    1 +
 include/trace/events/btrfs.h  |   55 ---
 15 files changed, 711 insertions(+), 1412 deletions(-)
 create mode 100644 fs/btrfs/extent-tree.h

-- 
2.3.5

