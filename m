Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40076 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LUGnD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 01:43:03 -0500
Message-ID: <50D404B8.2000102@oracle.com>
Date: Fri, 21 Dec 2012 14:42:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        dsterba@suse.cz
Subject: Re: [RFC PATCH v7 1/2] Btrfs: Add a new ioctl to get the label of
 a mounted file system
In-Reply-To: <50D372A5.4090906@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50D2CF98.6010806@oracle.com>
 <50D372A5.4090906@inwind.it>

Hi Goffredo,

On 12/21/2012 04:18 AM, Goffredo Baroncelli wrote:
> HI Jeff,
> 
> On 12/20/2012 09:43 AM, Jeff Liu wrote:
>> With the new ioctl(2) BTRFS_IOC_GET_FSLABEL we can fetch the label of a mounted file system.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>> Cc: Goffredo Baroncelli <kreijack@inwind.it>
>> Cc: David Sterba <dsterba@suse.cz>
> [...]
>> +static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
>> +{
>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>> +	const char *label = root->fs_info->super_copy->label;
>> +	int ret;
>> +
>> +	mutex_lock(&root->fs_info->volume_mutex);
>> +	ret = copy_to_user(arg, label, strlen(label));
> 
> Sorry for pointing out my doubt too late, but should we trust
> super_copy->label ?
> An user could insert a usb-key with a btrfs filesystem with a label
> without zero. In this case strlen() could access outside
> super_copy->label[].
Thank you for letting me be aware of this situation.

First of all, if the user set label via btrfs tools, he can not make it
length exceeding BTRFS_LABLE_SIZE - 1.

If the user does that through codes wrote by himself like:
btrfslabel.c->set_label_unmounted(), he can do that.
However, it most likely he did that for evil purpose or any other reasons?
> 
> I think that it should be quite easy to alter artificially a filesystem
> to crash the kernel. So I not consider this as big problem. However *in
> case* of a further cycle of this patch I suggest to replace strlen()
> with strnlen().
I don't think we should replace strlen() with strnlen() since it's
totally wrong if the length of label is more than BTRFS_LABEL_SIZE -1,
we can not just truncating the label and return it in this case.
Add BUG_ON(strlen(label) > BTRFS_LABEL_SIZE - 1) is reasonable instead.

Thanks,
-Jeff
> 
>> +	mutex_unlock(&root->fs_info->volume_mutex);
>> +
>> +	return ret ? -EFAULT : 0;
>> +}
>> +
>>  long btrfs_ioctl(struct file *file, unsigned int
>>  		cmd, unsigned long arg)
>>  {
>> @@ -3797,6 +3810,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>  		return btrfs_ioctl_qgroup_create(root, argp);
>>  	case BTRFS_IOC_QGROUP_LIMIT:
>>  		return btrfs_ioctl_qgroup_limit(root, argp);
>> +	case BTRFS_IOC_GET_FSLABEL:
>> +		return btrfs_ioctl_get_fslabel(file, argp);
>>  	}
>>  
>>  	return -ENOTTY;
>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>> index 731e287..5b2cbef 100644
>> --- a/fs/btrfs/ioctl.h
>> +++ b/fs/btrfs/ioctl.h
>> @@ -451,6 +451,8 @@ struct btrfs_ioctl_send_args {
>>  			       struct btrfs_ioctl_qgroup_create_args)
>>  #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
>>  			       struct btrfs_ioctl_qgroup_limit_args)
>> +#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>> +				   char[BTRFS_LABEL_SIZE])
>>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>  				      struct btrfs_ioctl_get_dev_stats)
>>  #endif
> 
> 

