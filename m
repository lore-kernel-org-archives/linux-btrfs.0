Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34588 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbcGGUUY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 16:20:24 -0400
Received: by mail-oi0-f52.google.com with SMTP id s66so38879210oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 13:20:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e6f35e35-f2bd-03f6-5544-4fb8fa527042@gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com> <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com> <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com> <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com> <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
 <e6f35e35-f2bd-03f6-5544-4fb8fa527042@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jul 2016 14:20:22 -0600
Message-ID: <CAJCQCtQvp8p71Uwv2x-Sag+1W=T9wKWn4YckKSYyqrbjdOYQcQ@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 1:59 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> D-Bus support needs to be optional, period.  Not everybody uses D-Bus (I
> have dozens of systems that get by just fine without it, and know hundreds
> of other people who do as well), and even people who do don't always use
> every tool needed (on the one system I manage that does have it, the only
> things I need it for are Avahi, ConsoleKit, udev, and NetworkManager, and
> I'm getting pretty close to the point of getting rid of NM and CK and
> re-implementing or forking Avahi).  You have to consider the fact that there
> are and always will be people who do not install a GUI on their system and
> want the absolute minimum of software installed.

That's fine, they can monitor kernel messages directly as their
notification system. I'm concerned with people who don't ever look at
kernel messages, you know, mortal users who have better things to do
with a computer than that. It's important for most anyone to not have
to wait for problems to manifest traumatically.


> Personally, I don't care what Fedora is doing, or even what GNOME (or any
> other DE for that matter, the only reason I use Xfce is because some things
> need a GUI (many of them unnecessarily), and that happens to be the DE I
> have the fewest complaints about) is doing.  The only reason that things
> like GNOME Disks and such exist is because they're trying to imitate Windows
> and OS X, which is all well and good for a desktop, but is absolute crap for
> many server and embedded environments (Microsoft finally realized this, and
> Windows Server 2012 added the ability to install without a full desktop,
> which actually means that they have _more_ options than a number of Linux
> distributions (yes you can rip out the desktop on many distros if you want,
> but that takes an insane amount of effort most of the time, not to mention
> storage space)).

I'm willing to bet dollars to donuts Xfce fans would love to know if
one of their rootfs mirrors is spewing read errors, while smartd
defers to the drive which says "hey no problems here". GNOME at least
does report certain critical smart errors, but that still leaves
something like 40% of drive failures happening without prior notice.


> Storaged also qualifies as something that _needs_ to be optional, especially
> because it appears to require systemd (and it falls into the same category
> as D-Bus of 'unnecessary bloat on many systems').  Adding a mandatory
> dependency on systemd _will_ split the community and severely piss off quite
> a few people (you will likely get some rather nasty looks from a number of
> senior kernel developers if you meet them in person).

I just want things to work for users, defined as people who would like
to stop depending on Windows and macOS for both server and desktop
usage. I don't really care about ideological issues outside of that
goal.

-- 
Chris Murphy
