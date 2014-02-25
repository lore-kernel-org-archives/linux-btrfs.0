Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62327 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaBYUay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 15:30:54 -0500
Received: by mail-vc0-f172.google.com with SMTP id lf12so7863477vcb.31
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 12:30:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <530CFCCE.5060707@iki.fi>
References: <530CC9B0.1080703@iki.fi>
	<530CDB7F.9020807@jrs-s.net>
	<20140225201921.GB13899@carfax.org.uk>
	<530CFCCE.5060707@iki.fi>
Date: Tue, 25 Feb 2014 14:30:53 -0600
Message-ID: <CAE5mzviojVcz2TGRvqtUB0s4uXntBuAv4X62hKhPv9-SzNso7A@mail.gmail.com>
Subject: Re: No space left on device (again)
From: cwillu <cwillu@cwillu.com>
To: Marcus Sundman <sundman@iki.fi>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>,
        Jim Salter <jim@jrs-s.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Try btrfs filesystem balance start -dusage=15 /home, and gradually
increase it until you see it relocate at least one chunk.

On Tue, Feb 25, 2014 at 2:27 PM, Marcus Sundman <sundman@iki.fi> wrote:
> On 25.02.2014 22:19, Hugo Mills wrote:
>>
>> On Tue, Feb 25, 2014 at 01:05:51PM -0500, Jim Salter wrote:
>>>
>>> 370GB of 410GB used isn't really "fine", it's over 90% usage.
>>>
>>> That said, I'd be interested to know why btrfs fi show /dev/sda3
>>> shows 412.54G used, but btrfs fi df /home shows 379G used...
>>
>>     This is an FAQ...
>>
>>     btrfs fi show tells you how much is allocated out of the available
>> pool on each disk. btrfs fi df then shows how much of that allocated
>> space (in each category) is used.
>
>
> What is the difference between the "used 371.11GB" and the "used 412.54GB"
> displayed by "btrfs fi show"?
>
>
>>     The problem here is also in the FAQ: the metadata is close to full
>> -- typically something like 500-750 MiB of headroom is needed in
>> metadata. The FS can't allocate more metadata because it's allocated
>> everything already (total=used in btrfs fi show), so the solution is
>> to do a filtered balance:
>>
>> btrfs balance start -dusage=5 /mountpoint
>
>
> Of course that was the first thing I tried, and it didn't help *at* *all*:
>
>> # btrfs filesystem balance start -dusage=5 /home
>> Done, had to relocate 0 out of 415 chunks
>> #
>
>
> ... and it really didn't free anything.
>
>
>>> On 02/25/2014 11:49 AM, Marcus Sundman wrote:
>>>>
>>>> Hi
>>>>
>>>> I get "No space left on device" and it is unclear why:
>>>>
>>>>> # df -h|grep sda3
>>>>> /dev/sda3       413G  368G   45G  90% /home
>>>>> # btrfs filesystem show /dev/sda3
>>>>> Label: 'home'  uuid: 46279061-51f4-40c2-afd0-61d6faab7f60
>>>>>     Total devices 1 FS bytes used 371.11GB
>>>>>     devid    1 size 412.54GB used 412.54GB path /dev/sda3
>>>>>
>>>>> Btrfs v0.20-rc1
>>>>> # btrfs filesystem df /home
>>>>> Data: total=410.52GB, used=369.61GB
>>>>> System: total=4.00MB, used=64.00KB
>>>>> Metadata: total=2.01GB, used=1.50GB
>>>>> #
>>>>
>>>> So, 'data' and 'metadata' seem to be fine(?), but 'system' is a
>>>> bit low. Is that it? If so, can I do something about it? Or should
>>>> I look somewhere else?
>>>>
>>>> I really wish I could get a warning before running out of disk
>>>> space, instead of everything breaking suddenly when there seems to
>>>> be lots and lots of space left.
>>>>
>>>> - Marcus
>>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
