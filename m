Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22809 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751281AbdCPH70 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 03:59:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14.2 10/16] btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
Date: Thu, 16 Mar 2017 15:58:48 +0800
Message-ID: <20170316075854.15788-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
References: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index 4708dc08c4d1..f938997c6d93 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -642,3 +642,49 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
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
+	u64 sectorsize = fs_info->sectorsize;
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
2.12.0



