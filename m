Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab3CKPDt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 11:03:49 -0400
Message-ID: <513DF252.8070109@redhat.com>
Date: Mon, 11 Mar 2013 10:03:46 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: use BTRFS_SCAN_BACKUP_SB flag in btrfs_scan_one_device
In-Reply-To: <1362756300-30212-4-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
 <1362756300-30212-4-git-send-email-anand.jain@oracle.com>

On 3/8/13 9:25 AM, Anand Jain wrote:
> bug:
> -------
> mkfs.btrfs /dev/sdb -f && yes| mkfs.ext4 /dev/sdb && mount /dev/sdb /ext4
> mkfs.btrfs -f /dev/sdc /dev/sdd (run twice)
> mkfs.btrfs -f /dev/sdc /dev/sdd
> ::
> ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
> ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
> adding device /dev/sdd id 2
> fs created label (null) on /dev/sdc
> 	nodesize 4096 leafsize 4096 sectorsize 4096 size 3.11GB
> --------
> 
> Since we run mkfs.btrfs twice above, there is already a stale
> btrfs when mkfs.btrfs is run for the 2nd time. which kicks in
> btrfs_scan_for_fsid() to perform a system-wide scan to find the
> stale btrfs's partner (to check if that by any chance is mounted)
> which in process comes across /dev/sdb. Now when it finds
> /dev/sdb it finds that primary SB is not present and we need
> to stop him there.
> This is done by NOT setting BTRFS_SCAN_BACKUP_SB for the function
> btrfs_scan_for_fsid(). To ensure rest of the logic is unaffected,
> this patch will ensure BTRFS_SCAN_BACKUP_SB is set for all other
> places except at check_mounted_where().

Thanks, this seems like progress in the right direction.

But that means that many other paths will still scan backups, right?

In the following case sdb1 is an ext4-mounted partition w/ a stale btrfs
backup superblock present in the middle.

# mount /dev/sdb1 /mnt/test
# mount | grep sdb1
/dev/sdb1 on /mnt/test type ext4 (rw)

# btrfs device scan /dev/sdb1
Scanning for Btrfs filesystems in '/dev/sdb1'
ERROR: unable to scan the device '/dev/sdb1' - Device or resource busy

Perhaps this is ok since we explicitly told it to scan an
ext4-mounted device.

