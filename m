Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab3DXPuR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 11:50:17 -0400
Date: Wed, 24 Apr 2013 17:50:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix all callers of read_tree_block
Message-ID: <20130424155011.GG16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366741222-1825-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366741222-1825-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 02:20:22PM -0400, Josef Bacik wrote:
> We kept leaking extent buffers when mounting a broken file system and it turns
> out it's because not everybody uses read_tree_block properly.  You need to check
> and make sure the extent_buffer is uptodate before you use it.  This patch fixes
> everybody who calls read_tree_block directly to make sure they check that it is
> uptodate and free it and return an error if it is not.  With this we no longer
> leak EB's when things go horribly wrong.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

> @@ -2762,7 +2771,10 @@ static int get_tree_block_key(struct reloc_control *rc,
>  	BUG_ON(block->key_ready);
>  	eb = read_tree_block(rc->extent_root, block->bytenr,
>  			     block->key.objectid, block->key.offset);
> -	BUG_ON(!eb);
> +	if (!eb || !extent_buffer_uptodate(eb)) {
> +		free_extent_buffer(eb);
> +		return -EIO;

The error code is not checked when called from relocate_tree_blocks:

2878         rb_node = rb_first(blocks);
2879         while (rb_node) {
2880                 block = rb_entry(rb_node, struct tree_block, rb_node);
2881                 if (!block->key_ready)
2882                         get_tree_block_key(rc, block);
2883                 rb_node = rb_next(rb_node);
2884         }

but the function is ready to return errors, I'll send this as a followup:

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2878,8 +2878,11 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
        rb_node = rb_first(blocks);
        while (rb_node) {
                block = rb_entry(rb_node, struct tree_block, rb_node);
-               if (!block->key_ready)
-                       get_tree_block_key(rc, block);
+               if (!block->key_ready) {
+                       ret = get_tree_block_key(rc, block);
+                       if (ret)
+                               goto out_free_path;
+               }
                rb_node = rb_next(rb_node);
        }

@@ -2906,6 +2909,7 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 out:
        err = finish_pending_nodes(trans, rc, path, err);

+out_free_path:
        btrfs_free_path(path);
 out_path:
        free_block_list(blocks);

