Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:34797 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753449AbdLSTrf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 14:47:35 -0500
Received: by mail-ot0-f173.google.com with SMTP id n18so8432070otd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 11:47:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171219175633.GA19477@polanet.pl>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 19 Dec 2017 12:47:33 -0700
Message-ID: <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 10:56 AM, Tomasz Pala <gotar@polanet.pl> wrote:
> On Tue, Dec 19, 2017 at 11:35:02 -0500, Austin S. Hemmelgarn wrote:
>
>>> 2. printed on screen when creating/converting "RAID1" profile (by btrfs tools),
>> I don't agree on this one.  It is in no way unreasonable to expect that
>> someone has read the documentation _before_ trying to use something.
>
> Provided there are:
> - a decent documentation AND
> - appropriate[*] level of "common knowledge" AND
> - stable behaviour and mature code (kernel, tools etc.)
>
> BTRFS lacks all of these - there are major functional changes in current
> kernels and it reaches far beyond LTS. All the knowledge YOU have here,
> on this maillist, should be 'engraved' into btrfs-progs, as there are
> people still using kernels with serious malfunctions. btrfs-progs could
> easily check kernel version and print appropriate warning - consider
> this a "software quirks".

The more verbose man pages are, the more likely it is that information
gets stale. We already see this with the Btrfs Wiki. So are you
volunteering to do the btrfs-progs work to easily check kernel
versions and print appropriate warnings? Or is this a case of
complaining about what other people aren't doing with their time?

>
> BTW, doesn't SuSE use btrfs by default? Would you expect everyone using
> this distro to research every component used?

As far as I'm aware, only Btrfs single device stuff is "supported".
The multiple device stuff is definitely not supported on openSUSE, but
I have no idea to what degree they support it with enterprise license,
no doubt that support must come with caveats.


>
>>> [*] yes, I know the recent kernels handle this, but the last LTS (4.14)
>>> is just too young.
>> 4.14 should have gotten that patch last I checked.
>
> I meant too young to be widely adopted yet. This requires some
> countermeasures in the toolkit that is easier to upgrade, like userspace.
>
>> Regarding handling of degraded mounts, BTRFS _is_ working just fine, we
>> just chose a different default behavior from MD and LVM (we make certain
>> the user knows about the issue without having to look through syslog).
>
> I'm not arguing about the behaviour - apparently there were some
> technical reasons. But IF the reasons are not technical, but
> philosophical, I'd like to have either mount option (allow_degraded) or
> even kernel-level configuration knob for this to happen RAID-style.


They are technical, which then runs into the philosophical. Giving
users a hurt me button is not ethical programming.


>
> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
> safely add "degraded" to the mount options? My primary concern is the
> machine UPTIME. I care less about the data, as they are backed up to
> some remote location and loosing day or week of changes is acceptable,
> brain-split as well, while every hour of downtime costs me a real money.

Btrfs simply is not ready for this use case. If you need to depend on
degraded raid1 booting, you need to use mdadm or LVM or hardware raid.
Complaining about the lack of maturity in this area? Get in line. Or
propose a design and scope of work that needs to be completed to
enable it.



> Meanwhile I can't fix broken server using 'remote hands' - mounting degraded
> volume means using physical keyboard or KVM which might be not available
> at a site. Current btrfs behavious requires physical presence AND downtime
> (if a machine rebooted) for fixing things, that could be fixed remotely
> an on-line.

Right. It's not ready for this use case. Complaining about this fact
isn't going to make it ready for this use case. What will make it
ready for the use case is a design, a lot of work, and testing.



> Anyway, users shouldn't look through syslog, device status should be
> reported by some monitoring tool.

Yes. And it doesn't exist yet.


-- 
Chris Murphy
