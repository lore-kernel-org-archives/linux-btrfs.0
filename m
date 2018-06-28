Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S968017AbeF1TD4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:03:56 -0400
Date: Thu, 28 Jun 2018 16:03:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: keep pages dirty when using
 btrfs_writepage_fixup_worker
Message-ID: <20180628140355.GH2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620145612.1644763-1-clm@fb.com>
 <20180620145612.1644763-3-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620145612.1644763-3-clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 07:56:12AM -0700, Chris Mason wrote:
> For COW, btrfs expects pages dirty pages to have been through a few setup
> steps.  This includes reserving space for the new block allocations and marking
> the range in the state tree for delayed allocation.
> 
> A few places outside btrfs will dirty pages directly, especially when unmapping
> mmap'd pages.  In order for these to properly go through COW, we run them
> through a fixup worker to wait for stable pages, and do the delalloc prep.
> 
> 87826df0ec36 added a window where the dirty pages were cleaned, but pending
> more action from the fixup worker.

Can you please be more specific about the window, where it starts and
ends?

> During this window, page migration can jump
> in and relocate the page.  Once our fixup work actually starts, it finds
> page->mapping is NULL and we end up freeing the page without ever writing it.

AFAICS the old and new code do the same sequence of calls from the first
mapping check:
ClearPageChecked, ulock_page, put_page, kfree, extent_changeset_free


> This leads to crc errors and other exciting problems, since it screws up the
> whole statemachine for waiting for ordered extents.  The fix here is to keep
> the page dirty while we're waiting for the fixup worker to get to work.  This
> also makes sure the error handling in btrfs_writepage_fixup_worker does the
> right thing with dirty bits when we run out of space.

So this would need to find the mapping first to be not NULL, go until
btrfs_start_ordered_extent where the lock is droppend and back to again:, check
for mapping that's now NULL?

But I still don't see how this is making things different.

In the remaining sequence

btrfs_lookup_ordered_range, btrfs_delalloc_reserve_space,
btrfs_set_extent_delalloc (without any errors), the clear page checked
comes after the extent is unlocked.

> Signed-off-by: Chris Mason <clm@fb.com>
> ---
>  fs/btrfs/inode.c | 67 +++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 49 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0b86cf1..5538900 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2100,11 +2100,21 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
>  	page = fixup->page;
>  again:
>  	lock_page(page);
> -	if (!page->mapping || !PageDirty(page) || !PageChecked(page)) {
> -		ClearPageChecked(page);
> +
> +	/*
> +	 * before we queued this fixup, we took a reference on the page.
> +	 * page->mapping may go NULL, but it shouldn't be moved to a
> +	 * different address space.
> +	 */
> +	if (!page->mapping || !PageDirty(page) || !PageChecked(page))
>  		goto out_page;
> -	}
>  
> +	/*
> +	 * we keep the PageChecked() bit set until we're done with the
> +	 * btrfs_start_ordered_extent() dance that we do below.  That
> +	 * drops and retakes the page lock, so we don't want new
> +	 * fixup workers queued for this page during the churn.
> +	 */
>  	inode = page->mapping->host;
>  	page_start = page_offset(page);
>  	page_end = page_offset(page) + PAGE_SIZE - 1;
> @@ -2129,33 +2139,46 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
>  
>  	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
>  					   PAGE_SIZE);
> -	if (ret) {
> -		mapping_set_error(page->mapping, ret);
> -		end_extent_writepage(page, ret, page_start, page_end);
> -		ClearPageChecked(page);
> -		goto out;
> -	 }
> +	if (ret)
> +		goto out_error;
>  
>  	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
>  					&cached_state, 0);
> -	if (ret) {
> -		mapping_set_error(page->mapping, ret);
> -		end_extent_writepage(page, ret, page_start, page_end);
> -		ClearPageChecked(page);
> -		goto out;
> -	}
> +	if (ret)
> +		goto out_error;
>  
> -	ClearPageChecked(page);
> -	set_page_dirty(page);

Hm, so previously the page was dirty, unconditionally calling down to
set_page_dirty that could call btree_set_page_dirty and
__set_page_dirty_nobuffers. If the dirty bit is set there, it'll do
nothing.

So this should be equivalent to the new code but looks strange to say at
least.

>  	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, false);
> +
> +	/*
> +	 * everything went as planned, we're now the proud owners of a
> +	 * Dirty page with delayed allocation bits set and space reserved
> +	 * for our COW destination.
> +	 *
> +	 * The page was dirty when we started, nothing should have cleaned it.
> +	 */
> +	BUG_ON(!PageDirty(page));
> +
>  out:
>  	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
>  			     &cached_state);
>  out_page:
> +	ClearPageChecked(page);
>  	unlock_page(page);
>  	put_page(page);
>  	kfree(fixup);
>  	extent_changeset_free(data_reserved);
> +	return;
> +
> +out_error:
> +	/*
> +	 * We hit ENOSPC or other errors.  Update the mapping and page to
> +	 * reflect the errors and clean the page.
> +	 */
> +	mapping_set_error(page->mapping, ret);
> +	end_extent_writepage(page, ret, page_start, page_end);
> +	clear_page_dirty_for_io(page);
> +	SetPageError(page);
> +	goto out;
>  }
>  
>  /*
> @@ -2179,6 +2202,13 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
>  	if (TestClearPagePrivate2(page))
>  		return 0;
>  
> +	/*
> +	 * PageChecked is set below when we create a fixup worker for this page,
> +	 * don't try to create another one if we're already PageChecked()
> +	 *
> +	 * The extent_io writepage code will redirty the page if we send
> +	 * back EAGAIN.
> +	 */
>  	if (PageChecked(page))
>  		return -EAGAIN;
>  
> @@ -2192,7 +2222,8 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
>  			btrfs_writepage_fixup_worker, NULL, NULL);
>  	fixup->page = page;
>  	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);
> -	return -EBUSY;
> +
> +	return -EAGAIN;

So now this will redirty unconditionally in __extent_writepage_io:

3338                         /* Fixup worker will requeue */
3339                         if (ret == -EBUSY)
3340                                 wbc->pages_skipped++;
3341                         else
3342                                 redirty_page_for_writepage(wbc, page);

The referred patch 87826df0ec36 changed that to avoid some pointless
redirty loops under ENOSPC and a potential crash in
drop_outstanding_extents, but IIRC this has been reworked in the
meanwhile so this might not apply anymore.


In summary, I feel like there are still not enough comments around to at
least give some directions where to lool. The reasons why the page is
dirtied besides the normal paths is unclear and was in the past too. I
remember that 'zap page range' can do that but was never able to follow
the exact callchain not to say reproduce it reliably.

Now you mention page migration that can in the end do the same but maybe
not, which means the fixup worker has to deal with more weird corner
cases.

Leaving the Checked bit until the last moment can save some trouble, but
its semantics are also quite unclear.
