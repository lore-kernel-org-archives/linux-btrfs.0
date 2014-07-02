Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGBBjS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 21:39:18 -0400
Message-ID: <53B362B6.6000903@oracle.com>
Date: Wed, 02 Jul 2014 09:39:02 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: device add must be sysloged
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com> <20140701174621.GQ1553@twin.jikos.cz>
In-Reply-To: <20140701174621.GQ1553@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/07/2014 01:46, David Sterba wrote:
> On Tue, Jul 01, 2014 at 12:58:56AM +0800, Anand Jain wrote:
>> when we add a new disk to the mounted btrfs we don't record it
>> as of now, disk add is a critical change of btrfs configuration,
>> it must be recorded in the syslog to help offline investigations
>> of customer problems when reported.
>>
>> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
>> ---
>>   fs/btrfs/ioctl.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 86d5474..16d20df 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2488,6 +2488,9 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
>>   	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
>>   	ret = btrfs_init_new_device(root, vol_args->name);
>>
>> +	if (!ret)
>> +		btrfs_info(root->fs_info, "disk added %s",vol_args->name);
>
> Please use 'device' instead, I think we're moving away from 'disk'
> everywhere else. Nitpick: space after the ,

yes, you are right. Thanks for commenting.

> Otherwise good,
>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
