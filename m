Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34318 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2F1Me0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jun 2012 08:34:26 -0400
Date: Thu, 28 Jun 2012 08:34:23 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix dio write vs buffered read race V2
Message-ID: <20120628123422.GB1729@localhost.localdomain>
References: <1340718176-4999-1-git-send-email-jbacik@fusionio.com>
 <4FEBD0EC.6070802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FEBD0EC.6070802@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 09:35:08PM -0600, Miao Xie wrote:
> On Tue, 26 Jun 2012 09:42:56 -0400, Josef Bacik wrote:
> > From: Josef Bacik <josef@redhat.com>
> > 
> > Miao pointed out there's a problem with mixing dio writes and buffered
> > reads.  If the read happens between us invalidating the page range and
> > actually locking the extent we can bring in pages into page cache.  Then
> > once the write finishes if somebody tries to read again it will just find
> > uptodate pages and we'll read stale data.  So we need to lock the extent and
> > check for uptodate bits in the range.  If there are uptodate bits we need to
> > unlock and invalidate again.  This will keep this race from happening since
> > we will hold the extent locked until we create the ordered extent, and then
> > teh read side always waits for ordered extents.  Thanks,
> 
> This patch still can not work well. It is because we don't update i_size in time.
> 	Writer		Worker		Reader
> 	lock_extent
> 	do direct io
> 	end io
> 			finish io
> 			unlock_extent
> 					lock_extent
> 					check the pos is beyond EOF or not
> 					  beyond EOF, zero the page and set it uptodate
> 					unlock_extent
> 	update i_size
> 
> So I think we must update the i_size in time, and I wrote a small patch to do it:
> 

We should probably be updating i_size when we create an extent past EOF in the
write stuff, not during endio, I will work this out and fold it into my patch.
Good catch.

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 77d4ae8..7f05f77 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5992,6 +5992,7 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
>  	struct btrfs_ordered_extent *ordered = NULL;
>  	u64 ordered_offset = dip->logical_offset;
>  	u64 ordered_bytes = dip->bytes;
> +	u64 i_size;
>  	int ret;
>  
>  	if (err)
> @@ -6003,6 +6004,11 @@ again:
>  	if (!ret)
>  		goto out_test;
>  
> +	/* We don't worry the file truncation because we hold i_mutex now. */
> +	i_size = ordered->file_offset + ordered->len;
> +	if (i_size > i_size_read(inode))
> +		i_size_write(inode, ordered->file_offset + ordered->len);
> +
>  	ordered->work.func = finish_ordered_fn;
>  	ordered->work.flags = 0;
>  	btrfs_queue_worker(&root->fs_info->endio_write_workers,
> 
> ----
> After applying your patch(the second version) and this patch, all my test passed. 
> 
> But I still think updating the pages is a good way to fix this problem, because it needn't
> invalidate the page again and again, and doesn't waste lots of time. Beside that there is no
> rule to say the direct io should not touch the page, so I think since we can not invalidate the pages at once just update them. And the race problem between aio and dio can be fixed completely.
> 

Except that your way makes us unconditionally search through pagecache for every
DIO write, where as my patch only causes multiple invalidations if somebody is
mixing buffered reads with direct writes, and if they are doing that they
deserve to be punished ;).  Thanks,

Josef
