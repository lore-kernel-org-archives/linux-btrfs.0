Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab3GSGcl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jul 2013 02:32:41 -0400
Message-ID: <51E8DD46.7070601@cn.fujitsu.com>
Date: Fri, 19 Jul 2013 14:31:34 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: wangshilong1991@gmail.com
Subject: [PATCH] Btrfs-progs: make btrfs-map-logical handle error gracefully
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If an overflow logical address is passed(for example),the original
code will cause segmentation, this is unfriendly to users,fix it.

Signed-off-by: Wang Shilong<wangsl.fnst@cn.fujitsu.com>
---
  btrfs-map-logical.c | 9 ++++++++-
  1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index b9635f7..fce6504 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -57,7 +57,14 @@ struct extent_buffer *debug_read_block(struct btrfs_root *root, u64 bytenr,
  		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
  				      eb->start, &length, &multi,
  				      mirror_num, NULL);
-		BUG_ON(ret);
+		if (ret) {
+			fprintf(info_file,
+				"Error: fails to map mirror%d logical %llu: %s\n",
+				mirror_num, (unsigned long long)eb->start,
+				strerror(-ret));
+			free_extent_buffer(eb);
+			return NULL;
+		}
  		device = multi->stripes[0].dev;
  		eb->fd = device->fd;
  		device->total_ios++;
-- 1.8.0.1

