Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:21848 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776Ab3EGIoG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 04:44:06 -0400
Message-ID: <5188BED5.3040201@giantdisaster.de>
Date: Tue, 07 May 2013 10:44:05 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: image: handle superblocks correctly on fs
 with big blocks
References: <1367874680-9502-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1367874680-9502-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon,  6 May 2013 23:11:20 +0200, David Sterba wrote:
> Superblock is always 4k, but metadata blocks may be larger. We have to
> use the appropriate block size when doing checksums, otherwise they're
> wrong.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  btrfs-image.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/btrfs-image.c b/btrfs-image.c
> index 188291c..dca7a28 100644
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -469,6 +469,16 @@ static int read_data_extent(struct metadump_struct *md,
>  	return 0;
>  }
>  
> +static int is_sb_offset(u64 offset) {
> +	switch (offset) {
> +		case 65536:
> +		case 67108864:
> +		case 274877906944:

Using btrfs_sb_offset() and an if statement would produce the same code
and would be more readable.
Additionally, the last huge number will cause a warning on 32-bit
systems, I assume.


> +			return 1;
> +	}
> +	return 0;
> +}
> +
>  static int flush_pending(struct metadump_struct *md, int done)
>  {
>  	struct async_work *async = NULL;
> @@ -506,7 +516,16 @@ static int flush_pending(struct metadump_struct *md, int done)
>  		}
>  
>  		while (!md->data && size > 0) {
> -			eb = read_tree_block(md->root, start, blocksize, 0);
> +			/*
> +			 * We must differentiate between superblock and
> +			 * metadata on filesystems with blocksize > 4k,
> +			 * otherwise the checksum fails for superblock
> +			 */
> +			int bs = blocksize;
> +
> +			if (is_sb_offset(start))
> +				bs = BTRFS_SUPER_INFO_SIZE;
> +			eb = read_tree_block(md->root, start, bs, 0);
>  			if (!eb) {
>  				free(async->buffer);
>  				free(async);
> @@ -516,9 +535,9 @@ static int flush_pending(struct metadump_struct *md, int done)
>  			}
>  			copy_buffer(async->buffer + offset, eb);
>  			free_extent_buffer(eb);
> -			start += blocksize;
> -			offset += blocksize;
> -			size -= blocksize;
> +			start += bs;
> +			offset += bs;
> +			size -= bs;
>  		}
>  
>  		md->pending_start = (u64)-1;
> 

