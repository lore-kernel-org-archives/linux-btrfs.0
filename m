Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751535AbdFAJx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:53:56 -0400
Subject: Re: [PATCH v2 3/9] btrfs: Check name len on add_inode_ref call path
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
 <20170601085716.25898-4-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <08abcc0c-c17c-23e9-96e6-48c48a287a83@suse.com>
Date: Thu, 1 Jun 2017 12:53:53 +0300
MIME-Version: 1.0
In-Reply-To: <20170601085716.25898-4-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.06.2017 11:57, Su Yue wrote:
> 'add_inode_ref' calls 'ref_get_fields' and 'extref_get_fields' to read
> ref/extref name. Check namelen before read in those two.
> 
> The call path also includes 'btrfs_match_dir_item_name' to read
> dir_item name in the parent dir.
> Change it to verify every dir item while doing matches.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/dir-item.c |  4 ++--
>  fs/btrfs/tree-log.c | 27 ++++++++++++++++++---------
>  2 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index f9d1ca76ca04..38dc5176cc5b 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -395,8 +395,6 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
>  
>  	leaf = path->nodes[0];
>  	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
> -	if (verify_dir_item(fs_info, leaf, path->slots[0], dir_item))
> -		return NULL;
>  
>  	total_len = btrfs_item_size_nr(leaf, path->slots[0]);
>  	while (cur < total_len) {
> @@ -405,6 +403,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
>  			btrfs_dir_data_len(leaf, dir_item);
>  		name_ptr = (unsigned long)(dir_item + 1);
>  
> +		if (verify_dir_item(fs_info, leaf, path->slots[0], dir_item))
> +			return NULL;
>  		if (btrfs_dir_name_len(leaf, dir_item) == name_len &&
>  		    memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)
>  			return dir_item;
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1930f28edcdd..7d98858df44f 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -1175,15 +1175,19 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> -static int extref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
> -			     u32 *namelen, char **name, u64 *index,
> -			     u64 *parent_objectid)
> +static int extref_get_fields(struct extent_buffer *eb, int slot,
> +			     unsigned long ref_ptr, u32 *namelen, char **name,
> +			     u64 *index, u64 *parent_objectid)
>  {
>  	struct btrfs_inode_extref *extref;
>  
>  	extref = (struct btrfs_inode_extref *)ref_ptr;
>  
>  	*namelen = btrfs_inode_extref_name_len(eb, extref);
> +	if (!btrfs_is_namelen_valid(eb, slot, (unsigned long)&extref->name,
> +				    *namelen))
> +		return -EIO;
> +
>  	*name = kmalloc(*namelen, GFP_NOFS);
>  	if (*name == NULL)
>  		return -ENOMEM;
> @@ -1198,14 +1202,19 @@ static int extref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
>  	return 0;
>  }
>  
> -static int ref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
> -			  u32 *namelen, char **name, u64 *index)
> +static int ref_get_fields(struct extent_buffer *eb, int slot,
> +			  unsigned long ref_ptr, u32 *namelen, char **name,
> +			  u64 *index)
>  {
>  	struct btrfs_inode_ref *ref;
>  
>  	ref = (struct btrfs_inode_ref *)ref_ptr;
>  
>  	*namelen = btrfs_inode_ref_name_len(eb, ref);
> +	if (!btrfs_is_namelen_valid(eb, slot, (unsigned long)(ref + 1),
> +				    *namelen))
> +		return -EIO;

I'd like to use this to raise a point - shouldn't btrfs actually try to
utilize a bit more the EUCLEAN error code. Both xfs/ext4 do define their
EFSCORRUPTED to EUCLEAN and signal that a structure is corrupted and
needs cleaning. Presumably when we btrfs_is_namelen_valid fails (or
other validation function) this means the data on=disk is corrupted
rather than there was an error during I/O which -EIO implies. Currently
btrfs uses EUCLEAN in only 3 instances in disk-io.c I'd like to solicit
opinions from other developers what their take on that is?


> +
>  	*name = kmalloc(*namelen, GFP_NOFS);
>  	if (*name == NULL)
>  		return -ENOMEM;
> @@ -1280,8 +1289,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  
>  	while (ref_ptr < ref_end) {
>  		if (log_ref_ver) {
> -			ret = extref_get_fields(eb, ref_ptr, &namelen, &name,
> -						&ref_index, &parent_objectid);
> +			ret = extref_get_fields(eb, slot, ref_ptr, &namelen,
> +					  &name, &ref_index, &parent_objectid);
>  			/*
>  			 * parent object can change from one array
>  			 * item to another.
> @@ -1293,8 +1302,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  				goto out;
>  			}
>  		} else {
> -			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
> -					     &ref_index);
> +			ret = ref_get_fields(eb, slot, ref_ptr, &namelen,
> +					     &name, &ref_index);
>  		}
>  		if (ret)
>  			goto out;
> 
