Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753041AbdGLWAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:00:04 -0400
Date: Wed, 12 Jul 2017 23:58:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix data race in btrfs-convert.
Message-ID: <20170712215850.GM2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712200538.18881-1-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712200538.18881-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 01:05:38PM -0700, Adam Buchbinder wrote:
> The status display was reading the state while the task was updating
> it. Use a mutex to prevent the race.
> 
> This race was detected using ThreadSanitizer and
> misc-tests/005-convert-progress-thread-crash.
> 
> ==================
> WARNING: ThreadSanitizer: data race
>   Write of size 8 by main thread:
>     #0 ext2_copy_inodes btrfs-progs/convert/source-ext2.c:853
>     #1 copy_inodes btrfs-progs/convert/main.c:145
>     #2 do_convert btrfs-progs/convert/main.c:1297
>     #3 main btrfs-progs/convert/main.c:1924
> 
>   Previous read of size 8 by thread T1:
>     #0 print_copied_inodes btrfs-progs/convert/main.c:124
> 
>   Location is stack of main thread.
> 
>   Thread T1 (running) created by main thread at:
>     #0 pthread_create <null>
>     #1 task_start btrfs-progs/task-utils.c:50
>     #2 do_convert btrfs-progs/convert/main.c:1295
>     #3 main btrfs-progs/convert/main.c:1924
> 
> SUMMARY: ThreadSanitizer: data race
> btrfs-progs/convert/source-ext2.c:853 in ext2_copy_inodes
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Thanks, patch applied, with some minor modifications.

> ---
>  convert/main.c        | 12 ++++++++++--
>  convert/source-ext2.c |  3 +++
>  convert/source-fs.h   |  3 +++
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/convert/main.c b/convert/main.c
> index c56382e..c9c1fd4 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -88,6 +88,7 @@
>  #include <fcntl.h>
>  #include <unistd.h>
>  #include <getopt.h>
> +#include <pthread.h>
>  #include <stdbool.h>
>  
>  #include "ctree.h"
> @@ -119,10 +120,12 @@ static void *print_copied_inodes(void *p)
>  	task_period_start(priv->info, 1000 /* 1s */);
>  	while (1) {
>  		count++;
> +		pthread_mutex_lock(&priv->mutex);
>  		printf("copy inodes [%c] [%10llu/%10llu]\r",
>  		       work_indicator[count % 4],
> -		       (unsigned long long)priv->cur_copy_inodes,
> -		       (unsigned long long)priv->max_copy_inodes);
> +		       (u64)priv->cur_copy_inodes,
> +		       (u64)priv->max_copy_inodes);

This needs to be unsigned long long to match %llu. We know that u64 will
always be equivalent, so there should not be any problem. With u64, the
compiler tends to warn. The cast is not necessary in kernel code, but I
don't know what magic has caused that, so we still use the ULL type cast
in progs.

> +		pthread_mutex_unlock(&priv->mutex);
>  		fflush(stdout);
>  		task_period_wait(priv->info);
>  	}
> @@ -1286,6 +1289,11 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
>  	}
>  
>  	printf("creating btrfs metadata");
> +	ret = pthread_mutex_init(&ctx.mutex, NULL);
> +	if (ret) {
> +		error("failed to init mutex: %d", ret);
> +		goto fail;
> +	}
>  	ctx.max_copy_inodes = (cctx.inodes_count - cctx.free_inodes_count);
>  	ctx.cur_copy_inodes = 0;
>  
> diff --git a/convert/source-ext2.c b/convert/source-ext2.c
> index 38c3cd3..4bce4b3 100644
> --- a/convert/source-ext2.c
> +++ b/convert/source-ext2.c
> @@ -18,6 +18,7 @@
>  
>  #include "kerncompat.h"
>  #include <linux/limits.h>
> +#include <pthread.h>
>  #include "disk-io.h"
>  #include "transaction.h"
>  #include "utils.h"
> @@ -850,7 +851,9 @@ static int ext2_copy_inodes(struct btrfs_convert_context *cctx,
>  		ret = ext2_copy_single_inode(trans, root,
>  					objectid, ext2_fs, ext2_ino,
>  					&ext2_inode, convert_flags);
> +		pthread_mutex_lock(&p->mutex);
>  		p->cur_copy_inodes++;
> +		pthread_mutex_unlock(&p->mutex);
>  		if (ret)
>  			return ret;
>  		if (trans->blocks_used >= 4096) {
> diff --git a/convert/source-fs.h b/convert/source-fs.h
> index ca32d15..7ae6edd 100644
> --- a/convert/source-fs.h
> +++ b/convert/source-fs.h
> @@ -17,6 +17,8 @@
>  #ifndef __BTRFS_CONVERT_SOURCE_FS_H__
>  #define __BTRFS_CONVERT_SOURCE_FS_H__
>  
> +#include <pthread.h>
> +
>  #include "kerncompat.h"

This is really minor, kerncompat should be always included first due to
potential clashes in type definitions.

>  #define CONV_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
> @@ -37,6 +39,7 @@ extern const struct simple_range btrfs_reserved_ranges[3];
>  struct task_info;
>  
>  struct task_ctx {
> +	pthread_mutex_t mutex;
>  	u64 max_copy_inodes;
>  	u64 cur_copy_inodes;
>  	struct task_info *info;
> -- 
> 2.13.2.932.g7449e964c-goog
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
