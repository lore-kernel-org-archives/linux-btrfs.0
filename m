Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:42321 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLTAIa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 19:08:30 -0500
Received: by mail-oi0-f65.google.com with SMTP id o64so13575986oia.9
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 16:08:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171219211757.GC14726@polanet.pl>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl> <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
 <20171219211757.GC14726@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 19 Dec 2017 17:08:28 -0700
Message-ID: <CAJCQCtSqw=-_6PBzaTiVhA=yoN4Fm=uwwjtqKgncK4B6R-zfJw@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 2:17 PM, Tomasz Pala <gotar@polanet.pl> wrote:
> On Tue, Dec 19, 2017 at 12:47:33 -0700, Chris Murphy wrote:
>
>> The more verbose man pages are, the more likely it is that information
>> gets stale. We already see this with the Btrfs Wiki. So are you
>
> True. The same applies to git documentation (3rd paragraph):
>
> https://stevebennett.me/2012/02/24/10-things-i-hate-about-git/
>
> Fortunately this CAN be done properly, one of the greatest
> documentations I've seen is systemd one.
>
> What I don't like about documentation is lack of objectivity:
>
> $ zgrep -i bugs /usr/share/man/man8/*btrfs*.8.gz | grep -v bugs.debian.org
>
> Nothing. The old-school manuals all had BUGS section even if it was
> empty. Seriously, nothing appropriate to be put in there? Documentation
> must be symmetric - if it mentions feature X, it must mention at least the
> most common caveats.

It's reasonable to have a known bugs section in the man page, so long
as people are willing to do the work adding to it and deleting it when
bugs are fixed.





>
>> volunteering to do the btrfs-progs work to easily check kernel
>> versions and print appropriate warnings? Or is this a case of
>> complaining about what other people aren't doing with their time?
>
> This is definitely the second case. You see, I got my issues with btrfs, I
> already know where to use it and when not. I've learned HARD and still
> didn't fully recovered (some dangling r/o, some ENOSPACE due to
> fragmentation etc). What I /MIGHT/ help to the community is to share my
> opinions and suggestions. And it's all up to you, what would you do with
> this. Either you blame me for complaining or you ignore me - you
> should realize, that _I_do_not_care_, because I already know things that
> I write. At least some other guy, some other day would read this thread and my
> opinions might save HIS day. After all, using btrfs should be preceded
> with research.
>
> No offence, just trying to be honest with you. Because the other thing
> that I've learned hard in my life is to listen regular users of my
> products and appreciate any feedback, even if it doesn't suit me.

Btrfs development has definitely been a lot more fractured and wild
west and people who do the work get to dictate the direction, than
perhaps other Linux file systems, and certainly that's true compared
to ZFS which has a small team with a very clear ideology and direction
established from the outset.


>
>>> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
>>> safely add "degraded" to the mount options? My primary concern is the
> [...]
>> Btrfs simply is not ready for this use case. If you need to depend on
>> degraded raid1 booting, you need to use mdadm or LVM or hardware raid.
>> Complaining about the lack of maturity in this area? Get in line. Or
>> propose a design and scope of work that needs to be completed to
>> enable it.
>
> I thought the work was already done if current kernel handles degraded RAID1
> without switching to r/o, doesn't it? Or something else is missing?

Well it only does rw once, then the next degraded is ro - there are
patches dealing with this better but I don't know the state. And
there's no resync code that I'm aware of, absolutely it's not good
enough to just kick off a full scrub - that has huge performance
implications and I'd consider it a regression compared to
functionality in LVM and mdadm RAID by default with the write intent
bitmap.  Without some equivalent short cut, automatic degraded means a
decently likely scenario where a slightly late assembly at boot time
will end up requiring a full scrub. That's not an improvement over
manual degraded so people aren't hit with even more silent
consequences of their unfortunate situation.



-- 
Chris Murphy
