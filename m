Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aarghimedes.fi ([62.75.165.48]:32866 "EHLO aarghimedes.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbcFKQ6I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 12:58:08 -0400
Received: from [192.168.2.120] (79-134-100-39.cust.suomicom.net [79.134.100.39])
	by aarghimedes.fi (Postfix) with ESMTPSA id 2620063C58F7
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jun 2016 19:58:03 +0300 (EEST)
Subject: Re: Kernel crash on mount after SMR disk trouble
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5736DFA3.3090904@aarghimedes.fi>
 <CAPmG0ja9J40q0npcANz=gN1EAiNOc400NjjA5V1wV_FFMPc02Q@mail.gmail.com>
 <575B816B.90506@aarghimedes.fi>
 <CAJCQCtStRu34z_joYtTh2+ChjLBCOruH5ej2hNU0wc88hyC46g@mail.gmail.com>
 <575C06AB.4020701@aarghimedes.fi>
 <CAJCQCtSwbT6ooXKFvQxtz=8mKsyoq8M7ZhOZbKaUfhwck2DAMA@mail.gmail.com>
From: Jukka Larja <roskakori@aarghimedes.fi>
Message-ID: <575C4327.8020702@aarghimedes.fi>
Date: Sat, 11 Jun 2016 19:58:15 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSwbT6ooXKFvQxtz=8mKsyoq8M7ZhOZbKaUfhwck2DAMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

11.6.2016, 19.30, Chris Murphy kirjoitti:
> On Sat, Jun 11, 2016 at 6:40 AM, Jukka Larja <roskakori@aarghimedes.fi> wrote:
>> 11.6.2016, 15.30, Chris Murphy kirjoitti:
>>
>>> On Fri, Jun 10, 2016 at 9:11 PM, Jukka Larja <roskakori@aarghimedes.fi>
>>> wrote:
>>>
>>>> I understand that usebackuproot requires kernel >= 4.6. I probably won't
>>>> be
>>>> installing a custom kernel, but if I still have the array in its current
>>>> state when 4.6 becomes available in Debian Stretch, I'll give it a try.
>>>
>>>
>>> It's the "recovery" mount option in older kernels.
>>
>>
>> That didn't work, one of the first things I tried. Crashes just like without
>> it.
>
> -o ro,recovery is quite a bit more tolerant in my experience. While
> it's not great to in effect have a read only file system, it's a lot
> easier to get data off of if necessary, rather than restoring to
> 'btrfs restore'.

Read-only mounting works even without recovery. My current plan is to copy 
most of the data (I probably skip snapshots even though that defeats part of 
the purpose of backups) once I get new disks. I have also run --repair, but 
that didn't have any effect.

-- 
      ...Elämälle vierasta toimintaa...
      Jukka Larja, jlarja@iki.fi, 0407679919

"Those who fail to learn history are doomed to repeat it; those who fail to 
learn it correctly -- why they are simply doomed."
- Andromeda -
