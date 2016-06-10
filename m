Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34858 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbcFJT0G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 15:26:06 -0400
Received: by mail-vk0-f51.google.com with SMTP id d127so110354662vkh.2
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 12:26:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9f5e3c8d-6461-887a-0574-6104f48d0957@swiftspirit.co.za>
References: <00ad8257-ba24-fe62-5c93-8db426afec69@swiftspirit.co.za>
 <f88b62ed-1e17-2f67-8d0d-210ad96cace5@gmail.com> <9f5e3c8d-6461-887a-0574-6104f48d0957@swiftspirit.co.za>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 10 Jun 2016 21:26:04 +0200
Message-ID: <CAPmG0jarU7qKzWQrE3Z-a6vieQGcei4G6tXQcGkAK6ocabNAsQ@mail.gmail.com>
Subject: Re: Allocator behaviour during device delete
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 9, 2016 at 3:54 PM, Brendan Hide <brendan@swiftspirit.co.za> wrote:
>
>
> On 06/09/2016 03:07 PM, Austin S. Hemmelgarn wrote:
>>
>> On 2016-06-09 08:34, Brendan Hide wrote:
>>>
>>> Hey, all
>>>
>>> I noticed this odd behaviour while migrating from a 1TB spindle to SSD
>>> (in this case on a LUKS-encrypted 200GB partition) - and am curious if
>>> this behaviour I've noted below is expected or known. I figure it is a
>>> bug. Depending on the situation, it *could* be severe. In my case it was
>>> simply annoying.
>>>
>>> ---
>>> Steps
>>>
>>> After having added the new device (btrfs dev add), I deleted the old
>>> device (btrfs dev del)
>>>
>>> Then, whilst waiting for that to complete, I started a watch of "btrfs
>>> fi show /". Note that the below is very close to the output at the time
>>> - but is not actually copy/pasted from the output.
>>>
>>>> Label: 'tricky-root'  uuid: bcbe47a5-bd3f-497a-816b-decb4f822c42
>>>>         Total devices 2 FS bytes used 115.03GiB
>>>>         devid    1 size 0.00GiB used 298.06GiB path /dev/sda2
>>>>         devid    2 size 200.88GiB used 0.00GiB path
>>>> /dev/mapper/cryptroot
>>>
>>>
>>>
>>> devid1 is the old disk while devid2 is the new SSD
>>>
>>> After a few minutes, I saw that the numbers have changed - but that the
>>> SSD still had no data:
>>>
>>>> Label: 'tricky-root'  uuid: bcbe47a5-bd3f-497a-816b-decb4f822c42
>>>>         Total devices 2 FS bytes used 115.03GiB
>>>>         devid    1 size 0.00GiB used 284.06GiB path /dev/sda2
>>>>         devid    2 size 200.88GiB used 0.00GiB path
>>>> /dev/mapper/cryptroot
>>>
>>>
>>> The "FS bytes used" amount was changing a lot - but mostly stayed near
>>> the original total, which is expected since there was very little
>>> happening other than the "migration".
>>>
>>> I'm not certain of the exact point where it started using the new disk's
>>> space. I figure that may have been helpful to pinpoint. :-/
>>
>> OK, I'm pretty sure I know what was going on in this case.  Your
>> assumption that device delete uses the balance code is correct, and that
>> is why you see what's happening happening.  There are two key bits that
>> are missing though:
>> 1. Balance will never allocate chunks when it doesn't need to.

In relation to discussions w.r.t. enospc and device full of chunks, I
say this 1. statement and I see different behavior with kernel 4.6.0
tools 4.5.3
On a idle fs with some fragmentation, I did balance -dusage=5, it
completes succesfuly and leaves and new empty chunk (highest vaddr).
Then balance -dusage=6, does 2 chunks with that usage level:
- the zero filled last chunk is replaced with a new empty chunk (higher vaddr)
- the 2 usage=6 chunks are gone
- one chunk with the lowest vaddr saw its usage increase from 47 to 60
- several metadata chunks have change slightly in usage

It could be a 2-step datamove, but from just the states before and
after balance I can't prove that.

>> 2. The space usage listed in fi show is how much space is allocated to
>> chunks, not how much is used in those chunks.
>>
>> In this case, based on what you've said, you had a lot of empty or
>> mostly empty chunks.  As a result of this, the device delete was both
>> copying data, and consolidating free space.  If you have a lot of empty
>> or mostly empty chunks, it's not unusual for a device delete to look
>> like this until you start hitting chunks that have actual data in them.
>> The pri8mary point of this behavior is that it makes it possible to
>> directly switch to a smaller device without having to run a balance and
>> then a resize before replacing the device, and then resize again
>> afterwards.
>
>
> Thanks, Austin. Your explanation is along the lines of my thinking though.
>
> The new disk should have had *some* data written to it at that point, as it
> started out at over 600GiB in allocation (should have probably mentioned
> that already). Consolidating or not, I would consider data being written to
> the old disk to be a bug, even if it is considered minor.
>
> I'll set up a reproducible test later today to prove/disprove the theory. :)
>
> --
> __________
> Brendan Hide
> http://swiftspirit.co.za/
> http://www.webafrica.co.za/?AFF1E97
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
