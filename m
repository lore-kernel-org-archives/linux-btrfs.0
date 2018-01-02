Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59070 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbeABTFH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jan 2018 14:05:07 -0500
Date: Tue, 2 Jan 2018 11:02:52 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/10] Btrfs: add tracepoint for em's EEXIST case
Message-ID: <20180102180251.GA22892@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
 <20171221224256.18196-10-bo.li.liu@oracle.com>
 <066b86a5-2836-b0a3-16b3-3c20e7ee2cf8@suse.com>
 <20171222190718.GD21643@lim.localdomain>
 <b97dfe4c-0648-eb7a-7e82-45fec97728db@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b97dfe4c-0648-eb7a-7e82-45fec97728db@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 23, 2017 at 09:39:00AM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.12.2017 21:07, Liu Bo wrote:
> > On Fri, Dec 22, 2017 at 10:56:31AM +0200, Nikolay Borisov wrote:
> >>
> >>
> >> On 22.12.2017 00:42, Liu Bo wrote:
> >>> This is adding a tracepoint 'btrfs_handle_em_exist' to help debug the
> >>> subtle bugs around merge_extent_mapping.
> >>
> >> In the next patch you are already making the function which takes all
> >> these values noinline, meaning you can attach a kprobe so you can
> >> interrogate the args via systemtap,perf probe or even bpf. So I'd rather
> >> not add this tracepoint since the general sentiment seems to be that
> >> tracepoints are ABI and so have to be maintained.
> >>
> > 
> > The following patch of noinline function is inside the else {} branch,
> > so kprobe would give us something back only when it runs to else{}.
> > 
> > Since subtle bugs may lie in this area, a simple tracepoint like this
> > can help us understand them more efficiently.
> 
> In that case if you make search_extent_mapping and put a kprobe/ret
> kprobe there you should be able to gain the same information, we should
> really careful when adding trace events...

Correct me if I'm wrong, using 'perf probe' can only return @retval,
it seems that we're not able to reference retval's number like
retval->var or retval.val.

As @exisiting is returned by search_extent_mapping(), I'm fine without
this tracepoint if 'perf probe' can do the referencing for retval.

Thanks,

-liubo
> > 
> >>>
> >>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >>> ---
> >>>  fs/btrfs/extent_map.c        |  1 +
> >>>  include/trace/events/btrfs.h | 35 +++++++++++++++++++++++++++++++++++
> >>>  2 files changed, 36 insertions(+)
> >>>
> >>> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> >>> index a8b7e24..40e4d30 100644
> >>> --- a/fs/btrfs/extent_map.c
> >>> +++ b/fs/btrfs/extent_map.c
> >>> @@ -539,6 +539,7 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
> >>>  		ret = 0;
> >>>  
> >>>  		existing = search_extent_mapping(em_tree, start, len);
> >>> +		trace_btrfs_handle_em_exist(existing, em, start, len);
> >>>  
> >>>  		/*
> >>>  		 * existing will always be non-NULL, since there must be
> >>> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> >>> index 4342a32..b7ffcf7 100644
> >>> --- a/include/trace/events/btrfs.h
> >>> +++ b/include/trace/events/btrfs.h
> >>> @@ -249,6 +249,41 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
> >>>  		  __entry->refs, __entry->compress_type)
> >>>  );
> >>>  
> >>> +TRACE_EVENT(btrfs_handle_em_exist,
> >>> +
> >>> +	TP_PROTO(const struct extent_map *existing, const struct extent_map *map, u64 start, u64 len),
> >>> +
> >>> +	TP_ARGS(existing, map, start, len),
> >>> +
> >>> +	TP_STRUCT__entry(
> >>> +		__field(	u64,  e_start		)
> >>> +		__field(	u64,  e_len		)
> >>> +		__field(	u64,  map_start		)
> >>> +		__field(	u64,  map_len		)
> >>> +		__field(	u64,  start		)
> >>> +		__field(	u64,  len		)
> >>> +	),
> >>> +
> >>> +	TP_fast_assign(
> >>> +		__entry->e_start	= existing->start;
> >>> +		__entry->e_len		= existing->len;
> >>> +		__entry->map_start	= map->start;
> >>> +		__entry->map_len	= map->len;
> >>> +		__entry->start		= start;
> >>> +		__entry->len		= len;
> >>> +	),
> >>> +
> >>> +	TP_printk("start=%llu len=%llu "
> >>> +		  "existing(start=%llu len=%llu) "
> >>> +		  "em(start=%llu len=%llu)",
> >>> +		  (unsigned long long)__entry->start,
> >>> +		  (unsigned long long)__entry->len,
> >>> +		  (unsigned long long)__entry->e_start,
> >>> +		  (unsigned long long)__entry->e_len,
> >>> +		  (unsigned long long)__entry->map_start,
> >>> +		  (unsigned long long)__entry->map_len)
> >>> +);
> >>> +
> >>>  /* file extent item */
> >>>  DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
> >>>  
> >>>
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
