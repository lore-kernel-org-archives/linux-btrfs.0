Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754386AbcKUQjq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2016 11:39:46 -0500
Date: Mon, 21 Nov 2016 17:39:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] btrfs: limit the number of asynchronous delalloc pages
 to reasonable value
Message-ID: <20161121163941.GJ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1478597458-29287-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478597458-29287-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 05:30:58PM +0800, Wang Xiaoguang wrote:
> The current limit of number of asynchronous delalloc pages is (10 * SZ_1M).
> For 4K page, the total ram bytes would be 40G, very big value, I think in
> most cases, this limit will not work, here I set limit of the number of
> asynchronous delalloc pages to SZ_1M(4GB ram bytes).
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8e3a5a2..3a910f6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1158,7 +1158,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	unsigned long nr_pages;
>  	u64 cur_end;
> -	int limit = 10 * SZ_1M;
> +	int limit = SZ_1M;

This looks like mismatch in units, the limit seems to be "10MiB" but
it's used to compare async_delalloc_pages, which is in pages. I'm not
sure what's the expected value for limit, as 10MiB is too small.
