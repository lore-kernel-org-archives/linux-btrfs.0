Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbbBYMy4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 07:54:56 -0500
Date: Wed, 25 Feb 2015 13:54:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: add WARN_ON() to check is space_info op
 current
Message-ID: <20150225125454.GZ8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1424832762-24926-1-git-send-email-zhaolei@cn.fujitsu.com>
 <1424832767-25076-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424832767-25076-1-git-send-email-zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 25, 2015 at 10:52:47AM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> space_info's value calculation is some complex and easy to cause
> bug, add WARN_ON() to help debug.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3e7a4af..8b51eb5 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9471,9 +9471,17 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  
>  	spin_lock(&block_group->space_info->lock);
>  	list_del_init(&block_group->ro_list);
> +
> +	WARN_ON(block_group->space_info->total_bytes
> +		< block_group->key.offset);
> +	WARN_ON(block_group->space_info->bytes_readonly
> +		< block_group->key.offset);
> +	WARN_ON(block_group->space_info->disk_total
> +		< block_group->key.offset * factor);

Please put them under the ENOSPC_DEBUG mount option.

>  	block_group->space_info->total_bytes -= block_group->key.offset;
>  	block_group->space_info->bytes_readonly -= block_group->key.offset;
>  	block_group->space_info->disk_total -= block_group->key.offset * factor;
> +
>  	spin_unlock(&block_group->space_info->lock);
>  
>  	memcpy(&key, &block_group->key, sizeof(key));
> -- 
> 1.8.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
