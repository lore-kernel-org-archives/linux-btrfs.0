Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:57713 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3JKNBA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 09:01:00 -0400
Message-ID: <5257F687.6020802@giantdisaster.de>
Date: Fri, 11 Oct 2013 15:00:55 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: "Geyslan G. Bem" <geyslan@gmail.com>, chris.mason@fusionio.com
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbacik@fusionio.com, joe@perches.com, kernel-br@googlegroups.com
Subject: Re: [PATCH v5] btrfs: Fix memory leakage in the tree-log.c
References: <1381443082-7670-1-git-send-email-geyslan@gmail.com>
In-Reply-To: <1381443082-7670-1-git-send-email-geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 10 Oct 2013 19:11:22 -0300, Geyslan G. Bem wrote:
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

The patch looks correct to me, but there are some nitpicking style issues.


> ---
>  fs/btrfs/tree-log.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 79f057c..beb41b0 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -1113,11 +1113,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  				  struct extent_buffer *eb, int slot,
>  				  struct btrfs_key *key)
>  {
> -	struct inode *dir;
> -	struct inode *inode;
> +	struct inode *dir = NULL;
> +	struct inode *inode = NULL;
>  	unsigned long ref_ptr;
>  	unsigned long ref_end;
> -	char *name;
> +	char *name = NULL;
>  	int namelen;
>  	int ret;
>  	int search_done = 0;
> @@ -1150,13 +1150,15 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  	 * care of the rest
>  	 */
>  	dir = read_one_inode(root, parent_objectid);
> -	if (!dir)
> -		return -ENOENT;
> +	if (!dir) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
>  
>  	inode = read_one_inode(root, inode_objectid);
>  	if (!inode) {
> -		iput(dir);
> -		return -EIO;
> +		ret = -EIO;
> +		goto out;
>  	}
>  
>  	while (ref_ptr < ref_end) {
> @@ -1169,14 +1171,17 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  			 */
>  			if (!dir)
>  				dir = read_one_inode(root, parent_objectid);
> -			if (!dir)
> -				return -ENOENT;
> +			if (!dir) {
> +				ret = -ENOENT;
> +				goto out;
> +			}
>  		} else {
>  			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
>  					     &ref_index);
>  		}
>  		if (ret)
> -			return ret;
> +			goto out;
> +

This additional empty line is not required, we would have two empty
lines in a row.


>  
>  		/* if we already have a perfect match, we're done */
>  		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
> @@ -1196,12 +1201,12 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  						      parent_objectid,
>  						      ref_index, name, namelen,
>  						      &search_done);
> -				if (ret == 1) {
> -					ret = 0;
> +

This empty line is also not required. You know, this hurts on regular
80x24 terminals. Do you get more than 24 lines on your display?
I thought there was a rule for this in Documentation/CodingStyle, but
there isn't. Therefore it's up to you. But the two empty lines above are
definitely not wanted.


> +				if (ret) {
> +					if (ret == 1)
> +						ret--;

I don't see a reason to change the "ret = 0" to a "ret--", this is not
an optimization and makes the code less readable.


>  					goto out;
>  				}
> -				if (ret)
> -					goto out;
>  			}
>  
>  			/* insert our name */
> @@ -1215,6 +1220,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  
>  		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
>  		kfree(name);
> +		name = NULL;
> +

Another empty line which is not required for the purpose of this patch.


>  		if (log_ref_ver) {
>  			iput(dir);
>  			dir = NULL;
> @@ -1225,6 +1232,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  	ret = overwrite_item(trans, root, path, eb, slot, key);
>  out:
>  	btrfs_release_path(path);
> +	kfree(name);
>  	iput(dir);
>  	iput(inode);
>  	return ret;
> 


