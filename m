Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36259 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdBNTgH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 14:36:07 -0500
Date: Tue, 14 Feb 2017 11:35:11 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 17/29] btrfs: remove unused parameter from
 extent_write_cache_pages
Message-ID: <20170214193511.GD31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <43296f2bae8942890fda6c428617fb474c812696.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43296f2bae8942890fda6c428617fb474c812696.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:13AM +0100, David Sterba wrote:
> The 'tree' was used to call locking hook that does not exist anymore.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index f683fa5a4b91..22a2f2fa62c7 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3916,8 +3916,7 @@ int btree_write_cache_pages(struct address_space *mapping,
>   * WB_SYNC_ALL then we were called for data integrity and we must wait for
>   * existing IO to complete.
>   */
> -static int extent_write_cache_pages(struct extent_io_tree *tree,
> -			     struct address_space *mapping,
> +static int extent_write_cache_pages(struct address_space *mapping,
>  			     struct writeback_control *wbc,
>  			     writepage_t writepage, void *data,
>  			     void (*flush_fn)(void *))
> @@ -4158,8 +4157,7 @@ int extent_writepages(struct extent_io_tree *tree,
>  		.bio_flags = 0,
>  	};
>  
> -	ret = extent_write_cache_pages(tree, mapping, wbc,
> -				       __extent_writepage, &epd,
> +	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd,
>  				       flush_write_bio);

Are we going to leave {btrfs,extent}_{read,write}pages untouched?

Thanks,

-liubo

>  	flush_epd_write_bio(&epd);
>  	return ret;
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
