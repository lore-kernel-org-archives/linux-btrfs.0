Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28350 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbaEIKwS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 06:52:18 -0400
Date: Fri, 9 May 2014 18:52:07 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix hang on error (such as ENOSPC) when
 writing extent pages
Message-ID: <20140509105206.GB4250@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1399577231-6345-1-git-send-email-fdmanana@gmail.com>
 <1399603321-7699-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399603321-7699-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 03:42:01AM +0100, Filipe David Borba Manana wrote:
> When running low on available disk space and having several processes
> doing buffered file IO, I got the following trace in dmesg:
> 
> [ 4202.720152] INFO: task kworker/u8:1:5450 blocked for more than 120 seconds.
> [ 4202.720401]       Not tainted 3.13.0-fdm-btrfs-next-26+ #1
> [ 4202.720596] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 4202.720874] kworker/u8:1    D 0000000000000001     0  5450      2 0x00000000
> [ 4202.720904] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
> [ 4202.720908]  ffff8801f62ddc38 0000000000000082 ffff880203ac2490 00000000001d3f40
> [ 4202.720913]  ffff8801f62ddfd8 00000000001d3f40 ffff8800c4f0c920 ffff880203ac2490
> [ 4202.720918]  00000000001d4a40 ffff88020fe85a40 ffff88020fe85ab8 0000000000000001
> [ 4202.720922] Call Trace:
> [ 4202.720931]  [<ffffffff816a3cb9>] schedule+0x29/0x70
> [ 4202.720950]  [<ffffffffa01ec48d>] btrfs_start_ordered_extent+0x6d/0x110 [btrfs]
> [ 4202.720956]  [<ffffffff8108e620>] ? bit_waitqueue+0xc0/0xc0
> [ 4202.720972]  [<ffffffffa01ec559>] btrfs_run_ordered_extent_work+0x29/0x40 [btrfs]
> [ 4202.720988]  [<ffffffffa0201987>] normal_work_helper+0x137/0x2c0 [btrfs]
> [ 4202.720994]  [<ffffffff810680e5>] process_one_work+0x1f5/0x530
> (...)
> [ 4202.721027] 2 locks held by kworker/u8:1/5450:
> [ 4202.721028]  #0:  (%s-%s){++++..}, at: [<ffffffff81068083>] process_one_work+0x193/0x530
> [ 4202.721037]  #1:  ((&work->normal_work)){+.+...}, at: [<ffffffff81068083>] process_one_work+0x193/0x530
> [ 4202.721054] INFO: task btrfs:7891 blocked for more than 120 seconds.
> [ 4202.721258]       Not tainted 3.13.0-fdm-btrfs-next-26+ #1
> [ 4202.721444] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 4202.721699] btrfs           D 0000000000000001     0  7891   7890 0x00000001
> [ 4202.721704]  ffff88018c2119e8 0000000000000086 ffff8800a33d2490 00000000001d3f40
> [ 4202.721710]  ffff88018c211fd8 00000000001d3f40 ffff8802144b0000 ffff8800a33d2490
> [ 4202.721714]  ffff8800d8576640 ffff88020fe85bc0 ffff88020fe85bc8 7fffffffffffffff
> [ 4202.721718] Call Trace:
> [ 4202.721723]  [<ffffffff816a3cb9>] schedule+0x29/0x70
> [ 4202.721727]  [<ffffffff816a2ebc>] schedule_timeout+0x1dc/0x270
> [ 4202.721732]  [<ffffffff8109bd79>] ? mark_held_locks+0xb9/0x140
> [ 4202.721736]  [<ffffffff816a90c0>] ? _raw_spin_unlock_irq+0x30/0x40
> [ 4202.721740]  [<ffffffff8109bf0d>] ? trace_hardirqs_on_caller+0x10d/0x1d0
> [ 4202.721744]  [<ffffffff816a488f>] wait_for_completion+0xdf/0x120
> [ 4202.721749]  [<ffffffff8107fa90>] ? try_to_wake_up+0x310/0x310
> [ 4202.721765]  [<ffffffffa01ebee4>] btrfs_wait_ordered_extents+0x1f4/0x280 [btrfs]
> [ 4202.721781]  [<ffffffffa020526e>] btrfs_mksubvol.isra.62+0x30e/0x5a0 [btrfs]
> [ 4202.721786]  [<ffffffff8108e620>] ? bit_waitqueue+0xc0/0xc0
> [ 4202.721799]  [<ffffffffa02056a9>] btrfs_ioctl_snap_create_transid+0x1a9/0x1b0 [btrfs]
> [ 4202.721813]  [<ffffffffa020583a>] btrfs_ioctl_snap_create_v2+0x10a/0x170 [btrfs]
> (...)
> 
> It turns out that extent_io.c:__extent_writepage(), which ends up being called
> through filemap_fdatawrite_range() in btrfs_start_ordered_extent(), was getting
> -ENOSPC when calling the fill_delalloc callback. In this situation, it returned
> without the writepage_end_io_hook callback (inode.c:btrfs_writepage_end_io_hook)
> ever being called for the respective page, which prevents the ordered extent's
> bytes_left count from ever reaching 0, and therefore a finish_ordered_fn work
> is never queued into the endio_write_workers queue. This makes the task that
> called btrfs_start_ordered_extent() hang forever on the wait queue of the ordered
> extent.

