Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbcBEBY4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:24:56 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 07/19] btrfs: dedup: Implement btrfs_dedup_calc_hash interface
Date: Fri,  5 Feb 2016 09:22:27 +0800
Message-Id: <1454635359-10013-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Unlike in-memory or on-disk dedup method, only SHA256 hash method is
supported yet, so implement btrfs_dedup_calc_hash() interface using
SHA256.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index dbcfcc9..9777355 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -543,3 +543,52 @@ int btrfs_dedup_search(struct btrfs_fs_info *fs_info,
 	}
 	return ret;
 }
+
+int btrfs_dedup_calc_hash(struct btrfs_fs_info *fs_info,
+			  struct inode *inode, u64 start,
+			  struct btrfs_dedup_hash *hash)
+{
+	int i;
+	int ret;
+	struct page *p;
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+	struct crypto_shash *tfm = dedup_info->dedup_driver;
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(tfm)];
+	} sdesc;
+	u64 dedup_bs;
+	u64 sectorsize = BTRFS_I(inode)->root->sectorsize;
+
+	if (!fs_info->dedup_enabled || !hash)
+		return 0;
+
+	if (WARN_ON(dedup_info == NULL))
+		return -EINVAL;
+
+	WARN_ON(!IS_ALIGNED(start, sectorsize));
+
+	dedup_bs = dedup_info->blocksize;
+
+	sdesc.desc.tfm = tfm;
+	sdesc.desc.flags = 0;
+	ret = crypto_shash_init(&sdesc.desc);
+	if (ret)
+		return ret;
+	for (i = 0; sectorsize * i < dedup_bs; i++) {
+		char *d;
+
+		p = find_get_page(inode->i_mapping,
+				  (start >> PAGE_CACHE_SHIFT) + i);
+		if (WARN_ON(!p))
+			return -ENOENT;
+		d = kmap(p);
+		ret = crypto_shash_update(&sdesc.desc, d, sectorsize);
+		kunmap(p);
+		page_cache_release(p);
+		if (ret)
+			return ret;
+	}
+	ret = crypto_shash_final(&sdesc.desc, hash->hash);
+	return ret;
+}
-- 
2.7.0



