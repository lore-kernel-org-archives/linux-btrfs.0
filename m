Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41534 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdBOUmu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 15:42:50 -0500
Date: Wed, 15 Feb 2017 12:41:52 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/29] btrfs: remove unused parameter from
 check_async_write
Message-ID: <20170215204152.GC11220@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <fd86bfb5b6f0b3191df78582a778ec7f58b2b386.1486977711.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fd86bfb5b6f0b3191df78582a778ec7f58b2b386.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:27AM +0100, David Sterba wrote:
> Added but never used.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 18004169552c..89cd597883fd 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1005,7 +1005,7 @@ static int __btree_submit_bio_done(struct inode *inode, struct bio *bio,
>  	return ret;
>  }
>  
> -static int check_async_write(struct inode *inode, unsigned long bio_flags)
> +static int check_async_write(unsigned long bio_flags)
>  {
>  	if (bio_flags & EXTENT_BIO_TREE_LOG)
>  		return 0;
> @@ -1021,7 +1021,7 @@ static int btree_submit_bio_hook(struct inode *inode, struct bio *bio,
>  				 u64 bio_offset)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> -	int async = check_async_write(inode, bio_flags);
> +	int async = check_async_write(bio_flags);
>  	int ret;
>  
>  	if (bio_op(bio) != REQ_OP_WRITE) {
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
