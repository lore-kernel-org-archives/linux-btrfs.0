Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:59647 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbdJTB7R (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 21:59:17 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/7] btrfs-progs: mkfs/rootdir: Introduce function to get end position of last device extent
Date: Fri, 20 Oct 2017 09:59:04 +0800
Message-Id: <20171020015907.25430-5-wqu@suse.com>
In-Reply-To: <20171020015907.25430-1-wqu@suse.com>
References: <20171020015907.25430-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Useful for later 'mkfs.btrfs --rootdir' shrink support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 99022afaa030..1ca37996a3b3 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -26,6 +26,7 @@
 #include <fcntl.h>
 #include <ftw.h>
 #include "ctree.h"
+#include "volumes.h"
 #include "internal.h"
 #include "disk-io.h"
 #include "messages.h"
@@ -778,3 +779,45 @@ u64 btrfs_mkfs_size_dir(const char *dir_name, u32 sectorsize, u64 min_dev_size,
 	total_size = data_chunk_size + meta_chunk_size + min_dev_size;
 	return total_size;
 }
+
+/*
+ * Get the end position of the last device extent for given @devid;
+ * @size_ret is exclsuive (means it should be aligned to sectorsize)
+ */
+static int get_device_extent_end(struct btrfs_fs_info *fs_info,
+				 u64 devid, u64 *size_ret)
+{
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_dev_extent *de;
+	int ret;
+
+	key.objectid = devid;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = (u64)-1;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+	/* Not really possible */
+	BUG_ON(ret == 0);
+
+	ret = btrfs_previous_item(dev_root, &path, devid, BTRFS_DEV_EXTENT_KEY);
+	if (ret < 0)
+		goto out;
+
+	/* No dev_extent at all, not really possible for rootdir case*/
+	if (ret > 0) {
+		*size_ret = 0;
+		ret = -EUCLEAN;
+		goto out;
+	}
+
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	de = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dev_extent);
+	*size_ret = key.offset + btrfs_dev_extent_length(path.nodes[0], de);
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
-- 
2.14.2

