Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43792 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932558AbeFZJcS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 05:32:18 -0400
Subject: Re: [PATCH 7/7] btrfs: fix mount and ioctl device scan ioctl race
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <4c223e9ba6d3ab54f9b41678bade731e5554d0a6.1529516229.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0e96eded-7920-bcaa-5b82-f90d0c1e8f82@oracle.com>
Date: Tue, 26 Jun 2018 17:33:21 +0800
MIME-Version: 1.0
In-Reply-To: <4c223e9ba6d3ab54f9b41678bade731e5554d0a6.1529516229.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> Technically this extends the critical section covered by uuid_mutex to:
> 
> - parse early mount options -- here we can call device scan on paths
>    that can be passed as 'device=/dev/...'
> 
> - scan the device passed to mount
> 
> - open the devices related to the fs_devices -- this increases
>    fs_devices::opened
> 
> The race can happen when mount calls one of the scans and there's
> another one called eg. by mkfs or 'btrfs dev scan':
> 
> Mount                                  Scan
> -----                                  ----
> scan_one_device (dev1, fsid1)
>                                         scan_one_device (dev2, fsid2)
                                                            ^^^^
                                                            dev1
typo?


> 				           add the device
> 					   free stale devices
> 					       fsid1 fs_devices::opened == 0
> 					           find fsid1:dev1
> 					           free fsid1:dev1
> 					           if it's the last one,
> 					            free fs_devices of fsid1
> 						    too
> 
> open_devices (dev1, fsid1)
>     dev1 not found
> 
> When fixed, the uuid mutex will make sure that mount will increase
> fs_devices::opened and this will not be touched by the racing scan
> ioctl.

  Using uuid_mutex will unnecessarily serialize mount across different
  fsids.

  Unfortunately we don't have a test case to measure concurrency across
  btrfs fsids. When we have that, this shall fail.

  Expecting different fsids to be able to mount concurrently is a fair
  expectation. And is certainly important for large servers running
  btrfs on few luns which shall start to mount at bootup.

  These changes is kind of going in an opposite direction as I
  originally planned to improve concurrency (across fsids) by reducing
  the unnecessary uuid_mutex footprints.

  And fix the other necessaries using the fsid local atomic volume
  exclusive operations flag. Which in the long term can replace
  fs_info::BTRFS_FS_EXCL_OP as well.

  As both of these approaches fix the issue, its a trade off between the
  concerns of atomic volume exclusive operations flag (except for the
  -EBUSY part [1]) VS serialize mount across different fsids, and IMO,
  its better to make sure different fsids are concurrent in their
  scan-mount operations as it is critical to the boot-up time.

  [1]
  Though returning -EBUSY (for one of the racing mount, scan and or ready
  threads) is theoretically correct but its blunt, and it may wrongly
  categorize as regression, let me try to fix that part and ask for
  comments.

Thanks, Anand


> Reported-and-tested-by: syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com
 >
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/super.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 1780eb41f203..b13b871bc584 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1557,19 +1557,19 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   
>   	mutex_lock(&uuid_mutex);
>   	error = btrfs_parse_early_options(data, mode, fs_type, &fs_devices);
> -	mutex_unlock(&uuid_mutex);
> -	if (error)
> +	if (error) {
> +		mutex_unlock(&uuid_mutex);
>   		goto error_fs_info;
> +	}
>   
> -	mutex_lock(&uuid_mutex);
>   	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> -	mutex_unlock(&uuid_mutex);
> -	if (error)
> +	if (error) {
> +		mutex_unlock(&uuid_mutex);
>   		goto error_fs_info;
> +	}
>   
>   	fs_info->fs_devices = fs_devices;
>   
> -	mutex_lock(&uuid_mutex);
>   	error = btrfs_open_devices(fs_devices, mode, fs_type);
>   	mutex_unlock(&uuid_mutex);
>   	if (error)
> 
