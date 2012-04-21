From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH v4] btrfs: fix early abort in 'remount'
Date: Sat, 21 Apr 2012 11:27:38 +0300
Message-ID: <1334996858-11188-1-git-send-email-slyich@gmail.com>
References: <20120420212750.GF1957@localhost.localdomain>
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120420212750.GF1957@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

[ Typical case of btrfs rootfs without initramfs: ]

When trying to remount 'ro' -> 'rw' filesystem
we get early abort from 'btrfs_remount()' due to
first unconditional 'goto':

> if (fs_info->fs_devices->rw_devices == 0)
>     ret = -EACCES;
>     goto restore; /* misindented */

Thus nothing like 'btrfs_super_log_root()' or
'btrfs_cleanup_fs_roots()' gets called and all
new options passed to remount are reverted and
'mount -o remount' does not return an error.

The regression is introduced by commit 49b25e05409.

Remounting 'rw' -> 'rw' is fine.

Cc: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: Josef Bacik <josef@redhat.com>
Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
v1->v2: fixed indentation of 'if (cond) {' suggested by Liu Bo
v2->v3: added 'Reviewed-by'
v3->v4: added Jeff's 'Acked-by'; enhanced changelog
 fs/btrfs/super.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8d5d380..2f28fc0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1148,13 +1148,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (ret)
 			goto restore;
 	} else {
-		if (fs_info->fs_devices->rw_devices == 0)
+		if (fs_info->fs_devices->rw_devices == 0) {
 			ret = -EACCES;
 			goto restore;
+		}
 
-		if (btrfs_super_log_root(fs_info->super_copy) != 0)
+		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
 			ret = -EINVAL;
 			goto restore;
+		}
 
 		ret = btrfs_cleanup_fs_roots(fs_info);
 		if (ret)
-- 
1.7.8.5

