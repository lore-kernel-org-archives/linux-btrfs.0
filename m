Return-Path: <SRS0=4fXr=V6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1F9C32750
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 694D020679
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394461AbfHBNjt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:39:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:60106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391798AbfHBNjt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Aug 2019 09:39:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19C38AFA4
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Aug 2019 13:39:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EA705DADC0; Fri,  2 Aug 2019 15:40:21 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 09/13] btrfs: factor out sysfs code for deleting block group and space infos
Date:   Fri,  2 Aug 2019 15:40:21 +0200
Message-Id: <4e6e4f7834c7f877e278031010b357ffeed5ed82.1564752900.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1564752900.git.dsterba@suse.com>
References: <cover.1564752900.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The helpers to create block group and space info directories already
live in sysfs.c, move the deletion part there too.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 14 +-------------
 fs/btrfs/sysfs.c       | 22 ++++++++++++++++++++++
 fs/btrfs/sysfs.h       |  1 +
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8ac496fddc59..3a711f5e7919 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7744,8 +7744,6 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 	btrfs_release_global_block_rsv(info);
 
 	while (!list_empty(&info->space_info)) {
-		int i;
-
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
 					list);
@@ -7759,17 +7757,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			    space_info->bytes_may_use > 0))
 			btrfs_dump_space_info(info, space_info, 0, 0);
 		list_del(&space_info->list);
-		for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
-			struct kobject *kobj;
-			kobj = space_info->block_group_kobjs[i];
-			space_info->block_group_kobjs[i] = NULL;
-			if (kobj) {
-				kobject_del(kobj);
-				kobject_put(kobj);
-			}
-		}
-		kobject_del(&space_info->kobj);
-		kobject_put(&space_info->kobj);
+		btrfs_sysfs_remove_space_info(space_info);
 	}
 	return 0;
 }
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 0f7e97ceec4e..2490144863ae 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -789,6 +789,28 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group_cache *cache)
 	space_info->block_group_kobjs[index] = &rkobj->kobj;
 }
 
+/*
+ * Remove sysfs directories for all block group types of a given space info and
+ * the space info as well
+ */
+void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		struct kobject *kobj;
+
+		kobj = space_info->block_group_kobjs[i];
+		space_info->block_group_kobjs[i] = NULL;
+		if (kobj) {
+			kobject_del(kobj);
+			kobject_put(kobj);
+		}
+	}
+	kobject_del(&space_info->kobj);
+	kobject_put(&space_info->kobj);
+}
+
 static const char *alloc_name(u64 flags)
 {
 	switch (flags) {
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 371fa9db5bbd..857710e77775 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -105,5 +105,6 @@ void btrfs_add_raid_kobjects(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_add_block_group_type(struct btrfs_block_group_cache *cache);
 int btrfs_sysfs_add_space_info_type(struct btrfs_fs_info *fs_info,
 				    struct btrfs_space_info *space_info);
+void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info);
 
 #endif
-- 
2.22.0

