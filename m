Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52918 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753285AbbL2ICa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 03:02:30 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 2D67C41890EF
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 16:01:28 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH 06/14] btrfs: dedup: Implement btrfs_dedup_calc_hash interface
Date: Tue, 29 Dec 2015 16:01:15 +0800
Message-ID: <1451376083-30474-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Unlike in-memory or on-disk dedup method, only SHA256 hash method is
supported yet, so implement btrfs_dedup_calc_hash() interface using
SHA256.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 4b8676b..f645101 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -441,3 +441,60 @@ int btrfs_dedup_search(struct inode *inode, u64 file_pos,
 	}
 	return ret;
 }
+
+static int hash_data(struct btrfs_dedup_info *dedup_info, const char *data,
+		     u64 length, struct btrfs_dedup_hash *hash)
+{
+	struct crypto_shash *tfm = dedup_info->dedup_driver;
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(tfm)];
+	} sdesc;
+	int ret;
+
+	sdesc.desc.tfm = tfm;
+	sdesc.desc.flags = 0;
+
+	ret = crypto_shash_digest(&sdesc.desc, data, length,
+				  (char *)(hash->hash));
+	return ret;
+}
+
+int btrfs_dedup_calc_hash(struct btrfs_root *root, struct inode *inode,
+			  u64 start, struct btrfs_dedup_hash *hash)
+{
+	struct page *p;
+	struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
+	char *data;
+	int i;
+	int ret;
+	u64 dedup_bs;
+	u64 sectorsize = root->sectorsize;
+
+	if (!dedup_info || !hash)
+		return 0;
+
+	WARN_ON(!IS_ALIGNED(start, sectorsize));
+
+	dedup_bs = dedup_info->blocksize;
+	sectorsize = root->sectorsize;
+
+	data = kmalloc(dedup_bs, GFP_NOFS);
+	if (!data)
+		return -ENOMEM;
+	for (i = 0; sectorsize * i < dedup_bs; i++) {
+		char *d;
+
+		/* TODO: Add support for subpage size case */
+		p = find_get_page(inode->i_mapping,
+				  (start >> PAGE_CACHE_SHIFT) + i);
+		WARN_ON(!p);
+		d = kmap_atomic(p);
+		memcpy((data + sectorsize * i), d, sectorsize);
+		kunmap_atomic(d);
+		page_cache_release(p);
+	}
+	ret = hash_data(dedup_info, data, dedup_bs, hash);
+	kfree(data);
+	return ret;
+}
-- 
2.6.4



