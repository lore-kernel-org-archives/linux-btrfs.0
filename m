Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35966 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964927AbbLOLM3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 06:12:29 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 341154092556
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 19:11:43 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs: Disable raid56 readahead
Date: Tue, 15 Dec 2015 19:09:49 +0800
Message-ID: <092e20dbfac092d4632f1fa04dbcd5f09f0066b7.1450177455.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
References: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Raid56 readahead can not work in current code, reada_find_extent()
will show warning of bbio->num_stripes > BTRFS_MAX_MIRRORS, because
raid56 have parity strip, which makes more bbio->num_stripes.

The reason why we haven't see above error is because another bug
in __btrfs_map_block(), which make raid56 readahead do nothing.

Before we will fix bug in __btrfs_map_block(), we need to disable
raid56 temporary, to avoid above warning.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 619f929..7bbd656 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -363,6 +363,11 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	if (ret || !bbio || length < blocksize)
 		goto error;
 
+	if (bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		/* Current code can not support RAID56 yet */
+		goto error;
+	}
+
 	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
 		btrfs_err(root->fs_info,
 			   "readahead: more than %d copies not supported",
-- 
1.8.5.1



