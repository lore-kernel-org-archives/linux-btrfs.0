Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41660 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2H3Fzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 01:55:52 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7U5tpkx016456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2012 05:55:51 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7U5tosd027047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2012 05:55:50 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7U5toHV001168
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2012 00:55:50 -0500
Message-ID: <503F005E.1060908@oracle.com>
Date: Thu, 30 Aug 2012 13:55:42 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Add get/set label ioctl
References: <1346229961-635-1-git-send-email-Anand.Jain@oracle.com> <503DDA25.1020407@oracle.com> <503EC7F0.2020305@oracle.com> <503EFDBA.8030707@oracle.com>
In-Reply-To: <503EFDBA.8030707@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/30/12 13:44, Anand Jain wrote:
>
> Jeff,
>
>  I don't find the get label ioctl part unless I am missing something.
>  Any idea?
Yes, you're right, I have not post the get label at that time.

The original patch could be revised with this support easily.
How about using one structure and one ioctl number for both of them? i.e,

#define BTRFS_IOC_FSLABEL_CTL    _IOW(BTRFS_IOCTL_MAGIC, 50, struct
btrfs_ioctl_fslabel_ctl_args)

#define BTRFS_FSLABEL_CTL_GET    0
#define BTRFS_FSLABEL_CTL_SET    1

struct btrfs_ioctl_fslabel_ctl_args {
        char label[BTRFS_LABEL_SIZE];
        u32  flags;
};

so that get/set label from user tools would looks like,

struct btrfs_ioctl_fslabel_ctl_args arg;
arg.flags = BTRFS_FSLABEL_CTL_GET;  /* get label */
or
arg.flags = BTRFS_FSLABEL_CTL_SET; /* set label */
....

ioctl(fd, BTRFS_FSLABEL_CTL, &arg);


Thanks,
-Jeff
>
> Thxs, -Anand
>
>
> On 30/08/12 09:54, Anand Jain wrote:
>>
>> Ah. I missed that. Thanks.
>> So should use your original patch.
>>
>> -Anand
>>
>> On 29/08/12 17:00, Jie Liu wrote:
>>> Hi Anand,
>>>
>>> I have posted a patch for set label back to last year, which can be
>>> found at:
>>> https://patchwork.kernel.org/patch/1124642/
>>>
>>> Besides that, we have discussed to use 50 as the ioctl(2) number at
>>> that time.
>>>
>>> task assignment in our wiki page:
>>> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Set.2Fchange_file_system_label
>>>
>>>
>>> Thanks,
>>> -Jeff
>>>
>>> On 08/29/12 16:46, Anand jain wrote:
>>>> From: Anand Jain<anand.jain@oracle.com>
>>>>
>>>> Signed-off-by: Anand Jain<anand.jain@oracle.com>
>>>> ---
>>>> fs/btrfs/ctree.h | 10 ++++++++++
>>>> fs/btrfs/ioctl.c | 30 ++++++++++++++++++++++++++++++
>>>> fs/btrfs/ioctl.h | 2 ++
>>>> 3 files changed, 42 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>> index 4bab807..eff506f 100644
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
>>>> @@ -2583,6 +2583,16 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type,
>>>> struct btrfs_super_block,
>>>> BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct
>>>> btrfs_super_block,
>>>> cache_generation, 64);
>>>>
>>>> +static inline char * btrfs_super_label(struct btrfs_super_block *s)
>>>> +{
>>>> + return s->label;
>>>> +}
>>>> +static inline void btrfs_set_super_label(struct btrfs_super_block *s,
>>>> + char *val)
>>>> +{
>>>> + memcpy(s->label,val,BTRFS_LABEL_SIZE);
>>>> +}
>>>> +
>>>> static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
>>>> {
>>>> int t = btrfs_super_csum_type(s);
>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>>> index 7bb7556..b472942 100644
>>>> --- a/fs/btrfs/ioctl.c
>>>> +++ b/fs/btrfs/ioctl.c
>>>> @@ -3687,6 +3687,32 @@ out:
>>>> return ret;
>>>> }
>>>>
>>>> +static int btrfs_ioctl_get_label(struct btrfs_root *root, void
>>>> __user *arg)
>>>> +{
>>>> + char *label;
>>>> + label = btrfs_super_label(root->fs_info->super_copy);
>>>> + if (copy_to_user(arg, label, BTRFS_LABEL_SIZE))
>>>> + return -EFAULT;
>>>> + return 0;
>>>> +}
>>>> +
>>>> +static int btrfs_ioctl_set_label(struct btrfs_root *root, void
>>>> __user *arg)
>>>> +{
>>>> + struct btrfs_trans_handle *trans;
>>>> + char label[BTRFS_LABEL_SIZE+1];
>>>> +
>>>> + if (!capable(CAP_SYS_ADMIN))
>>>> + return -EPERM;
>>>> + if (copy_from_user(label, arg, BTRFS_LABEL_SIZE))
>>>> + return -EFAULT;
>>>> + label[BTRFS_LABEL_SIZE] = '\0';
>>>> + trans = btrfs_start_transaction(root, 1);
>>>> + btrfs_set_super_label(root->fs_info->super_copy, label);
>>>> + btrfs_commit_transaction(trans, root);
>>>> +
>>>> + return 0;
>>>> +}
>>>> +
>>>> long btrfs_ioctl(struct file *file, unsigned int
>>>> cmd, unsigned long arg)
>>>> {
>>>> @@ -3785,6 +3811,10 @@ long btrfs_ioctl(struct file *file, unsigned
>>>> int
>>>> return btrfs_ioctl_qgroup_create(root, argp);
>>>> case BTRFS_IOC_QGROUP_LIMIT:
>>>> return btrfs_ioctl_qgroup_limit(root, argp);
>>>> + case BTRFS_IOC_GET_LABEL:
>>>> + return btrfs_ioctl_get_label(root, argp);
>>>> + case BTRFS_IOC_SET_LABEL:
>>>> + return btrfs_ioctl_set_label(root, argp);
>>>> }
>>>>
>>>> return -ENOTTY;
>>>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>>>> index 731e287..0c60fcb 100644
>>>> --- a/fs/btrfs/ioctl.h
>>>> +++ b/fs/btrfs/ioctl.h
>>>> @@ -453,4 +453,6 @@ struct btrfs_ioctl_send_args {
>>>> struct btrfs_ioctl_qgroup_limit_args)
>>>> #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>>> struct btrfs_ioctl_get_dev_stats)
>>>> +#define BTRFS_IOC_GET_LABEL _IOR(BTRFS_IOCTL_MAGIC, 53, __u64)
>>>> +#define BTRFS_IOC_SET_LABEL _IOW(BTRFS_IOCTL_MAGIC, 54, __u64)
>>>> #endif
>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html

