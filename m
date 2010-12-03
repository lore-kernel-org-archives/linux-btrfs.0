From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 5/5 v3] Btrfs: avoid log replay when btrfs is insane
Date: Fri, 03 Dec 2010 16:17:40 +0800
Message-ID: <4CF8A7A4.9020405@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>,
	Wenyi Liu <qingshenlwy@gmail.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs may do log replay even as mounted readonly, since we have added
readonly check at start transaction time, in order to keep the original
attribute, it needs to set and to restore readonly flags around log
replay.
However, we do not permit log replay when btrfs is insane, and log replay
can start once btrfs is mounted in good state.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 15d795a..727e156 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1937,9 +1937,14 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
-	if (btrfs_super_log_root(disk_super) != 0) {
+	if (btrfs_super_log_root(disk_super) != 0 &&
+	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
+		unsigned int s_flags = sb->s_flags;
+		if (s_flags & MS_RDONLY)
+			sb->s_flags &= ~MS_RDONLY;
+
 		if (fs_devices->rw_devices == 0) {
 			printk(KERN_WARNING "Btrfs log replay required "
 			       "on RO media\n");
@@ -1969,6 +1974,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			ret =  btrfs_commit_super(tree_root);
 			BUG_ON(ret);
 		}
+
+		sb->s_flags = s_flags;
 	}
 
 	ret = btrfs_find_orphan_roots(tree_root);
-- 
1.7.1
