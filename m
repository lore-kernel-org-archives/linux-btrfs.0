From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH] btrfs: fix early abort in 'remount'
Date: Mon, 16 Apr 2012 01:46:15 +0300
Message-ID: <1334529975-13289-1-git-send-email-slyich@gmail.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Josef Bacik <josef@redhat.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8d5d380..0b296f2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1149,12 +1149,16 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 	} else {
 		if (fs_info->fs_devices->rw_devices == 0)
+		{
 			ret = -EACCES;
 			goto restore;
+		}
 
 		if (btrfs_super_log_root(fs_info->super_copy) != 0)
+		{
 			ret = -EINVAL;
 			goto restore;
+		}
 
 		ret = btrfs_cleanup_fs_roots(fs_info);
 		if (ret)
-- 
1.7.8.5

