Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:63755 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbdK3I2x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 03:28:53 -0500
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1CE77AC009D
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 17:28:49 +0900 (JST)
Subject: Re: [PATCH 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
 <a8427cb0-c579-f34c-f39e-01a740a9af27@gmx.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <3c82c352-14a1-14b2-c6d7-87e430c389f3@jp.fujitsu.com>
Date: Thu, 30 Nov 2017 17:28:44 +0900
MIME-Version: 1.0
In-Reply-To: <a8427cb0-c579-f34c-f39e-01a740a9af27@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/11/30 16:59, Qu Wenruo wrote:
> 
> 
> On 2017年11月30日 15:52, Misono, Tomohiro wrote:
>> "fi usage" shows the warning "RAID5/6 numbers will be incorrect" when
>> runnning without root privilege even if raid5/6 is not used.  What
>> happens is it cannot get the per device profile usage info, so change
>> the message more appropriately.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> ---
>>  cmds-fi-usage.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
>> index 6c846c15..299c2dae 100644
>> --- a/cmds-fi-usage.c
>> +++ b/cmds-fi-usage.c
>> @@ -590,7 +590,8 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
>>  	ret = load_chunk_info(fd, chunkinfo, chunkcount);
>>  	if (ret == -EPERM) {
>>  		warning(
>> -"cannot read detailed chunk info, RAID5/6 numbers will be incorrect, run as root");
>> +		"cannot read detailed chunk info. " \
>> +		"per device profile usage will not be shown, run as root");
> 
> IIRC it's allowed for long string to cross 80 chars limit.
> This will make later grep easier.
> 
> And there is no need to indent the long string.
> 

Thanks, I will fix that.
Tomohiro

> Thanks,
> Qu
>>  	} else if (ret) {
>>  		return ret;
>>  	}
>>
> 

