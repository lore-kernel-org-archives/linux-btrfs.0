Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44581 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752719AbaEPFCb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 01:02:31 -0400
Message-ID: <53759B06.9030109@cn.fujitsu.com>
Date: Fri, 16 May 2014 12:58:46 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140515170634.GR6917@twin.jikos.cz> <537594D9.8010902@oracle.com>
In-Reply-To: <537594D9.8010902@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On 05/16/2014 12:32 PM, Anand Jain wrote:
>
> David,
>
>  As mentioned, this patch will back-out the earlier patch
>
>  50275bacab0f62b91453fbfa29e75c2bb77bf9b6
>
>  I am confused on what I am missing ? Any comment?
You are right, i guess dave just missed your previous thread.:-)
dave, please ignore my patch, sorry for noise.

Thanks,
Wang
>
> Thanks, Anand
>
>
> On 16/05/14 01:06, David Sterba wrote:
>> On Tue, May 13, 2014 at 05:05:05PM +0800, Wang Shilong wrote:
>>> Btrfs device id start from 1, not 0.
>>
>>> --- a/utils.c
>>> +++ b/utils.c
>>> @@ -1765,7 +1765,7 @@ int get_fs_info(char *path, struct 
>>> btrfs_ioctl_fs_info_args *fi_args,
>>>           goto out;
>>>       }
>>>
>>> -    for (; i <= fi_args->max_id; ++i) {
>>> +    for (i = 1; i <= fi_args->max_id; ++i) {
>>
>> You're right about the device id start, but forcing 1 here breaks the
>> case when get_fs_info is called with block device as an argument and 'i'
>> is set to the devid a few lines above.
>>
>> Initializing i to 1 in the declaration block is the right fix IMO, and
>> as this is a trivial change I'll do that myself, no need to resend.
>>
>>>           BUG_ON(ndevs >= fi_args->num_devices);
>>>           ret = get_device_info(fd, i, &di_args[ndevs]);
>>>           if (ret == -ENODEV)
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
> .
>

