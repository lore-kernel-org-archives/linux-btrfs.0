Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:47583 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LUReo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 12:34:44 -0500
Received: by mail-bk0-f45.google.com with SMTP id jk13so2543202bkc.32
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 09:34:43 -0800 (PST)
Message-ID: <50D49E30.1050100@gmail.com>
Date: Fri, 21 Dec 2012 18:36:48 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: kreijack@inwind.it, linux-btrfs@vger.kernel.org, anand.jain@oracle.com,
        miaox@cn.fujitsu.com, dsterba@suse.cz,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [RFC PATCH v7 1/2] Btrfs: Add a new ioctl to get the label of
 a mounted file system
In-Reply-To: <50D404B8.2000102@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50D2CF98.6010806@oracle.com>
 <50D372A5.4090906@inwind.it>
 <50D404B8.2000102@oracle.com>

On 12/21/2012 07:42 AM, Jeff Liu wrote:
> Hi Goffredo,
> 
> On 12/21/2012 04:18 AM, Goffredo Baroncelli wrote:
>> HI Jeff,
>>
>> On 12/20/2012 09:43 AM, Jeff Liu wrote:
>>> With the new ioctl(2) BTRFS_IOC_GET_FSLABEL we can fetch the label of a mounted file system.
>>>
>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>>> Cc: Goffredo Baroncelli <kreijack@inwind.it>
>>> Cc: David Sterba <dsterba@suse.cz>
>> [...]
>>> +static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
>>> +{
>>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>>> +	const char *label = root->fs_info->super_copy->label;
>>> +	int ret;
>>> +
>>> +	mutex_lock(&root->fs_info->volume_mutex);
>>> +	ret = copy_to_user(arg, label, strlen(label));
>>
>> Sorry for pointing out my doubt too late, but should we trust
>> super_copy->label ?
>> An user could insert a usb-key with a btrfs filesystem with a label
>> without zero. In this case strlen() could access outside
>> super_copy->label[].
> Thank you for letting me be aware of this situation.
> 
> First of all, if the user set label via btrfs tools, he can not make it
> length exceeding BTRFS_LABLE_SIZE - 1.
> 
> If the user does that through codes wrote by himself like:
> btrfslabel.c->set_label_unmounted(), he can do that.
> However, it most likely he did that for evil purpose or any other reasons?

I think the most likely case is the "evil purpose".

>>
>> I think that it should be quite easy to alter artificially a filesystem
>> to crash the kernel. So I not consider this as big problem. However *in
>> case* of a further cycle of this patch I suggest to replace strlen()
>> with strnlen().
> I don't think we should replace strlen() with strnlen() since it's
> totally wrong if the length of label is more than BTRFS_LABEL_SIZE -1,
> we can not just truncating the label and return it in this case.

This for me is sufficient, or we could copy all the label buffer,
without further check:

	copy_to_user(arg, label, BTRFS_LABEL_SIZE)


> Add BUG_ON(strlen(label) > BTRFS_LABEL_SIZE - 1) is reasonable instead.

I agree with Stefan, this is not a correct use of BUG_ON; a warning is
sufficient (there is un-correct data read from disk).

> 
> Thanks,
> -Jeff
>>
>>> +	mutex_unlock(&root->fs_info->volume_mutex);
>>> +
>>> +	return ret ? -EFAULT : 0;
>>> +}
>>> +
>>>  long btrfs_ioctl(struct file *file, unsigned int
>>>  		cmd, unsigned long arg)
>>>  {
>>> @@ -3797,6 +3810,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>>  		return btrfs_ioctl_qgroup_create(root, argp);
>>>  	case BTRFS_IOC_QGROUP_LIMIT:
>>>  		return btrfs_ioctl_qgroup_limit(root, argp);
>>> +	case BTRFS_IOC_GET_FSLABEL:
>>> +		return btrfs_ioctl_get_fslabel(file, argp);
>>>  	}
>>>  
>>>  	return -ENOTTY;
>>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>>> index 731e287..5b2cbef 100644
>>> --- a/fs/btrfs/ioctl.h
>>> +++ b/fs/btrfs/ioctl.h
>>> @@ -451,6 +451,8 @@ struct btrfs_ioctl_send_args {
>>>  			       struct btrfs_ioctl_qgroup_create_args)
>>>  #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
>>>  			       struct btrfs_ioctl_qgroup_limit_args)
>>> +#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>>> +				   char[BTRFS_LABEL_SIZE])
>>>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>>  				      struct btrfs_ioctl_get_dev_stats)
>>>  #endif
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
