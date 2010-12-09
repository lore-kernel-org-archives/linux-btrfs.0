From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs-progs: update super fields for space cache
Date: Thu,  9 Dec 2010 13:27:03 -0500
Message-ID: <1291919223-17489-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch updates the super field to add the cache_generation member.  It also
makes us set it to -1 on mkfs so any new filesystem will get the space cache
stuff turned on.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 ctree.h |    6 +++++-
 utils.c |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/ctree.h b/ctree.h
index b79e238..962c510 100644
--- a/ctree.h
+++ b/ctree.h
@@ -340,8 +340,10 @@ struct btrfs_super_block {
 
 	char label[BTRFS_LABEL_SIZE];
 
+	__le64 cache_generation;
+
 	/* future expansion */
-	__le64 reserved[32];
+	__le64 reserved[31];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 } __attribute__ ((__packed__));
 
@@ -1564,6 +1566,8 @@ BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
+BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
+			 cache_generation, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
diff --git a/utils.c b/utils.c
index 2f4c6e1..b890728 100644
--- a/utils.c
+++ b/utils.c
@@ -103,6 +103,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_super_stripesize(&super, stripesize);
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_super_chunk_root_generation(&super, 1);
+	btrfs_set_super_cache_generation(&super, -1);
 	if (label)
 		strcpy(super.label, label);
 
-- 
1.6.6.1

