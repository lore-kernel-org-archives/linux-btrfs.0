Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:64566 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbeHUHk3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 03:40:29 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id C6031AC010F
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 13:21:54 +0900 (JST)
Subject: Re: [PATCH] btrfs: Always check nocow for quota enabled case to make
 sure we won't reserve unnecessary data space
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180815061323.23936-1-wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <1c8e89b5-eed8-8fdd-33bd-80a9d579fc21@jp.fujitsu.com>
Date: Tue, 21 Aug 2018 13:21:29 +0900
MIME-Version: 1.0
In-Reply-To: <20180815061323.23936-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/15 15:13, Qu Wenruo wrote:
> Commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
> makes nocow check less frequent to improve performance.
> 
> However for quota enabled case, such optimization could lead to extra
> unnecessary data reservation, which results failure for test case like
> btrfs/153 in fstests.
> 
> Fix it by reverting to old behavior for quota enabled case.
> 
> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/file.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 51e77d72068a..f2ce1d707d4c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1587,6 +1587,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  	int ret = 0;
>  	bool only_release_metadata = false;
>  	bool force_page_uptodate = false;
> +	bool quota_enabled = test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>  
>  	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>  			PAGE_SIZE / (sizeof(struct page *)));
> @@ -1627,9 +1628,15 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  				fs_info->sectorsize);
>  
>  		extent_changeset_release(data_reserved);
> -		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
> +		/*
> +		 * If we have quota enabled, we must do the heavy lift nocow
> +		 * check here to avoid reserving data space, or we can hit
> +		 * limitation for NOCOW files.
> +		 */
> +		if (!quota_enabled)
> +			ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
>  						  write_bytes);
> -		if (ret < 0) {
> +		if (ret < 0 || quota_enabled) {
>  			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>  						      BTRFS_INODE_PREALLOC)) &&>  			    check_can_nocow(BTRFS_I(inode), pos,
> 

This fixes btrfs/153 but in turn makes other qgroup tests fail (022,091 etc.)

If quota is enabled and file is not marked as nocow, above if is false and write will stop.
so I think we still need to call btrfs_check_dta_free_space() when quota is enabled
and file is not nocow, right?
