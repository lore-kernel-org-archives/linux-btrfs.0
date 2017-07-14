Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24083 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750917AbdGNHpg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 03:45:36 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id C641246B5260
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 15:45:31 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: check: verify dir item name and hash in lowmem mode
Date: Fri, 14 Jul 2017 15:47:45 +0800
Message-ID: <20170714074746.28177-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170714074746.28177-1-suy.fnst@cn.fujitsu.com>
References: <20170714074746.28177-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although lowmem mode can detect name and hash mismatch in dir_item,
it's done by checking inode_ref to expose such problem.

This patch will enhance dir_item check, by also comparing name and
hash when checking dir_items.

Reported-by: Filippe LeMarchand <gasinvein@gmail.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 55afefbc..81578439 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4672,6 +4672,15 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 		read_extent_buffer(node, namebuf, (unsigned long)(di + 1), len);
 		filetype = btrfs_dir_type(node, di);
 
+		if (key->type == BTRFS_DIR_ITEM_KEY &&
+		    key->offset != btrfs_name_hash(namebuf, len)) {
+			err |= -EIO;
+			error("root %llu DIR_ITEM[%llu %llu] name %s namelen %u filetype %u mismatch with its hash, wanted %llu have %llu",
+				root->objectid, key->objectid, key->offset,
+				namebuf, len, filetype, key->offset,
+				btrfs_name_hash(namebuf, len));
+		}
+
 		btrfs_init_path(&path);
 		btrfs_dir_item_key_to_cpu(node, di, &location);
 
-- 
2.13.2



