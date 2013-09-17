Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab3IQOyO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 10:54:14 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0BD9EA535C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 16:54:14 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs-progs: use better name for nodiscard variable and flip the logic
Date: Tue, 17 Sep 2013 16:54:00 +0200
Message-Id: <4cf3c965e742f6f814f99b2244c7368029283382.1379429392.git.dsterba@suse.cz>
In-Reply-To: <cover.1379429392.git.dsterba@suse.cz>
References: <cover.1379429392.git.dsterba@suse.cz>
In-Reply-To: <cover.1379429392.git.dsterba@suse.cz>
References: <cover.1379429392.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 mkfs.c  | 8 ++++----
 utils.c | 4 ++--
 utils.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 3ac00ba..40da546 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1324,7 +1324,7 @@ int main(int ac, char **av)
 	int mixed = 0;
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
-	int nodiscard = 0;
+	int discard = 1;
 	int ssd = 0;
 	int force_overwrite = 0;
 
@@ -1409,7 +1409,7 @@ int main(int ac, char **av)
 				source_dir_set = 1;
 				break;
 			case 'K':
-				nodiscard=1;
+				discard = 0;
 				break;
 			default:
 				print_usage();
@@ -1507,7 +1507,7 @@ int main(int ac, char **av)
 		}
 		first_file = file;
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
-					   block_count, &mixed, nodiscard);
+					   block_count, &mixed, discard);
 		if (block_count && block_count > dev_block_count) {
 			fprintf(stderr, "%s is smaller than requested size\n", file);
 			exit(1);
@@ -1614,7 +1614,7 @@ int main(int ac, char **av)
 			continue;
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
-					   block_count, &mixed, nodiscard);
+					   block_count, &mixed, discard);
 		mixed = old_mixed;
 		BUG_ON(ret);
 
diff --git a/utils.c b/utils.c
index 134bf80..bb1bcdb 100644
--- a/utils.c
+++ b/utils.c
@@ -569,7 +569,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-			   u64 max_block_count, int *mixed, int nodiscard)
+			   u64 max_block_count, int *mixed, int discard)
 {
 	u64 block_count;
 	u64 bytenr;
@@ -596,7 +596,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		*mixed = 1;
 	}
 
-	if (!nodiscard) {
+	if (discard) {
 		/*
 		 * We intentionally ignore errors from the discard ioctl.  It is
 		 * not necessary for the mkfs functionality but just an optimization.
diff --git a/utils.h b/utils.h
index 6c2553a..6bf7880 100644
--- a/utils.h
+++ b/utils.h
@@ -34,7 +34,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-			 u64 max_block_count, int *mixed, int nodiscard);
+			 u64 max_block_count, int *mixed, int discard);
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-- 
1.8.3.1

