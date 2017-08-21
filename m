Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53611 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753536AbdHUOym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 10:54:42 -0400
Date: Mon, 21 Aug 2017 16:53:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 4/7] Btrfs: remove BUG() in print_extent_item
Message-ID: <20170821145317.GG2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
 <20170818211524.31325-5-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818211524.31325-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:15:21PM -0600, Liu Bo wrote:
> btrfs_print_leaf() is used in btrfs_get_extent_inline_ref_type, so
> here we really want to print the invalid value of ref type instead of
> causing a kernel panic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/print-tree.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
> index fcae61e..0e52e47 100644
> --- a/fs/btrfs/print-tree.c
> +++ b/fs/btrfs/print-tree.c
> @@ -121,7 +121,10 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
>  			       offset, btrfs_shared_data_ref_count(eb, sref));
>  			break;
>  		default:
> -			BUG();
> +			btrfs_err(eb->fs_info,
> +				  "extent %llu has invalid ref type %d\n",

I'll remove the trailing \n

Reviewed-by: David Sterba <dsterba@suse.com>
