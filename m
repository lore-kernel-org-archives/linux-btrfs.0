Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:55047 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3JKSys (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 14:54:48 -0400
Message-ID: <525849B2.7080306@giantdisaster.de>
Date: Fri, 11 Oct 2013 20:55:46 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: "Geyslan G. Bem" <geyslan@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6] btrfs: Fix memory leakage in the tree-log.c
References: <1381516545-27786-1-git-send-email-geyslan@gmail.com>
In-Reply-To: <1381516545-27786-1-git-send-email-geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/11/2013 20:35, Geyslan G. Bem wrote:
> In add_inode_ref() function:
>
> Initializes local pointers.
>
> Reduces the logical condition with the __add_inode_ref() return
> value by using only one 'goto out'.
>
> Centralizes the exiting, ensuring the freeing of all used memory.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>   fs/btrfs/tree-log.c | 33 +++++++++++++++++++--------------
>   1 file changed, 19 insertions(+), 14 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 79f057c..61bb051 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -1113,11 +1113,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>   				  struct extent_buffer *eb, int slot,
>   				  struct btrfs_key *key)
>   {
> -	struct inode *dir;
> -	struct inode *inode;
> +	struct inode *dir = NULL;
> +	struct inode *inode = NULL;
>   	unsigned long ref_ptr;
>   	unsigned long ref_end;
> -	char *name;
> +	char *name = NULL;
>   	int namelen;
>   	int ret;
>   	int search_done = 0;
> @@ -1150,13 +1150,15 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>   	 * care of the rest
>   	 */
>   	dir = read_one_inode(root, parent_objectid);
> -	if (!dir)
> -		return -ENOENT;
> +	if (!dir) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
>
>   	inode = read_one_inode(root, inode_objectid);
>   	if (!inode) {
> -		iput(dir);
> -		return -EIO;
> +		ret = -EIO;
> +		goto out;
>   	}
>
>   	while (ref_ptr < ref_end) {
> @@ -1169,14 +1171,16 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>   			 */
>   			if (!dir)
>   				dir = read_one_inode(root, parent_objectid);
> -			if (!dir)
> -				return -ENOENT;
> +			if (!dir) {
> +				ret = -ENOENT;
> +				goto out;
> +			}
>   		} else {
>   			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
>   					     &ref_index);
>   		}
>   		if (ret)
> -			return ret;
> +			goto out;
>
>   		/* if we already have a perfect match, we're done */
>   		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
> @@ -1196,12 +1200,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>   						      parent_objectid,
>   						      ref_index, name, namelen,
>   						      &search_done);
> -				if (ret == 1) {
> -					ret = 0;
> +				if (ret) {
> +					if (ret == 1)
> +						ret = 0;
>   					goto out;
>   				}
> -				if (ret)
> -					goto out;
>   			}
>
>   			/* insert our name */
> @@ -1215,6 +1218,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>
>   		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
>   		kfree(name);
> +		name = NULL;
>   		if (log_ref_ver) {
>   			iput(dir);
>   			dir = NULL;
> @@ -1225,6 +1229,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>   	ret = overwrite_item(trans, root, path, eb, slot, key);
>   out:
>   	btrfs_release_path(path);
> +	kfree(name);
>   	iput(dir);
>   	iput(inode);
>   	return ret;
>

The patch looks really good now. Thanks!

Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>


