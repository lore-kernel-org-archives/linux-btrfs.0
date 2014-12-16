Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29330 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaLPJAJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 04:00:09 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id sBG907k2000641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 09:00:08 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sBG9065A009201
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 09:00:07 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sBG906JF005730
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 09:00:06 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a warning of qgroup account on shared extents
Date: Tue, 16 Dec 2014 16:59:58 +0800
Message-Id: <1418720398-21847-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we don't record tree_mod_seq during adding delayed refs,
we may get inaccurate results from backref walking, ie.
btrfs_find_all_roots.

For shared extents made by ioctl 'clone', removing those extents
can end up warnings of qgroup accounting.

Here is an example, file A and B shares the same extent, both are in "fs tree"
1. remove A and B
2. add delayed ref 'DROP A' and 'DROP B'
3. run delayed ref 'DROP A'
4. qgroup record 'DROP A'
5. run delayed ref 'DROP B'
6. qgroup record 'DROP B'
7. qgroup account on'DROP A', it runs btrfs_find_all_roots() and
   finds no reference on this extent, and in qgroup_account_deleted_refs()
   'DROP B' has the same ref_root and is skipped then.
8. "fs tree"'s reference number is (num - extent_len),
    exclusive number is (num - extent_len)
9. qgroup account on 'DROP B', it's the last ref on this extent, thus
10."fs tree"'s reference number is (num - extent_len),
    exclusive number is (num - extent_len)

So "fs tree" 's numbers are wrong.

This adds an additional check in check_existing_ref() so that we can detect
the above case and make it right.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/qgroup.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 48b60db..5eb279b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1796,6 +1796,26 @@ static int check_existing_refs(struct btrfs_trans_handle *trans,
 	ulist_free(roots);
 	btrfs_put_tree_mod_seq(fs_info, &oper->elem);
 
+	if (ret == 0 && oper->type == BTRFS_QGROUP_OPER_SUB_SHARED) {
+		struct btrfs_qgroup_operation *tmp;
+		struct rb_node *n;
+
+		n = &oper->n;
+		do {
+			spin_lock(&fs_info->qgroup_op_lock);
+			n = rb_next(n);
+			spin_unlock(&fs_info->qgroup_op_lock);
+			if (!n)
+				return 0;
+
+			tmp = rb_entry(n, struct btrfs_qgroup_operation, n);
+
+			if (tmp->bytenr == oper->bytenr &&
+			    tmp->ref_root == oper->ref_root)
+				return 1;
+		} while (tmp->bytenr == oper->bytenr);
+	}
+
 	return ret;
 }
 
-- 
1.8.1.4

