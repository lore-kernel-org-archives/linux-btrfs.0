Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49739 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752742AbdGNCWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 22:22:24 -0400
Subject: Re: [PATCH 1/3] btrfs: Remove unused variables
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1499935063-24401-1-git-send-email-nborisov@suse.com>
 <1499935063-24401-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20c2a53b-85f0-ed2b-bd55-162af9a7bcaa@gmx.com>
Date: Fri, 14 Jul 2017 10:21:39 +0800
MIME-Version: 1.0
In-Reply-To: <1499935063-24401-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月13日 16:37, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks good.

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Kernel makefile disabled unused-but-set-variable warning so we can't 
detect it in normal compile.

Thanks,
Qu

> ---
>   fs/btrfs/volumes.c | 9 ---------
>   1 file changed, 9 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6466f53b1e81..9a38cbf233a1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1873,7 +1873,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>   	struct btrfs_fs_devices *cur_devices;
>   	u64 num_devices;
>   	int ret = 0;
> -	bool clear_super = false;
>   
>   	mutex_lock(&uuid_mutex);
>   
> @@ -1909,7 +1908,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>   		list_del_init(&device->dev_alloc_list);
>   		device->fs_devices->rw_devices--;
>   		mutex_unlock(&fs_info->chunk_mutex);
> -		clear_super = true;
>   	}
>   
>   	mutex_unlock(&uuid_mutex);
> @@ -4128,7 +4126,6 @@ static int btrfs_uuid_scan_kthread(void *data)
>   	struct btrfs_fs_info *fs_info = data;
>   	struct btrfs_root *root = fs_info->tree_root;
>   	struct btrfs_key key;
> -	struct btrfs_key max_key;
>   	struct btrfs_path *path = NULL;
>   	int ret = 0;
>   	struct extent_buffer *eb;
> @@ -4147,10 +4144,6 @@ static int btrfs_uuid_scan_kthread(void *data)
>   	key.type = BTRFS_ROOT_ITEM_KEY;
>   	key.offset = 0;
>   
> -	max_key.objectid = (u64)-1;
> -	max_key.type = BTRFS_ROOT_ITEM_KEY;
> -	max_key.offset = (u64)-1;
> -
>   	while (1) {
>   		ret = btrfs_search_forward(root, &key, path, 0);
>   		if (ret) {
> @@ -6452,7 +6445,6 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>   	struct extent_map *em;
>   	u64 logical;
>   	u64 length;
> -	u64 stripe_len;
>   	u64 devid;
>   	u8 uuid[BTRFS_UUID_SIZE];
>   	int num_stripes;
> @@ -6461,7 +6453,6 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>   
>   	logical = key->offset;
>   	length = btrfs_chunk_length(leaf, chunk);
> -	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
>   	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
>   
>   	ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
> 
