Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38843 "EHLO
	mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbcFINHV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 09:07:21 -0400
Received: by mail-it0-f54.google.com with SMTP id h190so34232871ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 06:07:21 -0700 (PDT)
Subject: Re: Allocator behaviour during device delete
To: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
References: <00ad8257-ba24-fe62-5c93-8db426afec69@swiftspirit.co.za>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f88b62ed-1e17-2f67-8d0d-210ad96cace5@gmail.com>
Date: Thu, 9 Jun 2016 09:07:14 -0400
MIME-Version: 1.0
In-Reply-To: <00ad8257-ba24-fe62-5c93-8db426afec69@swiftspirit.co.za>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-09 08:34, Brendan Hide wrote:
> Hey, all
>
> I noticed this odd behaviour while migrating from a 1TB spindle to SSD
> (in this case on a LUKS-encrypted 200GB partition) - and am curious if
> this behaviour I've noted below is expected or known. I figure it is a
> bug. Depending on the situation, it *could* be severe. In my case it was
> simply annoying.
>
> ---
> Steps
>
> After having added the new device (btrfs dev add), I deleted the old
> device (btrfs dev del)
>
> Then, whilst waiting for that to complete, I started a watch of "btrfs
> fi show /". Note that the below is very close to the output at the time
> - but is not actually copy/pasted from the output.
>
>> Label: 'tricky-root'  uuid: bcbe47a5-bd3f-497a-816b-decb4f822c42
>>         Total devices 2 FS bytes used 115.03GiB
>>         devid    1 size 0.00GiB used 298.06GiB path /dev/sda2
>>         devid    2 size 200.88GiB used 0.00GiB path /dev/mapper/cryptroot
>
>
> devid1 is the old disk while devid2 is the new SSD
>
> After a few minutes, I saw that the numbers have changed - but that the
> SSD still had no data:
>
>> Label: 'tricky-root'  uuid: bcbe47a5-bd3f-497a-816b-decb4f822c42
>>         Total devices 2 FS bytes used 115.03GiB
>>         devid    1 size 0.00GiB used 284.06GiB path /dev/sda2
>>         devid    2 size 200.88GiB used 0.00GiB path /dev/mapper/cryptroot
>
> The "FS bytes used" amount was changing a lot - but mostly stayed near
> the original total, which is expected since there was very little
> happening other than the "migration".
>
> I'm not certain of the exact point where it started using the new disk's
> space. I figure that may have been helpful to pinpoint. :-/
OK, I'm pretty sure I know what was going on in this case.  Your 
assumption that device delete uses the balance code is correct, and that 
is why you see what's happening happening.  There are two key bits that 
are missing though:
1. Balance will never allocate chunks when it doesn't need to.
2. The space usage listed in fi show is how much space is allocated to 
chunks, not how much is used in those chunks.

In this case, based on what you've said, you had a lot of empty or 
mostly empty chunks.  As a result of this, the device delete was both 
copying data, and consolidating free space.  If you have a lot of empty 
or mostly empty chunks, it's not unusual for a device delete to look 
like this until you start hitting chunks that have actual data in them. 
The pri8mary point of this behavior is that it makes it possible to 
directly switch to a smaller device without having to run a balance and 
then a resize before replacing the device, and then resize again afterwards.
