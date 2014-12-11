Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23542 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932241AbaLKIhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:37:55 -0500
Message-ID: <548957E0.3010708@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 16:37:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <mwilck@arcor.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 09/18] btrfs restore: more graceful error handling in
 copy_file
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de> <1418244708-7087-10-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-10-git-send-email-mwilck@arcor.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 09/18] btrfs restore: more graceful error handling in 
copy_file
From: <mwilck@arcor.de>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月11日 04:51
> From: Martin Wilck <mwilck@arcor.de>
>
> Setting size and attributes of a file makes sense even if some
> errors have occured during revovery.
>
> Also, do something useful with the number of bytes written.
>
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>   cmds-restore.c |   27 ++++++++++++++-------------
>   1 files changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 8ecd896..10bb8be 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -715,7 +715,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
>   					return ret;
>   				} else if (ret) {
>   					/* No more leaves to search */
> -					btrfs_free_path(path);
> +					ret = 0;
>   					goto set_size;
>   				}
>   				leaf = path->nodes[0];
> @@ -734,35 +734,36 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
>   		if (compression >= BTRFS_COMPRESS_LAST) {
>   			fprintf(stderr, "Don't support compression yet %d\n",
>   				compression);
> -			btrfs_free_path(path);
> -			return -1;
> +			ret = -1;
Although the original one uses -1, IMHO it would be more meaningful 
using -ENOTTY.
If someone later adds stderr() for the ret and print it, the author will 
be graceful.
> +			goto set_size;
>   		}
>   
> +		bytes_written = 0ULL;
>   		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)
>   			goto next;
>   		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>   			ret = copy_one_inline(fd, path, found_key.offset,
>   					      &bytes_written);
> -			if (ret) {
> -				btrfs_free_path(path);
> -				return -1;
> -			}
>   		} else if (extent_type == BTRFS_FILE_EXTENT_REG) {
>   			ret = copy_one_extent(root, fd, leaf, fi,
>   					      found_key.offset, &bytes_written);
> -			if (ret) {
> -				btrfs_free_path(path);
> -				return ret;
> -			}
>   		} else {
>   			printf("Weird extent type %d\n", extent_type);
>   		}
> +		total_written += bytes_written;
> +		next_pos = found_key.offset + bytes_written;
> +		if (ret) {
> +			fprintf(stderr, "ERROR after writing %llu bytes\n",
> +				total_written);
Just a advice, what about add stderr(-ret) for the info?
> +			ret = -1;
Why change ret to -1? At least some of the ret above can be meaningful 
like -EIO or -ENOENT.
> +			goto set_size;
> +		}
>   next:
>   		path->slots[0]++;
>   	}
>   
> -	btrfs_free_path(path);
>   set_size:
> +	btrfs_free_path(path);
>   	if (get_xattrs) {
>   		ret = set_file_xattrs(root, key->objectid, fd, file);
>   		if (ret)
> @@ -771,7 +772,7 @@ set_size:
>   	}
>   
>   	set_fd_attrs(fd, &st, file);
> -	return 0;
> +	return ret;
>   }
>   
>   static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
Other part looks good for me.

Thanks,
Qu
