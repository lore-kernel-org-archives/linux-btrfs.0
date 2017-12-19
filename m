Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:48011 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbdLSVR7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 16:17:59 -0500
Date: Tue, 19 Dec 2017 22:17:57 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171219211757.GC14726@polanet.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
 <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 12:47:33 -0700, Chris Murphy wrote:

> The more verbose man pages are, the more likely it is that information
> gets stale. We already see this with the Btrfs Wiki. So are you

True. The same applies to git documentation (3rd paragraph):

https://stevebennett.me/2012/02/24/10-things-i-hate-about-git/

Fortunately this CAN be done properly, one of the greatest
documentations I've seen is systemd one.

What I don't like about documentation is lack of objectivity:

$ zgrep -i bugs /usr/share/man/man8/*btrfs*.8.gz | grep -v bugs.debian.org

Nothing. The old-school manuals all had BUGS section even if it was
empty. Seriously, nothing appropriate to be put in there? Documentation
must be symmetric - if it mentions feature X, it must mention at least the
most common caveats.

> volunteering to do the btrfs-progs work to easily check kernel
> versions and print appropriate warnings? Or is this a case of
> complaining about what other people aren't doing with their time?

This is definitely the second case. You see, I got my issues with btrfs, I
already know where to use it and when not. I've learned HARD and still
didn't fully recovered (some dangling r/o, some ENOSPACE due to
fragmentation etc). What I /MIGHT/ help to the community is to share my
opinions and suggestions. And it's all up to you, what would you do with
this. Either you blame me for complaining or you ignore me - you
should realize, that _I_do_not_care_, because I already know things that
I write. At least some other guy, some other day would read this thread and my
opinions might save HIS day. After all, using btrfs should be preceded
with research.

No offence, just trying to be honest with you. Because the other thing
that I've learned hard in my life is to listen regular users of my
products and appreciate any feedback, even if it doesn't suit me.

>> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
>> safely add "degraded" to the mount options? My primary concern is the
[...]
> Btrfs simply is not ready for this use case. If you need to depend on
> degraded raid1 booting, you need to use mdadm or LVM or hardware raid.
> Complaining about the lack of maturity in this area? Get in line. Or
> propose a design and scope of work that needs to be completed to
> enable it.

I thought the work was already done if current kernel handles degraded RAID1
without switching to r/o, doesn't it? Or something else is missing?

-- 
Tomasz Pala <gotar@pld-linux.org>
