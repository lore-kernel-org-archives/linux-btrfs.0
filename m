Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29930 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbcC3H4q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 03:56:46 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v9 07/19] btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
Date: Wed, 30 Mar 2016 15:56:02 +0800
Message-Id: <1459324574-28063-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Unlike in-memory or on-disk dedupe method, only SHA256 hash method is
supported yet, so implement btrfs_dedupe_calc_hash() interface using
SHA256.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 9175a5f..bdaea3a 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -593,3 +593,52 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
 	}
 	return ret;
 }
+
+int btrfs_dedupe_calc_hash(struct btrfs_fs_info *fs_info,
+			   struct inode *inode, u64 start,
+			   struct btrfs_dedupe_hash *hash)
+{
+	int i;
+	int ret;
+	struct page *p;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	struct crypto_shash *tfm = dedupe_info->dedupe_driver;
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(tfm)];
+	} sdesc;
+	u64 dedupe_bs;
+	u64 sectorsize = BTRFS_I(inode)->root->sectorsize;
+
+	if (!fs_info->dedupe_enabled || !hash)
+		return 0;
+
+	if (WARN_ON(dedupe_info == NULL))
+		return -EINVAL;
+
+	WARN_ON(!IS_ALIGNED(start, sectorsize));
+
+	dedupe_bs = dedupe_info->blocksize;
+
+	sdesc.desc.tfm = tfm;
+	sdesc.desc.flags = 0;
+	ret = crypto_shash_init(&sdesc.desc);
+	if (ret)
+		return ret;
+	for (i = 0; sectorsize * i < dedupe_bs; i++) {
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
2.7.4



