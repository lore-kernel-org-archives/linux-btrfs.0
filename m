Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34223 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755231AbdKBIeB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 04:34:01 -0400
Subject: Re: [PATCH v2] Btrfs: add support for fallocate's zero range
 operation
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20171025125344.2111-1-fdmanana@kernel.org>
 <20171025145908.7311-1-fdmanana@kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fcf6ffd1-1126-c7a2-23a5-2e2160d12777@suse.com>
Date: Thu, 2 Nov 2017 10:33:59 +0200
MIME-Version: 1.0
In-Reply-To: <20171025145908.7311-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.10.2017 17:59, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This implements support the zero range operation of fallocate. For now
> at least it's as simple as possible while reusing most of the existing
> fallocate and hole punching infrastructure.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Removed double inode unlock on error path from failure to lock range.
> 
>  fs/btrfs/file.c | 332 +++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 290 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index aafcc785f840..e0d15c0d1641 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2448,7 +2448,48 @@ static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
>  	return ret;
>  }
>  

<snip>

>  
> +static int btrfs_zero_range_update_isize(struct inode *inode,
> +					 const loff_t offset,
> +					 const loff_t len,
> +					 const int mode)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_trans_handle *trans;
> +	const u64 end = offset + len;
> +	int ret;
> +
> +	if (mode & FALLOC_FL_KEEP_SIZE || end <= i_size_read(inode))
> +		return 0;
> +

Don't we also want to add inode->i_ctime = current_time(inode) similar
to what we have when updating the isize at the end of btrfs_fallocate
and __btrfs_prealloc_file_range


Also this function is very similarto the code right before the
'out_unlock' label in btrfs_fallocate. Perhaps this function could be
named btrfs_update_isize and used there as well?

<snip>
