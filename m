Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45243 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965453AbeFZOAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 10:00:49 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3B08AC43
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 14:00:47 +0000 (UTC)
Subject: Re: [PATCH] btrfs: remove warnings superseded by refcount_t usage
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20180625163822.25681-1-dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fae25e89-52c5-25ea-65ad-7405fedb0a68@suse.com>
Date: Tue, 26 Jun 2018 17:00:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180625163822.25681-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.06.2018 19:38, David Sterba wrote:
> There are several WARN_ON calls that catch incrorrect reference counter
> updates, but this is what the refcount_t does already:
> 
> * refcount_inc from 0 will warn
> * refcount_dec_and_test from 0 will warn
> 

But these warnings are only going to be triggered in the case of
CONFIG_REFCOUNT_FULL otherwise refcount falls back to plain atomic
operations.

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/delayed-ref.h | 1 -
>  fs/btrfs/extent_map.c  | 2 +-
>  fs/btrfs/transaction.c | 1 -
>  fs/btrfs/volumes.c     | 1 -
>  4 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index ea1aecb6a50d..16ee92c541bf 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -210,7 +210,6 @@ btrfs_free_delayed_extent_op(struct btrfs_delayed_extent_op *op)
>  
>  static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
>  {
> -	WARN_ON(refcount_read(&ref->refs) == 0);
>  	if (refcount_dec_and_test(&ref->refs)) {
>  		WARN_ON(ref->in_tree);
>  		switch (ref->type) {
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 6648d55e5339..6808ad4ed3c9 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -72,7 +72,7 @@ void free_extent_map(struct extent_map *em)
>  {
>  	if (!em)
>  		return;
> -	WARN_ON(refcount_read(&em->refs) == 0);
> +
>  	if (refcount_dec_and_test(&em->refs)) {
>  		WARN_ON(extent_map_in_tree(em));
>  		WARN_ON(!list_empty(&em->list));
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4485eae41e88..f6b68099b767 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -41,7 +41,6 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
>  
>  void btrfs_put_transaction(struct btrfs_transaction *transaction)
>  {
> -	WARN_ON(refcount_read(&transaction->use_count) == 0);
>  	if (refcount_dec_and_test(&transaction->use_count)) {
>  		BUG_ON(!list_empty(&transaction->list));
>  		WARN_ON(!RB_EMPTY_ROOT(&transaction->delayed_refs.href_root));
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..f64d26b4f278 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5330,7 +5330,6 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
>  
>  void btrfs_get_bbio(struct btrfs_bio *bbio)
>  {
> -	WARN_ON(!refcount_read(&bbio->refs));
>  	refcount_inc(&bbio->refs);
>  }
>  
> 
