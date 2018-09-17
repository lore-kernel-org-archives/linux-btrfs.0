Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36251 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbeIQSO7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 14:14:59 -0400
Subject: Re: [PATCH v3 3/7] btrfs-progs: lowmem check: find dir_item by di_key
 in check_dir_item()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
 <20180917072852.25831-4-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <63733469-2449-29f3-e899-c02294395e23@gmx.com>
Date: Mon, 17 Sep 2018 20:47:40 +0800
MIME-Version: 1.0
In-Reply-To: <20180917072852.25831-4-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/17 下午3:28, Su Yue wrote:
> In check_dir_item, we are going to search corresponding
> dir_item/index.
> 
> Commit 564901eac7a4 ("btrfs-progs: check: introduce
> print_dir_item_err()") Changed argument name from key to di_key but
> forgot to change the key name for dir_item search.
> So @key shouldn't be used here. It should be @di_key.
> Change comment about parameters too.
> 
> To keep compactness, move declarations into while loop in
> check_dir_item().
> 
> Fixes: 564901eac7a4 ("btrfs-progs: check: introduce print_dir_item_err()")
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 1bce44f5658a..4db12cc7f9fe 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1529,7 +1529,7 @@ static void print_dir_item_err(struct btrfs_root *root, struct btrfs_key *key,
>   * call find_inode_ref() to check related INODE_REF/INODE_EXTREF.
>   *
>   * @root:	the root of the fs/file tree
> - * @key:	the key of the INODE_REF/INODE_EXTREF
> + * @di_key:	the key of the dir_item/dir_index
>   * @path:       the path
>   * @size:	the st_size of the INODE_ITEM
>   *
> @@ -1540,20 +1540,11 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *di_key,
>  			  struct btrfs_path *path, u64 *size)
>  {
>  	struct btrfs_dir_item *di;
> -	struct btrfs_inode_item *ii;
> -	struct btrfs_key key;
> -	struct btrfs_key location;
>  	struct extent_buffer *node;
>  	int slot;
>  	char namebuf[BTRFS_NAME_LEN] = {0};
>  	u32 total;
>  	u32 cur = 0;
> -	u32 len;
> -	u32 name_len;
> -	u32 data_len;
> -	u8 filetype;
> -	u32 mode = 0;
> -	u64 index;
>  	int ret;
>  	int err;
>  	int tmp_err;
> @@ -1588,6 +1579,15 @@ begin:
>  	memset(namebuf, 0, sizeof(namebuf) / sizeof(*namebuf));
>  
>  	while (cur < total) {
> +		struct btrfs_inode_item *ii;
> +		struct btrfs_key key;

If we have several keys, it's better to avoid generic name like @key.

In this case, the @key is only used for find_dir_item(), thus it could
be called @found_dir_key.

Thanks,
Qu

> +		struct btrfs_key location;
> +		u8 filetype;
> +		u32 data_len;
> +		u32 name_len;
> +		u32 len;
> +		u32 mode = 0;
> +		u64 index;
>  		/*
>  		 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
>  		 * ignore index check.
> @@ -1658,7 +1658,7 @@ begin:
>  
>  		/* check relative INDEX/ITEM */
>  		key.objectid = di_key->objectid;
> -		if (key.type == BTRFS_DIR_ITEM_KEY) {
> +		if (di_key->type == BTRFS_DIR_ITEM_KEY) {
>  			key.type = BTRFS_DIR_INDEX_KEY;
>  			key.offset = index;
>  		} else {
> 
