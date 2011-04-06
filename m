From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: [PATCH] Btrfs: fix subvolume fake mount problem when default subvolume is set
Date: Wed,  6 Apr 2011 17:34:53 +0800
Message-ID: <1302082493-14589-1-git-send-email-xin.zhong@intel.com>
Cc: xin.zhong@intel.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We create two subvolumes (meego_root and meego_home) in
btrfs root directory. And set meego_root as default mount
subvolume. After we remount btrfs, meego_root is mounted
to top directory by default. Then if we create a directory with
the same name as meego_home, we can mount meego_home subvolume
sucessfully (subvol=meego_home). But this is incorrect. What we
do in this mount point will not change anything in meego_home
subvolume. The problem is when default mount subvolume is set to
meego_root, we search meego_home in meego_root. But if we find a
directory with the same name, we will treat it as subvolume. So
the solution is to check if what we find is really a subvolume.

Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
---
 fs/btrfs/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b85fe78..66a76b7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -823,7 +823,9 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 			error = PTR_ERR(new_root);
 			goto error_free_subvol_name;
 		}
-		if (!new_root->d_inode) {
+		if (!new_root->d_inode ||
+		    /* new_root is a directory, not subvolume */
+		    new_root->d_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
 			dput(root);
 			dput(new_root);
 			deactivate_locked_super(s);
-- 
1.7.0.4

