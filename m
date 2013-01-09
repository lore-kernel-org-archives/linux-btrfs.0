Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f175.google.com ([209.85.210.175]:45754 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AIRjn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 12:39:43 -0500
Received: by mail-ia0-f175.google.com with SMTP id 21so1561578iay.20
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2013 09:39:43 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Jan 2013 19:39:43 +0200
Message-ID: <CAOcd+r0aaeKiy_wTfsy4ibea+80u7yHmw_uNhfT7XQ4JqcLftQ@mail.gmail.com>
Subject: [PATCH 1/2] Avoid sending disknr==0 extents when possible
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Arne Jansen <sensille@gmx.net>, Chen Yang <chenyang.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <CAOcd+r1VfBCRmDptpp47CLDAbH-o+NpAQxx42ou5JVG-hfM0PA@mail.gmail.com>

Subject: [PATCH 1/2] Avoid sending disknr==0 extents in the following cases:
 1) full send 2) new inode in a diff-send 3) when
 disknr==0 extents are  added to the end of an inode

Original-version-by: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
---
 fs/btrfs/send.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5445454..5ab584f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3844,7 +3844,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 	btrfs_item_key_to_cpu(eb, &found_key, slot);
 	if (found_key.objectid != key.objectid ||
 	    found_key.type != key.type) {
-		ret = 0;
+		/* No need to send a no-data extent it in this case */
+		ret = (left_disknr == 0) ? 1 : 0;
 		goto out;
 	}

@@ -3870,7 +3871,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 		 * This may only happen on the first iteration.
 		 */
 		if (found_key.offset + right_len <= ekey->offset) {
-			ret = 0;
+			/* No need to send a no-data extent it in this case */
+			ret = (left_disknr == 0) ? 1 : 0;
 			goto out;
 		}

@@ -3951,6 +3953,28 @@ static int process_extent(struct send_ctx *sctx,
 			ret = 0;
 			goto out;
 		}
+	} else {
+		struct extent_buffer *eb;
+		struct btrfs_file_extent_item *ei;
+		u8 extent_type;
+		u64 extent_disknr;
+
+		eb = path->nodes[0];
+		ei = btrfs_item_ptr(eb, path->slots[0],
+				struct btrfs_file_extent_item);
+
+		extent_type = btrfs_file_extent_type(eb, ei);
+		extent_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
+		if (extent_type == BTRFS_FILE_EXTENT_REG && extent_disknr == 0) {
+			/*
+			 * This is disknr=0 extent in a full-send or a new inode
+			 * in a diff-send. Since we will send truncate command
+			 * in finish_inode_if_needed anyways, the inode size will be
+			 * correct, and we don't have to send all-zero data.
+			 */
+			ret = 0;
+			goto out;
+		}
 	}

 	ret = find_extent_clone(sctx, path, key->objectid, key->offset,
-- 
1.7.9.5