Nice fix, I've comfirmed the hang on my box, but things could be more complex,
more below,

> 
> This is fairly easy to reproduce using a small filesystem and fsstress on
> a quad core vm:
> 
>     mkfs.btrfs -f -b `expr 2100 \* 1024 \* 1024` /dev/sdd
>     mount /dev/sdd /mnt
> 
>     fsstress -p 6 -d /mnt -n 100000 -x \
>         "btrfs subvolume snapshot -r /mnt /mnt/mysnap" \
> 	    -f allocsp=0 \
> 	    -f bulkstat=0 \
> 	    -f bulkstat1=0 \
> 	    -f chown=0 \
> 	    -f creat=1 \
> 	    -f dread=0 \
> 	    -f dwrite=0 \
> 	    -f fallocate=1 \
> 	    -f fdatasync=0 \
> 	    -f fiemap=0 \
> 	    -f freesp=0 \
> 	    -f fsync=0 \
> 	    -f getattr=0 \
> 	    -f getdents=0 \
> 	    -f link=0 \
> 	    -f mkdir=0 \
> 	    -f mknod=0 \
> 	    -f punch=1 \
> 	    -f read=0 \
> 	    -f readlink=0 \
> 	    -f rename=0 \
> 	    -f resvsp=0 \
> 	    -f rmdir=0 \
> 	    -f setxattr=0 \
> 	    -f stat=0 \
> 	    -f symlink=0 \
> 	    -f sync=0 \
> 	    -f truncate=1 \
> 	    -f unlink=0 \
> 	    -f unresvsp=0 \
> 	    -f write=4
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Grab error from `em` pointer if available, do the error check and
>     end_extent_writepage call before unlocking the page (just like
>     end_bio_extent_writepage does).
> 
>  fs/btrfs/extent_io.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0c43896..b0c73ad 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3284,6 +3284,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
>  				     end - cur + 1, 1);
>  		if (IS_ERR_OR_NULL(em)) {
>  			SetPageError(page);
> +			ret = PTR_ERR_OR_ZERO(em);
>  			break;
>  		}
>  
> @@ -3370,13 +3371,17 @@ done:
>  		set_page_writeback(page);
>  		end_page_writeback(page);
>  	}
> +	if (PageError(page)) {
> +		ret = ret < 0 ? ret : -EIO;
> +		end_extent_writepage(page, ret, start, page_end);
> +	}
>  	unlock_page(page);
>  
>  done_unlocked:
>  
>  	/* drop our reference on any cached states */
>  	free_extent_state(cached_state);
> -	return 0;
> +	return ret;

So 'return ret' can makes extent_write_cache_pages() stop after this
__extent_writepage, and if the page happens to be the last one of the current
pagevec of the for() loop that extent_write_cache_pages() is using, the rest
pages will never get be processed.

Try to image this, on lack of space, we'd get ENOSPC on btrfs_reserve_extent()
which is in cow_file_range() -- a normal choice for run_delalloc_range(), and
for page N, it's the locked_page we use in cow_file_range(), and the delalloc
range also involves other pages that are after page N.  Now we get ENOSPC on
allocating space for page N+2 rather the page N, which means page N and page N+1
have been on the ordered list, then as this patch does, we bail out and return
the -ENOSPC error to caller, now if the above situation occurs, page N+1 will not
be processed, then the page N+1 's ordered extent will not be finished either
since we don't submit that page at all. 

However, this is a rare case, I don't run into that(I guess that's because it
has low possibility that the page happens to be the last one of pagevec).

So my suggestion is, let this locked page go for the normal submit_bio path if
it has been set up properly for ordered write.  Those pages that don't get space
in cow_file_range() has been cleaned up through the error handling path, but
what's lacked here is that these pages are not marked via SetPageError, we might
need to add that in extent_clear_unlock_delalloc().

(but I could be wrong, so cc maintainers for ideas)

thanks,
-liubo

>  }
>  
>  static int eb_wait(void *word)
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
