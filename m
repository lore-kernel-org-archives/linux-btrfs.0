Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59406 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753781AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E5955AC1E
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/13] btrfs-progs: pass OPEN_CTREE flags as unsigned
Date: Tue, 23 Aug 2016 12:25:05 +0200
Message-Id: <1471947917-5324-2-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we're passing a set of flags, the enum type is not appropriate.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 btrfstune.c  |  2 +-
 cmds-check.c |  2 +-
 disk-io.c    | 12 ++++++------
 disk-io.h    |  8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index ac559fb9e3de..93b25e8cece8 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -389,7 +389,7 @@ static void print_usage(void)
 int main(int argc, char *argv[])
 {
 	struct btrfs_root *root;
-	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_WRITES;
+	unsigned ctree_flags = OPEN_CTREE_WRITES;
 	int success = 0;
 	int total = 0;
 	int seeding_flag = 0;
diff --git a/cmds-check.c b/cmds-check.c
index fc15ce98f4bb..0ddfd24a4d8e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11178,7 +11178,7 @@ int cmd_check(int argc, char **argv)
 	int readonly = 0;
 	int qgroup_report = 0;
 	int qgroups_repaired = 0;
-	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
+	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
 
 	while(1) {
 		int c;
diff --git a/disk-io.c b/disk-io.c
index 3647ecca7e63..279e38b74c39 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -932,7 +932,7 @@ static int find_best_backup_root(struct btrfs_super_block *super)
 }
 
 static int setup_root_or_create_block(struct btrfs_fs_info *fs_info,
-				      enum btrfs_open_ctree_flags flags,
+				      unsigned flags,
 				      struct btrfs_root *info_root,
 				      u64 objectid, char *str)
 {
@@ -961,7 +961,7 @@ static int setup_root_or_create_block(struct btrfs_fs_info *fs_info,
 }
 
 int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
-			  enum btrfs_open_ctree_flags flags)
+			  unsigned flags)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	struct btrfs_root *root;
@@ -1217,7 +1217,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
 					     u64 root_tree_bytenr,
 					     u64 chunk_root_bytenr,
-					     enum btrfs_open_ctree_flags flags)
+					     unsigned flags)
 {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_super_block *disk_super;
@@ -1323,7 +1323,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 u64 chunk_root_bytenr,
-					 enum btrfs_open_ctree_flags flags)
+					 unsigned flags)
 {
 	int fp;
 	int ret;
@@ -1356,7 +1356,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 }
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
-			      enum btrfs_open_ctree_flags flags)
+			      unsigned flags)
 {
 	struct btrfs_fs_info *info;
 
@@ -1371,7 +1371,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
 }
 
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
-				 enum btrfs_open_ctree_flags flags)
+				 unsigned flags)
 {
 	struct btrfs_fs_info *info;
 
diff --git a/disk-io.h b/disk-io.h
index d6fb9822614f..9ebb2366b933 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -103,7 +103,7 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
 int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
 int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
-			  enum btrfs_open_ctree_flags flags);
+			  unsigned flags);
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
@@ -113,13 +113,13 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 			  u64 chunk_root_bytenr);
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
-			      enum btrfs_open_ctree_flags flags);
+			      unsigned flags);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
-				 enum btrfs_open_ctree_flags flags);
+				 unsigned flags);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 u64 chunk_root_bytenr,
-					 enum btrfs_open_ctree_flags flags);
+					 unsigned flags);
 int close_ctree_fs_info(struct btrfs_fs_info *fs_info);
 static inline int close_ctree(struct btrfs_root *root)
 {
-- 
2.7.1

