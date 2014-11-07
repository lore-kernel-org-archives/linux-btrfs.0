Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59987 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259AbaKGCJR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 21:09:17 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sA7295BR011254
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Nov 2014 10:09:05 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: fix wrong num_devices for btrfs fi show with seed devices
Date: Fri, 7 Nov 2014 10:07:43 +0800
Message-ID: <1415326063-8838-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The @fi_args->num_devices in @get_fs_info() does not include seed devices.
We could just correct it by searching the chunk tree and count how
many dev_items there are in total which includes seed devices.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
*Note*
This is just a temporary workaround to fix this problem in order to
make users happy, because a new ioctl or sysfs interface to handle this
problem needs more discussions and efforts. After the work implemented
and accepted, we could drop this.
---
 utils.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/utils.c b/utils.c
index 9bcc1a0..a6dcb8a 100644
--- a/utils.c
+++ b/utils.c
@@ -1781,6 +1781,73 @@ int get_device_info(int fd, u64 devid,
 	return ret ? -errno : 0;
 }
 
+u64 find_max_id(struct btrfs_ioctl_search_args *search_args, int nr_items)
+{
+	struct btrfs_dev_item *dev_item;
+	char *buf = search_args->buf;
+
+	buf += (nr_items - 1) * (sizeof(struct btrfs_ioctl_search_header)
+					+ sizeof(struct btrfs_dev_item));
+	buf += sizeof(struct btrfs_ioctl_search_header);
+
+	dev_item = (struct btrfs_dev_item *)buf;
+
+	return btrfs_stack_device_id(dev_item);
+}
+
+int correct_fs_info(int fd, struct btrfs_ioctl_fs_info_args *fi_args)
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
+		/ (sizeof(struct btrfs_ioctl_search_header)
+				+ sizeof(struct btrfs_dev_item));
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
+		start_devid = find_max_id(&search_args,
+				search_key->nr_items) + 1;
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
+		fi_args->max_id = find_max_id(&search_args,
+						search_key->nr_items);
+
+	return 0;
+}
+
 /*
  * For a given path, fill in the ioctl fs_ and info_ args.
  * If the path is a btrfs mountpoint, fill info for all devices.
@@ -1860,6 +1927,13 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 			ret = -errno;
 			goto out;
 		}
+
+		/*
+		 * The fs_args->num_devices does not include seed devices
+		 */
+		ret = correct_fs_info(fd, fi_args);
+		if (ret)
+			goto out;
 	}
 
 	if (!fi_args->num_devices)
-- 
1.8.1.4

