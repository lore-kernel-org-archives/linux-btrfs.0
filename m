Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbeGTHAu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 03:00:50 -0400
Subject: Re: [PATCH] btrfs: fix bug of chunk type check
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1532063858-32620-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <08fc876b-f9d7-dc11-5126-e35976402caf@suse.com>
Date: Fri, 20 Jul 2018 09:14:10 +0300
MIME-Version: 1.0
In-Reply-To: <1532063858-32620-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.07.2018 08:17, Gu Jinxiang wrote:
> chunk type BTRFS_BLOCK_GROUP_METADATA and BTRFS_BLOCK_GROUP_DATA
> should not be set in a non-mixed chunk at the same time.
> 
> Since BTRFS_BLOCK_GROUP_METADATA is 0x4 and BTRFS_BLOCK_GROUP_DATA is 0x1,
> BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA will be 0x0,
> so we should judge type is one of them separately.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/volumes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3f2f01ad9356..c7d009e45472 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6384,8 +6384,8 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
>  		mixed = 1;
>  
>  	if (!mixed) {
> -		if (type &
> -		    (BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
> +		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
> +			(type & BTRFS_BLOCK_GROUP_DATA)) {
>  			btrfs_err(fs_info,
>  			"mixed chunk type in non-mixed mode: %llu", type);
>  			return -EIO;
> 
