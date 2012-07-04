Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41824 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2GDNkK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:40:10 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so2633865bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:40:10 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 3/6] Btrfs-progs: print inode transid and dir item data field in debug-tree
Date: Wed,  4 Jul 2012 15:39:31 +0200
Message-Id: <1341409174-13619-4-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add printing of inode transid and dir item data field.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 print-tree.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index fc134c0..1377732 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -48,6 +48,12 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 		read_extent_buffer(eb, namebuf, (unsigned long)(di + 1), len);
 		printf("\t\tnamelen %u datalen %u name: %.*s\n",
 		       name_len, data_len, len, namebuf);
+		if (data_len) {
+			len = (data_len <= sizeof(namebuf))? data_len: sizeof(namebuf);
+			read_extent_buffer(eb, namebuf,
+				(unsigned long)(di + 1) + name_len, len);
+			printf("\t\tdata %.*s\n", len, namebuf);
+		}
 		len = sizeof(*di) + name_len + data_len;
 		di = (struct btrfs_dir_item *)((char *)di + len);
 		cur += len;
@@ -481,8 +487,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
-			printf("\t\tinode generation %llu size %llu block group %llu mode %o links %u\n",
+			printf("\t\tinode generation %llu transid %llu size %llu block group %llu mode %o links %u\n",
 			       (unsigned long long)btrfs_inode_generation(l, ii),
+			       (unsigned long long)btrfs_inode_transid(l, ii),
 			       (unsigned long long)btrfs_inode_size(l, ii),
 			       (unsigned long long)btrfs_inode_block_group(l,ii),
 			       btrfs_inode_mode(l, ii),
-- 
1.7.10

