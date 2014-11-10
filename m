Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20181 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101AbaKJETV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Nov 2014 23:19:21 -0500
Message-ID: <54603D2A.1030800@cn.fujitsu.com>
Date: Mon, 10 Nov 2014 12:20:58 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix incorrect compression ratio detection
References: <1412721875-39569-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1412721875-39569-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 7 Oct 2014 18:44:35 -0400, Wang Shilong wrote:
> Steps to reproduce:
>  # mkfs.btrfs -f /dev/sdb
>  # mount -t btrfs /dev/sdb /mnt -o compress=lzo
>  # dd if=/dev/zero of=/mnt/data bs=$((33*4096)) count=1
> 
> after previous steps, inode will be detected as bad compression ratio,
> and NOCOMPRESS flag will be set for that inode.
> 
> Reason is that compress have a max limit pages every time(128K), if a
> 132k write in, it will be splitted into two write(128k+4k), this bug
> is a leftover for commit 68bb462d42a(Btrfs: don't compress for a small write)
> 
> Fix this problem by checking every time before compression, if it is a
> small write(<=blocksize), we bail out and fall into nocompression directly.
> 
> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>

Looks good.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/inode.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 344a322..b78e90a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -411,14 +411,6 @@ static noinline int compress_file_range(struct inode *inode,
>  	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
>  		btrfs_add_inode_defrag(NULL, inode);
>  
> -	/*
> -	 * skip compression for a small file range(<=blocksize) that
> -	 * isn't an inline extent, since it dosen't save disk space at all.
> -	 */
> -	if ((end - start + 1) <= blocksize &&
> -	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
> -		goto cleanup_and_bail_uncompressed;
> -
>  	actual_end = min_t(u64, isize, end + 1);
>  again:
>  	will_compress = 0;
> @@ -440,6 +432,14 @@ again:
>  
>  	total_compressed = actual_end - start;
>  
> +	/*
> +	 * skip compression for a small file range(<=blocksize) that
> +	 * isn't an inline extent, since it dosen't save disk space at all.
> +	 */
> +	if (total_compressed <= blocksize &&
> +	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
> +		goto cleanup_and_bail_uncompressed;
> +
>  	/* we want to make sure that amount of ram required to uncompress
>  	 * an extent is reasonable, so we limit the total size in ram
>  	 * of a compressed extent to 128k.  This is a crucial number
> 

