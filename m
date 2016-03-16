Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36156 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbcCPAXT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 20:23:19 -0400
Subject: Re: [Hit return to continue]
To: linux-btrfs@vger.kernel.org
References: <1458083583-8445-1-git-send-email-anand.jain@oracle.com>
Cc: dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56E8A76E.5020901@oracle.com>
Date: Wed, 16 Mar 2016 08:23:10 +0800
MIME-Version: 1.0
In-Reply-To: <1458083583-8445-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Uh! Where that title came from. Sorry about the title.
  I am resending.

-Anand

On 03/16/2016 07:13 AM, Anand Jain wrote:
> For the matter of completeness we need to check if the device
> being scanned has features that are known to the kernel. As of
> now if it doesn't - the mount will fails, then what is the point
> in having those devices added to the btrfs_fs_devices list at
> device_list_add().
>
> So block those devices at scan. Which means the original block at
> open_ctee() won't reach in case of device with unsupported feature.
> But I am leaving that code as it is, without deleting.
>
> Unit testing:
> Create progs with the following changes and mkfs.
> --------------------------------------------------
> diff --git a/ctree.h b/ctree.h
> index 5ab0f4a45a15..a8d86facc045 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -480,6 +480,7 @@ struct btrfs_super_block {
>   #define BTRFS_FEATURE_INCOMPAT_RAID56          (1ULL << 7)
>   #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA (1ULL << 8)
>   #define BTRFS_FEATURE_INCOMPAT_NO_HOLES                (1ULL << 9)
> +#define BTRFS_FEATURE_INCOMPAT_TEST            (1ULL << 10)
>
>   #define BTRFS_FEATURE_COMPAT_SUPP              0ULL
>
> @@ -495,7 +496,8 @@ struct btrfs_super_block {
>           BTRFS_FEATURE_INCOMPAT_RAID56 |                \
>           BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |          \
>           BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |       \
> -        BTRFS_FEATURE_INCOMPAT_NO_HOLES)
> +        BTRFS_FEATURE_INCOMPAT_NO_HOLES |              \
> +        BTRFS_FEATURE_INCOMPAT_TEST)
>
>   /*
>    * A leaf is full of items. offset and size tell us where to find
> diff --git a/mkfs.c b/mkfs.c
> index ea584042db16..f3665a93364b 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1368,7 +1368,7 @@ int main(int ac, char **av)
>          int dev_cnt = 0;
>          int saved_optind;
>          char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
> -       u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
> +       u64 features = BTRFS_MKFS_DEFAULT_FEATURES | BTRFS_FEATURE_INCOMPAT_TEST;
>          struct mkfs_allocation allocation = { 0 };
>          struct btrfs_mkfs_config mkfs_cfg;
> ------------------------------------------------------------
>
> Results..
>
> btrfs dev scan /dev/sdc
> Scanning for Btrfs filesystems in '/dev/sdc'
> ERROR: device scan failed '/dev/sdc' - Protocol family not supported
>
> btrfs dev ready /dev/sdc
> ERROR: unable to determine if device '/dev/sdc' is ready for mount: Protocol family not supported
>
> mount /dev/sdc /btrfs
> mount: mount /dev/sdc on /btrfs failed: Protocol family not supported
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/volumes.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6f7873e401ac..8ca3b0d3f1ef 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1071,6 +1071,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   	u64 transid;
>   	u64 total_devices;
>   	u64 bytenr;
> +	u64 features;
>
>   	/*
>   	 * we would like to check all the supers, but that would make
> @@ -1091,6 +1092,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
>   		goto error_bdev_put;
>
> +	features = btrfs_super_incompat_flags(disk_super) &
> +				~BTRFS_FEATURE_INCOMPAT_SUPP;
> +	if (features) {
> +		ret = -EPFNOSUPPORT;
> +		goto error_disk_super;
> +	}
>   	devid = btrfs_stack_device_id(&disk_super->dev_item);
>   	transid = btrfs_super_generation(disk_super);
>   	total_devices = btrfs_super_num_devices(disk_super);
> @@ -1105,6 +1112,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   	if (!ret && fs_devices_ret)
>   		(*fs_devices_ret)->total_devices = total_devices;
>
> +error_disk_super:
>   	btrfs_release_disk_super(page);
>
>   error_bdev_put:
>
