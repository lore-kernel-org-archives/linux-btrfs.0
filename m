Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbaGQTkc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 15:40:32 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 5/5] btrfs: correctly handle return from ulist_add
Date: Thu, 17 Jul 2014 12:39:04 -0700
Message-Id: <1405625944-4883-6-git-send-email-mfasheh@suse.de>
In-Reply-To: <1405625944-4883-1-git-send-email-mfasheh@suse.de>
References: <1405625944-4883-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ulist_add() can return '1' on sucess, which qgroup_subtree_accounting()
doesn't take into account. As a result, that value can be bubbled up to
callers, causing an error to be printed. Fix this by only returning the
value of ulist_add() when it indicates an error.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/qgroup.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2ec2432..b55870c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1976,6 +1976,7 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup_list *glist;
 	struct ulist *parents;
 	int ret = 0;
+	int err;
 	struct btrfs_qgroup *qg;
 	u64 root_obj = 0;
 	struct seq_list elem = {};
@@ -2030,10 +2031,12 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	 * while adding parents of the parents to our ulist.
 	 */
 	list_for_each_entry(glist, &qg->groups, next_group) {
-		ret = ulist_add(parents, glist->group->qgroupid,
+		err = ulist_add(parents, glist->group->qgroupid,
 				ptr_to_u64(glist->group), GFP_ATOMIC);
-		if (ret < 0)
+		if (err < 0) {
+			ret = err;
 			goto out_unlock;
+		}
 	}
 
 	ULIST_ITER_INIT(&uiter);
@@ -2045,10 +2048,12 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 
 		/* Add any parents of the parents */
 		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(parents, glist->group->qgroupid,
+			err = ulist_add(parents, glist->group->qgroupid,
 					ptr_to_u64(glist->group), GFP_ATOMIC);
-			if (ret < 0)
+			if (err < 0) {
+				ret = err;
 				goto out_unlock;
+			}
 		}
 	}
 
-- 
1.8.4.5

