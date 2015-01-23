Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41660 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752568AbbAWBvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 20:51:47 -0500
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs:qgroup:make large size aligned
Date: Fri, 23 Jan 2015 09:50:49 +0800
Message-ID: <1421977849-5822-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

problem: when the size is too big, the output format will be unaligned.
the __update__columns_max_len function has been updated to fix this
problem

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
In my patch "[PATCH v3] make btrfs qgroups show human readable sizes"
I forget to update the function __update__columns_max_len which may
cause large size unaligned.

 qgroup.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 8ec55df..3e4a6ed 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -915,6 +915,7 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 	struct btrfs_qgroup_list *list = NULL;
 	char tmp[100];
 	int len;
+	unsigned unit_mode = btrfs_qgroup_columns[column].unit_mode;
 
 	switch (column) {
 
@@ -926,26 +927,22 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_RFER:
-		sprintf(tmp, "%llu", bq->rfer);
-		len = strlen(tmp);
+		len = strlen(pretty_size_mode(bq->rfer, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_EXCL:
-		sprintf(tmp, "%llu", bq->excl);
-		len = strlen(tmp);
+		len = strlen(pretty_size_mode(bq->excl, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		sprintf(tmp, "%llu", bq->max_rfer);
-		len = strlen(tmp);
+		len = strlen(pretty_size_mode(bq->max_rfer, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		sprintf(tmp, "%llu", bq->max_excl);
-		len = strlen(tmp);
+		len = strlen(pretty_size_mode(bq->max_excl, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
-- 
1.9.1

