Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58941 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab2G0Mc4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 08:32:56 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id eVlL3jsFF31nLhGJ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 06:32:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: only enforce a maximum size if we specify one
Date: Fri, 27 Jul 2012 08:37:55 -0400
Message-ID: <1343392675-2235-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My patch

04609add88ef8428d725de6ef60f46a3ff0dbc8e

introduced a regression where if you mkfs'ed a group of disks with different
sizes it limited the disks to the size of the first one that is specified.
This was not the intent of my patch, I only want it to limit the size based
on the -b option, so I've reworked the code to pass in a max block count and
that fixes the issue.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-vol.c   |    3 ++-
 cmds-device.c |    3 ++-
 mkfs.c        |   15 ++++++---------
 utils.c       |   12 +++---------
 utils.h       |    6 ++----
 5 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/btrfs-vol.c b/btrfs-vol.c
index 0efdbc1..ad824bd 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -150,7 +150,8 @@ int main(int ac, char **av)
 	if (cmd == BTRFS_IOC_ADD_DEV) {
 		int mixed = 0;
 
-		ret = btrfs_prepare_device(devfd, device, 1, &dev_block_count, &mixed);
+		ret = btrfs_prepare_device(devfd, device, 1, &dev_block_count,
+					   0, &mixed, 0);
 		if (ret) {
 			fprintf(stderr, "Unable to init %s\n", device);
 			exit(1);
diff --git a/cmds-device.c b/cmds-device.c
index b24e2a3..75ee293 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -107,7 +107,8 @@ static int cmd_add_dev(int argc, char **argv)
 			continue;
 		}
 
-		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count, &mixed);
+		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count,
+					   0, &mixed, 0);
 		if (res) {
 			fprintf(stderr, "ERROR: Unable to init '%s'\n", argv[i]);
 			close(devfd);
diff --git a/mkfs.c b/mkfs.c
index 8816db8..93cd83c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1373,11 +1373,9 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		first_file = file;
-		ret = __btrfs_prepare_device(fd, file, zero_end,
-				&dev_block_count, &mixed, nodiscard);
-		if (block_count == 0)
-			block_count = dev_block_count;
-		else if (block_count > dev_block_count) {
+		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
+					   block_count, &mixed, nodiscard);
+		if (block_count && block_count > dev_block_count) {
 			fprintf(stderr, "%s is smaller than requested size\n", file);
 			exit(1);
 		}
@@ -1418,7 +1416,7 @@ int main(int ac, char **av)
 			leafsize * i;
 	}
 
-	ret = make_btrfs(fd, file, label, blocks, block_count,
+	ret = make_btrfs(fd, file, label, blocks, dev_block_count,
 			 nodesize, leafsize,
 			 sectorsize, stripesize);
 	if (ret) {
@@ -1474,9 +1472,8 @@ int main(int ac, char **av)
 			close(fd);
 			continue;
 		}
-		dev_block_count = block_count;
-		ret = __btrfs_prepare_device(fd, file, zero_end,
-					   &dev_block_count, &mixed, nodiscard);
+		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
+					   block_count, &mixed, nodiscard);
 		mixed = old_mixed;
 		BUG_ON(ret);
 
diff --git a/utils.c b/utils.c
index aade9e2..a5ffb62 100644
--- a/utils.c
+++ b/utils.c
@@ -537,13 +537,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-			 int *mixed)
-{
-	/* discard by default when called from 'device add' */
-	return __btrfs_prepare_device(fd, file, zero_end, block_count_ret, mixed, 0);
-}
-int __btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-			 int *mixed, int nodiscard)
+			   u64 max_block_count, int *mixed, int nodiscard)
 {
 	u64 block_count;
 	u64 bytenr;
@@ -561,8 +555,8 @@ int __btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_re
 		fprintf(stderr, "unable to find %s size\n", file);
 		exit(1);
 	}
-	if (*block_count_ret)
-		block_count = min(block_count, *block_count_ret);
+	if (max_block_count)
+		block_count = min(block_count, max_block_count);
 	zero_end = 1;
 
 	if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
diff --git a/utils.h b/utils.h
index c147c12..3a0368b 100644
--- a/utils.h
+++ b/utils.h
@@ -26,10 +26,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
-int btrfs_prepare_device(int fd, char *file, int zero_end,
-			 u64 *block_count_ret, int *mixed);
-int __btrfs_prepare_device(int fd, char *file, int zero_end,
-			 u64 *block_count_ret, int *mixed, int nodiscard);
+int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
+			 u64 max_block_count, int *mixed, int nodiscard);
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-- 
1.7.7.6

