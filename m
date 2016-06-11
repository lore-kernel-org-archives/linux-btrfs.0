Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36412 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbcFKQao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 12:30:44 -0400
Received: by mail-oi0-f45.google.com with SMTP id p204so154067377oih.3
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jun 2016 09:30:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <575C06AB.4020701@aarghimedes.fi>
References: <5736DFA3.3090904@aarghimedes.fi>
	<CAPmG0ja9J40q0npcANz=gN1EAiNOc400NjjA5V1wV_FFMPc02Q@mail.gmail.com>
	<575B816B.90506@aarghimedes.fi>
	<CAJCQCtStRu34z_joYtTh2+ChjLBCOruH5ej2hNU0wc88hyC46g@mail.gmail.com>
	<575C06AB.4020701@aarghimedes.fi>
Date: Sat, 11 Jun 2016 10:30:43 -0600
Message-ID: <CAJCQCtSwbT6ooXKFvQxtz=8mKsyoq8M7ZhOZbKaUfhwck2DAMA@mail.gmail.com>
Subject: Re: Kernel crash on mount after SMR disk trouble
From: Chris Murphy <lists@colorremedies.com>
To: Jukka Larja <roskakori@aarghimedes.fi>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 11, 2016 at 6:40 AM, Jukka Larja <roskakori@aarghimedes.fi> wrote:
> 11.6.2016, 15.30, Chris Murphy kirjoitti:
>
>> On Fri, Jun 10, 2016 at 9:11 PM, Jukka Larja <roskakori@aarghimedes.fi>
>> wrote:
>>
>>> I understand that usebackuproot requires kernel >= 4.6. I probably won't
>>> be
>>> installing a custom kernel, but if I still have the array in its current
>>> state when 4.6 becomes available in Debian Stretch, I'll give it a try.
>>
>>
>> It's the "recovery" mount option in older kernels.
>
>
> That didn't work, one of the first things I tried. Crashes just like without
> it.

-o ro,recovery is quite a bit more tolerant in my experience. While
it's not great to in effect have a read only file system, it's a lot
easier to get data off of if necessary, rather than restoring to
'btrfs restore'.


-- 
Chris Murphy
