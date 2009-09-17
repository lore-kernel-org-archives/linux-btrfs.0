From: Chris Ball <cjb@laptop.org>
Subject: [PATCH 2/2] Btrfs: Fix setting umask when POSIX ACLs are not enabled
Date: Thu, 17 Sep 2009 01:42:35 -0400
Message-ID: <m3r5u6jfec.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We currently set sb->s_flags |= MS_POSIXACL unconditionally, which is
incorrect -- it tells the VFS that it shouldn't set umask because we
will, yet we don't set it ourselves if we aren't using POSIX ACLs, so
the umask ends up ignored.

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6d6d06c..48ed1c0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -344,7 +344,9 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_export_op = &btrfs_export_ops;
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
+#ifdef CONFIG_BTRFS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
+#endif
 
 	tree_root = open_ctree(sb, fs_devices, (char *)data);
 
-- 
1.6.4


-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
