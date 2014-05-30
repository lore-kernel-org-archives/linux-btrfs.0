Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55708 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbaE3CSE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 22:18:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4U2I1cs009968
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 10:18:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: Add dev uuid output for print_dev_item().
Date: Fri, 30 May 2014 10:19:04 +0800
Message-ID: <1401416344-1298-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original print_dev_item() only prints device id,total bytes and
bytes used.

When it comes to debug duplicated device id, dev uuid
is needed to distinguish different devices since device id is not
reliable.
(Although the current dev replace implement will reuse the dev uuid,
so not really helpful)

This patch adds dev uuid output for print_dev_item().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2:	Remove typos from comment message.
---
 print-tree.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 574ae9e..cb5c2e1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -179,11 +179,20 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 static void print_dev_item(struct extent_buffer *eb,
 			   struct btrfs_dev_item *dev_item)
 {
+	char disk_uuid_c[BTRFS_UUID_UNPARSED_SIZE];
+	u8 disk_uuid[BTRFS_UUID_SIZE];
+
+	read_extent_buffer(eb, disk_uuid,
+			   (unsigned long)btrfs_device_uuid(dev_item),
+			   BTRFS_UUID_SIZE);
+	uuid_unparse(disk_uuid, disk_uuid_c);
 	printf("\t\tdev item devid %llu "
-	       "total_bytes %llu bytes used %Lu\n",
+	       "total_bytes %llu bytes used %Lu\n"
+	       "\t\tdev uuid %s\n",
 	       (unsigned long long)btrfs_device_id(eb, dev_item),
 	       (unsigned long long)btrfs_device_total_bytes(eb, dev_item),
-	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item));
+	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item),
+	       disk_uuid_c);
 }
 
 static void print_uuids(struct extent_buffer *eb)
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
