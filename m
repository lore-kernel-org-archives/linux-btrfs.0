Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:55552 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbeA0N0o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 08:26:44 -0500
Date: Sat, 27 Jan 2018 14:26:41 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Tomasz Pala <gotar@polanet.pl>
Cc: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180127132641.mhmdhpokqrahgd4n@angband.pl>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180127110619.GA10472@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 12:06:19PM +0100, Tomasz Pala wrote:
> On Sat, Jan 27, 2018 at 13:26:13 +0300, Andrei Borzenkov wrote:
> 
> >> I just tested to boot with a single drive (raid1 degraded), even with
> >> degraded option in fstab and grub, unable to boot !  The boot process
> >> stop on initramfs.
> >> 
> >> Is there a solution to boot with systemd and degraded array ?
> > 
> > No. It is finger pointing. Both btrfs and systemd developers say
> > everything is fine from their point of view.

It's quite obvious who's the culprit: every single remaining rc system
manages to mount degraded btrfs without problems.  They just don't try to
outsmart the kernel.

> Treating btrfs volume as ready by systemd would open a window of
> opportunity when volume would be mounted degraded _despite_ all the
> components are (meaning: "would soon") be ready - just like Chris Murphy
> wrote; provided there is -o degraded somewhere.

For this reason, currently hardcoding -o degraded isn't a wise choice.  This
might chance once autoresync and devices coming back at runtime are
implemented.

> This is not a systemd issue, but apparently btrfs design choice to allow
> using any single component device name also as volume name itself.

And what other user interface would you propose?  The only alternative I see
is inventing a device manager (like you're implying below that btrfs does),
which would needlessly complicate the usual, single-device, case.
 
> If btrfs pretends to be device manager it should expose more states,

But it doesn't pretend to.

> especially "ready to be mounted, but not fully populated" (i.e.
> "degraded mount possible"). Then systemd could _fallback_ after timing
> out to degraded mount automatically according to some systemd-level
> option.

You're assuming that btrfs somehow knows this itself.  Unlike the bogus
assumption systemd does that by counting devices you can know whether a
degraded or non-degraded mount is possible, it is in general not possible to
know whether a mount attempt will succeed without actually trying.

Compare with the 4.14 chunk check patchset by Qu -- in the past, btrfs did
naive counting of this kind, it had to be replaced by actually checking
whether at least one copy of every block group is actually present.

An example scenario: you have a 3-device filesystem, sda sdb sdc.  Suddenly,
sda goes offline due to a loose cable, controller hiccup, evil fairies, or
something of this kind.  The sysadmin notices this, rushes in with an
USB-attached disk (sdd), rebalances.  After reboot, sda works well (or got
its cable reseated, etc), while sdd either got accidentally removed or is
just slow to initialize (USB...).  So, systemd asks sda how many devices
there are, answer is "3" (sdb and sdc would answer the same, BTW).  It can
even ask for UUIDs -- all devices are present.  So, mount will succeed,
right?
 
> Unless there is *some* signalling from btrfs, there is really not much
> systemd can *safely* do.

Btrfs already tells everything it knows.  To learn more, you need to do most
of the mount process (whether you continue or abort is another matter). 
This can't be done sanely from outside the kernel.  Adding finer control
would be reasonable ("wait and block" vs "try and return immediately") but
that's about all.  It's be also wrong to have a different interface for
daemon X than for humans.

Ie, the thing systemd can safely do, is to stop trying to rule everything,
and refrain from telling the user whether he can mount something or not.
And especially, unmounting after the user mounts manually...


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ The bill with 3 years prison for mentioning Polish concentration
⣾⠁⢰⠒⠀⣿⡁ camps is back.  What about KL Warschau (operating until 1956)?
⢿⡄⠘⠷⠚⠋⠀ Zgoda?  Łambinowice?  Most ex-German KLs?  If those were "soviet
⠈⠳⣄⠀⠀⠀⠀ puppets", Bereza Kartuska?  Sikorski's camps in UK (thanks Brits!)?
