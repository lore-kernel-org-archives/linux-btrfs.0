Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbaE2NEa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 09:04:30 -0400
Date: Thu, 29 May 2014 15:04:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 1/4] btrfs: dev delete should remove sysfs entry
Message-ID: <20140529130428.GC29992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
 <1401096626-13210-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401096626-13210-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 26, 2014 at 05:30:23PM +0800, Anand Jain wrote:
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -572,6 +572,26 @@ static void init_feature_attrs(void)
>  	}
>  }
>  
> +int rm_device_membership(struct btrfs_fs_info *fs_info,
> +		struct btrfs_device *one_device)

The name is too generic for a non-static function, so it would be good
to add at least the btrfs_ prefix. Same applies to the change of
'add_device_membership' in the next patch.

As this is only a trivial change, consider this
Reviewed-by: David Sterba <dsterba@suse.cz>

> +{
> +	struct hd_struct *disk;
> +	struct kobject *disk_kobj;
> +
> +	if (!fs_info->device_dir_kobj)
> +		return -EINVAL;
> +
> +	if (one_device) {
> +		disk = one_device->bdev->bd_part;
> +		disk_kobj = &part_to_dev(disk)->kobj;
> +
> +		sysfs_remove_link(fs_info->device_dir_kobj,
> +						disk_kobj->name);
> +	}
> +
> +	return 0;
> +}
> +
>  static int add_device_membership(struct btrfs_fs_info *fs_info)
>  {
>  	int error = 0;
