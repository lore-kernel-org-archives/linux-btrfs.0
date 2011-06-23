From: Josef Bacik <josef@redhat.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Thu, 23 Jun 2011 15:54:09 -0400
Message-ID: <20110623195409.GA21007@dhcp231-156.rdu.redhat.com>
References: <4E026FD4.7020606@podzimek.org> <1308793398-sup-9234@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrej Podzimek <andrej@podzimek.org>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308793398-sup-9234@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2011 at 09:45:20PM -0400, Chris Mason wrote:
> Excerpts from Andrej Podzimek's message of 2011-06-22 18:42:28 -0400:
> > 
> > Could I try your hack, pretty please? If there's any chance it could either resolve this problem
> > 
> >     http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg10683.html ,
> > 
> > or at least restore the data from the filesystem, then I'd like to give it a go. Waiting for the new btrfsck is currently not an option for me :-)
> 
> It looks like your box is failing to read the extent allocation tree.
> We don't allow the mount to proceed without that tree, but you don't
> actually need it for a readonly mount (to copy things off).
> 
> Josef, is your hack just a mount option to make -o readonly skip the
> extent allocation tree?
> 
> I can put this into my -o recovery patch and we can give it a try.
> 

Here's the patch, you _have_ to mount -o readonly.  Basically what it does is
search all the mirrors and finds the one with the newest generation number and
just uses that one, assuming that it will be the closest one to what we want.
This has worked relatively well for the people who have used it, so hopefully it
will work for you.  Thanks,

Josef

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c650a1d..53e330e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -281,7 +281,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
  * in the wrong place.
  */
 static int verify_parent_transid(struct extent_io_tree *io_tree,
-				 struct extent_buffer *eb, u64 parent_transid)
+				 struct extent_buffer *eb, u64 parent_transid, int uptodate)
 {
 	struct extent_state *cached_state = NULL;
 	int ret;
@@ -296,6 +296,11 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		ret = 0;
 		goto out;
 	}
+	if (!uptodate) {
+		ret = 0;
+		goto out;
+	}
+
 	if (printk_ratelimit()) {
 		printk("parent transid verify failed on %llu wanted %llu "
 		       "found %llu\n",
@@ -323,6 +328,9 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	int ret;
 	int num_copies = 0;
 	int mirror_num = 0;
+	int uptodate = 1;
+	int good_mirror = 0;
+	u64 generation = 0;
 
 	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
@@ -330,9 +338,14 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		ret = read_extent_buffer_pages(io_tree, eb, start, 1,
 					       btree_get_extent, mirror_num);
 		if (!ret &&
-		    !verify_parent_transid(io_tree, eb, parent_transid))
+		    !verify_parent_transid(io_tree, eb, parent_transid, uptodate))
 			return ret;
 
+		if (btrfs_header_generation(eb) > generation) {
+			good_mirror = mirror_num;
+			generation = btrfs_header_generation(eb);
+		}
+
 		/*
 		 * This buffer's crc is fine, but its contents are corrupted, so
 		 * there is no reason to read the other copies, they won't be
@@ -347,8 +360,11 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 			return ret;
 
 		mirror_num++;
-		if (mirror_num > num_copies)
-			return ret;
+		if (mirror_num > num_copies) {
+			mirror_num = good_mirror;
+			uptodate = 0;
+			continue;
+		}
 	}
 	return -EIO;
 }
@@ -1996,11 +2012,13 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_block_groups;
 	}
 
+	/*
 	ret = btrfs_read_block_groups(extent_root);
 	if (ret) {
 		printk(KERN_ERR "Failed to read block groups: %d\n", ret);
 		goto fail_block_groups;
 	}
+	*/
 
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
@@ -2613,12 +2631,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid)
 
 	ret = extent_buffer_uptodate(&BTRFS_I(btree_inode)->io_tree, buf,
 				     NULL);
-	if (!ret)
-		return ret;
-
-	ret = verify_parent_transid(&BTRFS_I(btree_inode)->io_tree, buf,
-				    parent_transid);
-	return !ret;
+	return ret;
 }
 
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf)
