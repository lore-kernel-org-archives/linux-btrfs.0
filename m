Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:57889 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2LXNq4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Dec 2012 08:46:56 -0500
Received: by mail-bk0-f49.google.com with SMTP id jm19so3349210bkc.22
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2012 05:46:54 -0800 (PST)
Message-ID: <50D85CCC.5090204@gmail.com>
Date: Mon, 24 Dec 2012 14:46:52 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        dsterba@suse.cz, Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [RFC PATCH v7 1/2] Btrfs: Add a new ioctl to get the label of
 a mounted file system
In-Reply-To: <50D80D5C.2060306@oracle.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50D2CF98.6010806@oracle.com>
 <50D372A5.4090906@inwind.it>
 <50D404B8.2000102@oracle.com>
 <50D49E30.1050100@gmail.com>
 <50D80D5C.2060306@oracle.com>

Hi Jeff,

On 12/24/2012 09:07 AM, Jeff Liu wrote:
> On 12/22/2012 01:36 AM, Goffredo Baroncelli wrote:
>> On 12/21/2012 07:42 AM, Jeff Liu wrote:
[...]
>>> I don't think we should replace strlen() with strnlen() since it's
>>> totally wrong if the length of label is more than BTRFS_LABEL_SIZE -1,
>>> we can not just truncating the label and return it in this case.
>>
>> This for me is sufficient, or we could copy all the label buffer,
>> without further check:
>>
>> 	copy_to_user(arg, label, BTRFS_LABEL_SIZE)
> That sounds ok to me, but it's better to limit the length to be
> 'BTRFS_LABEL_SIZE - 1' bytes, or else, it would copy 256 bytes back to
> the user space if the label length is beyond or equal to the array limits.

Sorry I don't understand your reply. The ioctl has as argument an array
of BTRFS_LABEL_SIZE characters, so it should not be any problem of page
fault (with the exception of an  user who passes a shorter array). So it
wouldn't be any problem to copy
BTRFS_LABEL_SIZE character, or I am missing something ?

The question is another. Is a kernel responsibility to assure that the
returned string is zero terminated ? If yes (and I think so)  we should
truncate the string before the copy:

	label[BTRFS_LABEL_SIZE-1] = 0;
	copy_to_user(arg, label, BTRFS_LABEL_SIZE);

>>
>>
>>> Add BUG_ON(strlen(label) > BTRFS_LABEL_SIZE - 1) is reasonable instead.
>>
>> I agree with Stefan, this is not a correct use of BUG_ON; a warning is
>> sufficient (there is un-correct data read from disk).
> Maybe like following?
> 
> size_t len = strlen(label);

If label (who is an array read from the disk) is not zero terminated,
this would lead to a possible page fault. I suggest to use strnlen() or
similar.

> 
> if (len > BTRFS_LABEL_SIZE - 1) {
> 	WARN(1, "btrfs: device label has weird length %zu bytes, "
> 		     "it will be truncated to %d bytes.\n",
> 		     len, BTRFS_LABEL_SIZE - 1);
> 
> 	len = BTRFS_LABEL_SIZE - 1;
> }

As message I suggest:

WARN(1, "btrfs: device label is not zero terminated, it will be
truncated to %d bytes.\n",
			BTRFS_LABEL-1 );			


NOTE: it is suggested to not span the string on more lines, to help
searching in the source a messages with grep. It is an exception of the
rule of the max 80 columns text width.

Happy Christmas you too
GB

> 
> I'll post a new patch with those changes if no other objections.
> 
> Happy Christmas.
> -Jeff
>>
>>>
>>> Thanks,
>>> -Jeff
>>>>
>>>>> +	mutex_unlock(&root->fs_info->volume_mutex);
>>>>> +
>>>>> +	return ret ? -EFAULT : 0;
>>>>> +}
>>>>> +
>>>>>  long btrfs_ioctl(struct file *file, unsigned int
>>>>>  		cmd, unsigned long arg)
>>>>>  {
>>>>> @@ -3797,6 +3810,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>>>>  		return btrfs_ioctl_qgroup_create(root, argp);
>>>>>  	case BTRFS_IOC_QGROUP_LIMIT:
>>>>>  		return btrfs_ioctl_qgroup_limit(root, argp);
>>>>> +	case BTRFS_IOC_GET_FSLABEL:
>>>>> +		return btrfs_ioctl_get_fslabel(file, argp);
>>>>>  	}
>>>>>  
>>>>>  	return -ENOTTY;
>>>>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>>>>> index 731e287..5b2cbef 100644
>>>>> --- a/fs/btrfs/ioctl.h
>>>>> +++ b/fs/btrfs/ioctl.h
>>>>> @@ -451,6 +451,8 @@ struct btrfs_ioctl_send_args {
>>>>>  			       struct btrfs_ioctl_qgroup_create_args)
>>>>>  #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
>>>>>  			       struct btrfs_ioctl_qgroup_limit_args)
>>>>> +#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>>>>> +				   char[BTRFS_LABEL_SIZE])
>>>>>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>>>>  				      struct btrfs_ioctl_get_dev_stats)
>>>>>  #endif
>>>>
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
