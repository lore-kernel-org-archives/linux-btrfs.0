Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23044 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbcEAXGc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 19:06:32 -0400
Subject: Re: [PATCH V2 RESEND] btrfs: pass the error code to the
 btrfs_std_error and log ret
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1457583735-3925-1-git-send-email-anand.jain@oracle.com>
 <20160316131019.GM21722@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57268BF5.7010408@oracle.com>
Date: Mon, 2 May 2016 07:06:29 +0800
MIME-Version: 1.0
In-Reply-To: <20160316131019.GM21722@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/16/2016 09:10 PM, David Sterba wrote:
> On Thu, Mar 10, 2016 at 12:22:15PM +0800, Anand Jain wrote:
>> This patch will log return value of add/del_qgroup_relation() and pass the
>> err code of btrfs_run_qgroups to the btrfs_std_error().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2: fix the forgotten git commit amend, to take in compile fail, sorry
>>
>>   fs/btrfs/ioctl.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index f704d1c..f43a104 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -4803,10 +4803,15 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>>   						sa->src, sa->dst);
>>   	}
>>
>> +	if (ret)
>> +		btrfs_err(root->fs_info,
>> +			"add/del qgroup relation failed, assign %llu ret %d",
>> +			sa->assign, ret);
>
> It's just logging an error, but it should really fail, without a
> message. The error code will tell what went wrong. Assigning existing
> qgroups is eg. EEXIST, if either doesn't exist then ENOENT. There's a
> FIXME a few lines above that should be addressed.
>
> I'd like to avoid the message in this case because it should be handled
> by the ioctl caller, otherwise it could be just flooding the system log.
>
>> +
>>   	/* update qgroup status and info */
>>   	err = btrfs_run_qgroups(trans, root->fs_info);
>>   	if (err < 0)
>> -		btrfs_std_error(root->fs_info, ret,
>> +		btrfs_std_error(root->fs_info, err,

  This patch is missing in the 'dev-del-by-id' branch. I agree with your
  the above comments, however the key intention of this patch was to get
  the correct parameter passed to the btrfs_std_error(). And the above
  btrfs_err() log should still help/motivate to get the part you
  mentioned corrected.

Thanks,  -Anand

>>   			    "failed to update qgroup status and info\n");
>>   	err = btrfs_end_transaction(trans, root);
>>   	if (err && !ret)
