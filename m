Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:21633 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbeFYFA2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 01:00:28 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 8AAAFAC0263
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 14:00:22 +0900 (JST)
Subject: Re: [PATCH] btrfs: Use iocb to derive pos instead of passing a
 separate parameter
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20180617173947.818-1-rgoldwyn@suse.de>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <5678d4d9-cc58-e07f-9592-07caa4deb59b@jp.fujitsu.com>
Date: Mon, 25 Jun 2018 13:58:58 +0900
MIME-Version: 1.0
In-Reply-To: <20180617173947.818-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, this is the updated version of https://patchwork.kernel.org/patch/10063039/

This time xfstest is ok and
 Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

On 2018/06/18 2:39, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> struct kiocb carries the ki_pos, so there is no need to pass it as
> a separate function parameter.
> 
> generic_file_direct_write() increments ki_pos, so we now assign pos
> after the function.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/file.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f660ba1e5e58..f84100a60cec 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1569,10 +1569,11 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
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
> @@ -1804,7 +1805,7 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file_inode(file);
> -	loff_t pos = iocb->ki_pos;
> +	loff_t pos;
>  	ssize_t written;
>  	ssize_t written_buffered;
>  	loff_t endbyte;
> @@ -1815,8 +1816,8 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	if (written < 0 || !iov_iter_count(from))
>  		return written;
>  
> -	pos += written;
> -	written_buffered = __btrfs_buffered_write(file, from, pos);
> +	pos = iocb->ki_pos;
> +	written_buffered = __btrfs_buffered_write(iocb, from);
>  	if (written_buffered < 0) {
>  		err = written_buffered;
>  		goto out;
> @@ -1953,7 +1954,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	if (iocb->ki_flags & IOCB_DIRECT) {
>  		num_written = __btrfs_direct_write(iocb, from);
>  	} else {
> -		num_written = __btrfs_buffered_write(file, from, pos);
> +		num_written = __btrfs_buffered_write(iocb, from);
>  		if (num_written > 0)
>  			iocb->ki_pos = pos + num_written;
>  		if (clean_page)
> 

