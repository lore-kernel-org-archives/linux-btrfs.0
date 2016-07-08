Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5618 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755178AbcGHMrh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 08:47:37 -0400
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Gabriel C <nix.or.die@gmail.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
 <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <quwenruo@cn.fujitsu.com>
From: Chris Mason <clm@fb.com>
Message-ID: <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
Date: Fri, 8 Jul 2016 08:41:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/08/2016 05:57 AM, Gabriel C wrote:
> 2016-07-07 21:21 GMT+02:00 Chris Mason <clm@fb.com>:
>>
>>
>> On 07/07/2016 06:24 AM, Gabriel C wrote:
>>>
>>> Hi,
>>>
>>> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
>>> other versions )
>>> I trigger the following :
>>
>>
>> I definitely thought we had this fixed in v4.7-rc.  Can you easily fsck this filesystem?  Something strange is going on.
>
> Yes , btrfs check and btrfs check  --check-data-csum are fine , no errors found.
>
> If you want me to test any patches let me know.
>

Can you please try a v4.5 stable kernel?  I'm curious if this really is 
the same regression that I tried to fix in v4.7

-chris

