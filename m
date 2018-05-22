Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:10809 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeEVGl2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 02:41:28 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 20DCCAC018E
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:41:24 +0900 (JST)
Subject: Re: [RFC PATCH 1/8] btrfs: use iocb for __btrfs_buffered_write
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <linux-btrfs@vger.kernel.org>
CC: Goldwyn Rodrigues <rgoldwyn@suse.com>, David Sterba <dsterba@suse.com>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
 <20171117174456.13393-2-rgoldwyn@suse.de>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <f4cc3baa-2083-6e89-c11e-234076aa8270@jp.fujitsu.com>
Date: Tue, 22 May 2018 15:40:18 +0900
MIME-Version: 1.0
In-Reply-To: <20171117174456.13393-2-rgoldwyn@suse.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/11/18 2:44, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Preparatory patch. It reduces the arguments to __btrfs_buffered_write
> to follow buffered_write() style.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> ---
>  fs/btrfs/file.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index aafcc785f840..9bceb0e61361 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1572,10 +1572,11 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
>  	return ret;
>  }
>  
> -static noinline ssize_t __btrfs_buffered_write(struct file *file,
> -					       struct iov_iter *i,
> -					       loff_t pos)
> +static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
> +					       struct iov_iter *i)
>  {
> +	struct file *file = iocb->ki_filp;
> +	loff_t pos = iocb->ki_pos;
>  	struct inode *inode = file_inode(file);
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> @@ -1815,7 +1816,6 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file_inode(file);
> -	loff_t pos = iocb->ki_pos;
>  	ssize_t written;
>  	ssize_t written_buffered;
>  	loff_t endbyte;
> @@ -1826,8 +1826,8 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	if (written < 0 || !iov_iter_count(from))
>  		return written;
>  
> -	pos += written;
> -	written_buffered = __btrfs_buffered_write(file, from, pos);

> +	iocb->ki_pos += written;

Hi,

I found btrfs/026 fails on current misc-next branch and
git bisect points this commit.

I noticed generic_file_direct_write() already updates iocb->ki_pos, and therefore
above "iocb->ki_pos += written" is not needed.

> +	written_buffered = __btrfs_buffered_write(iocb, from);
>  	if (written_buffered < 0) {
>  		err = written_buffered;
>  		goto out;
> @@ -1836,16 +1836,16 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	 * Ensure all data is persisted. We want the next direct IO read to be
>  	 * able to read what was just written.
>  	 */
> -	endbyte = pos + written_buffered - 1;
> -	err = btrfs_fdatawrite_range(inode, pos, endbyte);
> +	endbyte = iocb->ki_pos + written_buffered - 1;
> +	err = btrfs_fdatawrite_range(inode, iocb->ki_pos, endbyte);
>  	if (err)
>  		goto out;
> -	err = filemap_fdatawait_range(inode->i_mapping, pos, endbyte);
> +	err = filemap_fdatawait_range(inode->i_mapping, iocb->ki_pos, endbyte);
>  	if (err)
>  		goto out;
> +	iocb->ki_pos += written_buffered;
>  	written += written_buffered;
> -	iocb->ki_pos = pos + written_buffered;
> -	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
> +	invalidate_mapping_pages(file->f_mapping, iocb->ki_pos >> PAGE_SHIFT,
>  				 endbyte >> PAGE_SHIFT);

Also, this invalidate_mapping_pages() should be done before updating iocb->ki_pos
to invalidate buffered written area.

Thanks,
Tomohiro Misono

>  out:
>  	return written ? written : err;
> @@ -1964,7 +1964,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	if (iocb->ki_flags & IOCB_DIRECT) {
>  		num_written = __btrfs_direct_write(iocb, from);
>  	} else {
> -		num_written = __btrfs_buffered_write(file, from, pos);
> +		num_written = __btrfs_buffered_write(iocb, from);
>  		if (num_written > 0)
>  			iocb->ki_pos = pos + num_written;
>  		if (clean_page)
> 

