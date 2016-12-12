Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbcLLNI2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 08:08:28 -0500
Date: Mon, 12 Dec 2016 14:08:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: add 'inode' for extent map tracepoint
Message-ID: <20161212130821.GM12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480628641-17476-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480628641-17476-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 01:44:01PM -0800, Liu Bo wrote:
>  	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  root_objectid	)
> +		__field(	u64,  ino		)
>  		__field(	u64,  start		)
>  		__field(	u64,  len		)
>  		__field(	u64,  orig_start	)
> @@ -204,7 +206,8 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
>  
>  	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->root_objectid	= root->root_key.objectid;
> -		__entry->start 		= map->start;
> +		__entry->ino		= btrfs_ino(inode);
> +		__entry->start		= map->start;
>  		__entry->len		= map->len;
>  		__entry->orig_start	= map->orig_start;
>  		__entry->block_start	= map->block_start;
> @@ -214,12 +217,12 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
>  		__entry->compress_type	= map->compress_type;
>  	),
>  
> -	TP_printk_btrfs("root = %llu(%s), start = %llu, len = %llu, "
> +	TP_printk_btrfs("root = %llu(%s), ino = %llu start = %llu, len = %llu, "
>  		  "orig_start = %llu, block_start = %llu(%s), "
>  		  "block_len = %llu, flags = %s, refs = %u, "
>  		  "compress_type = %u",
>  		  show_root_type(__entry->root_objectid),
> -		  (unsigned long long)__entry->start,
> +		  __entry->ino, (unsigned long long)__entry->start,

I think the (unsigned long long) cast should be used here as well, at
least for consistency with the other u64.

>  		  (unsigned long long)__entry->len,
>  		  (unsigned long long)__entry->orig_start,
>  		  show_map_type(__entry->block_start),
