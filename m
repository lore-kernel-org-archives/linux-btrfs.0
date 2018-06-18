Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:30074 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968202AbeFRIiR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:17 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id CDBD7AC011E
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 03DC66925F3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 08/20] btrfs-progs: sub list: factor out main part of btrfs_list_subvols
Date: Mon, 18 Jun 2018 17:40:56 +0900
Message-ID: <a1f7638d0335e3823f453d50c388500c01c6aa1d.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes.
This is a preparation work for reworking "subvolume list".

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 cmds-subvolume.c | 50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c54a8003..279a6e51 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1125,22 +1125,15 @@ out:
 	return subvols;
 }
 
-static struct subvol_list *btrfs_list_subvols(int fd,
-					      struct btrfs_list_filter_set_v2 *filter_set)
+static void get_subvols_info(struct subvol_list **subvols,
+			     struct btrfs_list_filter_set_v2 *filter_set,
+			     int fd,
+			     size_t *capacity)
 {
-	struct subvol_list *subvols;
-	size_t capacity = 0;
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
 	int ret = -1;
 
-	subvols = malloc(sizeof(*subvols));
-	if (!subvols) {
-		error("out of memory");
-		return NULL;
-	}
-	subvols->num = 0;
-
 	err = btrfs_util_create_subvolume_iterator_fd(fd,
 						      BTRFS_FS_TREE_OBJECTID, 0,
 						      &iter);
@@ -1168,11 +1161,11 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 			continue;
 		}
 
-		if (subvols->num >= capacity) {
+		if ((*subvols)->num >= *capacity) {
 			struct subvol_list *new_subvols;
-			size_t new_capacity = max_t(size_t, 1, capacity * 2);
+			size_t new_capacity = max_t(size_t, 1, *capacity * 2);
 
-			new_subvols = realloc(subvols,
+			new_subvols = realloc(*subvols,
 					      sizeof(*new_subvols) +
 					      new_capacity *
 					      sizeof(new_subvols->subvols[0]));
@@ -1181,12 +1174,12 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 				goto out;
 			}
 
-			subvols = new_subvols;
-			capacity = new_capacity;
+			*subvols = new_subvols;
+			*capacity = new_capacity;
 		}
 
-		subvols->subvols[subvols->num] = subvol;
-		subvols->num++;
+		(*subvols)->subvols[(*subvols)->num] = subvol;
+		(*subvols)->num++;
 	}
 
 	ret = 0;
@@ -1194,9 +1187,26 @@ out:
 	if (iter)
 		btrfs_util_destroy_subvolume_iterator(iter);
 	if (ret) {
-		free_subvol_list(subvols);
-		subvols = NULL;
+		free_subvol_list(*subvols);
+		*subvols = NULL;
+	}
+}
+
+static struct subvol_list *btrfs_list_subvols(int fd,
+					      struct btrfs_list_filter_set_v2 *filter_set)
+{
+	struct subvol_list *subvols;
+	size_t capacity = 0;
+
+	subvols = malloc(sizeof(*subvols));
+	if (!subvols) {
+		error("out of memory");
+		return NULL;
 	}
+	subvols->num = 0;
+
+	get_subvols_info(&subvols, filter_set, fd, &capacity);
+
 	return subvols;
 }
 
-- 
2.14.4


