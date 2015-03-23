Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14022 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbbCWIKi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:38 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89Y29012324
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 00/11] Qgroup: new record/write/record infrastructure to record correct old/new_roots.
Date: Mon, 23 Mar 2015 16:08:26 +0800
Message-ID: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
https://patchwork.kernel.org/patch/6015791/
The above test case shows a bug caused by incorrect old/new_roots.
And the incorrect old/new_roots is caused by the incorrect timing
calling btrfs_find_all_roots().

[FIX]
This patchset try to fix it using a new routine for recording delayed
ref changes:
	Old			|	New
				|record old_roots
Run delayed_ref_node operation	|Run delayed_ref_node operation
Record_ref()			|Record_ref()
				|  |- record new_roots
...				|...

delayed_qgroup_accounting()	|delayed_qgroup_accounting()
  |- record new_roots		|  |
  |- update old_refcnt using	|  |- update old_refcnt using
  |  complicated logic		|  |  old_roots list
  |- update new_refcnt using	|  |- update new_refcnt using
     new_roots			|     new_roots list

Since we record old_roots before we do delayed_ref_node operation, so
the old_roots should be accurate(*), and we won't have the problem of
the old implement, where old/new_roots is recorded too late.

*: In fact, not completely correct, explained in CONS 1) and TODO
[PROS]
1) More generic code for old/new_refcnt.
As we have old/new_roots, update routine for old/new refcnt can be
merged into one generic code.

2) More generic code for rescan
For rescan case, we don't need the special flag anymore, just pass NULL
as old_roots and every thing is done.

3) Possible generic code for both shared/exclusive extents.
Infrastructure in this patch can handle exclusive extents without much
change.
Since old_roots will be empty and new_roots will contain the only root
referring to the exclusive extent, no need for special exclusive case.

[CONS]
1) Harder fix for Liu Bo's btrfs/017 test case.
Even with this patchset, ref_node still don't a "minor" sequence number
for us to judgment which node is inserted first.
Current seq in ref_node is just "major" sequence number and it won't
help in btrfs/017, since all node's sequence number is the same.

2) Much lower pass rate on btrfs/057.
The pass rate drops greatly on btrfs/057.
Not sure why, but is highly possible related to 1).


[TODO]
1) Try to cover exclusive extent case.
If I find something may cause problem in exclusive extent routine, then
it should also be covered by the infrastructure.

2) Reintroduce minor sequence number.
To solve CONS 1).

3) Continue investigate the infamous btrfs/057 case.

[PATCHSET STRUCTURE]
Patch 1 is the already sent patch, just resend it.
Patch 2~6 are parameter/member changes, providing the basis for later
patchse.
Patch 7~9 are the core infrastructure changes.
Patch 10 is self-test change to use the new infrastructure.
Patch 11 is cleanup.(Just press d!)

Qu Wenruo (11):
  btrfs: qgroup: Cleanup open-coded old/new_refcnt update and read.
  btrfs: extent-tree: Use ref_node to replace unneeded parameters in    
    __inc_extent_ref() and __free_extent()
  btrfs: backref: Add nolock option for btrfs_find_all_roots().
  btrfs: backref: Allow find_parent_nodes() to skip given ref_node.
  btrfs: backref: Allow btrfs_find_all_roots() to skip given ref_node.
  btrfs: qgroup: Add needed parameter and member for qgroup.
  btrfs: qgroup: save and pass old_roots ulist to    
    btrfs_qgroup_record_ref().
  btrfs: qgroup: Record current referenced roots at qgroup_record_ref().
  btrfs: qgroup: Use oper->old/new_roots to update refcnt.
  btrfs: qgroup-tests: Add old_roots ulist to allow qgroup test pass.
  btrfs: qgroup: Cleanup the unneeded codes.

 fs/btrfs/backref.c            |  70 +++++--
 fs/btrfs/backref.h            |   6 +-
 fs/btrfs/extent-tree.c        | 107 ++++++----
 fs/btrfs/ioctl.c              |   4 +-
 fs/btrfs/qgroup.c             | 471 +++++++++++++-----------------------------
 fs/btrfs/qgroup.h             |   7 +-
 fs/btrfs/tests/qgroup-tests.c |  38 +++-
 7 files changed, 299 insertions(+), 404 deletions(-)

-- 
2.3.3

