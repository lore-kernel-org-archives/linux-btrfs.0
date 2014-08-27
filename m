Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:42533 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbaH0SQD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 14:16:03 -0400
Date: Wed, 27 Aug 2014 11:16:03 -0700
From: Zach Brown <zab@zabbo.net>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: readahead errors are not fatal
Message-ID: <20140827181603.GF12827@lenny.home.zabbo.net>
References: <1409161665-28234-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409161665-28234-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 27, 2014 at 07:47:45PM +0200, David Sterba wrote:
> Kill the BUG_ON.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  disk-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 8db0335bc81b..7ddd4b90836f 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -152,7 +152,8 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
>  	length = blocksize;
>  	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
>  			      bytenr, &length, &multi, 0, NULL);
> -	BUG_ON(ret);
> +	if (ret)
> +		return 0
>  	device = multi->stripes[0].dev;
>  	device->total_ios++;
>  	blocksize = min(blocksize, (u32)(64 * 1024));

Seems like this is already leaking a refcount and only returns 0..  so
maybe remove the bug_on something like this totally untested patch?

There's another "#if 0"-ed out caller in extent-tree.c but that nonsense
should just be removed.

- z

commit 69a668994c70cc1fd86d1c349d272b1cbfde23b1
Author: Zach Brown <zab@zabbo.net>
Date:   Wed Aug 27 11:07:23 2014 -0700

    btrfs-progs: kill BUG_ON in readahead_tree_block()
    
    David sent a quick patch that removed a BUG_ON().  I took a peek and
    found that the function was already leaking an eb ref and only returned
    0.  So this fixes the leak and makes the function void and fixes up the
    callers.
    
    Accidentally-motivated-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Zach Brown <zab@zabbo.net>

diff --git a/cmds-check.c b/cmds-check.c
index 268e588..d479361 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1287,7 +1287,6 @@ static void reada_walk_down(struct btrfs_root *root,
 	u32 nritems;
 	u32 blocksize;
 	int i;
-	int ret;
 	int level;
 
 	level = btrfs_header_level(node);
@@ -1299,9 +1298,7 @@ static void reada_walk_down(struct btrfs_root *root,
 	for (i = slot; i < nritems; i++) {
 		bytenr = btrfs_node_blockptr(node, i);
 		ptr_gen = btrfs_node_ptr_generation(node, i);
-		ret = readahead_tree_block(root, bytenr, blocksize, ptr_gen);
-		if (ret)
-			break;
+		readahead_tree_block(root, bytenr, blocksize, ptr_gen);
 	}
 }
 
diff --git a/disk-io.c b/disk-io.c
index f71f5ca..1f1ce75 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -134,31 +134,26 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 				   blocksize);
 }
 
-int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
-			 u64 parent_transid)
+void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
+			  u64 parent_transid)
 {
-	int ret;
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi = NULL;
 	struct btrfs_device *device;
 
 	eb = btrfs_find_tree_block(root, bytenr, blocksize);
-	if (eb && btrfs_buffer_uptodate(eb, parent_transid)) {
-		free_extent_buffer(eb);
-		return 0;
+	if (!(eb && btrfs_buffer_uptodate(eb, parent_transid)) &&
+	    !btrfs_map_block(&root->fs_info->mapping_tree, READ,
+			     bytenr, &length, &multi, 0, NULL)) {
+		device = multi->stripes[0].dev;
+		device->total_ios++;
+		blocksize = min(blocksize, (u32)(64 * 1024));
+		readahead(device->fd, multi->stripes[0].physical, blocksize);
 	}
 
-	length = blocksize;
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-			      bytenr, &length, &multi, 0, NULL);
-	BUG_ON(ret);
-	device = multi->stripes[0].dev;
-	device->total_ios++;
-	blocksize = min(blocksize, (u32)(64 * 1024));
-	readahead(device->fd, multi->stripes[0].physical, blocksize);
+	free_extent_buffer(eb);
 	kfree(multi);
-	return 0;
 }
 
 static int verify_parent_transid(struct extent_io_tree *io_tree,
diff --git a/disk-io.h b/disk-io.h
index 13d4420..c296055 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -48,8 +48,8 @@ struct btrfs_device;
 int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror);
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
-int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
-			 u64 parent_transid);
+void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
+			  u64 parent_transid);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
 
