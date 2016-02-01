Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47741 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416AbcBAB7z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jan 2016 20:59:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aQ3mU-0004p6-1G
	for linux-btrfs@vger.kernel.org; Mon, 01 Feb 2016 02:59:54 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 02:59:54 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 02:59:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "WARNING: device 0 not present" during scrub?
Date: Mon, 1 Feb 2016 01:59:47 +0000 (UTC)
Message-ID: <pan$a5942$fba0acbe$9f4ebb6$67162104@cox.net>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
	<CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
	<CAKbQEqH5twwezxYicthcCb6=dWgW3Hy-s6fLjH_BQETk4i0ikQ@mail.gmail.com>
	<CAJCQCtRw1VqaES4UCbaSNqCRXV5puA5gssxNSxsiUBKxa13dPQ@mail.gmail.com>
	<CAKbQEqFYQ0XQAQOzOBX=n5jrxxws97Qd5OizEaGGq6tayEJcKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Pernegger posted on Sun, 31 Jan 2016 13:35:58 +0100 as
excerpted:

> On 31 January 2016 at 02:42, Chris Murphy <lists@colorremedies.com>
> wrote:
>> On Sat, Jan 30, 2016 at 2:19 PM, Christian Pernegger It maybe be stable
>> for Debian but is Debian explicitly supporting Btrfs with this release?
>> I don't think they are.
> 
> The modules are in the kernel, the progs are in the main archive, it's
> an option in the installer. It's not the default fs but I couldn't find
> any indication that it's more or less supported than, say, xfs.
> Why they've chosen 3.16 (and not 3.18, which would be a long term
> release) I don't know, but the fact remains that that's the default
> kernel of a tier 1 distro, so people using it are going to be around for
> a while.

[To pernegger@ and list both, as requested.]

What the distro wishes to support is of course up to the distro.  See 
below.

>> But absolutely, of course we hope the problem is gone with the newer
>> version, *that's how file system development works.*
> 
> Be that as it may, as I said, that approach doesn't inspire confidence.
> If I had the vaguest idea about how to reproduce it, sure, but all I
> have is an apparently lightly corrupted or at the very least glitchy fs
> (it mounts and unmounts just fine). How would I know if a new kernel
> helped things?

Umm... Because you _try_ it?

And if you're not willing to _try_ it, why on earth are you running a 
still stabilizing, not fully stable and mature, filesystem, where the 
recommendation is to stay at least reasonably current as there's still 
bugs being actively fixed?

>> I can see how it might seem like it's a reasonable question to just ask
>> first, but it really isn't. There's just so much development happening
>> right now, a developer is not in a great position to think that far
>> back for specific problems and whether yours might be one of them, and
>> in what kernel version it was fixed. *shrug* just doesn't work that
>> way, that's why there are changelogs for every sub kernel version.
> 
> I do understand your point of view, but: If a possible fs corruption bug
> on a widespread (if older) kernel after one month of use and without any
> discernible cause gets nothing more than *shrug* from this list then
> btrfs isn't production ready nor ready for any kind of day-to-day use,
> not because of code maturity but because of that mindset. IMHO the
> btrfs-genie is too far out of the bottle for that,
> the wording of the stability status on the wiki much too inviting.

I know of no list regular claiming btrfs is production ready or fully 
stable.  In fact, the general position here is that btrfs is _not_ 
production ready, and that while btrfs is "stabilizING", it is "not yet 
fully stable and mature."

Yes, depending on the use-case, btrfs is or can be ready for routine 
daily use, provided people are aware of the situation, and are following 
the sysadmin's first rule of backups, which in simplest form says that if 
you don't have at least one backup, by definition of your (in)action, you 
are defining that data as worth less than the time/hassle/resources 
necessary to do that backup.

Of course that's the first rule of backups even if you're running on a 
fully stable and mature filesystem, and because btrfs isn't at that point 
yet, having at least one backup, and preferably more (because with btrfs 
not fully stable and mature, it can't be considered reliable as the 
primary working copy either, more a test deployment, which effectively 
makes the first backup the primary working copy, which means if it isn't 
backed up, thus a second backup, you're still defining the data as of 
little more than trivial value.

Additionally, given the stability situation, here on this list we 
generally rather strongly recommend that people run either the latest or 
at the oldest, the first back, of either the current kernel series or the 
LTS kernel series.  With the just released 4.4 an LTS kernel, and 4.1 the 
previous LTS, that means for best support here, and of course 4.4 current 
and 4.3 the previous current, that means for best support here, we're now 
recommending no older than the 4.4 or 4.1 LTS kernel series, or the 4.4 
or 4.3 current kernel series, tho with 4.4 so new, it's understandable if 
people are still on the second-back LTS, 3.18, provided they're already 
working on upgrading to LTS-4.1.

Of course we still do our best if people are running older than that, but 
because btrfs is still moving fast and older kernels have known bugs that 
are fixed in newer versions, previous to that is ancient history for us, 
and we're simply not able to support it to the same level we do the 
recommended kernels.  As such, people should expect that as soon as they 
have a problem, the first thing they're going to be asked to do is 
upgrade to something newer than the btrfs Paleolithic era (OK, I'm 
exaggerating a bit, Neolithic, then) and see if the problem is already 
fixed.

Of course what distros choose to support is up to them, and some are 
indeed supporting older btrfs, backporting fixes, etc.  But in that case 
people really should be getting their btrfs support from them as well, 
because they're best positioned to know what fixes they've backported to 
whatever arbitrary kernel version number they're using, while all we know 
is what mainline code of a comparable version was like.

Then of course there's the userspace tools, btrfs-progs.  While on a 
normal runtime kernel the kernel code is what counts as userspace 
primarily simply makes calls to the kernel and the kernel does all the 
work, as soon as you're using userspace to try to work with an offline 
btrfs, btrfs check, btrfs restore, etc, it's userspace code doing the 
work, and then running current userspace becomes critical, as again, it 
has all the bugfixes that older versions lack.  While both kernels and 
userspace are designed to work with both older and newer versions of the 
other, a good rule of thumb for userspace is to keep its version at least 
in sync with your kernel version.  That way, provided you're following 
the kernel recommendations of no more than one LTS kernel series back 
from the current LTS kernel series, userspace won't get too outdated, 
either.


As for old and stable, yes, there's legitimate reasons to want to run old 
and stable.  However, they tend not to be very compatible with wanting to 
run a new and still stabilizing filesystem that's not yet mature, since 
the filesystem code is still moving fast and there are /real/ bugs being 
fixed every release.  Thus, the general recommendation, on-list at least, 
is to pick one or the other, and if you pick old and stale^h^hble, forget 
about btrfs for the time being.  Again, what your distro may support and 
whether you choose to use that support is between you and the distro, but 
then, you really are probably better off actually using that distro 
support, since they're the ones that know what they've backported, etc, 
and not the list, where our focus is on further stabilization in 
reasonably current mainline current or LTS series kernels.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

