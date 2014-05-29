Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbaE2MyY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 08:54:24 -0400
Date: Thu, 29 May 2014 14:54:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 4/4] btrfs: create sprout should rename fsid on the sysfs
 as well
Message-ID: <20140529125422.GB29992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
 <1401096626-13210-5-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401096626-13210-5-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 26, 2014 at 05:30:26PM +0800, Anand Jain wrote:
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2084,6 +2084,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>  
>  	if (seeding_dev) {
> +		char fsid_buf[37];

Is there a symbolic constant available? We have one in userspace, but I
can't find one for kernel, only a few locally defined.

>  		ret = init_first_rw_device(trans, root, device);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, root, ret);
> @@ -2094,6 +2095,13 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  			btrfs_abort_transaction(trans, root, ret);
>  			goto error_trans;
>  		}
> +
> +		/* Sprouting would change fsid of the mounted root,
> +		 * so rename the fsid on the sysfs
> +		 */
> +		sprintf(fsid_buf, "%pU", root->fs_info->fsid);

Would be better do use snprintf explicitly.

> +		if (kobject_rename(&root->fs_info->super_kobj, fsid_buf))
> +			goto error_trans;
>  	} else {

Otherwise ok.
