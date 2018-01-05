Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752393AbeAEQq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 11:46:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93589ACA7
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Jan 2018 16:46:55 +0000 (UTC)
Date: Fri, 5 Jan 2018 17:44:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle failure of add_pending_csums
Message-ID: <20180105164449.GQ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512474703-30066-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512474703-30066-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 01:51:43PM +0200, Nikolay Borisov wrote:
> add_pending_csums was added as part of the new data=ordered implementation in
> e6dcd2dc9c48 ("Btrfs: New data=ordered implementation"). Even back then it
> called the btrfs_csum_file_blocks which can fail but it never bothered handling
> the failure. In ENOMEM situation this could lead to the filesystem failing to
> write the checksums for a particular extent and not detect this. On read this
> could lead to the filesystem erroring out due to crc mismatch. Fix it by
> propagating failure from add_pending_csums and handling them
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e87ec11c0986..432bffdbb02f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2039,11 +2039,14 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
>  			     struct inode *inode, struct list_head *list)
>  {
>  	struct btrfs_ordered_sum *sum;
> +	int ret;
>  
>  	list_for_each_entry(sum, list, list) {
>  		trans->adding_csums = true;
> -		btrfs_csum_file_blocks(trans,
> +		ret = btrfs_csum_file_blocks(trans,
>  		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
> +		if (ret)
> +			return ret;

The return should come after the line below, otherwise the transaction
will be left in the "adding csums".

>  		trans->adding_csums = false;

...
>  	}
>  	return 0;
> @@ -3051,7 +3054,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>  		goto out;
>  	}
>  
> -	add_pending_csums(trans, inode, &ordered_extent->list);
> +	ret = add_pending_csums(trans, inode, &ordered_extent->list);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);

Ok, we can't do better here, this is too late and
add_pending_csums -> btrfs_csum_file_blocks modifies too much of the
state to be rolled back safely.
