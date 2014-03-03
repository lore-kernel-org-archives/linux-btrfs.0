Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42336 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaCCNbW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 08:31:22 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s23DVKgV025613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 13:31:21 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s23DVJuf001344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 13:31:20 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s23DVJir012957
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 13:31:19 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: share the same code for __record_{new,deleted}_ref
Date: Mon,  3 Mar 2014 21:31:03 +0800
Message-Id: <1393853463-26215-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1393853463-26215-1-git-send-email-bo.li.liu@oracle.com>
References: <1393853463-26215-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has no functional change, only picks out the same part of two functions,
and makes it shared.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/send.c | 49 +++++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a5f9626..2daa8d6 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2584,7 +2584,7 @@ struct recorded_ref {
  * everything mixed. So we first record all refs and later process them.
  * This function is a helper to record one ref.
  */
-static int record_ref(struct list_head *head, u64 dir,
+static int __record_ref(struct list_head *head, u64 dir,
 		      u64 dir_gen, struct fs_path *path)
 {
 	struct recorded_ref *ref;
@@ -3369,9 +3369,8 @@ out:
 	return ret;
 }
 
-static int __record_new_ref(int num, u64 dir, int index,
-			    struct fs_path *name,
-			    void *ctx)
+static int record_ref(struct btrfs_root *root, int num, u64 dir, int index,
+		      struct fs_path *name, void *ctx, struct list_head *refs)
 {
 	int ret = 0;
 	struct send_ctx *sctx = ctx;
@@ -3382,7 +3381,7 @@ static int __record_new_ref(int num, u64 dir, int index,
 	if (!p)
 		return -ENOMEM;
 
-	ret = get_inode_info(sctx->send_root, dir, NULL, &gen, NULL, NULL,
+	ret = get_inode_info(root, dir, NULL, &gen, NULL, NULL,
 			NULL, NULL);
 	if (ret < 0)
 		goto out;
@@ -3394,7 +3393,7 @@ static int __record_new_ref(int num, u64 dir, int index,
 	if (ret < 0)
 		goto out;
 
-	ret = record_ref(&sctx->new_refs, dir, gen, p);
+	ret = __record_ref(refs, dir, gen, p);
 
 out:
 	if (ret)
@@ -3402,37 +3401,23 @@ out:
 	return ret;
 }
 
+static int __record_new_ref(int num, u64 dir, int index,
+			    struct fs_path *name,
+			    void *ctx)
+{
+	struct send_ctx *sctx = ctx;
+	return record_ref(sctx->send_root, num, dir, index, name,
+			  ctx, &sctx->new_refs);
+}
+
+
 static int __record_deleted_ref(int num, u64 dir, int index,
 				struct fs_path *name,
 				void *ctx)
 {
-	int ret = 0;
 	struct send_ctx *sctx = ctx;
-	struct fs_path *p;
-	u64 gen;
-
-	p = fs_path_alloc();
-	if (!p)
-		return -ENOMEM;
-
-	ret = get_inode_info(sctx->parent_root, dir, NULL, &gen, NULL, NULL,
-			NULL, NULL);
-	if (ret < 0)
-		goto out;
-
-	ret = get_cur_path(sctx, dir, gen, p);
-	if (ret < 0)
-		goto out;
-	ret = fs_path_add_path(p, name);
-	if (ret < 0)
-		goto out;
-
-	ret = record_ref(&sctx->deleted_refs, dir, gen, p);
-
-out:
-	if (ret)
-		fs_path_free(p);
-	return ret;
+	return record_ref(sctx->parent_root, num, dir, index, name,
+			  ctx, &sctx->deleted_refs);
 }
 
 static int record_new_ref(struct send_ctx *sctx)
-- 
1.8.2.1

