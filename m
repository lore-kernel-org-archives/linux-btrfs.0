Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58359 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933851AbdIYNDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 09:03:36 -0400
Subject: Re: [PATCH 1/3] btrfs: undo writable when sprouting fails
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170925123104.16526-2-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e1d2a7a4-3207-da8f-2cb0-f26bdf4e1685@gmx.com>
Date: Mon, 25 Sep 2017 21:03:22 +0800
MIME-Version: 1.0
In-Reply-To: <20170925123104.16526-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月25日 20:31, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

The error_trans tag needs to revert the RDONLY flag without doubt.


But just a small question.

Just lines before error_trans tag, we're committing transaction and then 
relocating system chunks.
In which we don't use goto error branch but returning directly.

Don't we need to to revert the RDONLY flag in that error handler?

Thanks,
Qu

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
>   	btrfs_end_transaction(trans);
>   	rcu_string_free(device->name);
>   	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
> 
