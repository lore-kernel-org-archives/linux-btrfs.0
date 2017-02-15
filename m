Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33322 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdBOVYR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:24:17 -0500
Date: Wed, 15 Feb 2017 13:22:52 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/29] btrfs: remove unused parameter from
 update_nr_written
Message-ID: <20170215212252.GF19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <8eb2ad192a76e19472e34c98518508943246d4cd.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8eb2ad192a76e19472e34c98518508943246d4cd.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:07AM +0100, David Sterba wrote:
> The logic has been updated in "Btrfs: make mapping->writeback_index
> point to the last written page" (a91326679f2a0a4c2) and page is not
> needed anymore.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 00f3be5c4f2d..f683fa5a4b91 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3203,7 +3203,7 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
>  	return ret;
>  }
>  
> -static void update_nr_written(struct page *page, struct writeback_control *wbc,
> +static void update_nr_written(struct writeback_control *wbc,
>  			      unsigned long nr_written)
>  {
>  	wbc->nr_to_write -= nr_written;
> @@ -3341,7 +3341,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>  			else
>  				redirty_page_for_writepage(wbc, page);
>  
> -			update_nr_written(page, wbc, nr_written);
> +			update_nr_written(wbc, nr_written);
>  			unlock_page(page);
>  			return 1;
>  		}
> @@ -3351,7 +3351,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>  	 * we don't want to touch the inode after unlocking the page,
>  	 * so we update the mapping writeback index now
>  	 */
> -	update_nr_written(page, wbc, nr_written + 1);
> +	update_nr_written(wbc, nr_written + 1);
>  
>  	end = page_end;
>  	if (i_size <= start) {
> @@ -3764,7 +3764,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>  			break;
>  		}
>  		offset += PAGE_SIZE;
> -		update_nr_written(p, wbc, 1);
> +		update_nr_written(wbc, 1);
>  		unlock_page(p);
>  	}
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
