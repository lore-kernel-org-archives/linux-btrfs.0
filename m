Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56021 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751456AbdGRP4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:56:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31CE2AABA
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 15:56:11 +0000 (UTC)
Date: Tue, 18 Jul 2017 17:54:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/3] btrfs: Remove unused variables
Message-ID: <20170718155456.GW2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499935063-24401-1-git-send-email-nborisov@suse.com>
 <1499935063-24401-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499935063-24401-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For dead code removal, please document when it was last used and what's
the possible cause the code became unused. It's mostly for obvious
reasons, but sometimes it can reveal potential problems.

On Thu, Jul 13, 2017 at 11:37:41AM +0300, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6466f53b1e81..9a38cbf233a1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1873,7 +1873,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  	struct btrfs_fs_devices *cur_devices;
>  	u64 num_devices;
>  	int ret = 0;
> -	bool clear_super = false;
>  
>  	mutex_lock(&uuid_mutex);
>  
> @@ -1909,7 +1908,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  		list_del_init(&device->dev_alloc_list);
>  		device->fs_devices->rw_devices--;
>  		mutex_unlock(&fs_info->chunk_mutex);
> -		clear_super = true;
>  	}
>  
>  	mutex_unlock(&uuid_mutex);
> @@ -4128,7 +4126,6 @@ static int btrfs_uuid_scan_kthread(void *data)
>  	struct btrfs_fs_info *fs_info = data;
>  	struct btrfs_root *root = fs_info->tree_root;
>  	struct btrfs_key key;
> -	struct btrfs_key max_key;
>  	struct btrfs_path *path = NULL;
>  	int ret = 0;
>  	struct extent_buffer *eb;
> @@ -4147,10 +4144,6 @@ static int btrfs_uuid_scan_kthread(void *data)
>  	key.type = BTRFS_ROOT_ITEM_KEY;
>  	key.offset = 0;
>  
> -	max_key.objectid = (u64)-1;
> -	max_key.type = BTRFS_ROOT_ITEM_KEY;
> -	max_key.offset = (u64)-1;
> -
>  	while (1) {
>  		ret = btrfs_search_forward(root, &key, path, 0);
>  		if (ret) {
> @@ -6452,7 +6445,6 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  	struct extent_map *em;
>  	u64 logical;
>  	u64 length;
> -	u64 stripe_len;
>  	u64 devid;
>  	u8 uuid[BTRFS_UUID_SIZE];
>  	int num_stripes;
> @@ -6461,7 +6453,6 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  
>  	logical = key->offset;
>  	length = btrfs_chunk_length(leaf, chunk);
> -	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
>  	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
>  
>  	ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
