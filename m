Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbeAQNj1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 08:39:27 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A9642AF89
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 13:39:26 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: dir-item: Make btrfs_delete_one_dir_name
 more robust to handle corrupted name len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180117051710.16853-1-wqu@suse.com>
 <20180117051710.16853-4-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <95c9bb6a-305a-5512-0f71-46e8960e6b19@suse.com>
Date: Wed, 17 Jan 2018 15:39:25 +0200
MIME-Version: 1.0
In-Reply-To: <20180117051710.16853-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.01.2018 07:17, Qu Wenruo wrote:
> Function btrfs_delete_one_dir_name() will check if the dir_item is the
> last content of the item, and delete the whole item if needed.
> 
> However if @name_len of one dir_item/dir_index is corrupted and larger
> than the item size, the function will still try to treat it as partly
> remove, which will screw up the whole leaf.
> 
> This patch will enhance the item deletion check, to cover corrupted name
> len, so in that case we just delete the whole item.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  dir-item.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/dir-item.c b/dir-item.c
> index 31ad1eca29d5..7ce3d2a40433 100644
> --- a/dir-item.c
> +++ b/dir-item.c
> @@ -281,7 +281,6 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>  			      struct btrfs_path *path,
>  			      struct btrfs_dir_item *di)
>  {
> -
>  	struct extent_buffer *leaf;
>  	u32 sub_item_len;
>  	u32 item_len;
> @@ -291,7 +290,15 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>  	sub_item_len = sizeof(*di) + btrfs_dir_name_len(leaf, di) +
>  		btrfs_dir_data_len(leaf, di);
>  	item_len = btrfs_item_size_nr(leaf, path->slots[0]);
> -	if (sub_item_len == item_len) {
> +
> +	/*
> +	 * If @sub_item_len is longer than @item_len, then it means the
> +	 * name_len is just corrupted.
> +	 * No good idea to know if there is anything we can recover from
> +	 * the corrupted item.
> +	 * Just delete the item.
> +	 */
> +	if (sub_item_len >= item_len) {
>  		ret = btrfs_del_item(trans, root, path);
>  	} else {
>  		unsigned long ptr = (unsigned long)di;
> 
