Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727191AbeHaLob (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:44:31 -0400
Subject: Re: [PATCH 25/35] btrfs: make btrfs_destroy_delayed_refs use
 btrfs_delayed_ref_lock
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-26-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <35134b66-a4ad-850c-7021-cc175518dc4b@suse.com>
Date: Fri, 31 Aug 2018 10:38:21 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-26-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We have this open coded in btrfs_destroy_delayed_refs, use the helper
> instead.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 11ea2ea7439e..c72ab2ca7627 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4214,16 +4214,9 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  
>  		head = rb_entry(node, struct btrfs_delayed_ref_head,
>  				href_node);
> -		if (!mutex_trylock(&head->mutex)) {
> -			refcount_inc(&head->refs);
> -			spin_unlock(&delayed_refs->lock);
> -
> -			mutex_lock(&head->mutex);
> -			mutex_unlock(&head->mutex);
> -			btrfs_put_delayed_ref_head(head);
> -			spin_lock(&delayed_refs->lock);
> +		if (btrfs_delayed_ref_lock(delayed_refs, head))
>  			continue;
> -		}
> +
>  		spin_lock(&head->lock);
>  		while ((n = rb_first(&head->ref_tree)) != NULL) {
>  			ref = rb_entry(n, struct btrfs_delayed_ref_node,
> 
