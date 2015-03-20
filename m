Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36246 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbCTKEV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:21 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 13/27] Btrfs: introduce btrfs_get_fs_uuids to get fs_uuids
Date: Fri, 20 Mar 2015 18:01:28 +0800
Message-Id: <1426845702-6298-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++++
 fs/btrfs/volumes.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 218a14a..c1b1038 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -52,6 +52,10 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 
 DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
+struct list_head *btrfs_get_fs_uuids(void)
+{
+	return &fs_uuids;
+}
 
 static struct btrfs_fs_devices *__alloc_fs_devices(void)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c2e5bd0..d4586ac 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -539,5 +539,6 @@ static inline void unlock_chunks(struct btrfs_root *root)
 	mutex_unlock(&root->fs_info->chunk_mutex);
 }
 
+struct list_head *btrfs_get_fs_uuids(void);
 
 #endif
-- 
2.0.0.153.g79dcccc

