From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: try to only do one btrfs_search_slot in do_setxattr
Date: Fri, 27 May 2011 12:17:18 -0400
Message-ID: <1306513038-3133-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been watching how many btrfs_search_slot()'s we do and I noticed that when
we create a file with selinux enabled we were doing 2 each time we initialize
the security context.  That's because we lookup the xattr first so we can delete
it if we're setting a new value to an existing xattr.  But in the create case we
don't have any xattrs, so it is completely useless to have the extra lookup.  So
re-arrange things so that we only lookup first if we specifically have
XATTR_REPLACE.  That way in the basic case we only do 1 search, and in the more
complicated case we do the normal 2 lookups.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/xattr.c |   54 ++++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 72ab029..4857a87 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -102,43 +102,41 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	/* first lets see if we already have this xattr */
-	di = btrfs_lookup_xattr(trans, root, path, inode->i_ino, name,
-				strlen(name), -1);
-	if (IS_ERR(di)) {
-		ret = PTR_ERR(di);
-		goto out;
-	}
-
-	/* ok we already have this xattr, lets remove it */
-	if (di) {
-		/* if we want create only exit */
-		if (flags & XATTR_CREATE) {
-			ret = -EEXIST;
+	if (flags & XATTR_REPLACE) {
+		di = btrfs_lookup_xattr(trans, root, path, inode->i_ino, name,
+					strlen(name), -1);
+		if (IS_ERR(di)) {
+			ret = PTR_ERR(di);
+			goto out;
+		} else if (!di) {
+			ret = -ENODATA;
 			goto out;
 		}
-
 		ret = btrfs_delete_one_dir_name(trans, root, path, di);
-		BUG_ON(ret);
-		btrfs_release_path(root, path);
-
-		/* if we don't have a value then we are removing the xattr */
-		if (!value)
+		if (ret)
 			goto out;
-	} else {
 		btrfs_release_path(root, path);
-
-		if (flags & XATTR_REPLACE) {
-			/* we couldn't find the attr to replace */
-			ret = -ENODATA;
-			goto out;
-		}
 	}
 
-	/* ok we have to create a completely new xattr */
+again:
 	ret = btrfs_insert_xattr_item(trans, root, path, inode->i_ino,
 				      name, name_len, value, size);
-	BUG_ON(ret);
+	if (ret == -EEXIST) {
+		if (flags & XATTR_CREATE)
+			goto out;
+		di = btrfs_match_dir_item_name(root, path, name, name_len);
+		ret = btrfs_delete_one_dir_name(trans, root, path, di);
+		if (ret)
+			goto out;
+
+		/*
+		 * We have a value to set, so go back and try to insert it now.
+		 */
+		if (value) {
+			btrfs_release_path(root, path);
+			goto again;
+		}
+	}
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
1.7.2.3

