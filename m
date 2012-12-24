Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39681 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2LXIJK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Dec 2012 03:09:10 -0500
Message-ID: <50D80D5C.2060306@oracle.com>
Date: Mon, 24 Dec 2012 16:07:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org,
        anand.jain@oracle.com, miaox@cn.fujitsu.com, dsterba@suse.cz,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [RFC PATCH v7 1/2] Btrfs: Add a new ioctl to get the label of
 a mounted file system
In-Reply-To: <50D49E30.1050100@gmail.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50D2CF98.6010806@oracle.com>
 <50D372A5.4090906@inwind.it>
 <50D404B8.2000102@oracle.com>
 <50D49E30.1050100@gmail.com>

On 12/22/2012 01:36 AM, Goffredo Baroncelli wrote:
> On 12/21/2012 07:42 AM, Jeff Liu wrote:
>> Hi Goffredo,
>>
>> On 12/21/2012 04:18 AM, Goffredo Baroncelli wrote:
>>> HI Jeff,
>>>
>>> On 12/20/2012 09:43 AM, Jeff Liu wrote:
>>>> With the new ioctl(2) BTRFS_IOC_GET_FSLABEL we can fetch the label of a mounted file system.
>>>>
>>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>>>> Cc: Goffredo Baroncelli <kreijack@inwind.it>
>>>> Cc: David Sterba <dsterba@suse.cz>
>>> [...]
>>>> +static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
>>>> +{
>>>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>>>> +	const char *label = root->fs_info->super_copy->label;
>>>> +	int ret;
>>>> +
>>>> +	mutex_lock(&root->fs_info->volume_mutex);
>>>> +	ret = copy_to_user(arg, label, strlen(label));
>>>
>>> Sorry for pointing out my doubt too late, but should we trust
>>> super_copy->label ?
>>> An user could insert a usb-key with a btrfs filesystem with a label
>>> without zero. In this case strlen() could access outside
>>> super_copy->label[].
>> Thank you for letting me be aware of this situation.
>>
>> First of all, if the user set label via btrfs tools, he can not make it
>> length exceeding BTRFS_LABLE_SIZE - 1.
>>
>> If the user does that through codes wrote by himself like:
>> btrfslabel.c->set_label_unmounted(), he can do that.
>> However, it most likely he did that for evil purpose or any other reasons?
> 
> I think the most likely case is the "evil purpose".
> 
>>>
>>> I think that it should be quite easy to alter artificially a filesystem
>>> to crash the kernel. So I not consider this as big problem. However *in
>>> case* of a further cycle of this patch I suggest to replace strlen()
>>> with strnlen().
>> I don't think we should replace strlen() with strnlen() since it's
>> totally wrong if the length of label is more than BTRFS_LABEL_SIZE -1,
>> we can not just truncating the label and return it in this case.
> 
> This for me is sufficient, or we could copy all the label buffer,
> without further check:
> 
> 	copy_to_user(arg, label, BTRFS_LABEL_SIZE)
That sounds ok to me, but it's better to limit the length to be
'BTRFS_LABEL_SIZE - 1' bytes, or else, it would copy 256 bytes back to
the user space if the label length is beyond or equal to the array limits.
> 
> 
>> Add BUG_ON(strlen(label) > BTRFS_LABEL_SIZE - 1) is reasonable instead.
> 
> I agree with Stefan, this is not a correct use of BUG_ON; a warning is
> sufficient (there is un-correct data read from disk).
Maybe like following?

size_t len = strlen(label);

if (len > BTRFS_LABEL_SIZE - 1) {
	WARN(1, "btrfs: device label has weird length %zu bytes, "
		     "it will be truncated to %d bytes.\n",
		     len, BTRFS_LABEL_SIZE - 1);

	len = BTRFS_LABEL_SIZE - 1;
}

I'll post a new patch with those changes if no other objections.

Happy Christmas.
-Jeff
> 
>>
>> Thanks,
>> -Jeff
>>>
>>>> +	mutex_unlock(&root->fs_info->volume_mutex);
>>>> +
>>>> +	return ret ? -EFAULT : 0;
>>>> +}
>>>> +
>>>>  long btrfs_ioctl(struct file *file, unsigned int
>>>>  		cmd, unsigned long arg)
>>>>  {
>>>> @@ -3797,6 +3810,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>>>  		return btrfs_ioctl_qgroup_create(root, argp);
>>>>  	case BTRFS_IOC_QGROUP_LIMIT:
>>>>  		return btrfs_ioctl_qgroup_limit(root, argp);
>>>> +	case BTRFS_IOC_GET_FSLABEL:
>>>> +		return btrfs_ioctl_get_fslabel(file, argp);
>>>>  	}
>>>>  
>>>>  	return -ENOTTY;
>>>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>>>> index 731e287..5b2cbef 100644
>>>> --- a/fs/btrfs/ioctl.h
>>>> +++ b/fs/btrfs/ioctl.h
>>>> @@ -451,6 +451,8 @@ struct btrfs_ioctl_send_args {
>>>>  			       struct btrfs_ioctl_qgroup_create_args)
>>>>  #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
>>>>  			       struct btrfs_ioctl_qgroup_limit_args)
>>>> +#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>>>> +				   char[BTRFS_LABEL_SIZE])
>>>>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>>>  				      struct btrfs_ioctl_get_dev_stats)
>>>>  #endif
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 

