Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59876 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395AbaKMBVK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 20:21:10 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/2] btrfs-progs: fix wrong num_devices for btrfs fi show with seed devices
Date: Thu, 13 Nov 2014 09:19:29 +0800
Message-ID: <1415841569-2302-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The @fi_args->num_devices in @get_fs_info() does not include seed devices.
We could just correct it by searching the chunk tree and count how
many dev_items there are in total which includes seed devices.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: adopt more clear function name
		@find_max_device_id()
		@search_chunk_tree_for_fs_info()
---
 utils.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/utils.c b/utils.c
index f3fca4f..0d3d7fa 100644
--- a/utils.c
+++ b/utils.c
@@ -1812,6 +1812,75 @@ int get_device_info(int fd, u64 devid,
 	return ret ? -errno : 0;
 }
 
+static u64 find_max_device_id(struct btrfs_ioctl_search_args *search_args,
+			      int nr_items)
+{
+	struct btrfs_dev_item *dev_item;
+	char *buf = search_args->buf;
+
+	buf += (nr_items - 1) * (sizeof(struct btrfs_ioctl_search_header)
+				       + sizeof(struct btrfs_dev_item));
+	buf += sizeof(struct btrfs_ioctl_search_header);
+
+	dev_item = (struct btrfs_dev_item *)buf;
+
+	return btrfs_stack_device_id(dev_item);
+}
+
+static int search_chunk_tree_for_fs_info(int fd,
+				struct btrfs_ioctl_fs_info_args *fi_args)
+{
+	int ret;
+	int max_items;
+	u64 start_devid = 1;
+	struct btrfs_ioctl_search_args search_args;
+	struct btrfs_ioctl_search_key *search_key = &search_args.key;
+
+	fi_args->num_devices = 0;
+
+	max_items = BTRFS_SEARCH_ARGS_BUFSIZE
+	       / (sizeof(struct btrfs_ioctl_search_header)
+			       + sizeof(struct btrfs_dev_item));
+
+	search_key->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
+	search_key->min_objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	search_key->max_objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	search_key->min_type = BTRFS_DEV_ITEM_KEY;
+	search_key->max_type = BTRFS_DEV_ITEM_KEY;
+	search_key->min_transid = 0;
+	search_key->max_transid = (u64)-1;
+	search_key->nr_items = max_items;
+	search_key->max_offset = (u64)-1;
+
+again:
+	search_key->min_offset = start_devid;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search_args);
+	if (ret < 0)
+		return -errno;
+
+	fi_args->num_devices += (u64)search_key->nr_items;
+
+	if (search_key->nr_items == max_items) {
+		start_devid = find_max_device_id(&search_args,
+					search_key->nr_items) + 1;
+		goto again;
+	}
+
+	/* get the lastest max_id to stay consistent with the num_devices */
+	if (search_key->nr_items == 0)
+		/*
+		 * last tree_search returns an empty buf, use the devid of
+		 * the last dev_item of the previous tree_search
+		 */
+		fi_args->max_id = start_devid - 1;
+	else
+		fi_args->max_id = find_max_device_id(&search_args,
+						search_key->nr_items);
+
+	return 0;
+}
+
 /*
  * For a given path, fill in the ioctl fs_ and info_ args.
  * If the path is a btrfs mountpoint, fill info for all devices.
@@ -1891,6 +1960,13 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 			ret = -errno;
 			goto out;
 		}
+
+		/*
+		 * The fs_args->num_devices does not include seed devices
+		 */
+		ret = search_chunk_tree_for_fs_info(fd, fi_args);
+		if (ret)
+			goto out;
 	}
 
 	if (!fi_args->num_devices)
-- 
1.8.1.4

