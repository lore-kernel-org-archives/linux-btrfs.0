Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab3CNOUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 10:20:41 -0400
Message-ID: <5141DCB6.6000605@redhat.com>
Date: Thu, 14 Mar 2013 09:20:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs_scan_one_device return error code
References: <51418AD5.6090207@oracle.com>
In-Reply-To: <51418AD5.6090207@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/14/13 3:31 AM, Anand Jain wrote:
> 
> Hi,
> 
>  /dev/sdc does not contain btrfs SB at all..
> 
> ---
>  # btrfs dev scan /dev/sdc
>  Scanning for Btrfs filesystems in '/dev/sdc'
>  ERROR: unable to scan the device '/dev/sdc' - Invalid argument
> ---
> 
>  here appropriate error is something like
>  no btrfs found on dev
> 
>  However btrfs_scan_one_device (kernel) returns -EINVAL
>  for other errors too
> 
>  Does the below fix sound reasonable ?

Overall, things like "Insufficient memory" or "No space left on device"
seem like poor fits for problems like "your superblock straddles 2 pages."
or "I didn't find btrfs."  I'm not sure it's any more useful to the user
than "Invalid argument"

If non-btrfs devices aren't scanned as a matter of course, you could
add printks to each failure case.  But I fear that they are scanned
regularly and this might pollute the logs with nonsense & noise.

I guess you are not the first one to realize it, though:

                /*
                 * FIXME: which are the error code returned by this ioctl ?
                 * it seems that is impossible to understand if there no is
                 * a btrfs filesystem from an I/O error !!!
                 */
                ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);

IO errors could be returned, as could true ENOMEM situations, but
for basically non-btrfs data found on the device, nothing really fits.

It's too bad that ioctl arg doesn't have room to pass back
any other status.

A rev of the ioctl (BTRFS_IOC_SCAN_DEV_V2), which allows
passing status flags back out, would solve the problem nicely
I think.

ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args_v2);

if (ret < 0)
	<ioctl itself failed due to EIO, ENOMEM, EFAULT etc>

if (!ret && (args_v2.flags & BTRFS_DEV_NOT_FOUND))
	<ioctl succeeded in finding no btrfs>
	<tell user no btrfs was found>


As a hack you could strncpy the informational error
string into the args.name.  ;)  (no, don't really do that)

-Eric

> Thanks, Anand
> 
> --------------
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6b9cff4..d6deae0 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -808,7 +808,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>         struct block_device *bdev;
>         struct page *page;
>         void *p;
> -       int ret = -EINVAL;
> +       int ret = 0;
>         u64 devid;
>         u64 transid;
>         u64 total_devices;
> @@ -833,24 +833,32 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>         }
> 
>         /* make sure our super fits in the device */
> -       if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
> +       if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode)) {
> +               ret = -ENOSPC;
>                 goto error_bdev_put;
> +       }
> 
>         /* make sure our super fits in the page */
> -       if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
> +       if (sizeof(*disk_super) > PAGE_CACHE_SIZE) {
> +               ret = -ENOMEM;
>                 goto error_bdev_put;
> +       }
> 
>         /* make sure our super doesn't straddle pages on disk */
>         index = bytenr >> PAGE_CACHE_SHIFT;
> -       if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
> +       if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index) {
> +               ret = -ENOMEM;
>                 goto error_bdev_put;
> +       }
> 
>         /* pull in the page with our super */
>         page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
>                                    index, GFP_NOFS);
> 
> -       if (IS_ERR_OR_NULL(page))
> +       if (IS_ERR_OR_NULL(page)) {
> +               ret = -EIO;
>                 goto error_bdev_put;
> +       }
> 
>         p = kmap(page);
> 
> @@ -858,8 +866,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>         disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
> 
>         if (btrfs_super_bytenr(disk_super) != bytenr ||
> -           disk_super->magic != cpu_to_le64(BTRFS_MAGIC))
> +           disk_super->magic != cpu_to_le64(BTRFS_MAGIC)) {
> +               ret = -EINVAL;
>                 goto error_unmap;
> +       }
> 
>         devid = btrfs_stack_device_id(&disk_super->dev_item);
>         transid = btrfs_super_generation(disk_super);
> -------------------
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

