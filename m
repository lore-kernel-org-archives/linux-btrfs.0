Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751816AbeBZIs5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 03:48:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1Q8kxso141128
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:48:56 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2gcdywr8kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:48:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1Q8idLK026907
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:44:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1Q8id08018269
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:44:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: fix bare unsigned declarations
Date: Mon, 26 Feb 2018 16:46:05 +0800
Message-Id: <20180226084605.7120-1-anand.jain@oracle.com>
In-Reply-To: <20180223221252.GN1469@twin.jikos.cz>
References: <20180223221252.GN1469@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have btrfs_fs_info::data_chunk_allocations and
btrfs_fs_info::metadata_ratio declared as unsigned which would
be unsinged int and kernel style prefers unsigned int over bare
unsigned. So this patch changes them to u32.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: @old_metadata_ratio change it to u32
v1->v2: Update change log.

 fs/btrfs/ctree.h | 4 ++--
 fs/btrfs/super.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b67ee4dcb6e..32ea4cb839c4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -994,8 +994,8 @@ struct btrfs_fs_info {
 	struct btrfs_balance_control *balance_ctl;
 	wait_queue_head_t balance_wait_q;
 
-	unsigned data_chunk_allocations;
-	unsigned metadata_ratio;
+	u32 data_chunk_allocations;
+	u32 metadata_ratio;
 
 	void *bdev_holder;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f92f2e1ec00b..8f78fb2b8204 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1737,7 +1737,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	unsigned long old_compress_type = fs_info->compress_type;
 	u32 old_max_inline = fs_info->max_inline;
 	u32 old_thread_pool_size = fs_info->thread_pool_size;
-	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
+	u32 old_metadata_ratio = fs_info->metadata_ratio;
 	int ret;
 
 	sync_filesystem(sb);
-- 
2.7.0

