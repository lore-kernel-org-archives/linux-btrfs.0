Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:39679 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3GaOYD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 10:24:03 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id EB9FC7C06A5
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 08:24:01 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id 8lIbAq5StwezAk8o (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 08:24:01 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: sanitize xattrs when we specify sanitization
Date: Wed, 31 Jul 2013 10:23:58 -0400
Message-ID: <1375280638-1961-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexandre pointed out that his xattrs have sensitive information in them as
well, so fix btrfs-image to zero out the data part of xattrs that we find.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 82aa4f3..025facf 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -162,6 +162,7 @@ static int has_name(struct btrfs_key *key)
 	case BTRFS_DIR_INDEX_KEY:
 	case BTRFS_INODE_REF_KEY:
 	case BTRFS_INODE_EXTREF_KEY:
+	case BTRFS_XATTR_ITEM_KEY:
 		return 1;
 	default:
 		break;
@@ -446,6 +447,21 @@ static void sanitize_inode_ref(struct metadump_struct *md,
 	}
 }
 
+static void sanitize_xattr(struct metadump_struct *md,
+			   struct extent_buffer *eb, int slot)
+{
+	struct btrfs_dir_item *dir_item;
+	unsigned long data_ptr;
+	u32 data_len;
+
+	dir_item = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
+	data_len = btrfs_dir_data_len(eb, dir_item);
+
+	data_ptr = (unsigned long)((char *)(dir_item + 1) +
+				   btrfs_dir_name_len(eb, dir_item));
+	memset_extent_buffer(eb, 0, data_ptr, data_len);
+}
+
 static void sanitize_name(struct metadump_struct *md, u8 *dst,
 			  struct extent_buffer *src, struct btrfs_key *key,
 			  int slot)
@@ -471,6 +487,9 @@ static void sanitize_name(struct metadump_struct *md, u8 *dst,
 	case BTRFS_INODE_EXTREF_KEY:
 		sanitize_inode_ref(md, eb, slot, 1);
 		break;
+	case BTRFS_XATTR_ITEM_KEY:
+		sanitize_xattr(md, eb, slot);
+		break;
 	default:
 		break;
 	}
-- 
1.7.7.6

