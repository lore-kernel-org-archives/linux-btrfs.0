Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:48042 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbaBYSD0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:03:26 -0500
Message-ID: <530CDB7F.9020807@jrs-s.net>
Date: Tue, 25 Feb 2014 13:05:51 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Marcus Sundman <sundman@iki.fi>, linux-btrfs@vger.kernel.org
Subject: Re: No space left on device (again)
References: <530CC9B0.1080703@iki.fi>
In-Reply-To: <530CC9B0.1080703@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

370GB of 410GB used isn't really "fine", it's over 90% usage.

That said, I'd be interested to know why btrfs fi show /dev/sda3 shows 
412.54G used, but btrfs fi df /home shows 379G used...



On 02/25/2014 11:49 AM, Marcus Sundman wrote:
> Hi
>
> I get "No space left on device" and it is unclear why:
>
>> # df -h|grep sda3
>> /dev/sda3       413G  368G   45G  90% /home
>> # btrfs filesystem show /dev/sda3
>> Label: 'home'  uuid: 46279061-51f4-40c2-afd0-61d6faab7f60
>>     Total devices 1 FS bytes used 371.11GB
>>     devid    1 size 412.54GB used 412.54GB path /dev/sda3
>>
>> Btrfs v0.20-rc1
>> # btrfs filesystem df /home
>> Data: total=410.52GB, used=369.61GB
>> System: total=4.00MB, used=64.00KB
>> Metadata: total=2.01GB, used=1.50GB
>> #
>
> So, 'data' and 'metadata' seem to be fine(?), but 'system' is a bit 
> low. Is that it? If so, can I do something about it? Or should I look 
> somewhere else?
>
> I really wish I could get a warning before running out of disk space, 
> instead of everything breaking suddenly when there seems to be lots 
> and lots of space left.
>
> - Marcus
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

