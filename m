Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hibox-130.abo.fi ([130.232.216.130]:51042 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaBYUAD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 15:00:03 -0500
Message-ID: <530CF63E.9080008@iki.fi>
Date: Tue, 25 Feb 2014 21:59:58 +0200
From: Marcus Sundman <sundman@iki.fi>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Jim Salter <jim@jrs-s.net>
Subject: Re: No space left on device (again)
References: <530CC9B0.1080703@iki.fi> <530CDB7F.9020807@jrs-s.net>
In-Reply-To: <530CDB7F.9020807@jrs-s.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25.02.2014 20:05, Jim Salter wrote:
> 370GB of 410GB used isn't really "fine", it's over 90% usage.

Still, 45 gigs should be free there. If those 45 gigs aren't really 
there then it shouldn't say they are there, imho.

> That said, I'd be interested to know why btrfs fi show /dev/sda3 shows 
> 412.54G used, but btrfs fi df /home shows 379G used...

The former also says "bytes used 371.11GB" and there's not *that* much 
difference between "371.11" and "369.61" gigs. The devid line seems to 
always say "412.54GB used 412.54GB" no matter how much is actually in use.
I have no idea what these numbers actually mean.

> On 02/25/2014 11:49 AM, Marcus Sundman wrote:
>> Hi
>>
>> I get "No space left on device" and it is unclear why:
>>
>>> # df -h|grep sda3
>>> /dev/sda3       413G  368G   45G  90% /home
>>> # btrfs filesystem show /dev/sda3
>>> Label: 'home'  uuid: 46279061-51f4-40c2-afd0-61d6faab7f60
>>>     Total devices 1 FS bytes used 371.11GB
>>>     devid    1 size 412.54GB used 412.54GB path /dev/sda3
>>>
>>> Btrfs v0.20-rc1
>>> # btrfs filesystem df /home
>>> Data: total=410.52GB, used=369.61GB
>>> System: total=4.00MB, used=64.00KB
>>> Metadata: total=2.01GB, used=1.50GB
>>> #
>>
>> So, 'data' and 'metadata' seem to be fine(?), but 'system' is a bit 
>> low. Is that it? If so, can I do something about it? Or should I look 
>> somewhere else?
>>
>> I really wish I could get a warning before running out of disk space, 
>> instead of everything breaking suddenly when there seems to be lots 
>> and lots of space left.
>>
>> - Marcus
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

