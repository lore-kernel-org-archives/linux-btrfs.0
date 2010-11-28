From: Calvin Walton <calvin.walton@gmail.com>
Subject: [RFC-PATCH] Re: mounting arbitrary directories
Date: Sat, 27 Nov 2010 23:22:13 -0500
Message-ID: <1290918133.14274.20.camel@nayuki>
References: <AANLkTi=7LY6y3BvGgkyYBTLwu=SYJjZZhL8kHusCn_vs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=7LY6y3BvGgkyYBTLwu=SYJjZZhL8kHusCn_vs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2010-11-27 at 21:19 -0600, C Anthony Risinger wrote:
> i have read just recently and in the past that btrfs supports COW for
> _any_ file/directory (this is reflinks, yes?), and today i
> accidentally noticed that i can mount a directory as well (if it's in
> the top level volume at least).
> 
> eg. if i have a "regular" directory (not a subvolume) in the top-level:
> 
> /__boot
> 
> i can mount it with:
> 
> mount -o subvol=__boot /dev/sda /mnt

The 'subvol' option actually works using the same mechanism as a bind
mount. The fact that it works using a directory is purely a coincidence
- I would not expect it to be officially supported, and you shouldn't
rely on it.

> i am working on an update to my initramfs hook that will utilize
> extlinux, and this property to provide seamless kernel level system
> rollbacks, and i want to make sure it's safe to do this.

To handle system rollbacks, you really should be using subvolumes and
snapshots, not regular directories.

> also, is there a way to target an arbitrary directory?  does "subvol"
> support paths yet, or maybe via "subvolid" somehow?  essentially i

I don't think that it would be very hard to make subvol= support a path
instead of only one level deep. Actually, I think I could make a patch
for that myself... I've included it here. Mildly tested, but I'm not
really a kernel programmer and might have missed something -
particularly with regards to the locking.

> just want to mount a directory inside a snapshot at /boot, so when
> users upgrade there kernels, the images are visible to extlinux (which
> cannot yet peek inside or use subvolumes, so it has to be a regular
> directory in the top-level volume)

Ah, this is the first I've heard that extlinux doesn't support reading
files in subvolumes. That's an unfortunate limitation :/

------------------------8<----------8<---------------------

From: Calvin Walton <calvin.walton@gmail.com>
Date: Sat, 27 Nov 2010 23:17:55 -0500
Subject: [PATCH] Btrfs: Allow mounting sub-sub(-sub...)-volumes using subvol=a/b/c

Currently you can only mount subvolumes which are direct children of the
'default' root. I.e. with

	ID 258 top level 5 path a
	ID 259 top level 5 path a/b

you could mount with "-o subvol=a" but not "-o subvol=a/b"

This patch fixes that by recursively following the path to the subvolume.

Signed-off-by: Calvin Walton <calvin.walton@gmail.com>
---
 fs/btrfs/super.c |   41 +++++++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8299a25..5e78c86 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -646,26 +646,31 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	/* if they gave us a subvolume name bind mount into that */
 	if (strcmp(subvol_name, ".")) {
 		struct dentry *new_root;
-		mutex_lock(&root->d_inode->i_mutex);
-		new_root = lookup_one_len(subvol_name, root,
-				      strlen(subvol_name));
-		mutex_unlock(&root->d_inode->i_mutex);
-
-		if (IS_ERR(new_root)) {
-			deactivate_locked_super(s);
-			error = PTR_ERR(new_root);
-			dput(root);
-			goto error_free_subvol_name;
-		}
-		if (!new_root->d_inode) {
+		char *subvol_name_next = subvol_name;
+		char *subvol_name_part;
+
+		while ((subvol_name_part = strsep(&subvol_name_next, "/"))) {
+			mutex_lock(&root->d_inode->i_mutex);
+			new_root = lookup_one_len(subvol_name, root,
+						strlen(subvol_name));
+			mutex_unlock(&root->d_inode->i_mutex);
+
+			if (IS_ERR(new_root)) {
+				deactivate_locked_super(s);
+				error = PTR_ERR(new_root);
+				dput(root);
+				goto error_free_subvol_name;
+			}
+			if (!new_root->d_inode) {
+				dput(root);
+				dput(new_root);
+				deactivate_locked_super(s);
+				error = -ENXIO;
+				goto error_free_subvol_name;
+			}
 			dput(root);
-			dput(new_root);
-			deactivate_locked_super(s);
-			error = -ENXIO;
-			goto error_free_subvol_name;
+			root = new_root;
 		}
-		dput(root);
-		root = new_root;
 	}
 
 	kfree(subvol_name);
-- 
1.7.3.2

-- 
Calvin Walton <calvin.walton@gmail.com>

