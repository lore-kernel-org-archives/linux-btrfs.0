From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH v2] btrfs: fix early abort in 'remount'
Date: Mon, 16 Apr 2012 06:44:37 +0300
Message-ID: <1334547877-13726-1-git-send-email-slyich@gmail.com>
References: <4F8B7214.5010702@cn.fujitsu.com>
Cc: Liu Bo <liubo2009@cn.fujitsu.com>,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F8B7214.5010702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Josef Bacik <josef@redhat.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
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

