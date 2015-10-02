Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63561 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbbJBIbv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 04:31:51 -0400
Subject: Re: [PATCH 1/1] Btrfs: consolidate btrfs_error() to btrfs_std_error()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1443163381-12332-1-git-send-email-anand.jain@oracle.com>
 <20150925103128.GC11442@twin.jikos.cz> <560E3510.1070403@oracle.com>
Cc: dsterba@suse.cz
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <560E40E5.1000602@gmx.com>
Date: Fri, 2 Oct 2015 16:31:33 +0800
MIME-Version: 1.0
In-Reply-To: <560E3510.1070403@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年10月02日 15:41, Anand Jain 写道:
>
>
> On 09/25/2015 06:31 PM, David Sterba wrote:
>> On Fri, Sep 25, 2015 at 02:43:01PM +0800, Anand Jain wrote:
>>> btrfs_error() and btrfs_std_error() does the same thing
>>> and calls _btrfs_std_error(), so consolidate them together.
>>> And the main motivation is that btrfs_error() is closely
>>> named with btrfs_err(), one handles error action the other
>>> is to log the error, so don't closely name them.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> Suggested-by: David Sterba <dsterba@suse.com>
>>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>>
>> I guess we can live with the extra NULL argument, in some cases it does
>> not make sense to put a string there.
>>
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -4852,7 +4852,7 @@ static long btrfs_ioctl_qgroup_assign(struct
>>> file *file, void __user *arg)
>>>       /* update qgroup status and info */
>>>       err = btrfs_run_qgroups(trans, root->fs_info);
>>>       if (err < 0)
>>> -        btrfs_error(root->fs_info, ret,
>>> +        btrfs_std_error(root->fs_info, ret,
>>
>> This looks like a bug, ret instead of err. The value of 'ret' is set by
>> add/del qgroup relation which might fail if the relations are there, but
>> we do not care. We're likely interested in the return code of
>> btrfs_run_qgroups, ie. err. Can you please send a new patch on top of
>> this?
>
>
>   I think the original code intended to log the error (btrfs_err())
>   instead of handle the error (btrfs_error()->btrfs_std_error()).
>
>   Qu, Any idea ?
>
> Thanks, Anand
>

David is right, that's a bug. We lose the return value of 
add/del_qgroup_relation().

Just as David mentioned, add/del_qgroup_relation() does a lot of 
validation check, so we'd better log an error before we run qgroups.
But we still need to call btrfs_run_qgroups() to mark INCONSISTENT flag 
for qgroup tree.


And for your patch, it may be my personal preference, but the 
btrfs_std_error() naming is quite confusing for me.

Std_error() means more like stderr, for my first glance, I'd think it's 
just a new printk() warpper, until I checked the code.
It does more than printk, but also set FS_STATE_ERROR bit and set fs to 
readonly.
I'd like it to be something like btrfs_handle_err().

So, in the new patch(es) we may need to do the following things:
1) Add new log for btrfs_add/del_relation().
It only needs to log an error, no need to mark FS_ERROR bit.
As it may just be an invalid parameter.

2) Handle the err returned from btrfs_run_qgroups()
If btrfs_run_qgroups() return error, that's a BIG problem.
Which means we failed to update not only qgroup accounting info, but 
also qgroup status info.(including failed to mark INCONSISTENT)
So we need to set FS_STATE_ERROR bit.


Thanks,
Qu

>
>>>                   "failed to update qgroup status and info\n");
>>>       err = btrfs_end_transaction(trans, root);
>>>       if (err && !ret)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
