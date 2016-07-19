Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbcGSIv0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jul 2016 04:51:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v12.2 08/15] btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
Date: Tue, 19 Jul 2016 16:50:43 +0800
Message-Id: <20160719085050.30564-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160719085050.30564-1-quwenruo@cn.fujitsu.com>
References: <20160719085050.30564-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Unlike in-memory or on-disk dedupe method, only SHA256 hash method is
supported yet, so implement btrfs_dedupe_calc_hash() interface using
SHA256.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/dedupe.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index eb1b110..6296b65 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -639,3 +639,49 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
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
+	SHASH_DESC_ON_STACK(sdesc, tfm);
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
+	sdesc->tfm = tfm;
+	sdesc->flags = 0;
+	ret = crypto_shash_init(sdesc);
+	if (ret)
+		return ret;
+	for (i = 0; sectorsize * i < dedupe_bs; i++) {
+		char *d;
+
+		p = find_get_page(inode->i_mapping,
+				  (start >> PAGE_SHIFT) + i);
+		if (WARN_ON(!p))
+			return -ENOENT;
+		d = kmap(p);
+		ret = crypto_shash_update(sdesc, d, sectorsize);
+		kunmap(p);
+		put_page(p);
+		if (ret)
+			return ret;
+	}
+	ret = crypto_shash_final(sdesc, hash->hash);
+	return ret;
+}
-- 
2.9.0



