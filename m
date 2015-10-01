Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58997 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbbJAPCM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 11:02:12 -0400
Subject: Re: [PATCH V5 11/13] Btrfs: Clean pte corresponding to page
 straddling i_size
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1443608912-31667-12-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <560D49F0.4040200@fb.com>
Date: Thu, 1 Oct 2015 10:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <1443608912-31667-12-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> When extending a file by either "truncate up" or by writing beyond i_size, the
> page which had i_size needs to be marked "read only" so that future writes to
> the page via mmap interface causes btrfs_page_mkwrite() to be invoked. If not,
> a write performed after extending the file via the mmap interface will find
> the page to be writaeable and continue writing to the page without invoking
> btrfs_page_mkwrite() i.e. we end up writing to a file without reserving disk
> space.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>   fs/btrfs/file.c  | 12 ++++++++++--
>   fs/btrfs/inode.c |  2 +-
>   2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 360d56d..5715e29 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1757,6 +1757,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>   	ssize_t err;
>   	loff_t pos;
>   	size_t count;
> +	loff_t oldsize;
> +	int clean_page = 0;
>
>   	mutex_lock(&inode->i_mutex);
>   	err = generic_write_checks(iocb, from);
> @@ -1795,14 +1797,17 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>   	pos = iocb->ki_pos;
>   	count = iov_iter_count(from);
>   	start_pos = round_down(pos, root->sectorsize);
> -	if (start_pos > i_size_read(inode)) {
> +	oldsize = i_size_read(inode);
> +	if (start_pos > oldsize) {
>   		/* Expand hole size to cover write data, preventing empty gap */
>   		end_pos = round_up(pos + count, root->sectorsize);
> -		err = btrfs_cont_expand(inode, i_size_read(inode), end_pos);
> +		err = btrfs_cont_expand(inode, oldsize, end_pos);
>   		if (err) {
>   			mutex_unlock(&inode->i_mutex);
>   			goto out;
>   		}
> +		if (start_pos > round_up(oldsize, root->sectorsize))
> +			clean_page = 1;
>   	}
>
>   	if (sync)
> @@ -1814,6 +1819,9 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>   		num_written = __btrfs_buffered_write(file, from, pos);
>   		if (num_written > 0)
>   			iocb->ki_pos = pos + num_written;
> +		if (clean_page)
> +			pagecache_isize_extended(inode, oldsize,
> +						i_size_read(inode));
>   	}
>
>   	mutex_unlock(&inode->i_mutex);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c937357..f31da87 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4853,7 +4853,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>   	}
>
>   	if (newsize > oldsize) {
> -		truncate_pagecache(inode, newsize);

So I don't understand why we are dropping this bit here, could you 
explain?  Otherwise the patch looks fine to me.  Thanks,

Josef
