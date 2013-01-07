Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:37744 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab3AGRiR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 12:38:17 -0500
Message-ID: <50EB0694.7070401@tiscalinet.it>
Date: Mon, 07 Jan 2013 18:32:04 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        dsterba@suse.cz
Subject: Re: [RFC PATCH v9 1/2] Btrfs: Add a new ioctl to get the label of
 a mounted file system
References: <50E79461.3090802@oracle.com> <50E9C617.7010303@gmail.com> <50EA6A03.4090900@oracle.com>
In-Reply-To: <50EA6A03.4090900@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On 01/07/2013 07:24 AM, Jeff Liu wrote:
> Hi,
> On 01/07/2013 02:44 AM, Goffredo Baroncelli wrote:
>> Hi Jeff,
>>
>> On 01/05/2013 03:48 AM, Jeff Liu wrote:
>>> Add a new ioctl(2) BTRFS_IOC_GET_FSLABLE, so that we can get the label upon a mounted filesystem.
>>>
>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>>> Cc: Goffredo Baroncelli <kreijack@inwind.it>
>>> Cc: David Sterba <dsterba@suse.cz>
>>>
>>> ---
>>>  fs/btrfs/ioctl.c |   21 +++++++++++++++++++++
>>>  fs/btrfs/ioctl.h |    2 ++
>>>  2 files changed, 23 insertions(+)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 8fcf9a5..ef2f55a 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3699,6 +3699,25 @@ out:
>>>  	return ret;
>>>  }
>>>  
>>
>> May be that it was already discussed, and I am missing something, but if
>> we check the label length we should terminate the string with a zero in
>> case this is too long...
>>
>> However this is a minor bug, please push this patch forward..
> I don't think so.
> Why we need to terminate the string with a zero?
> We have already truncated the label string up to maximum 255 bytes if it
> was too long.
> 
> Consider the normal conditions, i.e. the label string is less than 256,
> we just copy it back to the user without a terminated NUL.

Sorry I don't understand the reason to terminate the string up to 255
chars without adding a zero. Or we copy all the buffer (BTRFS_LABEL_SIZE
characters without furthers checks) or we copy BTRFS_LABEL_SIZE-1
characters, adding a zero at the end.

>>
>>
>>> +static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
>>> +{
>>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>>> +	const char *label = root->fs_info->super_copy->label;
>>> +	size_t len = strnlen(label, BTRFS_LABEL_SIZE);
>>> +	int ret;
>> +       int label_is_too_long = 0;
> 	  bool label_is_too_long = false;
>>> +
>>> +	if (len == BTRFS_LABEL_SIZE) {
>>> +		pr_warn("btrfs: label is too long, return the first %zu bytes\n",
>>> +			--len);
>>
>> +               label_is_too_long = 1;
> 		  label_is_too_long = true;
>>> +	}
>>> +
>>> +	mutex_lock(&root->fs_info->volume_mutex);
>>> +	ret = copy_to_user(arg, label, len);
>> +	if (!ret && label_is_too_long)
>> +     		ret = copy_to_user(arg+BTRFS_LABEL_SIZE, "", 1);
> Hmm? 			ret = copy_to_user(arg + len, "", 1);
> 
My idea was to put a zero at the end of the string, but I did a mistake
with the cut&paste.. sorry :-)

>>> +	mutex_unlock(&root->fs_info->volume_mutex);
> If you or anyone has objection to this patch, please just post yours, I
> won't follow it up again.

Sorry I don't want to bother anybody, I know that reviewing a patch nine
times is a very havvy work. I (and I think more other peoples) really
appreciate your efforts.

BR
G.Baroncelli

>>> +
>>> +	return ret ? -EFAULT : 0;
>>> +}
>>> +
>>>  long btrfs_ioctl(struct file *file, unsigned int
>>>  		cmd, unsigned long arg)
>>>  {
>>> @@ -3797,6 +3816,8 @@ long btrfs_ioctl(struct file *file, unsigned int
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
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
