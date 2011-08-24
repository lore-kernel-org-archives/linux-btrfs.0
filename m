From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] Btrfs: fix the file extent gap when doing direct
 IO
Date: Wed, 24 Aug 2011 13:14:32 +0800
Message-ID: <4E5488B8.40602@cn.fujitsu.com>
References: <4E4CC9AA.6040402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4CC9AA.6040402@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 010aec8..a9c4636 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1073,12 +1073,6 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
>  	start_pos = pos & ~((u64)root->sectorsize - 1);
>  	last_pos = ((u64)index + num_pages) << PAGE_CACHE_SHIFT;
>  
> -	if (start_pos > inode->i_size) {
> -		err = btrfs_cont_expand(inode, i_size_read(inode), start_pos);
> -		if (err)
> -			return err;
> -	}
> -
>  again:
>  	for (i = 0; i < num_pages; i++) {
>  		pages[i] = find_or_create_page(inode->i_mapping, index + i,
> @@ -1336,6 +1330,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
>  	struct inode *inode = fdentry(file)->d_inode;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	loff_t *ppos = &iocb->ki_pos;
> +	u64 start_pos;
>  	ssize_t num_written = 0;
>  	ssize_t err = 0;
>  	size_t count, ocount;
> @@ -1384,6 +1379,15 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
>  	file_update_time(file);
>  	BTRFS_I(inode)->sequence++;
>  
> +	start_pos = round_down(pos, root->sectorsize);
> +	if (start_pos > i_size_read(inode)) {

You changed the code to use i_size_read() instead of inode->i_size, which
is not necessary since we're holding i_mutex.

> +		err = btrfs_cont_expand(inode, i_size_read(inode), start_pos);

So here we can also use inode->i_size directly.

> +		if (err) {
> +			mutex_unlock(&inode->i_mutex);
> +			goto out;
> +		}
> +	}
> +
>  	if (unlikely(file->f_flags & O_DIRECT)) {
>  		num_written = __btrfs_direct_write(iocb, iov, nr_segs,
>  						   pos, ppos, count, ocount);
