Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5881 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932080AbdDEI7V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2017 04:59:21 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 30BEA49FD53E
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Apr 2017 16:59:18 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: dump-super: check array_size in print_sys_chunk_array
Date: Wed, 5 Apr 2017 16:59:14 +0800
Message-ID: <20170405085915.21791-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Without validation of array_size, the dump-super may lead to a bad
memory access.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index ee2c8e3a..48b5219c 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -62,16 +62,23 @@ static void print_sys_chunk_array(struct btrfs_super_block *sb)
 	struct btrfs_key key;
 	int item;
 
-	buf = malloc(sizeof(*buf) + sizeof(*sb));
+	buf = malloc(sizeof(*buf) + BTRFS_SUPER_INFO_SIZE);
 	if (!buf) {
 		error("not enough memory");
-		goto out;
+		return;
 	}
-	write_extent_buffer(buf, sb, 0, sizeof(*sb));
+	write_extent_buffer(buf, sb, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(sb);
 
 	array_ptr = sb->sys_chunk_array;
 	sb_array_offset = offsetof(struct btrfs_super_block, sys_chunk_array);
+
+	if (array_size > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
+		error("sys_array_size %u shouldn't exceed %u bytes",
+				array_size, BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
+		goto out;
+	}
+
 	cur_offset = 0;
 	item = 0;
 
@@ -124,8 +131,8 @@ static void print_sys_chunk_array(struct btrfs_super_block *sb)
 		item++;
 	}
 
-	free(buf);
 out:
+	free(buf);
 	return;
 
 out_short_read:
-- 
2.12.1



