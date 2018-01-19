Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36102 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751548AbeASHgS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 02:36:18 -0500
Subject: Re: [PATCH v2 3/3] btrfs-progs: dir-item: Make
 btrfs_delete_one_dir_name more robust to handle corrupted name len
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-4-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <b7ccfbce-41bf-2af6-38fd-99ae208ecd03@cn.fujitsu.com>
Date: Fri, 19 Jan 2018 15:40:51 +0800
MIME-Version: 1.0
In-Reply-To: <20180119072536.22286-4-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/19/2018 03:25 PM, Qu Wenruo wrote:
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

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   dir-item.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/dir-item.c b/dir-item.c
> index e0a0ab4d7a5d..35e0615fb423 100644
> --- a/dir-item.c
> +++ b/dir-item.c
> @@ -263,7 +263,6 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>   			      struct btrfs_path *path,
>   			      struct btrfs_dir_item *di)
>   {
> -
>   	struct extent_buffer *leaf;
>   	u32 sub_item_len;
>   	u32 item_len;
> @@ -273,7 +272,15 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>   	sub_item_len = sizeof(*di) + btrfs_dir_name_len(leaf, di) +
>   		btrfs_dir_data_len(leaf, di);
>   	item_len = btrfs_item_size_nr(leaf, path->slots[0]);
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
>   		ret = btrfs_del_item(trans, root, path);
>   	} else {
>   		unsigned long ptr = (unsigned long)di;
> 


