Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60392 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758080Ab2IFKov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:51 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A1ANp017479
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:01:11 +0800
Message-ID: <50487459.6060701@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:00:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 02/12] Btrfs: fix full backref problem when inserting shared
 block reference
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

If we create several snapshots at the same time, the following BUG_ON() will be
triggered.

	kernel BUG at fs/btrfs/extent-tree.c:6047!

Steps to reproduce:
 # mkfs.btrfs <partition>
 # mount <partition> <mnt>
 # cd <mnt>
 # for ((i=0;i<2400;i++)); do touch long_name_to_make_tree_more_deep$i; done
 # for ((i=0; i<4; i++))
 > do
 > mkdir $i
 > for ((j=0; j<200; j++))
 > do
 > btrfs sub snap . $i/$j
 > done &
 > done

The reason is:
Before transaction commit, some operations changed the fs tree and new tree
blocks were allocated because of COW. We used the implicit non-shared back
reference for those newly allocated tree blocks because they were not shared by
two or more trees.

And then we created the first snapshot for the fs tree, according to the back
reference rules, we also used implicit back refs for the child tree blocks of
the root node of the fs tree, now those child nodes/leaves were shared by two
trees.

Then We didn't deal with the delayed references, and continued to change the fs
tree(created the second snapshot and inserted the dir item of the new snapshot
into the fs tree). According to the rules of the back reference, we added full
back refs for those tree blocks whose parents have be shared by two trees.
Now some newly allocated tree blocks had two types of the references.

As we know, the delayed reference system handles these delayed references from
back to front, and the full delayed reference is inserted after the implicit
ones. So when we dealt with the back references of those newly allocated tree
blocks, the full references was dealt with at first. And if the first reference
is a shared back reference and the tree block that the reference points to is
newly allocated, It would be considered as a tree block which is shared by two
or more trees when it is allocated and should be a full back reference not a
implicit one, the flag of its reference also should be set to FULL_BACKREF.
But in fact, it was a non-shared tree block with a implicit reference at
beginning, so it was not compulsory to set the flags to FULL_BACKREF. So BUG_ON
was triggered.

We have several methods to fix this bug:
1. deal with delayed references after the snapshot is created and before we
   change the source tree of the snapshot. This is the easiest and safest way.
2. modify the sort method of the delayed reference tree, make the full delayed
   references be inserted before the implicit ones. It is also very easy, but
   I don't know if it will introduce some problems or not.
3. modify select_delayed_ref() and make it select the implicit delayed reference
   at first. This way is not so good because it may wastes CPU time if we have
   lots of delayed references.
4. set the flags to FULL_BACKREF, this method is a little complex comparing with
   the 1st way.

I chose the 1st way to fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- No change.
---
 fs/btrfs/transaction.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b259d22f2..8bd2511 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1114,6 +1114,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_reloc_post_snapshot(trans, pending);
 	if (ret)
 		goto abort_trans;
+
+	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+	if (ret)
+		goto abort_trans;
 fail:
 	dput(parent);
 	trans->block_rsv = rsv;
-- 
1.7.6.5
