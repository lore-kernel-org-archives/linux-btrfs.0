Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbcFATka (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 15:40:30 -0400
Date: Wed, 1 Jun 2016 12:40:28 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v10 04/21] btrfs: dedupe: Introduce function to remove
 hash from in-memory tree
Message-ID: <20160601194028.GG7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-5-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459492512-31435-5-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:34:55PM +0800, Qu Wenruo wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Introduce static function inmem_del() to remove hash from in-memory
> dedupe tree.
> And implement btrfs_dedupe_del() and btrfs_dedup_destroy() interfaces.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 105 insertions(+)
> 
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index 4e8455e..a229ded 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -303,3 +303,108 @@ int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
>  		return inmem_add(dedupe_info, hash);
>  	return -EINVAL;
>  }
> +
> +static struct inmem_hash *
> +inmem_search_bytenr(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
> +{
> +	struct rb_node **p = &dedupe_info->bytenr_root.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct inmem_hash *entry = NULL;
> +
> +	while (*p) {
> +		parent = *p;
> +		entry = rb_entry(parent, struct inmem_hash, bytenr_node);
> +
> +		if (bytenr < entry->bytenr)
> +			p = &(*p)->rb_left;
> +		else if (bytenr > entry->bytenr)
> +			p = &(*p)->rb_right;
> +		else
> +			return entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Delete a hash from in-memory dedupe tree */
> +static int inmem_del(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
> +{
> +	struct inmem_hash *hash;
> +
> +	mutex_lock(&dedupe_info->lock);
> +	hash = inmem_search_bytenr(dedupe_info, bytenr);
> +	if (!hash) {
> +		mutex_unlock(&dedupe_info->lock);
> +		return 0;
> +	}
> +
> +	__inmem_del(dedupe_info, hash);
> +	mutex_unlock(&dedupe_info->lock);
> +	return 0;
> +}
> +
> +/* Remove a dedupe hash from dedupe tree */
> +int btrfs_dedupe_del(struct btrfs_trans_handle *trans,
> +		     struct btrfs_fs_info *fs_info, u64 bytenr)
> +{
> +	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
> +
> +	if (!fs_info->dedupe_enabled)
> +		return 0;
> +
> +	if (WARN_ON(dedupe_info == NULL))
> +		return -EINVAL;
> +
> +	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
> +		return inmem_del(dedupe_info, bytenr);
> +	return -EINVAL;
> +}
> +
> +static void inmem_destroy(struct btrfs_dedupe_info *dedupe_info)
> +{
> +	struct inmem_hash *entry, *tmp;
> +
> +	mutex_lock(&dedupe_info->lock);
> +	list_for_each_entry_safe(entry, tmp, &dedupe_info->lru_list, lru_list)
> +		__inmem_del(dedupe_info, entry);
> +	mutex_unlock(&dedupe_info->lock);
> +}
> +
> +int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_dedupe_info *dedupe_info;
> +	int ret;
> +
> +	/* Here we don't want to increase refs of dedupe_info */
> +	fs_info->dedupe_enabled = 0;

Can this clear of fs_info->dedupe_enabled race with another thread in write?
I don't see any locking (but perhaps that comes in a later patch).
	--Mark

--
Mark Fasheh
