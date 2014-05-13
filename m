Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33350 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752985AbaEML3b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 07:29:31 -0400
Message-ID: <5372015D.4070901@cn.fujitsu.com>
Date: Tue, 13 May 2014 19:26:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <5371F89B.1060401@giantdisaster.de>
In-Reply-To: <5371F89B.1060401@giantdisaster.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/13/2014 06:48 PM, Stefan Behrens wrote:
> On Tue, 13 May 2014 17:05:05 +0800, Wang Shilong wrote:
>> Btrfs device id start from 1, not 0.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   utils.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/utils.c b/utils.c
>> index 560c557..d480353 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1765,7 +1765,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>>   		goto out;
>>   	}
> You've not seen the two assignments in get_fs_info() above the lines
> that you change:
>
>          if (is_block_device(path)) {
>                  ...
>                  fi_args->max_id = devid;
>                  i = devid;
Oops, i did not see this one, but this condition may not meet, so
i guess the right fix is to set i=1 when declaration, something like:

int i = 1;

>
>>   
>> -	for (; i <= fi_args->max_id; ++i) {
>> +	for (i = 1; i <= fi_args->max_id; ++i) {
>>   		BUG_ON(ndevs >= fi_args->num_devices);
>>   		ret = get_device_info(fd, i, &di_args[ndevs]);
>>   		if (ret == -ENODEV)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

