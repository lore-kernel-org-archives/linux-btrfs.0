Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750967AbdLGJKJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 04:10:09 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs-progs: Replace usage of list_for_each with list_for_each_entry
Date: Thu,  7 Dec 2017 11:10:05 +0200
Message-Id: <1512637805-11712-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-5-git-send-email-nborisov@suse.com>
References: <1512463189-24724-5-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are a couple of places where instead of the more succinct
list_for_each_entry the code uses list_for_each. This results in
slightly more code with no additional benefit as well as no
coherent pattern. This patch makes the code uniform. No functional
changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 cmds-filesystem.c |  3 +--
 disk-io.c         |  4 +---
 utils.c           |  7 +------
 volumes.c         | 15 ++++-----------
 4 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7728430f16a1..7c154589a15f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -182,8 +182,7 @@ static int uuid_search(struct btrfs_fs_devices *fs_devices, const char *search)
 	if (!strncmp(uuidbuf, search, search_len))
 		return 1;
 
-	list_for_each(cur, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if ((device->label && strcmp(device->label, search) == 0) ||
 		    strcmp(device->name, search) == 0)
 			return 1;
diff --git a/disk-io.c b/disk-io.c
index f5edc4796619..3d8785d5bb37 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1556,7 +1556,6 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 
 int write_all_supers(struct btrfs_fs_info *fs_info)
 {
-	struct list_head *cur;
 	struct list_head *head = &fs_info->fs_devices->devices;
 	struct btrfs_device *dev;
 	struct btrfs_super_block *sb;
@@ -1566,8 +1565,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 
 	sb = fs_info->super_copy;
 	dev_item = &sb->dev_item;
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (!dev->writeable)
 			continue;
 
diff --git a/utils.c b/utils.c
index 6c0d9fc1bebf..65383282b512 100644
--- a/utils.c
+++ b/utils.c
@@ -804,14 +804,9 @@ static int blk_file_in_dev_list(struct btrfs_fs_devices* fs_devices,
 		const char* file)
 {
 	int ret;
-	struct list_head *head;
-	struct list_head *cur;
 	struct btrfs_device *device;
 
-	head = &fs_devices->devices;
-	list_for_each(cur, head) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
-
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if((ret = is_same_loop_file(device->name, file)))
 			return ret;
 	}
diff --git a/volumes.c b/volumes.c
index ce3a540578fd..2e1fb4a46465 100644
--- a/volumes.c
+++ b/volumes.c
@@ -58,10 +58,8 @@ static struct btrfs_device *__find_device(struct list_head *head, u64 devid,
 					  u8 *uuid)
 {
 	struct btrfs_device *dev;
-	struct list_head *cur;
 
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (dev->devid == devid &&
 		    !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE)) {
 			return dev;
@@ -72,11 +70,9 @@ static struct btrfs_device *__find_device(struct list_head *head, u64 devid,
 
 static struct btrfs_fs_devices *find_fsid(u8 *fsid)
 {
-	struct list_head *cur;
 	struct btrfs_fs_devices *fs_devices;
 
-	list_for_each(cur, &fs_uuids) {
-		fs_devices = list_entry(cur, struct btrfs_fs_devices, list);
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
 		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0)
 			return fs_devices;
 	}
@@ -234,13 +230,10 @@ void btrfs_close_all_devices(void)
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 {
 	int fd;
-	struct list_head *head = &fs_devices->devices;
-	struct list_head *cur;
 	struct btrfs_device *device;
 	int ret;
 
-	list_for_each(cur, head) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (!device->name) {
 			printk("no name for device %llu, skip it now\n", device->devid);
 			continue;
@@ -1726,7 +1719,7 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 		return -EIO;
 	}
 	if (btrfs_chunk_sector_size(leaf, chunk) != sectorsize) {
-		error("invalid chunk sectorsize %llu", 
+		error("invalid chunk sectorsize %llu",
 		      (unsigned long long)btrfs_chunk_sector_size(leaf, chunk));
 		return -EIO;
 	}
-- 
2.7.4