[[But, then if I unmount it:

# btrfs device scan /dev/sdb1
Scanning for Btrfs filesystems in '/dev/sdb1'
ERROR: unable to scan the device '/dev/sdb1' - Invalid argument

weird, not sure where that came from.  :(  Unrelated to this question
though.]]

Also:

# btrfs filesystem show /dev/sdb1
Label: none  uuid: a96ea6e6-d3d5-444d-9aaf-057ec579dffe
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 4.00GB used 445.50MB path /dev/sdb1

whoa, ok, so it's a currently mounted ext4 device, but filesystem
show tells me it's btrfs?

How about this one:
# mount /dev/sdb1 /mnt/test
# mount | grep sdb1
/dev/sdb1 on /mnt/test type ext4 (rw)

# btrfs check /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: a96ea6e6-d3d5-444d-9aaf-057ec579dffe
checking extents
checking fs roots
checking root refs
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 22875
file data blocks allocated: 0
 referenced 0
Btrfs v0.20-rc1-194-g3deeb4c

So my mountged ext4 fs is also a perfectly consistent btrfs fs?

and I think the list goes on.

IMHO, nothing should be checking the backup superblocks unless explicitly
told to.  i.e. in e2fsprogs, e2fsck has:

       -b superblock
              Instead  of using the normal superblock, use an alternative
              superblock specified by superblock.

and debugfs has:

       -s superblock
              Causes the file system superblock to be read from the given
              block  number,  instead  of  using  the  primary superblock

I think the backups need to be used for explicit recovery (and maybe to
be checked once the primary has been confirmed) and never used during any
normal operation, if the first one is found to be missing.

-Eric



> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-device.c     | 3 ++-
>  cmds-filesystem.c | 2 +-
>  cmds-replace.c    | 3 ++-
>  disk-io.c         | 7 ++++---
>  find-root.c       | 5 +++--
>  utils.c           | 9 ++++++---
>  volumes.c         | 4 ++--
>  volumes.h         | 2 +-
>  8 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index 1b8f378..9447e7f 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -203,7 +203,8 @@ static int cmd_scan_dev(int argc, char **argv)
>  
>  		printf("Scanning for Btrfs filesystems\n");
>  		if(checklist)
> -			ret = btrfs_scan_block_devices(BTRFS_SCAN_REGISTER);
> +			ret = btrfs_scan_block_devices(BTRFS_SCAN_REGISTER|
> +						       BTRFS_SCAN_BACKUP_SB);
>  		else
>  			ret = btrfs_scan_one_dir("/dev", BTRFS_SCAN_REGISTER);
>  		if (ret){
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 2210020..d2e708d 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -257,7 +257,7 @@ static int cmd_show(int argc, char **argv)
>  		usage(cmd_show_usage);
>  
>  	if(checklist)
> -		ret = btrfs_scan_block_devices(0);
> +		ret = btrfs_scan_block_devices(BTRFS_SCAN_BACKUP_SB);
>  	else
>  		ret = btrfs_scan_one_dir("/dev", 0);
>  
> diff --git a/cmds-replace.c b/cmds-replace.c
> index 4cc32df..f6e1619 100644
> --- a/cmds-replace.c
> +++ b/cmds-replace.c
> @@ -275,7 +275,8 @@ static int cmd_start_replace(int argc, char **argv)
>  		goto leave_with_error;
>  	}
>  	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
> -				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
> +				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
> +				    BTRFS_SCAN_BACKUP_SB);
>  	if (ret >= 0 && !force_using_targetdev) {
>  		fprintf(stderr,
>  			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
> diff --git a/disk-io.c b/disk-io.c
> index 33e7e78..914b567 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -825,7 +825,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  	posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED);
>  
>  	ret = btrfs_scan_one_device(fp, path, &fs_devices,
> -				    &total_devs, sb_bytenr);
> +				    &total_devs, sb_bytenr,
> +				    BTRFS_SCAN_BACKUP_SB);
>  
>  	if (ret) {
>  		fprintf(stderr, "No valid Btrfs found on %s\n", path);
> @@ -834,7 +835,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  
>  	if (total_devs != 1) {
>  		ret = btrfs_scan_for_fsid(fs_devices, total_devs,
> -			BTRFS_SCAN_REGISTER);
> +			BTRFS_SCAN_REGISTER|BTRFS_SCAN_BACKUP_SB);
>  		if (ret)
>  			goto out;
>  	}
> @@ -1102,7 +1103,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
>  }
>  
>  int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
> -	u64 flags)
> +			 u64 flags)
>  {
>  	u8 fsid[BTRFS_FSID_SIZE];
>  	int fsid_is_initialized = 0;
> diff --git a/find-root.c b/find-root.c
> index c76de2b..40cacf1 100644
> --- a/find-root.c
> +++ b/find-root.c
> @@ -102,7 +102,8 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
>  	u64 features;
>  
>  	ret = btrfs_scan_one_device(fd, device, &fs_devices,
> -				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
> +				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
> +				    BTRFS_SCAN_BACKUP_SB);
>  
>  	if (ret) {
>  		fprintf(stderr, "No valid Btrfs found on %s\n", device);
> @@ -111,7 +112,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
>  
>  	if (total_devs != 1) {
>  		ret = btrfs_scan_for_fsid(fs_devices, total_devs,
> -			BTRFS_SCAN_REGISTER);
> +			BTRFS_SCAN_REGISTER|BTRFS_SCAN_BACKUP_SB);
>  		if (ret)
>  			goto out;
>  	}
> diff --git a/utils.c b/utils.c
> index feee572..95dee29 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -835,7 +835,8 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>  
>  	/* scan the initial device */
>  	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
> -				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
> +				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
> +				    BTRFS_SCAN_BACKUP_SB);
>  	is_btrfs = (ret >= 0);
>  
>  	/* scan other devices */
> @@ -1032,7 +1033,8 @@ again:
>  		}
>  		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
>  					    &num_devices,
> -					    BTRFS_SUPER_INFO_OFFSET);
> +					    BTRFS_SUPER_INFO_OFFSET,
> +					    BTRFS_SCAN_BACKUP_SB);
>  		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
>  			btrfs_register_one_device(fullpath);
>  		}
> @@ -1361,7 +1363,8 @@ scan_again:
>  		}
>  		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
>  					    &num_devices,
> -					    BTRFS_SUPER_INFO_OFFSET);
> +					    BTRFS_SUPER_INFO_OFFSET,
> +					    flags);
>  		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
>  			btrfs_register_one_device(fullpath);
>  		}
> diff --git a/volumes.c b/volumes.c
> index b6e3f29..e1795e3 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -212,7 +212,7 @@ fail:
>  
>  int btrfs_scan_one_device(int fd, const char *path,
>  			  struct btrfs_fs_devices **fs_devices_ret,
> -			  u64 *total_devs, u64 super_offset)
> +			  u64 *total_devs, u64 super_offset, u64 flags)
>  {
>  	struct btrfs_super_block *disk_super;
>  	char *buf;
> @@ -227,7 +227,7 @@ int btrfs_scan_one_device(int fd, const char *path,
>  	}
>  	disk_super = (struct btrfs_super_block *)buf;
>  	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
> -		BTRFS_SCAN_BACKUP_SB);
> +				flags);
>  	if (ret < 0) {
>  		ret = -EIO;
>  		goto error_brelse;
> diff --git a/volumes.h b/volumes.h
> index 911f788..f87aa5b 100644
> --- a/volumes.h
> +++ b/volumes.h
> @@ -179,7 +179,7 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
>  			struct btrfs_device *device);
>  int btrfs_scan_one_device(int fd, const char *path,
>  			  struct btrfs_fs_devices **fs_devices_ret,
> -			  u64 *total_devs, u64 super_offset);
> +			  u64 *total_devs, u64 super_offset, u64 flags);
>  int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
>  int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
>  			      struct btrfs_fs_devices *fs_devices);
> 

