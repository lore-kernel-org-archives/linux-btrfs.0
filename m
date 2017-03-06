Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64800 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751710AbdCFAqC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Mar 2017 19:46:02 -0500
Subject: Re: [PATCH] btrfs-progs: report I/O errors when closing the
 filesystem
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <d187bd863a7eacb2172b693a95c6a8b875e144c4.1488560213.git.osandov@fb.com>
CC: <kernel-team@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <eee671a1-cbfb-be07-bc1c-b568da47f463@cn.fujitsu.com>
Date: Mon, 6 Mar 2017 08:40:54 +0800
MIME-Version: 1.0
In-Reply-To: <d187bd863a7eacb2172b693a95c6a8b875e144c4.1488560213.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/04/2017 12:59 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> If the final fsync() on the Btrfs device fails, we just swallow the
> error and don't alert the user in any way. This was uncovered by xfstest
> generic/405, which checks that mkfs fails when it encounters EIO.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  disk-io.c | 4 ++--
>  volumes.c | 9 +++++++--
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/disk-io.c b/disk-io.c
> index 2a94d4fc..48fb3c6b 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1817,10 +1817,10 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
>  	free_fs_roots_tree(&fs_info->fs_root_tree);
>
>  	btrfs_release_all_roots(fs_info);
> -	btrfs_close_devices(fs_info->fs_devices);
> +	ret = btrfs_close_devices(fs_info->fs_devices);
>  	btrfs_cleanup_all_caches(fs_info);
>  	btrfs_free_fs_info(fs_info);
> -	return 0;
> +	return ret;
>  }
>
>  int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> diff --git a/volumes.c b/volumes.c
> index a0a85edd..89335d35 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -160,6 +160,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  {
>  	struct btrfs_fs_devices *seed_devices;
>  	struct btrfs_device *device;
> +	int ret = 0;
>
>  again:
>  	if (!fs_devices)
> @@ -168,7 +169,11 @@ again:
>  		device = list_entry(fs_devices->devices.next,
>  				    struct btrfs_device, dev_list);
>  		if (device->fd != -1) {
> -			fsync(device->fd);
> +			if (fsync(device->fd) == -1) {
> +				warning("fsync on device %llu failed: %s",
> +					device->devid, strerror(errno));
> +				ret = -1;

-1 is -EINVAL, better using -errno here.

Despite of that, looks good.

Thanks,
Qu
> +			}
>  			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
>  				fprintf(stderr, "Warning, could not drop caches\n");
>  			close(device->fd);
> @@ -197,7 +202,7 @@ again:
>  		free(fs_devices);
>  	}
>
> -	return 0;
> +	return ret;
>  }
>
>  void btrfs_close_all_devices(void)
>


