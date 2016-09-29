Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6111 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755056AbcI2HSn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 03:18:43 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com>
 <4f91af54-78ae-5c08-3daa-8a0c16210e5f@profihost.ag>
 <57EBB329.9060009@cn.fujitsu.com>
 <3e429001-020a-748b-c0c5-85b4091599a1@profihost.ag>
 <57ECBAE7.5030807@cn.fujitsu.com>
 <0e556b63-7c85-1e97-00b0-91bfca44e82c@profihost.ag>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57ECBF0D.3050609@cn.fujitsu.com>
Date: Thu, 29 Sep 2016 15:13:17 +0800
MIME-Version: 1.0
In-Reply-To: <0e556b63-7c85-1e97-00b0-91bfca44e82c@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/29/2016 03:09 PM, Stefan Priebe - Profihost AG wrote:
> Am 29.09.2016 um 08:55 schrieb Wang Xiaoguang:
>> Hi,
>>
>> On 09/29/2016 02:49 PM, Stefan Priebe - Profihost AG wrote:
>>> Hi,
>>>
>>> Am 28.09.2016 um 14:10 schrieb Wang Xiaoguang:
>>>> OK, I see.
>>>> But given that you often run into enospc errors, can you work out a
>>>> reproduce
>>>> script according to you work load. That will give us great help.
>> You got ENOSPC errors only when you have compress enabled?
>>
>> I found that compress sometime report ENOSPC error even in 4.8-rc8,
>> currently
> I cannot confirm that as i do not have anough space to test this without
> compression ;-( But yes i've compression enabled.
I might not get you, my poor english :)
You mean that you only get ENOSPC error when compression is enabled?

And when compression is not enabled, you do not get ENOSPC error?
>
>> I'm trying to fix it.
> That sounds good but do you also get the
> BTRFS: space_info 4 has 18446742286429913088 free, is not full
>
> kernel messages on umount? if not you might have found another problem.
Yes, I seem similar messages, you can paste you whole dmesg info here.

Regards,
Xiaoguang Wang

>
> Stefan
>
>> Regards,
>> Xiaoguang Wang
>>
>>> I tried hard to reproduce it but i can't get it to reproduce with a test
>>> script. Any ideas?
>>>
>>> Stefan
>>>
>>>> Reagrds,
>>>> Xiaoguang Wang
>>>>
>>>>> Greets,
>>>>> Stefan
>>>>>
>>>>>> Regards,
>>>>>> Xiaoguang Wang
>>>>>>> Greets,
>>>>>>> Stefan
>>>>>>> -- 
>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-btrfs" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>>
>>>>
>>
>>
>



