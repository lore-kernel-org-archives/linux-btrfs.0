Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:56378 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750808AbdHRHE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 03:04:26 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Piotr Szymaniak <szarpaj@grubelek.pl>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/2] Don't call lookup_path_rootid() when ino=BTRFS_EMPTY_SUBVOL_DIR_OBJECTID
Date: Fri, 18 Aug 2017 09:04:21 +0200
Message-Id: <20170818070421.2696-3-kreijack@libero.it>
In-Reply-To: <20170818070421.2696-1-kreijack@libero.it>
References: <20170818070421.2696-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

When ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID, the item is not referred
to any file-tree. So lookup_path_rootid() doesn't return any sensate
value.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-fi-du.c | 25 ++++++++++++++++---------
 ctree.h      |  2 ++
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 4bf6af3e..013f8dfd 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -433,7 +433,6 @@ static int du_add_file(const char *filename, int dirfd,
 	u64 file_total = 0;
 	u64 file_shared = 0;
 	u64 dir_set_shared = 0;
-	u64 subvol;
 	int fd;
 	DIR *dirstream = NULL;
 
@@ -462,16 +461,24 @@ static int du_add_file(const char *filename, int dirfd,
 		goto out;
 	}
 
-	ret = lookup_path_rootid(fd, &subvol);
-	if (ret)
-		goto out_close;
+	/*
+	 * st.st_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID (==2)
+	 * there is no any related tree
+	 */
+	if (st.st_ino != BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
+		u64 subvol;
 
-	if (inode_seen(st.st_ino, subvol))
-		goto out_close;
+		ret = lookup_path_rootid(fd, &subvol);
+		if (ret)
+			goto out_close;
 
-	ret = mark_inode_seen(st.st_ino, subvol);
-	if (ret)
-		goto out_close;
+		if (inode_seen(st.st_ino, subvol))
+			goto out_close;
+
+		ret = mark_inode_seen(st.st_ino, subvol);
+		if (ret)
+			goto out_close;
+	}
 
 	if (S_ISREG(st.st_mode)) {
 		ret = du_calc_file_space(fd, shared_extents, &file_total,
diff --git a/ctree.h b/ctree.h
index 48ae8903..2fc67b06 100644
--- a/ctree.h
+++ b/ctree.h
@@ -138,6 +138,8 @@ struct btrfs_free_space_ctl;
  */
 #define BTRFS_DEV_ITEMS_OBJECTID 1ULL
 
+#define BTRFS_EMPTY_SUBVOL_DIR_OBJECTID 2
+
 /*
  * the max metadata block size.  This limit is somewhat artificial,
  * but the memmove costs go through the roof for larger blocks.
-- 
2.14.1

