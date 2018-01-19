Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41465 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753670AbeASJnL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 04:43:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF871AECF
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jan 2018 09:43:09 +0000 (UTC)
Subject: Re: [PATCH v2 3/3] btrfs-progs: dir-item: Make
 btrfs_delete_one_dir_name more robust to handle corrupted name len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-4-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <648ca774-916b-59d1-08b1-e8e9df0d4a8f@suse.com>
Date: Fri, 19 Jan 2018 11:43:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180119072536.22286-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.01.2018 09:25, Qu Wenruo wrote:
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

Perhaps it would be worth it creating a regression test for that ?

> ---
>  dir-item.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/dir-item.c b/dir-item.c
> index e0a0ab4d7a5d..35e0615fb423 100644
> --- a/dir-item.c
> +++ b/dir-item.c
> @@ -263,7 +263,6 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>  			      struct btrfs_path *path,
>  			      struct btrfs_dir_item *di)
>  {
> -
>  	struct extent_buffer *leaf;
>  	u32 sub_item_len;
>  	u32 item_len;
> @@ -273,7 +272,15 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
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
