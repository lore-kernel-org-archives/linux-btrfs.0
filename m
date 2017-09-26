Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61028 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965798AbdIZM57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 08:57:59 -0400
Subject: Re: [PATCH v3 1/2] btrfs: undo writable when sprouting fails
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0ea2f1ae-4145-aa76-62a6-bdbbbeea9594@gmx.com>
Date: Tue, 26 Sep 2017 20:57:47 +0800
MIME-Version: 1.0
In-Reply-To: <20170926084135.3189-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170926084135.3189-1-anand.jain@oracle.com>
 <20170926084135.3189-2-anand.jain@oracle.com>



On 2017年09月26日 16:41, Anand Jain wrote:
> When new device is being added to seed FS, seed FS is marked writable,
> but when we fail to bring in the new device, we missed to undo the
> writable part. This patch fixes it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/volumes.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0e8f16c305df..9d64700cc9b6 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2501,6 +2501,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   	return ret;
>   
>   error_trans:
> +	if (seeding_dev)
> +		sb->s_flags |= MS_RDONLY;

Still the same question.

---
	if (seeding_dev) {
		mutex_unlock(&uuid_mutex);
		up_write(&sb->s_umount);

		if (ret) /* transaction commit */
			return ret;

		ret = btrfs_relocate_sys_chunks(fs_info);
		if (ret < 0)
			btrfs_handle_fs_error(fs_info, ret,
				    "Failed to relocate sys chunks after device initialization. This 
can be fixed using the \"btrfs balance\" command.");
		trans = btrfs_attach_transaction(root);
		if (IS_ERR(trans)) {
			if (PTR_ERR(trans) == -ENOENT)
				return 0;
			return PTR_ERR(trans);
		}
---
In the above btrfs_attch_transaction() error handler, which just 
returned without going to error_trans tags, did we misseed the s_flag 
revert thing?

Thanks,
Qu

>   	btrfs_end_transaction(trans);
>   	rcu_string_free(device->name);
>   	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
> 
