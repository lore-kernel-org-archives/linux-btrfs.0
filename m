Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:45963 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbeC2HyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 03:54:04 -0400
Received: by mail-pf0-f193.google.com with SMTP id l27so2702386pfk.12
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 00:54:04 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 1/5] libbtrfsutil: don't return free space cache inodes from deleted_subvolumes()
Date: Thu, 29 Mar 2018 00:53:53 -0700
Message-Id: <4e26593120026bc81403d4eccb1557d00dc82fe8.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Deleted free space cache inodes also get an orphan item in the root
tree, but we shouldn't report those as deleted subvolumes. Deleted
subvolumes will still have the root item, so we can just do an extra
tree search.

Reported-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/subvolume.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index d9728281..d6c0ced8 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -1339,21 +1339,31 @@ PUBLIC enum btrfs_util_error btrfs_util_deleted_subvolumes_fd(int fd,
 		}
 
 		header = (struct btrfs_ioctl_search_header *)(search.buf + buf_off);
-		if (*n >= capacity) {
-			size_t new_capacity = capacity ? capacity * 2 : 1;
-			uint64_t *new_ids;
 
-			new_ids = reallocarray(*ids, new_capacity,
-					       sizeof(**ids));
-			if (!new_ids)
-				return BTRFS_UTIL_ERROR_NO_MEMORY;
-
-			*ids = new_ids;
-			capacity = new_capacity;
+		/*
+		 * The orphan item might be for a free space cache inode, so
+		 * check if there's a matching root item.
+		 */
+		err = btrfs_util_subvolume_info_fd(fd, header->offset, NULL);
+		if (!err) {
+			if (*n >= capacity) {
+				size_t new_capacity;
+				uint64_t *new_ids;
+
+				new_capacity = capacity ? capacity * 2 : 1;
+				new_ids = reallocarray(*ids, new_capacity,
+						       sizeof(**ids));
+				if (!new_ids)
+					return BTRFS_UTIL_ERROR_NO_MEMORY;
+
+				*ids = new_ids;
+				capacity = new_capacity;
+			}
+			(*ids)[(*n)++] = header->offset;
+		} else if (err != BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND) {
+			goto out;
 		}
 
-		(*ids)[(*n)++] = header->offset;
-
 		items_pos++;
 		buf_off += sizeof(*header) + header->len;
 		search.key.min_offset = header->offset + 1;
-- 
2.16.3

