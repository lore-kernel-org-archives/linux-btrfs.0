Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755172AbeDZN1e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 09:27:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 53063ABE4
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 13:27:33 +0000 (UTC)
Date: Thu, 26 Apr 2018 15:24:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trace: Add trace points for unused block groups
Message-ID: <20180426132459.GU21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426091720.24185-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180426091720.24185-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 05:17:20PM +0800, Qu Wenruo wrote:
> This patch will add the following trace events:
> 1) btrfs_remove_block_group
>    For btrfs_remove_block_group() function.
>    Triggered when a block group is really removed.
> 
> 2) btrfs_add_unused_block_group
>    Triggered which block group is added to unused_bgs list.
> 
> 3) btrfs_skip_unused_block_group
>    Triggered which unused block group is not deleted.
> 
> These trace events is pretty handy to debug case related to block group
> auto remove.

Sounds useful.

> Signed-off-by: Qu Wenruo <wqu@suse.com>

> +DECLARE_EVENT_CLASS(btrfs__block_group,
> +	TP_PROTO(const struct btrfs_block_group_cache *bg_cache),
> +
> +	TP_ARGS(bg_cache),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,	bytenr		)
> +		__field(	u64,	flags		)
> +		__field(	u64,	len		)
> +		__field(	u64,	used		)
> +	),
> +
> +	TP_fast_assign_btrfs(bg_cache->fs_info,
> +		__entry->bytenr = bg_cache->key.objectid,
> +		__entry->len	= bg_cache->key.offset,
> +		__entry->flags	= bg_cache->flags;
> +		__entry->used	= btrfs_block_group_used(&bg_cache->item);
> +	),
> +
> +	TP_printk_btrfs("bg bytenr=%llu len=%llu used=%llu flags=%llu(%s)",
> +		__entry->bytenr, __entry->len, __entry->used, __entry->flags,
> +		__print_flags(__entry->flags, "|", BTRFS_GROUP_FLAGS))

I've reorered the fields so they're sorted the same way in all 3
sections, as defined in the printk (bytenr, len, used, flags).

Reviewed-by: David Sterba <dsterba@suse.com>
