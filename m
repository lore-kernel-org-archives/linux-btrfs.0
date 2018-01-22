Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750945AbeAVIJd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 03:09:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C28CABF3
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 08:09:32 +0000 (UTC)
Subject: Re: [PATCH v2.1 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180119072536.22286-3-wqu@suse.com>
 <20180122054529.7055-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7541adaf-b954-b0ce-3ebd-edd0e0c94977@suse.com>
Date: Mon, 22 Jan 2018 10:09:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180122054529.7055-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.01.2018 07:45, Qu Wenruo wrote:
> verify_dir_item() is called in btrfs_match_dir_item_name() to ensure we
> won't search beyond item boundary and does extra filetype check.
> 
> However in the follow call chain, such extra filetype check can cause
> problems:
> 
> 1) btrfs_add_link()
>    |- check_dir_conflict()
>       |- btrfs_lookup_dir_index()
>          |- btrfs_match_dir_item_name()
> 
>    And if we have an offending dir index whose filetype is invalid,
>    btrfs_match_dir_item_name() will return NULL, meaning no match dir
>    index is found.
>    So btrfs_add_link() will still try to insert a dir index, which may
>    have same key->offset and leading to duplicated dir index.
> 
> 2) btrfs_unlink()
>    |- btrfs_lookup_dir_index()
>       |- btrfs_lookup_dir_index()
>          |- btrfs_match_dir_item_name()
> 
>    For the same offending dir index with invalid filetype, this will
>    return NULL, and btrfs_unlink() will just consider there is no
>    existing dir_index and do nothing.
>    Leave an orphan and invalid dir_index hanging there forever.
> 
> The patch removes the extra filetype check, as "btrfs check" can already
> handle invalid filetype correctly for both modes.
> 
> And this makes "btrfs check --repair --mode=lowmem" to delete the
> offending dir index to repair it correctly.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> v2:
>   Get rid of the new parameter.
> v2.1:
>   Better commit message.
> ---
>  dir-item.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/dir-item.c b/dir-item.c
> index 462546c0eaf4..e0a0ab4d7a5d 100644
> --- a/dir-item.c
> +++ b/dir-item.c
> @@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *root,
>  	u16 namelen = BTRFS_NAME_LEN;
>  	u8 type = btrfs_dir_type(leaf, dir_item);
>  
> -	if (type >= BTRFS_FT_MAX) {
> -		fprintf(stderr, "invalid dir item type: %d\n",
> -		       (int)type);
> -		return 1;
> -	}
> -
>  	if (type == BTRFS_FT_XATTR)
>  		namelen = XATTR_NAME_MAX;
>  
> 
