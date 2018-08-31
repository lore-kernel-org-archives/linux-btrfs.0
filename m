Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727178AbeHaLph (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:45:37 -0400
Subject: Re: [PATCH 26/35] btrfs: make btrfs_destroy_delayed_refs use
 btrfs_delete_ref_head
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-27-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d7e1bd24-a8f4-2f57-05fb-7c6bff1db337@suse.com>
Date: Fri, 31 Aug 2018 10:39:26 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-27-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> Instead of open coding this stuff use the helper instead.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c72ab2ca7627..1d3f5731d616 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4232,12 +4232,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  		if (head->must_insert_reserved)
>  			pin_bytes = true;
>  		btrfs_free_delayed_extent_op(head->extent_op);
> -		delayed_refs->num_heads--;
> -		if (head->processing == 0)
> -			delayed_refs->num_heads_ready--;
> -		atomic_dec(&delayed_refs->num_entries);
> -		rb_erase(&head->href_node, &delayed_refs->href_root);
> -		RB_CLEAR_NODE(&head->href_node);
> +		btrfs_delete_ref_head(delayed_refs, head);
>  		spin_unlock(&head->lock);
>  		spin_unlock(&delayed_refs->lock);
>  		mutex_unlock(&head->mutex);
> 
