Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57403 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3G3Pkr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 11:40:47 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 917C17C0689
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 09:40:46 -0600 (MDT)
Date: Tue, 30 Jul 2013 11:40:44 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix all callers of read_tree_block
Message-ID: <20130730154044.GE24583@localhost.localdomain>
References: <1366741222-1825-1-git-send-email-jbacik@fusionio.com>
 <CAOcd+r1JhTKCTp4zmj9Yy-ASjKPjaRsGk8uhxGYM6zPOwbsA6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1JhTKCTp4zmj9Yy-ASjKPjaRsGk8uhxGYM6zPOwbsA6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 30, 2013 at 06:11:39PM +0300, Alex Lyakas wrote:
> Hi Josef,
> 
> On Tue, Apr 23, 2013 at 9:20 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > We kept leaking extent buffers when mounting a broken file system and it turns
> > out it's because not everybody uses read_tree_block properly.  You need to check
> > and make sure the extent_buffer is uptodate before you use it.  This patch fixes
> > everybody who calls read_tree_block directly to make sure they check that it is
> > uptodate and free it and return an error if it is not.  With this we no longer
> > leak EB's when things go horribly wrong.  Thanks,
> >
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/backref.c     |   10 ++++++++--
> >  fs/btrfs/ctree.c       |   21 ++++++++++++++++-----
> >  fs/btrfs/disk-io.c     |   19 +++++++++++++++++--
> >  fs/btrfs/extent-tree.c |    4 +++-
> >  fs/btrfs/relocation.c  |   18 +++++++++++++++---
> >  5 files changed, 59 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 23e927b..04b5b30 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
> > @@ -423,7 +423,10 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
> >                 BUG_ON(!ref->wanted_disk_byte);
> >                 eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
> >                                      fs_info->tree_root->leafsize, 0);
> > -               BUG_ON(!eb);
> > +               if (!eb || !extent_buffer_uptodate(eb)) {
> > +                       free_extent_buffer(eb);
> > +                       return -EIO;
> > +               }
> >                 btrfs_tree_read_lock(eb);
> >                 if (btrfs_header_level(eb) == 0)
> >                         btrfs_item_key_to_cpu(eb, &ref->key_for_search, 0);
> > @@ -913,7 +916,10 @@ again:
> >                                                         info_level);
> >                                 eb = read_tree_block(fs_info->extent_root,
> >                                                            ref->parent, bsz, 0);
> > -                               BUG_ON(!eb);
> > +                               if (!eb || !extent_buffer_uptodate(eb)) {
> > +                                       free_extent_buffer(eb);
> > +                                       return -EIO;
> > +                               }
> >                                 ret = find_extent_in_eb(eb, bytenr,
> >                                                         *extent_item_pos, &eie);
> >                                 ref->inode_list = eie;
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 566d99b..2bc3440 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -1281,7 +1281,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
> >                 free_extent_buffer(eb_root);
> >                 blocksize = btrfs_level_size(root, old_root->level);
> >                 old = read_tree_block(root, logical, blocksize, 0);
> > -               if (!old) {
> > +               if (!old || !extent_buffer_uptodate(old)) {
> > +                       free_extent_buffer(old);
> >                         pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
> >                                 logical);
> >                         WARN_ON(1);
> > @@ -1526,8 +1527,10 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
> >                         if (!cur) {
> >                                 cur = read_tree_block(root, blocknr,
> >                                                          blocksize, gen);
> > -                               if (!cur)
> > +                               if (!cur || !extent_buffer_uptodate(cur)) {
> > +                                       free_extent_buffer(cur);
> >                                         return -EIO;
> > +                               }
> >                         } else if (!uptodate) {
> >                                 err = btrfs_read_buffer(cur, gen);
> >                                 if (err) {
> > @@ -1692,6 +1695,8 @@ static noinline struct extent_buffer *read_node_slot(struct btrfs_root *root,
> >                                    struct extent_buffer *parent, int slot)
> >  {
> >         int level = btrfs_header_level(parent);
> > +       struct extent_buffer *eb;
> > +
> >         if (slot < 0)
> >                 return NULL;
> >         if (slot >= btrfs_header_nritems(parent))
> > @@ -1699,9 +1704,15 @@ static noinline struct extent_buffer *read_node_slot(struct btrfs_root *root,
> >
> >         BUG_ON(level == 0);
> >
> > -       return read_tree_block(root, btrfs_node_blockptr(parent, slot),
> > -                      btrfs_level_size(root, level - 1),
> > -                      btrfs_node_ptr_generation(parent, slot));
> > +       eb = read_tree_block(root, btrfs_node_blockptr(parent, slot),
> > +                            btrfs_level_size(root, level - 1),
> > +                            btrfs_node_ptr_generation(parent, slot));
> > +       if (eb && !extent_buffer_uptodate(eb)) {
> > +               free_extent_buffer(eb);
> > +               eb = NULL;
> > +       }
> > +
> > +       return eb;
> >  }
> >
> >  /*
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index fb0e5c2..4605cc7 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -1534,6 +1534,14 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
> >         blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
> >         root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
> >                                      blocksize, generation);
> > +       if (!root->node || !extent_buffer_uptodate(root->node)) {
> > +               ret = (!root->node) ? -ENOMEM : -EIO;
> > +
> > +               free_extent_buffer(root->node);
> > +               kfree(root);
> > +               return ERR_PTR(ret);
> > +       }
> > +
> >         root->commit_root = btrfs_root_node(root);
> >         BUG_ON(!root->node); /* -ENOMEM */
> >  out:
> > @@ -2572,8 +2580,8 @@ int open_ctree(struct super_block *sb,
> >         chunk_root->node = read_tree_block(chunk_root,
> >                                            btrfs_super_chunk_root(disk_super),
> >                                            blocksize, generation);
> > -       BUG_ON(!chunk_root->node); /* -ENOMEM */
> > -       if (!test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
> > +       if (!chunk_root->node ||
> > +           !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
> >                 printk(KERN_WARNING "btrfs: failed to read chunk root on %s\n",
> >                        sb->s_id);
> >                 goto fail_tree_roots;
> > @@ -2758,6 +2766,13 @@ retry_root_backup:
> >                 log_tree_root->node = read_tree_block(tree_root, bytenr,
> >                                                       blocksize,
> >                                                       generation + 1);
> > +               if (!log_tree_root->node ||
> > +                   !extent_buffer_uptodate(log_tree_root->node)) {
> > +                       printk(KERN_ERR "btrfs: failed to read log tree\n");
> > +                       free_extent_buffer(log_tree_root->node);
> > +                       kfree(log_tree_root);
> > +                       goto fail_trans_kthread;
> > +               }
> >                 /* returns with log_tree_root freed on success */
> >                 ret = btrfs_recover_log_trees(log_tree_root);
> >                 if (ret) {
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 10a980c..ea92671 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -7103,8 +7103,10 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
> >                 if (reada && level == 1)
> >                         reada_walk_down(trans, root, wc, path);
> >                 next = read_tree_block(root, bytenr, blocksize, generation);
> > -               if (!next)
> > +               if (!next || !extent_buffer_uptodate(next)) {
> > +                       free_extent_buffer(next);
> >                         return -EIO;
> > +               }
> >                 btrfs_tree_lock(next);
> >                 btrfs_set_lock_blocking(next);
> >         }
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index a5955e8..ed568e3 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -1771,7 +1771,11 @@ again:
> >
> >                         eb = read_tree_block(dest, old_bytenr, blocksize,
> >                                              old_ptr_gen);
> > -                       BUG_ON(!eb);
> > +                       if (!eb || !extent_buffer_uptodate(eb)) {
> > +                               ret = (!eb) ? -ENOMEM : -EIO;
> > +                               free_extent_buffer(eb);
> > +                               return ret;
> > +                       }
> >                         btrfs_tree_lock(eb);
> >                         if (cow) {
> >                                 ret = btrfs_cow_block(trans, dest, eb, parent,
> > @@ -1924,6 +1928,10 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
> >                 bytenr = btrfs_node_blockptr(eb, path->slots[i]);
> >                 blocksize = btrfs_level_size(root, i - 1);
> >                 eb = read_tree_block(root, bytenr, blocksize, ptr_gen);
> > +               if (!eb || !extent_buffer_uptodate(eb)) {
> > +                       free_extent_buffer(eb);
> > +                       return -EIO;
> > +               }
> >                 BUG_ON(btrfs_header_level(eb) != i - 1);
> >                 path->nodes[i - 1] = eb;
> >                 path->slots[i - 1] = 0;
> > @@ -2601,7 +2609,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
> >                 blocksize = btrfs_level_size(root, node->level);
> >                 generation = btrfs_node_ptr_generation(upper->eb, slot);
> >                 eb = read_tree_block(root, bytenr, blocksize, generation);
> > -               if (!eb) {
> > +               if (!eb || !extent_buffer_uptodate(eb)) {
> > +                       free_extent_buffer(eb);
> >                         err = -EIO;
> >                         goto next;
> >                 }
> > @@ -2762,7 +2771,10 @@ static int get_tree_block_key(struct reloc_control *rc,
> >         BUG_ON(block->key_ready);
> >         eb = read_tree_block(rc->extent_root, block->bytenr,
> >                              block->key.objectid, block->key.offset);
> > -       BUG_ON(!eb);
> > +       if (!eb || !extent_buffer_uptodate(eb)) {
> > +               free_extent_buffer(eb);
> > +               return -EIO;
> > +       }
> >         WARN_ON(btrfs_header_level(eb) != block->level);
> >         if (block->level == 0)
> >                 btrfs_item_key_to_cpu(eb, &block->key, 0);
> > --
> > 1.7.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Without this fix, we are seeing crashes when
> btree_read_extent_buffer_pages() fails to read the page, because of IO
> error. We see warnings like [1], [2], eventually leading to crash like
> [3].
> 
> However, with this fix in place we can also crash; for example, in
> btrfs_search_old_slot():
> ...
> 	b = get_old_root(root, time_seq);
> 	level = btrfs_header_level(b);
> 
> The fixed get_old_root() can experience an IO error in
> read_tree_block(), and them "b" will be NULL, so we will crash,
> correct? Then again, your patch was intended to fix only the callers
> of read_tree_block, not the callers' callers:)
> 

Yes we should fix the callers' callers :).  I'll fix it up after I track down
this balance problem.  Thanks,

Josef
