Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51886 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbeGDIRZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 04:17:25 -0400
Subject: Re: [PATCH 5/7] btrfs: lift uuid_mutex to callers of
 btrfs_parse_early_options
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <70e9faa71c1360e0f28db4031b0c2796d35f2cc9.1529516228.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2c11dc47-2b5f-ba83-c984-324969eb3ddd@oracle.com>
Date: Wed, 4 Jul 2018 16:20:38 +0800
MIME-Version: 1.0
In-Reply-To: <70e9faa71c1360e0f28db4031b0c2796d35f2cc9.1529516228.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> Prepartory work to fix race between mount and device scan.
> 
> btrfs_parse_early_options calls the device scan from mount and we'll
> need to let mount completely manage the critical section.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> ---
>   fs/btrfs/super.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index ee82d02f5453..e3324ddf2777 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -892,6 +892,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>   	char *device_name, *opts, *orig, *p;
>   	int error = 0;
>   
> +	lockdep_assert_held(&uuid_mutex);
> +
>   	if (!options)
>   		return 0;
>   
> @@ -917,10 +919,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>   				error = -ENOMEM;
>   				goto out;
>   			}
> -			mutex_lock(&uuid_mutex);
>   			error = btrfs_scan_one_device(device_name,
>   					flags, holder, fs_devices);
> -			mutex_unlock(&uuid_mutex);
>   			kfree(device_name);
>   			if (error)
>   				goto out;
> @@ -1528,8 +1528,10 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   	if (!(flags & SB_RDONLY))
>   		mode |= FMODE_WRITE;
>   
> +	mutex_lock(&uuid_mutex);
>   	error = btrfs_parse_early_options(data, mode, fs_type,
>   					  &fs_devices);
> +	mutex_unlock(&uuid_mutex);
>   	if (error) {
>   		return ERR_PTR(error);
>   	}
> 
