Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab3KTOS6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 09:18:58 -0500
Date: Wed, 20 Nov 2013 15:18:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fusionio.com
Subject: Re: [PATCH v4 2/3] btrfs-progs: fs show should handle if subvol(s)
 mounted
Message-ID: <20131120141856.GH5007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384514735-24761-1-git-send-email-anand.jain@oracle.com>
 <1384514735-24761-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384514735-24761-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 07:25:34PM +0800, Anand Jain wrote:
>  static int btrfs_scan_kernel(void *search)
>  {
> -	int ret = 0, fd;
> -	FILE *f;
> -	struct mntent *mnt;
> -	struct btrfs_ioctl_fs_info_args fs_info_arg;
> -	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
> -	struct btrfs_ioctl_space_args *space_info_arg;
> +	int ret = 0;
>  	char label[BTRFS_LABEL_SIZE];
> -
> -	f = setmntent("/proc/self/mounts", "r");
> -	if (f == NULL)
> -		return 1;
> -
> -	memset(label, 0, sizeof(label));
> -	while ((mnt = getmntent(f)) != NULL) {
> -		if (strcmp(mnt->mnt_type, "btrfs"))
> +	char mnt[BTRFS_PATH_NAME_MAX + 1];
> +	struct btrfs_ioctl_fslist *fslist;
> +	struct btrfs_ioctl_fslist *fslist_saved;

    [CC]     cmds-send.o
cmds-filesystem.c: In function ‘btrfs_scan_kernel’:
cmds-filesystem.c:461:29: warning: variable ‘fslist_saved’ set but not used [-Wunused-but-set-variable]

> +	u64 cnt_fs;
> +	int cnt_mnt;
> +	__u8 *fsid;
> +	__u64 flags;
> +
> +	ret = get_fslist(&fslist, &cnt_fs);
> +	if (ret)
> +		return ret;
> +	fslist_saved = fslist;
> +	while (cnt_fs--) {
> +		fsid = fslist->fsid;
> +		flags = fslist->flags;
> +		fslist++;
> +		if (!(flags & BTRFS_FS_MOUNTED))
>  			continue;
> -		ret = get_fs_info(mnt->mnt_dir, &fs_info_arg,
> -				&dev_info_arg);
> +		memset(mnt, 0, BTRFS_PATH_NAME_MAX + 1);
> +		memset(label, 0, sizeof(label));
> +		ret = fsid_to_mntpt(fsid, mnt, &cnt_mnt);
>  		if (ret)
>  			return ret;
> -
> -		if (get_label_mounted(mnt->mnt_dir, label)) {
> -			kfree(dev_info_arg);
> +		if (get_label_mounted(mnt, label))
>  			return 1;
> -		}
> -		if (search && !match_search_item_kernel(fs_info_arg.fsid,
> -					mnt->mnt_dir, label, search)) {
> -			kfree(dev_info_arg);
> +
> +		if (search && !match_search_item_kernel(fsid,
> +					mnt, label, search))
>  			continue;
> -		}
>  
> -		fd = open(mnt->mnt_dir, O_RDONLY);
> -		if ((fd != -1) && !get_df(fd, &space_info_arg)) {
> -			print_one_fs(&fs_info_arg, dev_info_arg,
> -					space_info_arg, label, mnt->mnt_dir);
> -			kfree(space_info_arg);
> -			memset(label, 0, sizeof(label));
> -		}
> -		if (fd != -1)
> -			close(fd);
> -		kfree(dev_info_arg);
> +		handle_print(mnt, label);
>  		if (search)
>  			return 0;
>  	}
