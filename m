Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3GCRKB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 13:10:01 -0400
Date: Wed, 3 Jul 2013 19:09:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs-progs: add missing write check for mkfs
Message-ID: <20130703170959.GQ18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
 <1372593106-6593-2-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372593106-6593-2-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 30, 2013 at 12:51:44PM +0100, Filipe David Borba Manana wrote:
> Assert that the write of the device tree root succeeds.
> This verification is currently done for all other tree
> roots, however it was missing for the device tree root.
> 
> Would this tree root write fail, but all others succeed,
> it would lead to a corrupted/incomplete btrfs filesystem.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  utils.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/utils.c b/utils.c
> index 7b4cd74..43d93f1 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -381,6 +381,7 @@ int make_btrfs(int fd, const char *device, const char *label,
>  	btrfs_set_header_nritems(buf, nritems);
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
>  	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
> +	BUG_ON(ret != leafsize);

Please fix also the 2nd instance where the return value check is
missing

 344         btrfs_set_header_bytenr(buf, blocks[3]);
 345         btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
 346         btrfs_set_header_nritems(buf, nritems);
 347         csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 348         ret = pwrite(fd, buf->data, leafsize, blocks[3]);
 349
 350         /* create the device tree */
 351         memset(buf->data+sizeof(struct btrfs_header), 0,
 352                 leafsize-sizeof(struct btrfs_header));

>  
>  	/* create the FS root */
>  	memset(buf->data+sizeof(struct btrfs_header), 0,

Also, replacing the BUG_ON with something else would be nice of course.

thanks,
david
