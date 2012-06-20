Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:55732 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab2FTRGe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 13:06:34 -0400
Message-ID: <4FE20319.8080507@libero.it>
Date: Wed, 20 Jun 2012 19:06:33 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Device names
References: <4FDFC807.2080209@zytor.com> <20120619235129.GB4102@shiny> <4FE1128B.5080004@zytor.com> <20120620133754.GE4102@shiny>
In-Reply-To: <20120620133754.GE4102@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 03:37 PM, Chris Mason wrote:
> On Tue, Jun 19, 2012 at 06:00:11PM -0600, H. Peter Anvin wrote:
>> On 06/19/2012 04:51 PM, Chris Mason wrote:
>>>
>>> At mount time, we go through and verify the path names still belong to
>>> the filesystem you thought they belonged to.  The bdev is locked during
>>> the verification, so it won't be able to go away or change.
>>>
>>> This is a long way of saying right we don't spit out device numbers.
>>> Even device numbers can change.  We can easily add a uuid based listing,
>>> which I think is what you want.
>>>
>>
>> No, I want to find the actual devices.  I know I can get the UUID, but
>> scanning all the block devices in the system looking for that UUID is a
>> nonstarter.
>>
>> Device path names can change while the system is operating (and, worse,
>> are dependent on namespace changes and chroot); device *numbers* cannot
>> as long as the device is in use (e.g. mounted.)  They can indeed change
>> while not in use, of course.
> 
> Ok, my two choices for exporting this to you are a /sys/btrfs kind of
> directory (representing the mounted filesystems) or an ioctl.  Which one
> is most usable for you?

As short term solution, I suggest to update the BTRFS_IOC_DEV_INFO to
export also the major:minor pair. This should be a minor change and
also should be backward compatible (there is a lot of space in the
struct btrfs_ioctl_dev_info_args )

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 14f8e1f..79fdd83 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2261,6 +2261,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_root
*root,
        di_args->devid = dev->devid;
        di_args->bytes_used = dev->bytes_used;
        di_args->total_bytes = dev->total_bytes;
+       di_args->major = imajor(dev->bdev->bd_inode);
+       di_args->minor = iminor(dev->bdev->bd_inode);
        memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
        if (dev->name)
                strncpy(di_args->path, dev->name, sizeof(di_args->path));
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 086e6bd..7afa688 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -98,7 +98,9 @@ struct btrfs_ioctl_dev_info_args {
        __u8 uuid[BTRFS_UUID_SIZE];             /* in/out */
        __u64 bytes_used;                       /* out */
        __u64 total_bytes;                      /* out */
-       __u64 unused[379];                      /* pad to 4k */
+       __u64 major;                            /* out */
+       __u64 minor;                            /* out */
+       __u64 unused[377];                      /* pad to 4k */
        __u8 path[BTRFS_DEVICE_PATH_NAME_MAX];  /* out */
 };



As long term solution, exporting all this kind of information in
/sys/btrfs/... could be a more robust solution, which could simplify the
"backward compatible" problem.

Only my 2¢...

GB

> 
> You want to map from /some_dir to a definitive list of devices you need
> to find in syslinux to later boot off that FS, right?
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

