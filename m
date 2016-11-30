Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757922AbcK3ObR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 09:31:17 -0500
Date: Wed, 30 Nov 2016 15:31:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs-progs: Use helper functions to access
 btrfs_super_block->sys_chunk_array_size
Message-ID: <20161130143111.GL12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480431542-16889-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480431542-16889-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2016 at 08:29:02PM +0530, Chandan Rajendra wrote:
> btrfs_super_block->sys_chunk_array_size is stored as le32 data on
> disk. However insert_temp_chunk_item() writes sys_chunk_array_size in
> host cpu order. This commit fixes this by using super block access
> helper functions to read and write
> btrfs_super_block->sys_chunk_array_size field.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  utils.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/utils.c b/utils.c
> index d0189ad..7b17b20 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -562,14 +562,17 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
>  	 */
>  	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
>  		char *cur;
> +		u32 array_size;
>  
>  		cur = (char *)sb->sys_chunk_array + sb->sys_chunk_array_size;

This should also use the accessor, 'sb' is directly mapped to the buffer
read from disk.

>  		memcpy(cur, &disk_key, sizeof(disk_key));
>  		cur += sizeof(disk_key);
>  		read_extent_buffer(buf, cur, (unsigned long int)chunk,
>  				   btrfs_chunk_item_size(1));
> -		sb->sys_chunk_array_size += btrfs_chunk_item_size(1) +
> +		array_size = btrfs_super_sys_array_size(sb);
> +		array_size += btrfs_chunk_item_size(1) +
>  					    sizeof(disk_key);
> +		btrfs_set_super_sys_array_size(sb, array_size);
>  
>  		ret = write_temp_super(fd, sb, cfg->super_bytenr);
>  	}
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
