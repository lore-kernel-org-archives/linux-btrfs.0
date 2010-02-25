From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Wed, 24 Feb 2010 20:40:06 -0500
Message-ID: <20100225014006.GO25641@think>
References: <loom.20100212T220341-877@post.gmane.org>
 <20100217141813.GH29430@think>
 <loom.20100218T013258-629@post.gmane.org>
 <20100218150238.GL10559@think>
 <loom.20100218T183230-637@post.gmane.org>
 <20100218204843.GW10559@think>
 <loom.20100218T215310-779@post.gmane.org>
 <loom.20100223T092903-542@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100223T092903-542@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2010 at 08:30:56AM +0000, Alex Elsayed wrote:
> Alex Elsayed <eternaleye <at> gmail.com> writes:
> 
> > 
> > Chris Mason <chris.mason <at> oracle.com> writes:
> > > I think the btrfsck output is missing.  It sounds like we'll survive if
> > > we just skip this part of the log replay.  I'll cook a patch based on
> > > the btrfsck output.
> > 
> > It was inline in my first message, immediately after the BUG trace.
> 
> Any update? Including btrfsck output here, in case it got lost:

Sorry for the delay.  With this patch, you'll have a consistent
filesystem but any fsyncs that were done before your last crash are not
going to be there after the mount.

The tree logging code should be made more tolerant of this problem, but
that is a larger change that will take longer to get right.  And you
want to mount this FS and get to your data.

With this patch, mount -o danger_del_log_tree /dev/xxx

Just let me know how things are working afterwards:

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2aa8ec6..1a532a5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1162,6 +1162,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
 #define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
+#define BTRFS_MOUNT_DELLOGTREE          (1 << 12)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b59201..aa2aa59 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1955,6 +1955,13 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			err = -EIO;
 			goto fail_trans_kthread;
 		}
+
+		if (btrfs_test_opt(tree_root, DELLOGTREE)) {
+			printk(KERN_WARNING "Btrfs deleting log tree");
+			btrfs_set_super_log_root(disk_super, 0);
+			goto postrecover;
+		}
+
 		blocksize =
 		     btrfs_level_size(tree_root,
 				      btrfs_super_log_root_level(disk_super));
@@ -1968,15 +1975,16 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		log_tree_root->node = read_tree_block(tree_root, bytenr,
 						      blocksize,
 						      generation + 1);
+
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
 
+postrecover:
 		if (sb->s_flags & MS_RDONLY) {
 			ret =  btrfs_commit_super(tree_root);
 			BUG_ON(ret);
 		}
 	}
-
 	ret = btrfs_find_orphan_roots(tree_root);
 	BUG_ON(ret);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8a1ea6e..6132721 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -67,7 +67,7 @@ enum {
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
 	Opt_ssd, Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl,
 	Opt_compress, Opt_compress_force, Opt_notreelog, Opt_ratio,
-	Opt_flushoncommit,
+	Opt_flushoncommit, Opt_danger_del_log_tree,
 	Opt_discard, Opt_err,
 };
 
@@ -92,6 +92,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_danger_del_log_tree, "danger_del_log_tree"},
 	{Opt_err, NULL},
 };
 
@@ -270,6 +271,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_danger_del_log_tree:
+			btrfs_set_opt(info->mount_opt, DELLOGTREE);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
