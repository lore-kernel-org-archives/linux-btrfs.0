Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753798AbdLFHyr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 02:54:47 -0500
Subject: Re: [PATCH v4 2/2] btrfs: introduce feature to ignore a btrfs device
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171205085258.4038-1-anand.jain@oracle.com>
 <20171205085258.4038-4-anand.jain@oracle.com>
 <20171205192434.GW3553@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <05084ef4-b707-d811-e54d-51ab556363f8@oracle.com>
Date: Wed, 6 Dec 2017 15:55:14 +0800
MIME-Version: 1.0
In-Reply-To: <20171205192434.GW3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> This patch proposes to use ioctl #5 as it was empty.
>> 	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
>> If #5 is reserved for some other purpose, I think I should change this.
> 
> I think 5 is free for use.

ok.

>> +static int device_list_remove(struct btrfs_super_block *disk_super, u64 devid)
>> +{
>> +	int ret = 0;
>> +	struct btrfs_fs_devices *fs_devices;
>> +	struct btrfs_device *device;
>> +
>> +	fs_devices = find_fsid(disk_super->fsid);
> 
> Don't we need uuid mutext to call find_fsid? All other users do that.

Actually we need it. Will fix. Thanks.

>> +int btrfs_ignore_one_device(const char *path, fmode_t flags, void *holder,
>> +			  struct btrfs_fs_devices **fs_devices_ret)
>> +{
>> +	struct btrfs_super_block *disk_super;
>> +	struct block_device *bdev;
>> +	struct page *page;
>> +	int ret = -EINVAL;
> 
> Please move EINVAL to the point where this happens (ie. after the
> btrfs_read_disk_super call). This is the common pattern and makes
> reading the code smooth.

Right.

>> +	ret = device_list_remove(disk_super, devid);
>> +	if (ret)
>> +		pr_err("BTRFS: %pU device %s devid %llu failed to ignore: %d\n",
>> +			disk_super->fsid, path, devid, ret);
> 
> So we can't easily use btrfs_printk here due to lack of fs_info that
> would appear as "<unknown>" in place of the device. Ok.

  Side topic. We should rather make btrfs_printk independent of fs_info
  by passing fs_devices, also that means use fsid instead of s_id,
  something like [1]. For the concern of long-prefixes, we need new
  ideas. I can resend RFC.

    [1]
    https://www.spinics.net/lists/linux-btrfs/msg47759.html
    [2]
    https://patchwork.kernel.org/patch/7014191/

>> +#define BTRFS_IOC_IGNORE_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
>> +				   struct btrfs_ioctl_vol_args)
> 
> While reading the patches, I realized we may want to extend the ioctl to
> unregister/forge all devices that are not currently mounted. For that > purpose using the btrfs_ioctl_vol_args_v2 would be suitable as it has
> more struct members.
  Good point. How about using a flag to indicate to forget all unmounted
  devices BTRFS_IOCTL_PURGE_ALL_DEVS and with in btrfs_ioctl_vol_args
  as below [3], since btrfs_control_ioctl() uses only
  btrfs_ioctl_vol_args, so we decode arg before the cmd ioctl check,
  which is not a roadblock though.

[3]
------------------------------
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index de0f1144d945..eaf6ef04b300 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -28,8 +28,12 @@

  /* this should be 4k */
  #define BTRFS_PATH_NAME_MAX 4087
+#define BTRFS_IOCTL_PURGE_ALL_DEVS     (1ULL << 0)
  struct btrfs_ioctl_vol_args {
-       __s64 fd;
+       union {
+               __s64 fd;
+               __u64 ioctl_flag;
+       };
         char name[BTRFS_PATH_NAME_MAX + 1];
  };
------------------------------

  Or I am ok with btrfs_ioctl_vol_args_v2 as well.


> Another extension is to unregister only stale devices (when there's no
> device node under /dev), eg. after the device is unuplugged and readded
> by another name.

  Ok. So that means match the device-path instead of its fsid && devid.


  This part of the code is messy -- all because we don't free per fsid
  btrfs_fs_devices and btrfs_devices structures upon unmount. Any idea
  why not we free them instead ? Which means we have rerun 'btrfs dev
  scan' to mount it again. May be that was the reason. But not too sure.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
