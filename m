Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:57033 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbbIIAdS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 20:33:18 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 72A3EAC00EB
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2015 09:33:15 +0900 (JST)
Subject: Re: [PATCH 04/19] btrfs: qgroup: Introduce function to insert
 non-overlap reserve range
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1441702920-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <55EF7E34.9040601@jp.fujitsu.com>
Date: Wed, 9 Sep 2015 09:32:52 +0900
MIME-Version: 1.0
In-Reply-To: <1441702920-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu,

On 2015/09/08 18:01, Qu Wenruo wrote:
> New function insert_data_ranges() will insert non-overlap reserve ranges
> into reserve map.
> 
> It provides the basis for later qgroup reserve map implement.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/qgroup.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 124 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index fc24fc3..a4e3af4 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2577,6 +2577,130 @@ find_reserve_range(struct btrfs_qgroup_data_rsv_map *map, u64 start)
>   }
>   
>   /*
> + * Insert one data range

> + * [start,len) here won't overflap with each other.

                             overlap

Thanks,
Tsutomu

> + *
> + * Return 0 if range is inserted and tmp is not used.
> + * Return > 0 if range is inserted and tmp is used.
> + * No catchable error case. Only possible error will cause BUG_ON() as
> + * that's logical error.
> + */
> +static int insert_data_range(struct btrfs_qgroup_data_rsv_map *map,
> +			     struct data_rsv_range *tmp,
> +			     u64 start, u64 len)
> +{
> +	struct rb_node **p = &map->root.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct rb_node *tmp_node = NULL;
> +	struct data_rsv_range *range = NULL;
> +	struct data_rsv_range *prev_range = NULL;
> +	struct data_rsv_range *next_range = NULL;
> +	int prev_merged = 0;
> +	int next_merged = 0;
> +	int ret = 0;
> +
> +	while (*p) {
> +		parent = *p;
> +		range = rb_entry(parent, struct data_rsv_range, node);
> +		if (range->start < start)
> +			p = &(*p)->rb_right;
> +		else if (range->start > start)
> +			p = &(*p)->rb_left;
> +		else
> +			BUG_ON(1);
> +	}
> +
> +	/* Empty tree, goto isolated case */
> +	if (!range)
> +		goto insert_isolated;
> +
> +	/* get adjusted ranges */
> +	if (range->start < start) {
> +		prev_range = range;
> +		tmp_node = rb_next(parent);
> +		if (tmp)
> +			next_range = rb_entry(tmp_node, struct data_rsv_range,
> +					      node);
> +	} else {
> +		next_range = range;
> +		tmp_node = rb_prev(parent);
> +		if (tmp)
> +			prev_range = rb_entry(tmp_node, struct data_rsv_range,
> +					      node);
> +	}
> +
> +	/* try to merge with previous and next ranges */
> +	if (prev_range && prev_range->start + prev_range->len == start) {
> +		prev_merged = 1;
> +		prev_range->len += len;
> +	}
> +	if (next_range && start + len == next_range->start) {
> +		next_merged = 1;
> +
> +		/*
> +		 * the range can be merged with adjusted two ranges into one,
> +		 * remove the tailing range.
> +		 */
> +		if (prev_merged) {
> +			prev_range->len += next_range->len;
> +			rb_erase(&next_range->node, &map->root);
> +			kfree(next_range);
> +		} else {
> +			next_range->start = start;
> +			next_range->len += len;
> +		}
> +	}
> +
> +insert_isolated:
> +	/* isolated case, need to insert range now */
> +	if (!next_merged && !prev_merged) {
> +		BUG_ON(!tmp);
> +
> +		tmp->start = start;
> +		tmp->len = len;
> +		rb_link_node(&tmp->node, parent, p);
> +		rb_insert_color(&tmp->node, &map->root);
> +		ret = 1;
> +	}
> +	return ret;
> +}
> +
> +/*
> + * insert reserve range and merge them if possible
> + *
> + * Return 0 if all inserted and tmp not used
> + * Return > 0 if all inserted and tmp used
> + * No catchable error return value.
> + */
> +static int insert_data_ranges(struct btrfs_qgroup_data_rsv_map *map,
> +			      struct data_rsv_range *tmp,
> +			      struct ulist *insert_list)
> +{
> +	struct ulist_node *unode;
> +	struct ulist_iterator uiter;
> +	int tmp_used = 0;
> +	int ret = 0;
> +
> +	ULIST_ITER_INIT(&uiter);
> +	while ((unode = ulist_next(insert_list, &uiter))) {
> +		ret = insert_data_range(map, tmp, unode->val, unode->aux);
> +
> +		/*
> +		 * insert_data_range() won't return error return value,
> +		 * no need to hanle <0 case.
> +		 *
> +		 * Also tmp should be used at most one time, so clear it to
> +		 * NULL to cooperate with sanity check in insert_data_range().
> +		 */
> +		if (ret > 0) {
> +			tmp_used = 1;
> +			tmp = NULL;
> +		}
> +	}
> +	return tmp_used;
> +}
> +
> +/*
>    * Init data_rsv_map for a given inode.
>    *
>    * This is needed at write time as quota can be disabled and then enabled
> 


