From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] fs/btrfs: Add missing btrfs_free_path
Date: Sat, 14 May 2011 09:10:51 +0200
Message-ID: <1305357051-5288-1-git-send-email-julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Btrfs_alloc_path should be matched with btrfs_free_path in error-handling code.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression struct btrfs_path * x;
expression ra,rb;
position p1,p2;
@@

x = btrfs_alloc_path@p1(...)
...  when != btrfs_free_path(x,...)
     when != if (...) { ... btrfs_free_path(x,...) ...}
     when != x = ra
if(...) { ... when != x = rb
     when forall
     when != btrfs_free_path(x,...)
 \(return <+...x...+>; \| return@p2...; \) }

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

cocci.print_main("alloc",p1)
cocci.print_secs("return",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/inode.c |    1 +
 fs/btrfs/super.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7cd8ab0..079a8df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7315,6 +7315,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 				      datasize);
 	if (err) {
 		drop_inode = 1;
+		btrfs_free_path(path);
 		goto out_unlock;
 	}
 	leaf = path->nodes[0];
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index be4ffa1..6ee0d04 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -507,8 +507,10 @@ static struct dentry *get_default_root(struct super_block *sb,
 	 */
 	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
 	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
-	if (IS_ERR(di))
+	if (IS_ERR(di)) {
+		btrfs_free_path(path);
 		return ERR_CAST(di);
+	}
 	if (!di) {
 		/*
 		 * Ok the default dir item isn't there.  This is weird since

