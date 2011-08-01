From: Chris Mason <chris.mason@oracle.com>
Subject: Re: PLEASE TEST: Everybody who is seeing weird and long hangs
Date: Mon, 01 Aug 2011 11:45:43 -0400
Message-ID: <1312213264-sup-9624@shiny>
References: <4E36C47E.70309@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E36C47E.70309@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-08-01 11:21:34 -0400:
> Hello,
> 
> We've seen a lot of reports of people having these constant long pauses
> when doing things like sync or such.  The stack traces usually all look
> the same, one is btrfs-transaction stuck in btrfs_wait_marked_extents
> and one is btrfs-submit-# stuck in get_request_wait.  I had originally
> thought this was due to the new plugging stuff, but I think it just
> makes the problem happen more quickly as we've seen that 2.6.38 which we
> thought was ok will still have the problem happen if given enough time.
> 
> I _think_ this is because of the way we write out metadata in the
> transaction commit phase.  We're doing write_on_page for every dirty
> page in the btree during the commit.  This sucks because basically we
> end up with one bio per page, which makes us blow out our nr_requests
> constantly, which is why btrfs-submit-# is always stuck in
> get_request_wait.  What we need to do instead is use filemap_fdatawrite
> which will do a WB_SYNC_ALL but will do it via writepages, so hopefully
> we will get less bios and this problem will go away.  Please try this
> very hastily put together patch if you are experiencing this problem and
> let me know if it fixes it for you.  Thanks,

I'm definitely curious to hear if this helps, but I think it might cause
a different set of problems.  It writes everything that is dirty on the
btree, which includes a lot of things we've cow'd in the current
transaction and marked dirty.  They will have to go through COW again
if someone wants to modify them again.

The btrfs writepage code does this:

        ret = __extent_writepage(page, wbc, &epd);

        extent_write_cache_pages(tree, mapping, &wbc_writepages,
                                 __extent_writepage, &epd, flush_write_bio);
        flush_epd_write_bio(&epd);

So during the commit phase we'll be grabbing adjacent pages already.  My
bet is that our problem will go away if we remove this extra IO
completely.

-chris

> 
> Josef
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index eb55863..86217a4 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -577,15 +577,17 @@ int btrfs_end_transaction_dmeta(struct
> btrfs_trans_handle *trans,
>  int btrfs_write_marked_extents(struct btrfs_root *root,
>                     struct extent_io_tree *dirty_pages, int mark)
>  {
> -    int ret;
> -    int err = 0;
> -    int werr = 0;
> -    struct page *page;
> +//    int ret;
> +//    int err = 0;
> +//    int werr = 0;
> +//    struct page *page;
>      struct inode *btree_inode = root->fs_info->btree_inode;
> -    u64 start = 0;
> -    u64 end;
> -    unsigned long index;
> +//    u64 start = 0;
> +//    u64 end;
> +//    unsigned long index;
> 
> +    return filemap_fdatawrite(btree_inode->i_mapping);
> +    /*
>      while (1) {
>          ret = find_first_extent_bit(dirty_pages, start, &start, &end,
>                          mark);
> @@ -624,7 +626,8 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
>      }
>      if (err)
>          werr = err;
> -    return werr;
> +    */
> +//    return werr;
>  }
> 
>  /*
