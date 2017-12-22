Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933113AbdLVI4d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 03:56:33 -0500
Subject: Re: [PATCH 09/10] Btrfs: add tracepoint for em's EEXIST case
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
 <20171221224256.18196-10-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <066b86a5-2836-b0a3-16b3-3c20e7ee2cf8@suse.com>
Date: Fri, 22 Dec 2017 10:56:31 +0200
MIME-Version: 1.0
In-Reply-To: <20171221224256.18196-10-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.12.2017 00:42, Liu Bo wrote:
> This is adding a tracepoint 'btrfs_handle_em_exist' to help debug the
> subtle bugs around merge_extent_mapping.

In the next patch you are already making the function which takes all
these values noinline, meaning you can attach a kprobe so you can
interrogate the args via systemtap,perf probe or even bpf. So I'd rather
not add this tracepoint since the general sentiment seems to be that
tracepoints are ABI and so have to be maintained.

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_map.c        |  1 +
>  include/trace/events/btrfs.h | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index a8b7e24..40e4d30 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -539,6 +539,7 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
>  		ret = 0;
>  
>  		existing = search_extent_mapping(em_tree, start, len);
> +		trace_btrfs_handle_em_exist(existing, em, start, len);
>  
>  		/*
>  		 * existing will always be non-NULL, since there must be
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 4342a32..b7ffcf7 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -249,6 +249,41 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
>  		  __entry->refs, __entry->compress_type)
>  );
>  
> +TRACE_EVENT(btrfs_handle_em_exist,
> +
> +	TP_PROTO(const struct extent_map *existing, const struct extent_map *map, u64 start, u64 len),
> +
> +	TP_ARGS(existing, map, start, len),
> +
> +	TP_STRUCT__entry(
> +		__field(	u64,  e_start		)
> +		__field(	u64,  e_len		)
> +		__field(	u64,  map_start		)
> +		__field(	u64,  map_len		)
> +		__field(	u64,  start		)
> +		__field(	u64,  len		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->e_start	= existing->start;
> +		__entry->e_len		= existing->len;
> +		__entry->map_start	= map->start;
> +		__entry->map_len	= map->len;
> +		__entry->start		= start;
> +		__entry->len		= len;
> +	),
> +
> +	TP_printk("start=%llu len=%llu "
> +		  "existing(start=%llu len=%llu) "
> +		  "em(start=%llu len=%llu)",
> +		  (unsigned long long)__entry->start,
> +		  (unsigned long long)__entry->len,
> +		  (unsigned long long)__entry->e_start,
> +		  (unsigned long long)__entry->e_len,
> +		  (unsigned long long)__entry->map_start,
> +		  (unsigned long long)__entry->map_len)
> +);
> +
>  /* file extent item */
>  DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
>  
> 
