Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40055 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751247AbdGLWEa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:04:30 -0400
Date: Thu, 13 Jul 2017 00:03:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix data races in btrfs-image.
Message-ID: <20170712220316.GN2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712200510.18753-1-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712200510.18753-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 01:05:10PM -0700, Adam Buchbinder wrote:
> Making the code data-race safe requires that reads *and* writes
> happen under a mutex lock, if any of the access are writes. See
> Dmitri Vyukov, "Benign data races: what could possibly go wrong?"
> for more details.
> 
> The fix here was to put most of the main loop of restore_worker
> under a mutex lock.
> 
> This race was detected using fsck-tests/012-leaf-corruption.
> 
> ==================
> WARNING: ThreadSanitizer: data race
>   Write of size 4 by main thread:
>     #0 add_cluster btrfs-progs/image/main.c:1931
>     #1 restore_metadump btrfs-progs/image/main.c:2566
>     #2 main btrfs-progs/image/main.c:2859
> 
>   Previous read of size 4 by thread T6:
>     #0 restore_worker btrfs-progs/image/main.c:1720
> 
>   Location is stack of main thread.
> 
>   Thread T6 (running) created by main thread at:
>     #0 pthread_create <null>
>     #1 mdrestore_init btrfs-progs/image/main.c:1868
>     #2 restore_metadump btrfs-progs/image/main.c:2534
>     #3 main btrfs-progs/image/main.c:2859
> 
> SUMMARY: ThreadSanitizer: data race btrfs-progs/image/main.c:1931 in
> add_cluster
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Applied, thanks.

> ---
>  image/main.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/image/main.c b/image/main.c
> index 1eca414..a5d01d8 100644
> --- a/image/main.c
> +++ b/image/main.c
> @@ -1715,14 +1715,15 @@ static void *restore_worker(void *data)
>  		}
>  		async = list_entry(mdres->list.next, struct async_work, list);
>  		list_del_init(&async->list);
> -		pthread_mutex_unlock(&mdres->mutex);
>  
>  		if (mdres->compress_method == COMPRESS_ZLIB) {
>  			size = compress_size; 
> +			pthread_mutex_unlock(&mdres->mutex);
>  			ret = uncompress(buffer, (unsigned long *)&size,
>  					 async->buffer, async->bufsize);
> +			pthread_mutex_lock(&mdres->mutex);
>  			if (ret != Z_OK) {
> -				error("decompressiion failed with %d", ret);
> +				error("decompression failed with %d", ret);

The typo fixes belong to a separate patch, as they fix a different
problem. We stick to the same style as in kernel "one patch per logical
change", so I'll split them to another patch as it's fairly trivial.

>  				err = -EIO;
>  			}
>  			outbuf = buffer;
> @@ -1798,7 +1799,6 @@ error:
>  		if (!mdres->multi_devices && async->start == BTRFS_SUPER_INFO_OFFSET)
>  			write_backup_supers(outfd, outbuf);
>  
> -		pthread_mutex_lock(&mdres->mutex);
>  		if (err && !mdres->error)
>  			mdres->error = err;
>  		mdres->num_items--;
> @@ -1899,7 +1899,7 @@ static int fill_mdres_info(struct mdrestore_struct *mdres,
>  		ret = uncompress(buffer, (unsigned long *)&size,
>  				 async->buffer, async->bufsize);
>  		if (ret != Z_OK) {
> -			error("decompressiion failed with %d", ret);
> +			error("decompression failed with %d", ret);
>  			free(buffer);
>  			return -EIO;
>  		}
> @@ -1928,7 +1928,9 @@ static int add_cluster(struct meta_cluster *cluster,
>  	u32 i, nritems;
>  	int ret;
>  
> +	pthread_mutex_lock(&mdres->mutex);
>  	mdres->compress_method = header->compress;
> +	pthread_mutex_unlock(&mdres->mutex);
>  
>  	bytenr = le64_to_cpu(header->bytenr) + BLOCK_SIZE;
>  	nritems = le32_to_cpu(header->nritems);
> @@ -2171,7 +2173,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
>  				continue;
>  			}
>  			error(
> -	"unknown state after reading cluster at %llu, probably crrupted data",
> +	"unknown state after reading cluster at %llu, probably corrupted data",
>  					cluster_bytenr);
>  			ret = -EIO;
>  			break;
> @@ -2220,7 +2222,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
>  						 (unsigned long *)&size, tmp,
>  						 bufsize);
>  				if (ret != Z_OK) {
> -					error("decompressiion failed with %d",
> +					error("decompression failed with %d",
>  							ret);
>  					ret = -EIO;
>  					break;
> @@ -2340,7 +2342,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
>  		ret = uncompress(tmp, (unsigned long *)&size,
>  				 buffer, le32_to_cpu(item->size));
>  		if (ret != Z_OK) {
> -			error("decompressiion failed with %d", ret);
> +			error("decompression failed with %d", ret);
>  			free(buffer);
>  			free(tmp);
>  			return -EIO;
> -- 
> 2.13.2.932.g7449e964c-goog
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
