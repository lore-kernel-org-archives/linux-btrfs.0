Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aarghimedes.fi ([62.75.165.48]:55956 "EHLO aarghimedes.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbcFKMkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 08:40:05 -0400
Received: from [192.168.2.120] (79-134-100-39.cust.suomicom.net [79.134.100.39])
	by aarghimedes.fi (Postfix) with ESMTPSA id 9934D63C58E6
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jun 2016 15:39:59 +0300 (EEST)
Subject: Re: Kernel crash on mount after SMR disk trouble
References: <5736DFA3.3090904@aarghimedes.fi>
 <CAPmG0ja9J40q0npcANz=gN1EAiNOc400NjjA5V1wV_FFMPc02Q@mail.gmail.com>
 <575B816B.90506@aarghimedes.fi>
 <CAJCQCtStRu34z_joYtTh2+ChjLBCOruH5ej2hNU0wc88hyC46g@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jukka Larja <roskakori@aarghimedes.fi>
Message-ID: <575C06AB.4020701@aarghimedes.fi>
Date: Sat, 11 Jun 2016 15:40:11 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtStRu34z_joYtTh2+ChjLBCOruH5ej2hNU0wc88hyC46g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

11.6.2016, 15.30, Chris Murphy kirjoitti:

> On Fri, Jun 10, 2016 at 9:11 PM, Jukka Larja <roskakori@aarghimedes.fi> wrote:
>
>> I understand that usebackuproot requires kernel >= 4.6. I probably won't be
>> installing a custom kernel, but if I still have the array in its current
>> state when 4.6 becomes available in Debian Stretch, I'll give it a try.
>
> It's the "recovery" mount option in older kernels.

That didn't work, one of the first things I tried. Crashes just like without it.

-- 
      ...Elämälle vierasta toimintaa...
      Jukka Larja, jlarja@iki.fi, 0407679919

"BTW: You won't get that extra point if you plagiate the feedback. (We will 
run automatic plagiation checkers... ;)"
- Aki Hiisilä, news.tky.hut.fi: opinnot.as.as0101 -
