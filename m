Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab3CRVfY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 17:35:24 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 250B9A522B
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 22:35:23 +0100 (CET)
Date: Mon, 18 Mar 2013 22:35:23 +0100
From: Jan Kara <jack@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] btrfs-progs: convert: access name_len and file_type
 the old way
Message-ID: <20130318213523.GE7852@quack.suse.cz>
References: <20130318152151.GA28508@quack.suse.cz>
 <1363631971-2929-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363631971-2929-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon 18-03-13 19:39:31, David Sterba wrote:
> We can't use ext2_dir_entry_2 typecast on big endian machines directly.
> The bytes do not get converted during extX block read due to missing
> flag EXT2_DIRBLOCK_V2_STRUCT passed down to ext2fs_read_dir_block4 from
> ext2fs_process_dir_block. Fixing on the ext2 side needs updating callers
> and (maybe) the library interfaces. We'll fix it on the convert side for
> now.
> 
> CC: Jan Kara <jack@suse.cz>
> Signed-off-by: David Sterba <dsterba@suse.cz>
  Yes, now the patch looks OK to me.

									Honza

> ---
> 
> v2:
> - use v1 ext2_dir_entry everywhere
> - fix remaining incorrect uses of dirent->name_len
> 
>  convert.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/convert.c b/convert.c
> index f462597..399856f 100644
> --- a/convert.c
> +++ b/convert.c
> @@ -252,7 +252,7 @@ static u8 filetype_conversion_table[EXT2_FT_MAX] = {
>  };
>  
>  static int dir_iterate_proc(ext2_ino_t dir, int entry,
> -			    struct ext2_dir_entry *old,
> +			    struct ext2_dir_entry *dirent,
>  			    int offset, int blocksize,
>  			    char *buf,void *priv_data)
>  {
> @@ -262,12 +262,14 @@ static int dir_iterate_proc(ext2_ino_t dir, int entry,
>          u64 inode_size;
>  	char dotdot[] = "..";
>  	struct btrfs_key location;
> -	struct ext2_dir_entry_2 *dirent = (struct ext2_dir_entry_2 *)old;
>  	struct dir_iterate_data *idata = (struct dir_iterate_data *)priv_data;
> +	int name_len;
> +
> +	name_len = dirent->name_len & 0xFF;
>  
>  	objectid = dirent->inode + INO_OFFSET;
> -	if (!strncmp(dirent->name, dotdot, dirent->name_len)) {
> -		if (dirent->name_len == 2) {
> +	if (!strncmp(dirent->name, dotdot, name_len)) {
> +		if (name_len == 2) {
>  			BUG_ON(idata->parent != 0);
>  			idata->parent = objectid;
>  		}
> @@ -280,24 +282,24 @@ static int dir_iterate_proc(ext2_ino_t dir, int entry,
>  	location.offset = 0;
>  	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
>  
> -	file_type = dirent->file_type;
> +	file_type = dirent->name_len >> 8;
>  	BUG_ON(file_type > EXT2_FT_SYMLINK);
>  	ret = btrfs_insert_dir_item(idata->trans, idata->root,
> -				    dirent->name, dirent->name_len,
> +				    dirent->name, name_len,
>  				    idata->objectid, &location,
>  				    filetype_conversion_table[file_type],
>  				    idata->index_cnt);
>  	if (ret)
>  		goto fail;
>  	ret = btrfs_insert_inode_ref(idata->trans, idata->root,
> -				     dirent->name, dirent->name_len,
> +				     dirent->name, name_len,
>  				     objectid, idata->objectid,
>  				     idata->index_cnt);
>  	if (ret)
>  		goto fail;
>  	idata->index_cnt++;
>  	inode_size = btrfs_stack_inode_size(idata->inode) +
> -		     dirent->name_len * 2;
> +		     name_len * 2;
>  	btrfs_set_stack_inode_size(idata->inode, inode_size);
>  	return 0;
>  fail:
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
