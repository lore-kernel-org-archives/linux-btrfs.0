Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:34720 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbeEVR2p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 13:28:45 -0400
Received: by mail-pl0-f66.google.com with SMTP id ay10-v6so11316833plb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 10:28:45 -0700 (PDT)
Date: Tue, 22 May 2018 10:28:43 -0700
From: Omar Sandoval <osandov@osandov.com>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
Message-ID: <20180522172843.GA9536@vader>
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1526442757-7167-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 11:52:37AM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> This idea is from direct io. By this patch, we can make the buffered
> write parallel, and improve the performance and latency. But because we
> can not update isize without i_mutex, the unlocked buffered write just
> can be done in front of the EOF.
> 
> We needn't worry about the race between buffered write and truncate,
> because the truncate need wait until all the buffered write end.

I'm not convinced that this race isn't an issue. Consider this:

__btrfs_buffered_write()	btrfs_setsize()
inode_dio_begin()
inode_unlock()
				inode_lock()
				truncate_setsize() /* Updates i_size */
				truncate_pagecache() /* Locks and unlocks pages */
				inode_dio_wait()
prepare_pages() /* Locks pages */
btrfs_dirty_pages() /* Updates i_size without i_rwsem! */

I think moving inode_dio_wait() to before truncate_setsize() in
btrfs_setsize() would close this race, but I haven't thought about it
long enough to determine whether that still works for the original
reason the inode_dio_wait() was added.

> And we also needn't worry about the race between dio write and punch hole,
> because we have extent lock to protect our operation.
> 
> I ran fio to test the performance of this feature.
> 
> == Hardware ==
> CPU: Intel® Xeon® D-1531
> SSD: Intel S3710 200G
> Volume : RAID 5 , SSD * 6
> 
> == config file ==
> [global]
> group_reporting
> time_based
> thread=1
> norandommap
> ioengine=libaio
> bs=4k
> iodepth=32
> size=16G
> runtime=180
> numjobs=8
> rw=randwrite
> 
> [file1]
> filename=/mnt/btrfs/nocow/testfile
> 
> == result (iops) ==
> lock     = 68470
> unlocked = 94242
> 
> == result (clat) ==
> lock
>  lat (usec): min=184, max=1209.9K, avg=3738.35, stdev=20869.49
>  clat percentiles (usec):
>   |  1.00th=[  322],  5.00th=[  330], 10.00th=[  334], 20.00th=[  346],
>   | 30.00th=[  370], 40.00th=[  386], 50.00th=[  406], 60.00th=[  446],
>   | 70.00th=[  516], 80.00th=[  612], 90.00th=[  828], 95.00th=[10432],
>   | 99.00th=[84480], 99.50th=[117248], 99.90th=[226304], 99.95th=[333824],
>   | 99.99th=[692224]
> 
> unlocked
>  lat (usec): min=10, max=218208, avg=2691.44, stdev=5380.82
>  clat percentiles (usec):
>   |  1.00th=[  302],  5.00th=[  390], 10.00th=[  442], 20.00th=[  502],
>   | 30.00th=[  548], 40.00th=[  596], 50.00th=[  652], 60.00th=[  724],
>   | 70.00th=[  916], 80.00th=[ 5024], 90.00th=[ 5664], 95.00th=[10048],
>   | 99.00th=[29568], 99.50th=[39168], 99.90th=[54016], 99.95th=[59648],
>   | 99.99th=[78336]
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/file.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 41ab907..8eac540 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1600,6 +1600,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  	int ret = 0;
>  	bool only_release_metadata = false;
>  	bool force_page_uptodate = false;
> +	bool relock = false;
>  
>  	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>  			PAGE_SIZE / (sizeof(struct page *)));
> @@ -1609,6 +1610,18 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  	if (!pages)
>  		return -ENOMEM;
>  
> +	inode_dio_begin(inode);

This would need a comment as to why we're using inode_dio_begin() for
buffered I/O.

> +	/*
> +	 * If the write is beyond the EOF, we need update
> +	 * the isize, but it is protected by i_mutex. So we can
> +	 * not unlock the i_mutex at this case.
> +	 */
> +	if (pos + iov_iter_count(i) <= i_size_read(inode)) {
> +		inode_unlock(inode);
> +		relock = true;
> +	}
> +
>  	while (iov_iter_count(i) > 0) {
>  		size_t offset = pos & (PAGE_SIZE - 1);
>  		size_t sector_offset;
> @@ -1808,6 +1821,10 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  		}
>  	}
>  
> +	inode_dio_end(inode);
> +	if (relock)
> +		inode_lock(inode);
> +
>  	extent_changeset_free(data_reserved);
>  	return num_written ? num_written : ret;
>  }
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
