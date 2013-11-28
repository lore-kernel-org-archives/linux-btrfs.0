Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab3K1Ffk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 00:35:40 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAS5ZNXm008146
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 13:35:36 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs: scan devices in parallel for chunk-recover
Date: Thu, 28 Nov 2013 13:32:52 +0800
Message-Id: <1385616772-13222-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1385616772-13222-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1385616772-13222-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally, multi devices are scanned one by one;
Now, one thread is used per device to scan.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 7 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index ac2a437..d103e17 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -26,6 +26,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
+#include <pthread.h>
 
 #include "kerncompat.h"
 #include "list.h"
@@ -64,6 +65,7 @@ struct recover_control {
 	struct list_head good_chunks;
 	struct list_head bad_chunks;
 	struct list_head unrepaired_chunks;
+	pthread_mutex_t rc_lock;
 };
 
 struct extent_record {
@@ -75,6 +77,12 @@ struct extent_record {
 	int nmirrors;
 };
 
+struct device_scan {
+	struct recover_control *rc;
+	struct btrfs_device *dev;
+	int fd;
+};
+
 static struct extent_record *btrfs_new_extent_record(struct extent_buffer *eb)
 {
 	struct extent_record *rec;
@@ -202,6 +210,7 @@ static void init_recover_control(struct recover_control *rc, int verbose,
 
 	rc->verbose = verbose;
 	rc->yes = yes;
+	pthread_mutex_init(&rc->rc_lock, NULL);
 }
 
 static void free_recover_control(struct recover_control *rc)
@@ -210,6 +219,7 @@ static void free_recover_control(struct recover_control *rc)
 	free_chunk_cache_tree(&rc->chunk);
 	free_device_extent_tree(&rc->devext);
 	free_extent_record_tree(&rc->eb_cache);
+	pthread_mutex_destroy(&rc->rc_lock);
 }
 
 static int process_block_group_item(struct block_group_tree *bg_cache,
@@ -694,14 +704,20 @@ static int extract_metadata_record(struct recover_control *rc,
 		btrfs_item_key_to_cpu(leaf, &key, i);
 		switch (key.type) {
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
+			pthread_mutex_lock(&rc->rc_lock);
 			ret = process_block_group_item(&rc->bg, leaf, &key, i);
+			pthread_mutex_unlock(&rc->rc_lock);
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
+			pthread_mutex_lock(&rc->rc_lock);
 			ret = process_chunk_item(&rc->chunk, leaf, &key, i);
+			pthread_mutex_unlock(&rc->rc_lock);
 			break;
 		case BTRFS_DEV_EXTENT_KEY:
+			pthread_mutex_lock(&rc->rc_lock);
 			ret = process_device_extent_item(&rc->devext, leaf,
 							 &key, i);
+			pthread_mutex_unlock(&rc->rc_lock);
 			break;
 		}
 		if (ret)
@@ -721,12 +737,19 @@ static inline int is_super_block_address(u64 offset)
 	return 0;
 }
 
-static int scan_one_device(struct recover_control *rc, int fd,
-			   struct btrfs_device *device)
+static int scan_one_device(void *dev_scan_struct)
 {
 	struct extent_buffer *buf;
 	u64 bytenr;
 	int ret = 0;
+	struct device_scan *dev_scan = (struct device_scan *)dev_scan_struct;
+	struct recover_control *rc = dev_scan->rc;
+	struct btrfs_device *device = dev_scan->dev;
+	int fd = dev_scan->fd;
+
+	ret = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
+	if (ret)
+		return 1;
 
 	buf = malloc(sizeof(*buf) + rc->leafsize);
 	if (!buf)
@@ -754,7 +777,9 @@ static int scan_one_device(struct recover_control *rc, int fd,
 			continue;
 		}
 
+		pthread_mutex_lock(&rc->rc_lock);
 		ret = process_extent_buffer(&rc->eb_cache, buf, device, bytenr);
+		pthread_mutex_unlock(&rc->rc_lock);
 		if (ret)
 			goto out;
 
@@ -784,6 +809,7 @@ next_node:
 		bytenr += rc->leafsize;
 	}
 out:
+	close(fd);
 	free(buf);
 	return ret;
 }
@@ -793,6 +819,27 @@ static int scan_devices(struct recover_control *rc)
 	int ret = 0;
 	int fd;
 	struct btrfs_device *dev;
+	struct device_scan *dev_scans;
+	pthread_t *t_scans;
+	int *t_rets;
+	int devnr = 0;
+	int devidx = 0;
+	int cancel_from = 0;
+	int cancel_to = 0;
+	int i;
+
+	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list)
+		devnr++;
+	dev_scans = (struct device_scan *)malloc(sizeof(struct device_scan)
+						 * devnr);
+	if (!dev_scans)
+		return -ENOMEM;
+	t_scans = (pthread_t *)malloc(sizeof(pthread_t) * devnr);
+	if (!t_scans)
+		return -ENOMEM;
+	t_rets = (int *)malloc(sizeof(int) * devnr);
+	if (!t_rets)
+		return -ENOMEM;
 
 	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list) {
 		fd = open(dev->name, O_RDONLY);
@@ -801,12 +848,40 @@ static int scan_devices(struct recover_control *rc)
 				dev->name);
 			return -1;
 		}
-		ret = scan_one_device(rc, fd, dev);
-		close(fd);
-		if (ret)
-			return ret;
+		dev_scans[devidx].rc = rc;
+		dev_scans[devidx].dev = dev;
+		dev_scans[devidx].fd = fd;
+		ret = pthread_create(&t_scans[devidx], NULL,
+				     (void *)scan_one_device,
+				     (void *)&dev_scans[devidx]);
+		if (ret) {
+			cancel_from = 0;
+			cancel_to = devidx - 1;
+			goto out;
+		}
+		devidx++;
 	}
-	return ret;
+
+	i = 0;
+	while (i < devidx) {
+		ret = pthread_join(t_scans[i], (void **)&t_rets[i]);
+		if (ret || t_rets[i]) {
+			ret = 1;
+			cancel_from = i + 1;
+			cancel_to = devnr - 1;
+			break;
+		}
+		i++;
+	}
+out:
+	while (cancel_from <= cancel_to) {
+		pthread_cancel(t_scans[cancel_from]);
+		cancel_from++;
+	}
+	free(dev_scans);
+	free(t_scans);
+	free(t_rets);
+	return !!ret;
 }
 
 static int build_device_map_by_chunk_record(struct btrfs_root *root,
-- 
1.8.0.1

