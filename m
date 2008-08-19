From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Reinstate '-osubvol=.' option to mount entire tree
Date: Tue, 19 Aug 2008 19:24:52 +0100
Message-ID: <1219170292.2988.7.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This disappeared when I removed the special case for '.' in btrfs_lookup()

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 super.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/super.c b/super.c
index 55f4d00..f7b3eac 100644
--- a/super.c
+++ b/super.c
@@ -451,21 +451,25 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		s->s_flags |= MS_ACTIVE;
 	}
 
-	mutex_lock(&s->s_root->d_inode->i_mutex);
-	root = lookup_one_len(subvol_name, s->s_root, strlen(subvol_name));
-	mutex_unlock(&s->s_root->d_inode->i_mutex);
-	if (IS_ERR(root)) {
-		up_write(&s->s_umount);
-		deactivate_super(s);
-		error = PTR_ERR(root);
-		goto error;
-	}
-	if (!root->d_inode) {
-		dput(root);
-		up_write(&s->s_umount);
-		deactivate_super(s);
-		error = -ENXIO;
-		goto error;
+	if (!strcmp(subvol_name, "."))
+		root = dget(s->s_root);
+	else {
+		mutex_lock(&s->s_root->d_inode->i_mutex);
+		root = lookup_one_len(subvol_name, s->s_root, strlen(subvol_name));
+		mutex_unlock(&s->s_root->d_inode->i_mutex);
+		if (IS_ERR(root)) {
+			up_write(&s->s_umount);
+			deactivate_super(s);
+			error = PTR_ERR(root);
+			goto error;
+		}
+		if (!root->d_inode) {
+			dput(root);
+			up_write(&s->s_umount);
+			deactivate_super(s);
+			error = -ENXIO;
+			goto error;
+		}
 	}
 
 	mnt->mnt_sb = s;
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



