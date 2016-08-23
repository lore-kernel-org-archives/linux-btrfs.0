Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59415 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757076AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 442FBAD43
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/13] btrfs-progs: introduce signature for a partially set up filesystem
Date: Tue, 23 Aug 2016 12:25:07 +0200
Message-Id: <1471947917-5324-4-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the superblock is created first, with a valid signaure, but
the rest of the filesystem is missing. When the creation process is
interrupted, the filesystem still might be considered as valid.

To prevent that, create the filesytem with an invalid signature that
would be still recognized during the mkfs process, and finalize at the
end.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 ctree.h | 6 ++++++
 utils.c | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index b9fb732c0d40..89e47abd9d14 100644
--- a/ctree.h
+++ b/ctree.h
@@ -40,6 +40,12 @@ struct btrfs_trans_handle;
 struct btrfs_free_space_ctl;
 #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
+/*
+ * Fake signature for an unfinalized filesystem, structures might be partially
+ * created or missing.
+ */
+#define BTRFS_MAGIC_PARTIAL 0x4D5F536652484221ULL /* ascii !BHRfS_M, no null */
+
 #define BTRFS_MAX_MIRRORS 3
 
 #define BTRFS_MAX_LEVEL 8
diff --git a/utils.c b/utils.c
index 8be0e7537f8f..e7195b53b015 100644
--- a/utils.c
+++ b/utils.c
@@ -2400,7 +2400,12 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 
 	ret = 0;
 	disk_super = (struct btrfs_super_block *)buf;
-	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC)
+	/*
+	 * Accept devices from the same filesystem, allow partially created
+	 * structures.
+	 */
+	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC &&
+			btrfs_super_magic(disk_super) != BTRFS_MAGIC_PARTIAL)
 		goto brelse;
 
 	if (!memcmp(disk_super->fsid, root->fs_info->super_copy->fsid,
-- 
2.7.1

