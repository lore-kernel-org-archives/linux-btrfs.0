Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48486 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3LPMiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 07:38:55 -0500
Received: by mail-pb0-f45.google.com with SMTP id rp16so5417776pbb.32
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 04:38:55 -0800 (PST)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 3/3] btrfs_progs: handle error in the btrfs_prepare_device
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1387197239-29893-3-git-send-email-anand.jain@oracle.com>
Date: Mon, 16 Dec 2013 20:38:49 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <93924585-F0F1-4BA8-880D-E9D27EF2C2CD@gmail.com>
References: <1387197239-29893-1-git-send-email-anand.jain@oracle.com> <1387197239-29893-3-git-send-email-anand.jain@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand,

s/btrfs_progs/btrfs-progs?

more comments below¡­

> this patch will handle the strerror reporting of the error instead of
> printing errno,  and also replaced the BUG_ON with the error handling
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> cmds-device.c  |  7 +++----
> cmds-replace.c | 10 ++++------
> mkfs.c         |  9 ++++++++-
> utils.c        | 30 +++++++++++++++++++-----------
> 4 files changed, 34 insertions(+), 22 deletions(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index bc4a8dc..ada0bcd 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -111,13 +111,11 @@ static int cmd_add_dev(int argc, char **argv)
> 
> 		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count,
> 					   0, &mixed, discard);
> +		close(devfd);
> 		if (res) {
> -			fprintf(stderr, "ERROR: Unable to init '%s'\n", argv[i]);
> -			close(devfd);
> 			ret++;
> -			continue;
> +			goto error_out;
> 		}
> -		close(devfd);
> 
> 		strncpy_null(ioctl_args.name, argv[i]);
> 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
> @@ -130,6 +128,7 @@ static int cmd_add_dev(int argc, char **argv)
> 
> 	}
> 
> +error_out:
> 	close_file_or_dir(fdmnt, dirstream);
> 	return !!ret;
> }
> diff --git a/cmds-replace.c b/cmds-replace.c
> index d9b0940..8160107 100644
> --- a/cmds-replace.c
> +++ b/cmds-replace.c
> @@ -276,13 +276,11 @@ static int cmd_start_replace(int argc, char **argv)
> 	}
> 	strncpy((char *)start_args.start.tgtdev_name, dstdev,
> 		BTRFS_DEVICE_PATH_NAME_MAX);
> -	if (btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
> -				 &mixed, 0)) {
> -		fprintf(stderr, "Error: Failed to prepare device '%s'\n",
> -			dstdev);
> -		goto leave_with_error;
> -	}
> +	ret = btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
> +				 &mixed, 0);
> 	close(fddstdev);
> +	if (ret)
> +		goto leave_with_error;
> 	fddstdev = -1;
> 
> 	dev_replace_handle_sigint(fdmnt);
> diff --git a/mkfs.c b/mkfs.c
> index 33369f9..18df087 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1446,6 +1446,10 @@ int main(int ac, char **av)
> 		first_file = file;
> 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
> 					   block_count, &mixed, discard);
> +		if (ret) {
> +			close(fd);
> +			exit(1);
> +		}
> 		if (block_count && block_count > dev_block_count) {
> 			fprintf(stderr, "%s is smaller than requested size\n", file);
> 			exit(1);
> @@ -1553,8 +1557,11 @@ int main(int ac, char **av)
> 		}
> 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
> 					   block_count, &mixed, discard);
> +		if (ret) {
> +			close(fd);
> +			exit(1);
> +		}
> 		mixed = old_mixed;
> -		BUG_ON(ret);
> 
> 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
> 					sectorsize, sectorsize, sectorsize);
> diff --git a/utils.c b/utils.c
> index f499023..85b967b 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -581,13 +581,13 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
> 	ret = fstat(fd, &st);
> 	if (ret < 0) {
> 		fprintf(stderr, "unable to stat %s\n", file);
> -		exit(1);
> +		return 1;
> 	}
> 
> 	block_count = btrfs_device_size(fd, &st);
> 	if (block_count == 0) {
> 		fprintf(stderr, "unable to find %s size\n", file);
> -		exit(1);
> +		return 1;
> 	}
> 	if (max_block_count)
> 		block_count = min(block_count, max_block_count);
> @@ -612,26 +612,34 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
> 	}
> 
> 	ret = zero_dev_start(fd);
> -	if (ret) {
> -		fprintf(stderr, "failed to zero device start %d\n", ret);
> -		exit(1);
> -	}
> +	if (ret)
> +		goto zero_dev_error;
> 
> 	for (i = 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> 		bytenr = btrfs_sb_offset(i);
> 		if (bytenr >= block_count)
> 			break;
> -		zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
> +		ret = zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
> +		if (ret)
> +			goto zero_dev_error;
> 	}
> 
> 	if (zero_end) {
> 		ret = zero_dev_end(fd, block_count);
> -		if (ret) {
> -			fprintf(stderr, "failed to zero device end %d\n", ret);
> -			exit(1);
> -		}
> +		if (ret)
> +			goto zero_dev_error;
> 	}
> 	*block_count_ret = block_count;
> +
> +zero_dev_error:
> +	if (ret) {
> +		ret < 0 ?
> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %s\n",
> +			file, strerror(-ret)) :
> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %d\n",
> +			file, ret);

Why we output message twice here¡­.

Thanks,
Wang
> +		return 1;
> +	}
> 	return 0;
> }
> 
> -- 
> 1.8.1.164.g2d0029e
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

