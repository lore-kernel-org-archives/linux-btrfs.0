From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: rename the option to nospace_cache
Date: Fri, 11 Nov 2011 16:41:55 +0100
Message-ID: <1321026115-26424-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, josef@redhat.com,
	David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Rename no_space_cache option to nospace_cache to be more consistent with
the rest, where the simple prefix 'no' is used to negate an option.

The option has been introduced during the -rc1 cycle and there are has not been
widely used, so it's safe.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

 fs/btrfs/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 629281c..8bd9d6d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -197,7 +197,7 @@ static match_table_t tokens = {
 	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_defrag, "autodefrag"},
 	{Opt_inode_cache, "inode_cache"},
-	{Opt_no_space_cache, "no_space_cache"},
+	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
 	{Opt_err, NULL},
 };
@@ -711,7 +711,7 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (btrfs_test_opt(root, SPACE_CACHE))
 		seq_puts(seq, ",space_cache");
 	else
-		seq_puts(seq, ",no_space_cache");
+		seq_puts(seq, ",nospace_cache");
 	if (btrfs_test_opt(root, CLEAR_CACHE))
 		seq_puts(seq, ",clear_cache");
 	if (btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
-- 
1.7.6

