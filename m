Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48204 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3JVFpf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 01:45:35 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris.mason@fusionio.com, jbacik@fusionio.com
Subject: [PATCH 1/2] btrfs-progs: make get_btrfs_mount callable
Date: Tue, 22 Oct 2013 13:53:21 +0800
Message-Id: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_btrfs_mount is reusable function but it is printing
errors, this removes it. Here the parent function of
open_path_or_dev_mnt does print error msg on error.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |    6 ++----
 utils.h |    1 +
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/utils.c b/utils.c
index a7441c1..cb69b2b 100644
--- a/utils.c
+++ b/utils.c
@@ -692,7 +692,8 @@ int is_block_device(const char *path) {
  * On failure, returns -errno (not mounted yields -EINVAL)
  * Is noisy on failures, expects to be given a mounted device.
  */
-static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size)
+{
 	int ret;
 	int fd = -1;
 
@@ -717,7 +718,6 @@ static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
 
 	ret = check_mounted_where(fd, dev, mp, mp_size, NULL);
 	if (!ret) {
-		fprintf(stderr, "%s is not a mounted btrfs device\n", dev);
 		ret = -EINVAL;
 	} else { /* mounted, all good */
 		ret = 0;
@@ -725,8 +725,6 @@ static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
 out:
 	if (fd != -1)
 		close(fd);
-	if (ret)
-		fprintf(stderr, "Could not get mountpoint for %s\n", dev);
 	return ret;
 }
 
diff --git a/utils.h b/utils.h
index 251ef8e..8370686 100644
--- a/utils.h
+++ b/utils.h
@@ -91,5 +91,6 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 
 #endif
-- 
1.7.1

