Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35613 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaEPEaB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 00:30:01 -0400
Message-ID: <537594D9.8010902@oracle.com>
Date: Fri, 16 May 2014 12:32:25 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140515170634.GR6917@twin.jikos.cz>
In-Reply-To: <20140515170634.GR6917@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


David,

  As mentioned, this patch will back-out the earlier patch

  50275bacab0f62b91453fbfa29e75c2bb77bf9b6

  I am confused on what I am missing ? Any comment?

Thanks, Anand


On 16/05/14 01:06, David Sterba wrote:
> On Tue, May 13, 2014 at 05:05:05PM +0800, Wang Shilong wrote:
>> Btrfs device id start from 1, not 0.
>
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1765,7 +1765,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>>   		goto out;
>>   	}
>>
>> -	for (; i <= fi_args->max_id; ++i) {
>> +	for (i = 1; i <= fi_args->max_id; ++i) {
>
> You're right about the device id start, but forcing 1 here breaks the
> case when get_fs_info is called with block device as an argument and 'i'
> is set to the devid a few lines above.
>
> Initializing i to 1 in the declaration block is the right fix IMO, and
> as this is a trivial change I'll do that myself, no need to resend.
>
>>   		BUG_ON(ndevs >= fi_args->num_devices);
>>   		ret = get_device_info(fd, i, &di_args[ndevs]);
>>   		if (ret == -ENODEV)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
