Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:64193 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603AbaH0WkA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 18:40:00 -0400
Received: by mail-oa0-f42.google.com with SMTP id m1so11229oag.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 15:40:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADw2B2NX8XY3V_vD-7eN9vj0tHtEfJwdsS4bovQ0cOHus_9Q-g@mail.gmail.com>
References: <CADw2B2PYPJdcLWvkufY71kvAdCdgXhsdO2Gizf8hXAruppxXPA@mail.gmail.com>
	<pan$427a1$f65bd1f8$7ddfd94c$6b06de1b@cox.net>
	<CADw2B2NX8XY3V_vD-7eN9vj0tHtEfJwdsS4bovQ0cOHus_9Q-g@mail.gmail.com>
Date: Wed, 27 Aug 2014 15:39:59 -0700
Message-ID: <CADw2B2MJS-pkd+XfwLTpq_pqzQzLWnkzxLcaw8UYjnS-jOF25g@mail.gmail.com>
Subject: Re: fallocate fail on btrfs
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also, here's the strace of the fallocate call:
http://sprunge.us/QXFN

On Wed, Aug 27, 2014 at 10:39 AM, G. Richard Bellamy
<rbellamy@pteradigm.com> wrote:
> Good questions, should have included that info in the OP.
>
> The current versions I can get, but I'm frankly terrified to try to
> roll back to prior versions to "test" this, since back in that land be
> monsters with deadlocks preventing degraded volumes from being fixed
> and other challenges I wasn't qualified to fix - and it was over three
> months ago that I tried fallocate last. I run Arch and aggressively
> update, so I can infer what those version were, and will do so, though
> I know that is of limited efficacy in helping you help me...
>
> Best-guess Prior (2014-06-30):
> ------------------------------------------------
> linux-lts 3.10.45-1
> btrfs-progs 3.14.2-2
> linux 3.15.2-1
> util-linux 2.24.2-1
>
> Current (2014-08-27 10:28:07):
> -----------
> rbellamy@eanna i ~ % pacman -Q linux-lts btrfs-progs-git linux util-linux
> linux-lts 3.14.17-1
> btrfs-progs-git 3.16_108_d34cbe7-1
> linux 3.16.1-1
> util-linux 2.25-3
>
> On Tue, Aug 26, 2014 at 11:39 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> G. Richard Bellamy posted on Tue, 26 Aug 2014 22:05:01 -0700 as excerpted:
>>
>>> When I try to run fallocate with "--keep-size" on my btrfs partitions,
>>> it's failing, and I'm at a loss as to why. This was working in prior
>>> versions.
>>>
>>> Any suggestions on how to attack this problem? I'm betting I'm missing
>>> something simple here, and have just gone down the rabbit hole...
>>>
>>> BTW, I've confirmed that the line that fails is fallocate.c:368 [2],
>>> with "open" always returning -1.
>>
>> One "something simple" you're missing (either that or I am) is any
>> reference to which version you're running.  You say it was working in
>> prior versions, but /which/ prior versions, and /which/ version doesn't
>> work now?
>>
>> --
>> Duncan - List replies preferred.   No HTML msgs.
>> "Every nonfree program has a lord, a master --
>> and if you use the program, he is your master."  Richard Stallman
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
