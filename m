From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 2/5] Btrfs: fix subvol_name leak on error in btrfs_mount()
Date: Wed,  9 Nov 2011 16:38:34 +0200
Message-ID: <1320849517-13172-3-git-send-email-idryomov@gmail.com>
References: <1320849517-13172-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320849517-13172-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_parse_early_options() can fail due to error while scanning devices
(-o device= option), but still strdup() subvol_name string:

mount -o subvol=SUBV,device=BAD_DEVICE <dev> <mnt>

So free subvol_name string on error.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6befcaf..58e9492 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -905,8 +905,10 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &subvol_name, &subvol_objectid,
 					  &subvol_rootid, &fs_devices);
-	if (error)
+	if (error) {
+		kfree(subvol_name);
 		return ERR_PTR(error);
+	}
 
 	if (subvol_name) {
 		root = mount_subvol(subvol_name, flags, device_name, data);
-- 
1.7.6.3

