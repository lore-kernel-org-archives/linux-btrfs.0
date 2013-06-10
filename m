Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59871 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3FJTwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 15:52:09 -0400
Received: by mail-we0-f174.google.com with SMTP id q58so5288908wes.33
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 12:52:07 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 4/5] Btrfs-progs: pretty print dir_item type
Date: Mon, 10 Jun 2013 20:51:34 +0100
Message-Id: <1370893895-24884-5-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of printing an integer, print a symbolic name which
is more human friendly. Particularly useful when using the
program btrfs-debug-tree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 print-tree.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index aae47a9..4401a1a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -25,6 +25,42 @@
 #include "disk-io.h"
 #include "print-tree.h"
 
+
+static void print_dir_item_type(struct extent_buffer *eb,
+                                struct btrfs_dir_item *di)
+{
+	u8 type = btrfs_dir_type(eb, di);
+
+	switch (type) {
+	case BTRFS_FT_REG_FILE:
+		printf("FILE");
+		break;
+	case BTRFS_FT_DIR:
+		printf("DIR");
+		break;
+	case BTRFS_FT_CHRDEV:
+		printf("CHRDEV");
+		break;
+	case BTRFS_FT_BLKDEV:
+		printf("BLKDEV");
+		break;
+	case BTRFS_FT_FIFO:
+		printf("FIFO");
+		break;
+	case BTRFS_FT_SOCK:
+		printf("SOCK");
+		break;
+	case BTRFS_FT_SYMLINK:
+		printf("SYMLINK");
+		break;
+	case BTRFS_FT_XATTR:
+		printf("XATTR");
+		break;
+	default:
+		printf("%u", type);
+	}
+}
+
 static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 			  struct btrfs_dir_item *di)
 {
@@ -41,7 +77,9 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 		btrfs_dir_item_key(eb, di, &location);
 		printf("\t\tlocation ");
 		btrfs_print_key(&location);
-		printf(" type %u\n", btrfs_dir_type(eb, di));
+		printf(" type ");
+		print_dir_item_type(eb, di);
+		printf("\n");
 		name_len = btrfs_dir_name_len(eb, di);
 		data_len = btrfs_dir_data_len(eb, di);
 		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
