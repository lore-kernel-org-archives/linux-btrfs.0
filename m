Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbcFATho (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 15:37:44 -0400
Date: Wed, 1 Jun 2016 12:37:41 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v10 03/21] btrfs: dedupe: Introduce function to add hash
 into in-memory tree
Message-ID: <20160601193741.GF7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459492512-31435-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:34:54PM +0800, Qu Wenruo wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Introduce static function inmem_add() to add hash into in-memory tree.
> And now we can implement the btrfs_dedupe_add() interface.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 151 insertions(+)
> 
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index 2211588..4e8455e 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -32,6 +32,14 @@ struct inmem_hash {
>  	u8 hash[];
>  };
>  
> +static inline struct inmem_hash *inmem_alloc_hash(u16 type)
> +{
> +	if (WARN_ON(type >= ARRAY_SIZE(btrfs_dedupe_sizes)))
> +		return NULL;
> +	return kzalloc(sizeof(struct inmem_hash) + btrfs_dedupe_sizes[type],
> +			GFP_NOFS);
> +}
> +
>  static int init_dedupe_info(struct btrfs_dedupe_info **ret_info, u16 type,
>  			    u16 backend, u64 blocksize, u64 limit)
>  {
> @@ -152,3 +160,146 @@ enable:
>  	fs_info->dedupe_enabled = 1;
>  	return ret;
>  }
> +
> +static int inmem_insert_hash(struct rb_root *root,
> +			     struct inmem_hash *hash, int hash_len)
> +{
> +	struct rb_node **p = &root->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct inmem_hash *entry = NULL;
> +
> +	while (*p) {
> +		parent = *p;
> +		entry = rb_entry(parent, struct inmem_hash, hash_node);
> +		if (memcmp(hash->hash, entry->hash, hash_len) < 0)
> +			p = &(*p)->rb_left;
> +		else if (memcmp(hash->hash, entry->hash, hash_len) > 0)
> +			p = &(*p)->rb_right;
> +		else
> +			return 1;
> +	}
> +	rb_link_node(&hash->hash_node, parent, p);
> +	rb_insert_color(&hash->hash_node, root);
> +	return 0;
> +}
> +
> +static int inmem_insert_bytenr(struct rb_root *root,
> +			       struct inmem_hash *hash)
> +{
> +	struct rb_node **p = &root->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct inmem_hash *entry = NULL;
> +
> +	while (*p) {
> +		parent = *p;
> +		entry = rb_entry(parent, struct inmem_hash, bytenr_node);
> +		if (hash->bytenr < entry->bytenr)
> +			p = &(*p)->rb_left;
> +		else if (hash->bytenr > entry->bytenr)
> +			p = &(*p)->rb_right;
> +		else
> +			return 1;
> +	}
> +	rb_link_node(&hash->bytenr_node, parent, p);
> +	rb_insert_color(&hash->bytenr_node, root);
> +	return 0;
> +}
> +
> +static void __inmem_del(struct btrfs_dedupe_info *dedupe_info,
> +			struct inmem_hash *hash)
> +{
> +	list_del(&hash->lru_list);
> +	rb_erase(&hash->hash_node, &dedupe_info->hash_root);
> +	rb_erase(&hash->bytenr_node, &dedupe_info->bytenr_root);
> +
> +	if (!WARN_ON(dedupe_info->current_nr == 0))
> +		dedupe_info->current_nr--;
> +
> +	kfree(hash);
> +}
> +
> +/*
> + * Insert a hash into in-memory dedupe tree
> + * Will remove exceeding last recent use hash.
> + *
> + * If the hash mathced with existing one, we won't insert it, to
> + * save memory
> + */
> +static int inmem_add(struct btrfs_dedupe_info *dedupe_info,
> +		     struct btrfs_dedupe_hash *hash)
> +{
> +	int ret = 0;
> +	u16 type = dedupe_info->hash_type;
> +	struct inmem_hash *ihash;
> +
> +	ihash = inmem_alloc_hash(type);
> +
> +	if (!ihash)
> +		return -ENOMEM;
> +
> +	/* Copy the data out */
> +	ihash->bytenr = hash->bytenr;
> +	ihash->num_bytes = hash->num_bytes;
> +	memcpy(ihash->hash, hash->hash, btrfs_dedupe_sizes[type]);
> +
> +	mutex_lock(&dedupe_info->lock);

Can you describe somewhere in a comment why we need this mutex? It is
unclear just based on reading the code why we need a sleeping lock here.
	--Mark

--
Mark Fasheh
