Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38524 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2LLDRm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 22:17:42 -0500
Message-ID: <50C7F749.4000605@oracle.com>
Date: Wed, 12 Dec 2012 11:17:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [PATCH V4 2/2] Btrfs: Add a new ioctl to change the label of
 a mounted filesystem
In-Reply-To: <50C7F409.3000902@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50C7CE44.3010405@oracle.com>
 <50C7F409.3000902@cn.fujitsu.com>

Hi Miao,

On 12/12/2012 11:03 AM, Miao Xie wrote:
> Hi, Liu
> 
> On wed, 12 Dec 2012 08:22:28 +0800, Jeff Liu wrote:
>> Add a new ioctl BTRFS_FS_SETLABEL to change the label of a mounted filesystem.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> ---
>>  fs/btrfs/ioctl.c |   14 ++++++++++++++
>>  fs/btrfs/ioctl.h |    2 ++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 8fcf9a5..b0a5e17 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3699,6 +3699,18 @@ out:
>>  	return ret;
>>  }
>>  
>> +static int btrfs_ioctl_get_fslabel(struct btrfs_root *root, void __user *arg)
>> +{
>> +	const char *label = root->fs_info->super_copy->label;
>> +	int ret;
>> +
>> +	mutex_lock(&root->fs_info->volume_mutex);
>> +	ret = copy_to_user(arg, label, strlen(label));
>> +	mutex_unlock(&root->fs_info->volume_mutex);
>> +
>> +	return ret ? -EFAULT : 0;
>> +}
> 
> 
> You sent out a wrong patch.
Ah! I should not send patches out during my sleepy state, will re-send
them a little while, thank you. :)

-Jeff
> 
> Thanks
> Miao
> 
>> +
>>  long btrfs_ioctl(struct file *file, unsigned int
>>  		cmd, unsigned long arg)
>>  {
>> @@ -3797,6 +3809,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>  		return btrfs_ioctl_qgroup_create(root, argp);
>>  	case BTRFS_IOC_QGROUP_LIMIT:
>>  		return btrfs_ioctl_qgroup_limit(root, argp);
>> +	case BTRFS_IOC_GET_FSLABEL:
>> +		return btrfs_ioctl_get_fslabel(root, argp);
>>  	}
>>  
>>  	return -ENOTTY;
>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>> index 731e287..98f896f 100644
>> --- a/fs/btrfs/ioctl.h
>> +++ b/fs/btrfs/ioctl.h
>> @@ -453,4 +453,6 @@ struct btrfs_ioctl_send_args {
>>  			       struct btrfs_ioctl_qgroup_limit_args)
>>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>  				      struct btrfs_ioctl_get_dev_stats)
>> +#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 53, \
>> +				   char[BTRFS_LABEL_SIZE])
>>  #endif
>>
> 

