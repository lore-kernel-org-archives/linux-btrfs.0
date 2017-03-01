Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29823 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751102AbdCAJeN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 04:34:13 -0500
Subject: Re: [PATCH 2/2] Btrfs: remove start_pos
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
 <1488330280-22678-2-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <48a869a9-86fc-188f-58bf-8132138f94a2@cn.fujitsu.com>
Date: Wed, 1 Mar 2017 16:48:20 +0800
MIME-Version: 1.0
In-Reply-To: <1488330280-22678-2-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/01/2017 09:04 AM, Liu Bo wrote:
> @pos, not aligned @start_pos, should be used to check whether the eof page
> needs to be marked as readonly, thus @start_pos can be removed.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/file.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 0be837b..ef88e6d 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1814,7 +1814,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	struct inode *inode = file_inode(file);
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	u64 start_pos;
>  	u64 end_pos;
>  	ssize_t num_written = 0;
>  	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
> @@ -1822,7 +1821,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	loff_t pos;
>  	size_t count;
>  	loff_t oldsize;
> -	int clean_page = 0;
>
>  	inode_lock(inode);
>  	err = generic_write_checks(iocb, from);
> @@ -1860,7 +1858,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>
>  	pos = iocb->ki_pos;
>  	count = iov_iter_count(from);
> -	start_pos = round_down(pos, fs_info->sectorsize);
>  	end_pos = round_up(pos + count, fs_info->sectorsize);
>  	oldsize = i_size_read(inode);
>  	if (end_pos > oldsize) {
> @@ -1870,8 +1867,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  			inode_unlock(inode);
>  			goto out;
>  		}
> -		if (start_pos > round_up(oldsize, fs_info->sectorsize))
> -			clean_page = 1;
>  	}
>
>  	if (sync)
> @@ -1883,7 +1878,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  		num_written = __btrfs_buffered_write(file, from, pos);
>  		if (num_written > 0)
>  			iocb->ki_pos = pos + num_written;
> -		if (clean_page)
> +		if (oldsize < pos)
>  			pagecache_isize_extended(inode, oldsize,
>  						i_size_read(inode));

Not familiar with page cache, so I can be totally wrong here.

But what will happen if @oldsize and @pos are in the same page?

For example:
Page start                                    Page start + 4K
|             |                |              |
               old size         pos

Do we still need to call pagecache_iszie_extented() since we will dirty 
that page anyway?

Thanks,
Qu
>  	}
>


