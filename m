Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19648 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFOWRt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 18:17:49 -0400
Subject: Re: [PATCH 5/5] btrfs: sysfs: export the force_dev_flush flag
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1497544265.git.dsterba@suse.com>
 <6957a4896cc64a1ff44b712bb6723ada016d76b9.1497544265.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cc6072b3-7be5-7f20-f138-e830b707fee0@oracle.com>
Date: Fri, 16 Jun 2017 06:24:00 +0800
MIME-Version: 1.0
In-Reply-To: <6957a4896cc64a1ff44b712bb6723ada016d76b9.1497544265.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/16/2017 12:49 AM, David Sterba wrote:
> Add per-filesystem tunable to switch on/off the device barriers,
> regardless of the actual device support. This is a debugging feature.
> 
> The path to the sysfs file is /sys/fs/btrfs/UUID/force_dev_flush,
> allowed values are 0 and 1. Default is 0.


  Anyway the flush command won't touch the device if its write through.
  So unless I am missing something, IMO we don't need something
  like this.

-------------------
generic_make_request_checks(struct bio *bio)
::
	/*
	 * Filter flush bio's early so that make_request based
	 * drivers without flush support don't have to worry
	 * about them.
	 */
	if (op_is_flush(bio->bi_opf) &&
	    !test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
		bio->bi_opf &= ~(REQ_PREFLUSH | REQ_FUA);
		if (!nr_sectors) {
			err = 0;
			goto end_io;
		}
	}
-------------------



Thanks, Anand


> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/sysfs.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index c2d5f3580b4c..197d43911936 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -487,12 +487,59 @@ static ssize_t quota_override_store(struct kobject *kobj,
>   
>   BTRFS_ATTR_RW(quota_override, quota_override_show, quota_override_store);
>   
> +static ssize_t force_dev_flush_show(struct kobject *kobj,
> +				   struct kobj_attribute *a, char *buf)
> +{
> +	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
> +	int force;
> +
> +	if (!fs_info)
> +		return -EPERM;
> +
> +	force = !!(test_bit(BTRFS_FS_FORCE_DEV_FLUSH, &fs_info->flags));
> +	return snprintf(buf, PAGE_SIZE, "%d\n", force);
> +}
> +
> +static ssize_t force_dev_flush_store(struct kobject *kobj,
> +				    struct kobj_attribute *a,
> +				    const char *buf, size_t len)
> +{
> +	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
> +	unsigned long force;
> +	int err;
> +
> +	if (!fs_info)
> +		return -EPERM;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	err = kstrtoul(buf, 10, &force);
> +	if (err)
> +		return err;
> +	if (force > 1)
> +		return -EINVAL;
> +
> +	if (force) {
> +		set_bit(BTRFS_FS_FORCE_DEV_FLUSH, &fs_info->flags);
> +		btrfs_info(fs_info, "Forced device flushes enabled");
> +	} else {
> +		clear_bit(BTRFS_FS_FORCE_DEV_FLUSH, &fs_info->flags);
> +		btrfs_info(fs_info, "Forced device flushes disabled");
> +	}
> +
> +	return len;
> +}
> +
> +BTRFS_ATTR_RW(force_dev_flush, force_dev_flush_show, force_dev_flush_store);
> +
>   static const struct attribute *btrfs_attrs[] = {
>   	BTRFS_ATTR_PTR(label),
>   	BTRFS_ATTR_PTR(nodesize),
>   	BTRFS_ATTR_PTR(sectorsize),
>   	BTRFS_ATTR_PTR(clone_alignment),
>   	BTRFS_ATTR_PTR(quota_override),
> +	BTRFS_ATTR_PTR(force_dev_flush),
>   	NULL,
>   };
>   
> 
