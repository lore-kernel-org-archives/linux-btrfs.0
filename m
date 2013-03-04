Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3CDQ1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 11:27:25 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r24GROtL027911
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:24 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r24GRNPa004705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:24 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r24GRNeM020521
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 10:27:23 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] Btrfs: do not BUG_ON on aborted situation
Date: Tue,  5 Mar 2013 00:25:40 +0800
Message-Id: <1362414341-17306-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs balance can easily hit BUG_ON in these places, but we want
to it bail out gracefully after we force the whole filesystem to
readonly.  So we use btrfs_std_error hook in place of BUG_ON.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c |    6 +++++-
 fs/btrfs/volumes.c    |    9 +++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c45c833..9fd63e9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3771,7 +3771,11 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	while (1) {
 		progress++;
 		trans = btrfs_start_transaction(rc->extent_root, 0);
-		BUG_ON(IS_ERR(trans));
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			trans = NULL;
+			break;
+		}
 restart:
 		if (update_backref_cache(trans, &rc->backref_cache)) {
 			btrfs_end_transaction(trans, rc->extent_root);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5349e17..0a1559f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2357,7 +2357,11 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 		return ret;
 
 	trans = btrfs_start_transaction(root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		btrfs_std_error(root->fs_info, ret);
+		return ret;
+	}
 
 	lock_chunks(root);
 
@@ -3024,7 +3028,8 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 
 	unset_balance_control(fs_info);
 	ret = del_balance_item(fs_info->tree_root);
-	BUG_ON(ret);
+	if (ret)
+		btrfs_std_error(fs_info, ret);
 
 	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 }
-- 
1.7.7

