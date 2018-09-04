Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38902 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726041AbeIDLXq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 07:23:46 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15 07/13] btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
Date: Tue, 4 Sep 2018 14:59:36 +0800
Message-ID: <20180904065942.3621-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
References: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
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
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 9c6152b7f0eb..9b0a90dd8e42 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -644,3 +644,53 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
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
+	struct shash_desc *shash;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	struct crypto_shash *tfm = dedupe_info->dedupe_driver;
+	u64 dedupe_bs;
+	u64 sectorsize = fs_info->sectorsize;
+
+	shash = kmalloc(sizeof(*shash) + crypto_shash_descsize(tfm), GFP_NOFS);
+	if (!shash)
+		return -ENOMEM;
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
+	shash->tfm = tfm;
+	shash->flags = 0;
+	ret = crypto_shash_init(shash);
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
+		ret = crypto_shash_update(shash, d, sectorsize);
+		kunmap(p);
+		put_page(p);
+		if (ret)
+			return ret;
+	}
+	ret = crypto_shash_final(shash, hash->hash);
+	return ret;
+}
-- 
2.18.0
