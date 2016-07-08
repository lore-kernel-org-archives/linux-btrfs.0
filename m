Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34252 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbcGHMYY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 08:24:24 -0400
Received: by mail-it0-f65.google.com with SMTP id u186so3399849ita.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 05:24:24 -0700 (PDT)
Subject: Re: 64-btrfs.rules and degraded boot
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
 <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com>
 <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com>
 <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
 <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
 <e6f35e35-f2bd-03f6-5544-4fb8fa527042@gmail.com>
 <CAJCQCtQvp8p71Uwv2x-Sag+1W=T9wKWn4YckKSYyqrbjdOYQcQ@mail.gmail.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3e97fc5d-74ab-b1bc-1556-32ddd8d2ba8f@gmail.com>
Date: Fri, 8 Jul 2016 08:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQvp8p71Uwv2x-Sag+1W=T9wKWn4YckKSYyqrbjdOYQcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 16:20, Chris Murphy wrote:
> On Thu, Jul 7, 2016 at 1:59 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> D-Bus support needs to be optional, period.  Not everybody uses D-Bus (I
>> have dozens of systems that get by just fine without it, and know hundreds
>> of other people who do as well), and even people who do don't always use
>> every tool needed (on the one system I manage that does have it, the only
>> things I need it for are Avahi, ConsoleKit, udev, and NetworkManager, and
>> I'm getting pretty close to the point of getting rid of NM and CK and
>> re-implementing or forking Avahi).  You have to consider the fact that there
>> are and always will be people who do not install a GUI on their system and
>> want the absolute minimum of software installed.
>
> That's fine, they can monitor kernel messages directly as their
> notification system. I'm concerned with people who don't ever look at
> kernel messages, you know, mortal users who have better things to do
> with a computer than that. It's important for most anyone to not have
> to wait for problems to manifest traumatically.
My point is that they probably need btrfs-progs too.  Take me for 
example, I don't use some fancy graphical tool to tell me when my disks 
are failing, but I don't scrape kernel logs either.  I have things set 
up to monitor the disks directly (using btrfs-progs in the case of stuff 
that can check for), and notify me via e-mail if there's an issue.  Not 
supporting that use case at all would be like e2fsprogs adding a 
dependency on X11 and telling everyone who doesn't want to use X11 to 
just go implement their own tools.  If that happened, e2fsprogs would 
get forked, the commit reverted in that fork, and most of the 
non-enterprise distros would probably switch pretty damn quick to the 
forked version.
>
>
>> Personally, I don't care what Fedora is doing, or even what GNOME (or any
>> other DE for that matter, the only reason I use Xfce is because some things
>> need a GUI (many of them unnecessarily), and that happens to be the DE I
>> have the fewest complaints about) is doing.  The only reason that things
>> like GNOME Disks and such exist is because they're trying to imitate Windows
>> and OS X, which is all well and good for a desktop, but is absolute crap for
>> many server and embedded environments (Microsoft finally realized this, and
>> Windows Server 2012 added the ability to install without a full desktop,
>> which actually means that they have _more_ options than a number of Linux
>> distributions (yes you can rip out the desktop on many distros if you want,
>> but that takes an insane amount of effort most of the time, not to mention
>> storage space)).
>
> I'm willing to bet dollars to donuts Xfce fans would love to know if
> one of their rootfs mirrors is spewing read errors, while smartd
> defers to the drive which says "hey no problems here". GNOME at least
> does report certain critical smart errors, but that still leaves
> something like 40% of drive failures happening without prior notice.
I'm not saying some specific users don't care, I'm saying that requiring 
people to have a specific software stack which may not work for their 
use case is a stupid choice for something as low level as this.  Yes 
people want to know when something failed, but we shouldn't mandate 
_how_ they choose in a given system to check this.  There need to be 
more choices than just a GUI tool and talking directly to the kernel. 
Looking at this another way, it is fully possible to implement something 
to do this in a DE agnostic manner _without depending on D-BUS_ using 
the tools as they are right now.  An initial implementation would of 
course be inefficient, but until we get notifications _from the kernel_ 
about FS state, we have to poll regardless, which means that having 
D-Bus support would not help (and would probably just make things slower).
>
>
>> Storaged also qualifies as something that _needs_ to be optional, especially
>> because it appears to require systemd (and it falls into the same category
>> as D-Bus of 'unnecessary bloat on many systems').  Adding a mandatory
>> dependency on systemd _will_ split the community and severely piss off quite
>> a few people (you will likely get some rather nasty looks from a number of
>> senior kernel developers if you meet them in person).
>
> I just want things to work for users, defined as people who would like
> to stop depending on Windows and macOS for both server and desktop
> usage. I don't really care about ideological issues outside of that
> goal.
Making us hard depend on storaged would not help this goal.  It's no 
different than the Microsoft and Apple approach of 'our way or not at all'.

To clarify, I'm not trying to argue against adding support, I'm arguing 
against it being mandatory.  A filesystem which requires specific system 
services to be running just for regular maintenance tasks is not a well 
designed filesystem.  To be entirely honest, I'm not all that happy 
about the functional dependency on udev to have device discovery, but 
there's no point in me arguing about that...

Just thinking aloud, but why not do a daemon that does the actual 
monitoring, and then provide an interface (at least a UNIX domain 
socket, and optionally a D-Bus endpoint) that other tools can use to 
query filesystem status.  LVM already has a similar setup for monitoring 
DM-RAID volumes, snapshots, and thin storage pools, although it's 
designed as an event driven tool that does something when specific 
things happen (for example, possibly auto-extending snapshots when they 
start to get full).  Other than the D-Bus support, I could probably 
write a basic piece of software to do this in Python in about a week of 
work (most of which would be figuring out the edge cases and making sure 
it works on both 2.7 and 3) that would provide similar functionality 
(with better configurability too) to that which could easily provide an 
interface to query filesystem status.
