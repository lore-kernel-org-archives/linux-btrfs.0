From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: make show_options result match actual option names
Date: Tue, 12 May 2009 08:11:37 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0905120810500.18624@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The /proc/mounts output should match the actual option names.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f23f8f0..a2b8bc4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -428,9 +428,9 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (btrfs_test_opt(root, SSD))
 		seq_puts(seq, ",ssd");
 	if (btrfs_test_opt(root, NOTREELOG))
-		seq_puts(seq, ",no-treelog");
+		seq_puts(seq, ",notreelog");
 	if (btrfs_test_opt(root, FLUSHONCOMMIT))
-		seq_puts(seq, ",flush-on-commit");
+		seq_puts(seq, ",flushoncommit");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
 	return 0;
-- 
1.5.6.5

