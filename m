Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5881 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932081AbdDEI7X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2017 04:59:23 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A39EA4D14A49
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Apr 2017 16:59:18 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: print-tree: add validation to print_chunk
Date: Wed, 5 Apr 2017 16:59:15 +0800
Message-ID: <20170405085915.21791-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170405085915.21791-1-lufq.fnst@cn.fujitsu.com>
References: <20170405085915.21791-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In print_chunk, validate the value of uuid_offset when read the dev_uuid of
stripe.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c |  1 +
 print-tree.c              | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 48b5219c..a89fe451 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -68,6 +68,7 @@ static void print_sys_chunk_array(struct btrfs_super_block *sb)
 		return;
 	}
 	write_extent_buffer(buf, sb, 0, BTRFS_SUPER_INFO_SIZE);
+	buf->len = BTRFS_SUPER_INFO_SIZE;
 	array_size = btrfs_super_sys_array_size(sb);
 
 	array_ptr = sb->sys_chunk_array;
diff --git a/print-tree.c b/print-tree.c
index 5af80e87..8352e03d 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -199,8 +199,14 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
+	u32 chunk_item_size = btrfs_chunk_item_size(num_stripes);
 	char chunk_flags_str[32] = {0};
 
+	if ((unsigned long)chunk + chunk_item_size > eb->len) {
+		printf("\t\tchunk item invalid\n");
+		return;
+	}
+
 	bg_flags_to_str(btrfs_chunk_type(eb, chunk), chunk_flags_str);
 	printf("\t\tlength %llu owner %llu stripe_len %llu type %s\n",
 	       (unsigned long long)btrfs_chunk_length(eb, chunk),
@@ -216,9 +222,21 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 	for (i = 0 ; i < num_stripes ; i++) {
 		unsigned char dev_uuid[BTRFS_UUID_SIZE];
 		char str_dev_uuid[BTRFS_UUID_UNPARSED_SIZE];
+		u64 uuid_offset;
+		u64 stripe_offset;
+
+		uuid_offset = (unsigned long)btrfs_stripe_dev_uuid_nr(chunk, i);
+		stripe_offset = (unsigned long)btrfs_stripe_nr(chunk, i);
+
+		if (uuid_offset < stripe_offset ||
+			(uuid_offset + BTRFS_UUID_SIZE) >
+				(stripe_offset + sizeof(struct btrfs_stripe))) {
+			printf("\t\t\tstripe %d invalid\n", i);
+			break;
+		}
 
 		read_extent_buffer(eb, dev_uuid,
-			(unsigned long)btrfs_stripe_dev_uuid_nr(chunk, i),
+			uuid_offset,
 			BTRFS_UUID_SIZE);
 		uuid_unparse(dev_uuid, str_dev_uuid);
 		printf("\t\t\tstripe %d devid %llu offset %llu\n", i,
-- 
2.12.1



