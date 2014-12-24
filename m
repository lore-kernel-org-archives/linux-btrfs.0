Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXFMo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 00:12:44 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 0D25D3EE190
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:12:43 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id EFAFAAC02CD
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:12:41 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 71946E0800E
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:12:41 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 5FFA6BD653A
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:12:40 +0900 (JST)
Message-ID: <549A4B3F.9040409@jp.fujitsu.com>
Date: Wed, 24 Dec 2014 14:12:31 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Remove unnecessary placeholder in btrfs_err_code
References: <5497F2EE.1010906@jp.fujitsu.com>	 <5497F4CD.4010301@jp.fujitsu.com> <1419299971.2086.8.camel@localhost.localdomain>
In-Reply-To: <1419299971.2086.8.camel@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

On 2014/12/23 10:59, Gui Hecheng wrote:
> On Mon, 2014-12-22 at 19:39 +0900, Satoru Takeuchi wrote:
>> Sorry, I forgot to add Signed-off-by line.
>>
>> ---
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> "notused" is not necessary. Set 1 to the first entry is enough.
>
> Hi Satoru,
>
> Actually, the struct is copied from the kernel header
> include/uapi/linux/btrfs.h.
> I think they should stay the same, so either change the kernel header
> in another path, or just keep them in old style.

OK, I'll send also kernel patches soon.

Thanks,
Satoru

>
> Thanks,
> Gui
>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> ---
>>   ioctl.h | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/ioctl.h b/ioctl.h
>> index 2c2c7c1..c377b96 100644
>> --- a/ioctl.h
>> +++ b/ioctl.h
>> @@ -474,8 +474,7 @@ struct btrfs_ioctl_qgroup_create_args {
>>
>>   /* Error codes as returned by the kernel */
>>   enum btrfs_err_code {
>> -	notused,
>> -	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
>> +	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
>>   	BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
>>   	BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
>>   	BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
>> -- 1.8.3.1 -- To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

