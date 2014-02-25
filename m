Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbaBYR1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 12:27:10 -0500
Date: Tue, 25 Feb 2014 18:27:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: latest_devid is not always the probed
 devid
Message-ID: <20140225172709.GZ16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1393242219-18525-1-git-send-email-Anand.Jain@oracle.com>
 <1393242219-18525-2-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393242219-18525-2-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 07:43:38PM +0800, Anand Jain wrote:
> @@ -1646,6 +1646,11 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  	memset(fi_args, 0, sizeof(*fi_args));
>  
>  	if (is_block_device(path)) {
> +
> +		struct btrfs_super_block *disk_super;
> +		char *buf;
> +		u64 devid;
> +
>  		/* Ensure it's mounted, then set path to the mountpoint */
>  		fd = open(path, O_RDONLY);
>  		if (fd < 0) {
> @@ -1665,8 +1670,23 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		path = mp;
>  		/* Only fill in this one device */
>  		fi_args->num_devices = 1;
> -		fi_args->max_id = fs_devices_mnt->latest_devid;
> -		i = fs_devices_mnt->latest_devid;
> +
> +		buf = malloc(4096);
> +		if (!buf) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		disk_super = (struct btrfs_super_block *)buf;
> +		ret = btrfs_read_dev_super(fd, disk_super, BTRFS_SUPER_INFO_OFFSET);
> +		if (ret < 0) {
> +			ret = -EIO;
> +			goto out;
> +		}
> +		devid = btrfs_stack_device_id(&disk_super->dev_item);
> +
> +		fi_args->max_id = devid;
> +		i = devid;
> +
>  		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
>  		close(fd);

This is leaking memory, but as this is userspace code we can use the
staack for the superblock. I've committed this with the following fixup:

--- a/utils.c
+++ b/utils.c
@@ -1680,7 +1680,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
        if (is_block_device(path)) {

                struct btrfs_super_block *disk_super;
-               char *buf;
+               char buf[BTRFS_SUPER_INFO_SIZE];
                u64 devid;

                /* Ensure it's mounted, then set path to the mountpoint */
@@ -1703,11 +1703,6 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
                /* Only fill in this one device */
                fi_args->num_devices = 1;

-               buf = malloc(4096);
-               if (!buf) {
-                       ret = -ENOMEM;
-                       goto out;
-               }
                disk_super = (struct btrfs_super_block *)buf;
                ret = btrfs_read_dev_super(fd, disk_super, BTRFS_SUPER_INFO_OFFSET);
                if (ret < 0) {

