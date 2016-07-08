Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35741 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbcGHPRG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 11:17:06 -0400
Received: by mail-wm0-f65.google.com with SMTP id k123so8335580wme.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 08:17:04 -0700 (PDT)
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Chris Mason <clm@fb.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
 <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
 <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
From: Gabriel C <nix.or.die@gmail.com>
Message-ID: <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
Date: Fri, 8 Jul 2016 17:02:44 +0200
MIME-Version: 1.0
In-Reply-To: <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08.07.2016 14:41, Chris Mason wrote:

>
>
> On 07/08/2016 05:57 AM, Gabriel C wrote:
>> 2016-07-07 21:21 GMT+02:00 Chris Mason <clm@fb.com>:
>>>
>>>
>>> On 07/07/2016 06:24 AM, Gabriel C wrote:
>>>>
>>>> Hi,
>>>>
>>>> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
>>>> other versions )
>>>> I trigger the following :
>>>
>>>
>>> I definitely thought we had this fixed in v4.7-rc.  Can you easily 
>>> fsck this filesystem?  Something strange is going on.
>>
>> Yes , btrfs check and btrfs check  --check-data-csum are fine , no 
>> errors found.
>>
>> If you want me to test any patches let me know.
>>
>
> Can you please try a v4.5 stable kernel?  I'm curious if this really 
> is the same regression that I tried to fix in v4.7
>

I'm on linux 4.5.7 now and everything is fine. I'm writing this email 
from thunderbird.. which was not
possible in 4.6.3 or 4.7.-rc.

Let me know you want me to test other kernels or whatever else may help 
fixing this problem.

Regards,

Gabriel C

