Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65090 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751441AbdEEAbk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 20:31:40 -0400
Subject: Re: [RFC] [PATCH] btrfs: clean up qgroup trace event
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170504140411.26723-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8dca776f-8925-3f20-843a-44f9398cb1a5@cn.fujitsu.com>
Date: Fri, 5 May 2017 08:31:33 +0800
MIME-Version: 1.0
In-Reply-To: <20170504140411.26723-1-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/04/2017 10:04 PM, Anand Jain wrote:
> Hi Qu,
> 
> The commit 81fb6f77a026 (btrfs: qgroup: Add new trace point for
> qgroup data reserve) added the following events which aren't used.
>    btrfs__qgroup_data_map
>    btrfs_qgroup_init_data_rsv_map
>    btrfs_qgroup_free_data_rsv_map
> I wonder if it is better to remove or keep it for future use.

Please remove them.

These 2 old tracepoints are never used due to later patch split.
Some of the old caller doesn't ever exist.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks for catching this,
Qu

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> cc: quwenruo@cn.fujitsu.com
> ---
>   include/trace/events/btrfs.h | 36 ------------------------------------
>   1 file changed, 36 deletions(-)
> 
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index a3c3cab643a9..5471f9b4dc9e 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -1270,42 +1270,6 @@ DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
>   	TP_ARGS(wq)
>   );
>   
> -DECLARE_EVENT_CLASS(btrfs__qgroup_data_map,
> -
> -	TP_PROTO(struct inode *inode, u64 free_reserved),
> -
> -	TP_ARGS(inode, free_reserved),
> -
> -	TP_STRUCT__entry_btrfs(
> -		__field(	u64,		rootid		)
> -		__field(	unsigned long,	ino		)
> -		__field(	u64,		free_reserved	)
> -	),
> -
> -	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
> -		__entry->rootid		=	BTRFS_I(inode)->root->objectid;
> -		__entry->ino		=	inode->i_ino;
> -		__entry->free_reserved	=	free_reserved;
> -	),
> -
> -	TP_printk_btrfs("rootid=%llu ino=%lu free_reserved=%llu",
> -		  __entry->rootid, __entry->ino, __entry->free_reserved)
> -);
> -
> -DEFINE_EVENT(btrfs__qgroup_data_map, btrfs_qgroup_init_data_rsv_map,
> -
> -	TP_PROTO(struct inode *inode, u64 free_reserved),
> -
> -	TP_ARGS(inode, free_reserved)
> -);
> -
> -DEFINE_EVENT(btrfs__qgroup_data_map, btrfs_qgroup_free_data_rsv_map,
> -
> -	TP_PROTO(struct inode *inode, u64 free_reserved),
> -
> -	TP_ARGS(inode, free_reserved)
> -);
> -
>   #define BTRFS_QGROUP_OPERATIONS				\
>   	{ QGROUP_RESERVE,	"reserve"	},	\
>   	{ QGROUP_RELEASE,	"release"	},	\
> 


