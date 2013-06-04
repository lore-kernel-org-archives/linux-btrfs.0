Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3FDWSF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 18:18:05 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54MI5O7018471
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:05 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r54MI2Q4002655
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:05 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: fix readdir hang with offsets past INT_MAX
Date: Tue,  4 Jun 2013 15:17:56 -0700
Message-Id: <1370384280-28652-3-git-send-email-zab@redhat.com>
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To work around bugs in userspace btrfs_real_readdir() sets f_pos to an
offset that will prevent any future entries from being returned once the
last entry is hit.  Over time this supposedly impossible offset was
decreased from the initial U64_MAX to INT_MAX to appease 32bit
userspace.

  https://oss.oracle.com/pipermail/btrfs-devel/2008-January/000437.html
  commit c2a8b6e11009398ca9363d8ba8d4e7e40fb897fd
  commit 89f135d8b53bcccafd91a075366d2704ba257cf3
  commit 406266ab9ac8ed8b085c58aacd9e3161480dc5d5

The remaining problem is that resetting f_pos to some impossible offset
causes userspace to spin when it's, well, possible for an entry to have
that offset.  It takes a single thread on a modern cpu about nine hours
of constant file creation and removal to hit an offset past INT_MAX on a
single spindle.

Instead of trying to find an impossible f_pos that doesn't break various
layers of the stack, let's use f_version to indicate that readdir should
stop returning entries until seek changes f_pos and clears f_version.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/inode.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6a5784b..e6e2b86 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4983,6 +4983,16 @@ unsigned char btrfs_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
+/*
+ * There have been buggy applications that can't handle one readdir pass
+ * returning the same name for different inodes that are unlinked and
+ * re-created during the readdir pass.  This was partially worked around
+ * by trying to set f_pos to magic values that broke either 32bit userspace
+ * or entries with huge offsets.  Now we set f_version to a magic value
+ * which prevents readdir results until seek resets f_pos and f_version.
+ */
+#define BTRFS_READDIR_EOF ~0ULL
+
 static int btrfs_real_readdir(struct file *filp, void *dirent,
 			      filldir_t filldir)
 {
@@ -5008,6 +5018,9 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	char *name_ptr;
 	int name_len;
 
+	if (filp->f_version == BTRFS_READDIR_EOF)
+		return 0;
+
 	/* FIXME, use a real flag for deciding about the key type */
 	if (root->fs_info->tree_root == root)
 		key_type = BTRFS_DIR_ITEM_KEY;
@@ -5145,14 +5158,9 @@ next:
 			goto nopos;
 	}
 
-	/* Reached end of directory/root */
-	if (key_type == BTRFS_DIR_INDEX_KEY) {
-		/*
-		 * 32-bit glibc will use getdents64, but then strtol -
-		 * so the last number we can serve is this.
-		 */
-		filp->f_pos = 0x7fffffff;
-	}
+	/* prevent further readdir results without seeking once we hit EOF */
+	if (key_type == BTRFS_DIR_INDEX_KEY)
+		filp->f_version = BTRFS_READDIR_EOF;
 
 nopos:
 	ret = 0;
-- 
1.7.11.7

