Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59864 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487AbaGYIH7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 04:07:59 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 0A9243EE147
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 17:07:58 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 25E9AAC0A02
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 17:07:57 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id C36E3E08001
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 17:07:56 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
	by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 210A06D64A5
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 17:07:56 +0900 (JST)
Message-ID: <53D21054.6050107@jp.fujitsu.com>
Date: Fri, 25 Jul 2014 17:07:48 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: use IS_ALIGNED() for assertion in btrfs_lookup_csums_range()
 for simplicity
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

btrfs_lookup_csums_range() uses ALIGN() to check if "start"
and "end + 1" are aligned to "root->sectorsize". It's better to
replace these with IS_ALIGNED() for simplicity.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 fs/btrfs/file-item.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index f46cfe4..4b9e40f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -329,8 +329,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	u64 csum_end;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
-	ASSERT(start == ALIGN(start, root->sectorsize) &&
-	       (end + 1) == ALIGN(end + 1, root->sectorsize));
+	ASSERT(IS_ALIGNED(start, root->sectorsize) &&
+	       IS_ALIGNED(end + 1, root->sectorsize));
 
 	path = btrfs_alloc_path();
 	if (!path)
-- 
1.9.3

