Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61010 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S941522AbdDTIIB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 04:08:01 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 1/2] btrfs-progs: dump-super: check array_size in print_sys_chunk_array
Date: Thu, 20 Apr 2017 16:07:56 +0800
Message-ID: <20170420080757.1895-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Without validation of array_size, the dump-super may lead to a bad
memory access.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
v2:
	Accept David's advice, no longer use BTRFS_SUPER_INFO_SIZE instead of sizeof(*sb).
---
 cmds-inspect-dump-super.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index ee2c8e3a..b65bd2d9 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -65,13 +65,20 @@ static void print_sys_chunk_array(struct btrfs_super_block *sb)
 	buf = malloc(sizeof(*buf) + sizeof(*sb));
 	if (!buf) {
 		error("not enough memory");
-		goto out;
+		return;
 	}
 	write_extent_buffer(buf, sb, 0, sizeof(*sb));
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
2.12.2



