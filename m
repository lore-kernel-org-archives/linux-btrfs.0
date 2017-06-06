Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56527 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751532AbdFFJz0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 05:55:26 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 6/9] btrfs: Check name_len before read in iterate_dir_item
Date: Tue, 6 Jun 2017 17:57:05 +0800
Message-ID: <20170606095708.494-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since 'iterate_dir_item' checks name_len in its way,
so use 'btrfs_is_name_len_valid' not 'verify_dir_item' to make more strict
name_len check.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/send.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fc496a6f842a..f0e33f7f221e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1069,6 +1069,12 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 			}
 		}
 
+		ret = btrfs_is_name_len_valid(eb, path->slots[0],
+			  (unsigned long)(di + 1), name_len + data_len);
+		if (!ret) {
+			ret = -ENAMETOOLONG;
+			goto out;
+		}
 		if (name_len + data_len > buf_len) {
 			buf_len = name_len + data_len;
 			if (is_vmalloc_addr(buf)) {
-- 
2.13.0



