Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab3CRPVx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 11:21:53 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B415EA5200
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 16:21:51 +0100 (CET)
Date: Mon, 18 Mar 2013 16:21:51 +0100
From: Jan Kara <jack@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] btrfs-progs: convert: access name_len and file_type
 the old way
Message-ID: <20130318152151.GA28508@quack.suse.cz>
References: <1363363845-23318-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363363845-23318-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 15-03-13 17:10:45, David Sterba wrote:
> We can't use ext2_dir_entry_2 typecast on big endian machines directly.
> The bytes do not get converted during extX block read due to missing
> flag EXT2_DIRBLOCK_V2_STRUCT passed down to ext2fs_read_dir_block4 from
> ext2fs_process_dir_block. Fixing on the ext2 side needs updating callers
> and (maybe) the library interfaces. We'll fix it on the convert side for
> now.
> 
> CC: Jan Kara <jack@suse.cz>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  convert.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/convert.c b/convert.c
> index 400488e..7766c09 100644
> --- a/convert.c
> +++ b/convert.c
> @@ -264,10 +264,13 @@ static int dir_iterate_proc(ext2_ino_t dir, int entry,
>  	struct btrfs_key location;
>  	struct ext2_dir_entry_2 *dirent = (struct ext2_dir_entry_2 *)old;
  You may as well remove this and use 'old' everywhere. But technically the
patch is OK.

									Honza

>  	struct dir_iterate_data *idata = (struct dir_iterate_data *)priv_data;
> +	int name_len;
> +
> +	name_len = old->name_len & 0xFF;
>  
>  	objectid = dirent->inode + INO_OFFSET;
> -	if (!strncmp(dirent->name, dotdot, dirent->name_len)) {
> -		if (dirent->name_len == 2) {
> +	if (!strncmp(dirent->name, dotdot, name_len)) {
> +		if (name_len == 2) {
>  			BUG_ON(idata->parent != 0);
>  			idata->parent = objectid;
>  		}
> @@ -280,7 +283,7 @@ static int dir_iterate_proc(ext2_ino_t dir, int entry,
>  	location.offset = 0;
>  	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
>  
> -	file_type = dirent->file_type;
> +	file_type = old->name_len >> 8;
>  	BUG_ON(file_type > EXT2_FT_SYMLINK);
>  	ret = btrfs_insert_dir_item(idata->trans, idata->root,
>  				    dirent->name, dirent->name_len,
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
