Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38722 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab2LRCVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 21:21:03 -0500
Message-ID: <50CFD32A.6070501@cn.fujitsu.com>
Date: Tue, 18 Dec 2012 10:21:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>, Jeff Liu <jeff.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [RFC PATCH V5 2/2] Btrfs: Add a new ioctl to change the label
 of a mounted file system
In-Reply-To: <50CF57B1.1000106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50CF0063.3060503@oracle.com>
 <50CF08A8.9010504@cn.fujitsu.com>
 <50CF1E5A.8030407@oracle.com>
 <50CF57B1.1000106@gmail.com>

On 	mon, 17 Dec 2012 18:34:41 +0100, Goffredo Baroncelli wrote:
> On 12/17/2012 02:30 PM, Jeff Liu wrote:
>> On 12/17/2012 07:57 PM, Miao Xie wrote:
>>> On 	mon, 17 Dec 2012 19:22:11 +0800, Jeff Liu wrote:
>>>> Introduce a new ioctl BTRFS_IOC_SET_FSLABEL to change the label of a mounted file system.
>>>>
>>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> Cc: Miao Xie <miaox@cn.fujitsu.com>
> [...]
>>>> +
>>>> +	if (strlen(label) > BTRFS_LABEL_SIZE - 1)
>>>> +		return -EINVAL;
>>>
>>> I think we should use strnlen()
>> AFAICS, strnlen() is better only if the caller need to get the length of
>> a length-limited string and make use of it proceeding, which means that
>> the procedure would not return an error even if the length is beyond the
>> limit.  Or if the caller need to examine if a length-limited string is
>> nul-terminated or not in a manner below,
>> if (strnlen(buf, MAX_BUF_SIZE) == MAX_BUF_SIZE) {
>> 	....
>> }
>>
>> I don't think it really needed here since the logic is clear with
>> strlen(), or Am I miss anything?
> 
> I think that Miao fears strlen() searching a zero could go beyond the
> page limit touching an un-mapped page and raising an segmentation fault....

Yes, so I think the following check is better.

if (strnlen(buf, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE)
	return -EINVAL;

Thanks
Miao

> I think that we should change the code as
> 
> +	label[BTRFS_LABEL_SIZE - 1] = 0;
> +
> +	if (strlen(label) > BTRFS_LABEL_SIZE - 1)
> +		return -EINVAL;
> 
> My 2¢
> 
> Ciao
> G.Baroncelli
>>
>>
>> Thanks,
>> -Jeff
>>
>>> Thanks
>>> Miao
>>>
>>>> +
>>>> +	ret = mnt_want_write_file(file);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	mutex_lock(&root->fs_info->volume_mutex);
>>>> +	trans = btrfs_start_transaction(root, 1);
>>>> +	if (IS_ERR(trans)) {
>>>> +		ret = PTR_ERR(trans);
>>>> +		goto out_unlock;
>>>> +	}
>>>> +
>>>> +	label[BTRFS_LABEL_SIZE - 1] = '\0';
>>>> +	strcpy(super_block->label, label);
>>>> +	btrfs_end_transaction(trans, root);
>>>> +
>>>> +out_unlock:
>>>> +	mutex_unlock(&root->fs_info->volume_mutex);
>>>> +	mnt_drop_write_file(file);
>>>> +	return ret;
>>>> +}
>>>> +
>>>>  long btrfs_ioctl(struct file *file, unsigned int
>>>>  		cmd, unsigned long arg)
>>>>  {
>>>> @@ -3812,6 +3850,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>>>  		return btrfs_ioctl_qgroup_limit(root, argp);
>>>>  	case BTRFS_IOC_GET_FSLABEL:
>>>>  		return btrfs_ioctl_get_fslabel(file, argp);
>>>> +	case BTRFS_IOC_SET_FSLABEL:
>>>> +		return btrfs_ioctl_set_fslabel(file, argp);
>>>>  	}
>>>>  
>>>>  	return -ENOTTY;
>>>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>>>> index 5b2cbef..2abe239 100644
>>>> --- a/fs/btrfs/ioctl.h
>>>> +++ b/fs/btrfs/ioctl.h
>>>> @@ -453,6 +453,8 @@ struct btrfs_ioctl_send_args {
>>>>  			       struct btrfs_ioctl_qgroup_limit_args)
>>>>  #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>>>>  				   char[BTRFS_LABEL_SIZE])
>>>> +#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
>>>> +				   char[BTRFS_LABEL_SIZE])
>>>>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>>>  				      struct btrfs_ioctl_get_dev_stats)
>>>>  #endif
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 

