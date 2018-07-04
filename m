Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49086 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932319AbeGDIGp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 04:06:45 -0400
Subject: Re: [PATCH 1/7] btrfs: restore uuid_mutex in btrfs_open_devices
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <953899caf13686e1f128748ef3220281a1b9a47e.1529516228.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e439cf5c-df8f-dbbb-736d-c07a03d34e83@oracle.com>
Date: Wed, 4 Jul 2018 16:09:50 +0800
MIME-Version: 1.0
In-Reply-To: <953899caf13686e1f128748ef3220281a1b9a47e.1529516228.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> Commit 542c5908abfe84f7b4c1 ("btrfs: replace uuid_mutex by
> device_list_mutex in btrfs_open_devices") switched to device_list_mutex
> as we need that for the device list traversal, but we also need
> uuid_mutex to protect access to fs_devices::opened to be consistent with
> other users of that item.
> 
> CC: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: David Sterba <dsterba@suse.com>

  I am optimize the uuid_mutex for fsids concurrency on top these set of 
patches, so.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/volumes.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..1da162928d1a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1146,6 +1146,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>   {
>   	int ret;
>   
> +	mutex_lock(&uuid_mutex);
>   	mutex_lock(&fs_devices->device_list_mutex);
>   	if (fs_devices->opened) {
>   		fs_devices->opened++;
> @@ -1155,6 +1156,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>   		ret = open_fs_devices(fs_devices, flags, holder);
>   	}
>   	mutex_unlock(&fs_devices->device_list_mutex);
> +	mutex_unlock(&uuid_mutex);
>   
>   	return ret;
>   }
> 
