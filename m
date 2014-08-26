Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29638 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbaHZI3y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 04:29:54 -0400
Message-ID: <53FC457B.5050703@oracle.com>
Date: Tue, 26 Aug 2014 16:29:47 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs-progs: remove BTRFS_SCAN_DEV and btrfs_scan_one_dir
References: <53F51F4D.2090203@redhat.com> <53F5201B.6030504@redhat.com>
In-Reply-To: <53F5201B.6030504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  :-( to see the entire btrfs_scan_one_dir() going away.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 21/08/2014 06:24, Eric Sandeen wrote:
> After the previous 2 patches, nothing uses
> whole-dev-tree scanning, so remove the code which
> implemented that functionality.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/utils.c b/utils.c
> index 12ed7a2..765a214 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1228,117 +1228,6 @@ void btrfs_register_one_device(char *fname)
>   	close(fd);
>   }
>
> -int btrfs_scan_one_dir(char *dirname, int run_ioctl)
> -{
> -	DIR *dirp = NULL;
> -	struct dirent *dirent;
> -	struct pending_dir *pending;
> -	struct stat st;
> -	int ret;
> -	int fd;
> -	int dirname_len;
> -	char *fullpath;
> -	struct list_head pending_list;
> -	struct btrfs_fs_devices *tmp_devices;
> -	u64 num_devices;
> -
> -	INIT_LIST_HEAD(&pending_list);
> -
> -	pending = malloc(sizeof(*pending));
> -	if (!pending)
> -		return -ENOMEM;
> -	strcpy(pending->name, dirname);
> -
> -again:
> -	dirname_len = strlen(pending->name);
> -	fullpath = malloc(PATH_MAX);
> -	dirname = pending->name;
> -
> -	if (!fullpath) {
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -	dirp = opendir(dirname);
> -	if (!dirp) {
> -		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
> -		ret = -errno;
> -		goto fail;
> -	}
> -	while(1) {
> -		dirent = readdir(dirp);
> -		if (!dirent)
> -			break;
> -		if (dirent->d_name[0] == '.')
> -			continue;
> -		if (dirname_len + strlen(dirent->d_name) + 2 > PATH_MAX) {
> -			ret = -EFAULT;
> -			goto fail;
> -		}
> -		snprintf(fullpath, PATH_MAX, "%s/%s", dirname, dirent->d_name);
> -		ret = lstat(fullpath, &st);
> -		if (ret < 0) {
> -			fprintf(stderr, "failed to stat %s\n", fullpath);
> -			continue;
> -		}
> -		if (S_ISLNK(st.st_mode))
> -			continue;
> -		if (S_ISDIR(st.st_mode)) {
> -			struct pending_dir *next = malloc(sizeof(*next));
> -			if (!next) {
> -				ret = -ENOMEM;
> -				goto fail;
> -			}
> -			strcpy(next->name, fullpath);
> -			list_add_tail(&next->list, &pending_list);
> -		}
> -		if (!S_ISBLK(st.st_mode)) {
> -			continue;
> -		}
> -		fd = open(fullpath, O_RDONLY);
> -		if (fd < 0) {
> -			/* ignore the following errors:
> -				ENXIO (device don't exists)
> -				ENOMEDIUM (No medium found ->
> -					like a cd tray empty)
> -			*/
> -			if(errno != ENXIO && errno != ENOMEDIUM)
> -				fprintf(stderr, "failed to read %s: %s\n",
> -					fullpath, strerror(errno));
> -			continue;
> -		}
> -		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
> -					    &num_devices,
> -					    BTRFS_SUPER_INFO_OFFSET, 0);
> -		if (ret == 0 && run_ioctl > 0) {
> -			btrfs_register_one_device(fullpath);
> -		}
> -		close(fd);
> -	}
> -	if (!list_empty(&pending_list)) {
> -		free(pending);
> -		pending = list_entry(pending_list.next, struct pending_dir,
> -				     list);
> -		free(fullpath);
> -		list_del(&pending->list);
> -		closedir(dirp);
> -		dirp = NULL;
> -		goto again;
> -	}
> -	ret = 0;
> -fail:
> -	free(pending);
> -	free(fullpath);
> -	while (!list_empty(&pending_list)) {
> -		pending = list_entry(pending_list.next, struct pending_dir,
> -				     list);
> -		list_del(&pending->list);
> -		free(pending);
> -	}
> -	if (dirp)
> -		closedir(dirp);
> -	return ret;
> -}
> -
>   int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>   				 int super_offset)
>   {
> @@ -2291,9 +2180,6 @@ int scan_for_btrfs(int where, int update_kernel)
>   	case BTRFS_SCAN_PROC:
>   		ret = btrfs_scan_block_devices(update_kernel);
>   		break;
> -	case BTRFS_SCAN_DEV:
> -		ret = btrfs_scan_one_dir("/dev", update_kernel);
> -		break;
>   	case BTRFS_SCAN_LBLKID:
>   		ret = btrfs_scan_lblkid(update_kernel);
>   		break;
> diff --git a/utils.h b/utils.h
> index 0c9b65f..3a05131 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -27,9 +27,8 @@
>   #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
>
>   #define BTRFS_SCAN_PROC		(1ULL << 0)
> -#define BTRFS_SCAN_DEV		(1ULL << 1)
> -#define BTRFS_SCAN_MOUNTED	(1ULL << 2)
> -#define BTRFS_SCAN_LBLKID	(1ULL << 3)
> +#define BTRFS_SCAN_MOUNTED	(1ULL << 1)
> +#define BTRFS_SCAN_LBLKID	(1ULL << 2)
>
>   #define BTRFS_UPDATE_KERNEL	1
>
> @@ -70,7 +69,6 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   		      u32 sectorsize);
>   int btrfs_scan_for_fsid(int run_ioctls);
>   void btrfs_register_one_device(char *fname);
> -int btrfs_scan_one_dir(char *dirname, int run_ioctl);
>   char *canonicalize_dm_name(const char *ptname);
>   char *canonicalize_path(const char *path);
>   int check_mounted(const char *devicename);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
