Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:53716 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdGVT67 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 15:58:59 -0400
Date: Sat, 22 Jul 2017 21:58:30 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: btrfs device ready purpose
Message-ID: <20170722195830.lx3xgdbsfj3keuil@angband.pl>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
 <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com>
 <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
 <20170717155400.GN2866@twin.jikos.cz>
 <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
 <9a16f6d5-90cd-bd04-a0ea-63e88cc3faf4@gmail.com>
 <CAJCQCtQBidjgsg4MadAAqoy6+dQHCkgz=8pxPX2CC=6Mwj38MQ@mail.gmail.com>
 <CAJCQCtQohx9MYbNFYyd6HidxSE6Cm7+ptwx76HmxBFdy9_7Zuw@mail.gmail.com>
 <20170722181558.GI7140@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170722181558.GI7140@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 22, 2017 at 06:15:58PM +0000, Hugo Mills wrote:
> On Sat, Jul 22, 2017 at 12:06:17PM -0600, Chris Murphy wrote:
> > I just did an additional test that's pretty icky behavior.
> > 
> > 2x HDD device Btrfs volume. Add both devices and `btrfs devices ready`
> > exits with 0 as expected. Physically remove both USB devices.
> > Reconnect one device. `btrfs device ready` still exits 0. That's
> > definitely not good. (If I leave that one device connected and reboot,
> > `btrfs device ready` exits 1).
> 
>    In a slightly less-specific way, this has been a problem pretty
> much since the inception of the FS. It's not possible to do the
> reverse of the "scan" operation on a device -- that is, invalidate/
> remove the device's record in the kernel. So, as you've discovered
> here, if you have a device which is removed (overwritten, unplugged),
> the kernel still thinks it's a part of the FS.

Alas, this needs to be fixed.  The reproducers I posted last week give data
corruption in case a device that was once a part of the FS is reconnected. 
It doesn't matter what it contains now -- be it another part of the FS or
something totally unrelated, as far as the device node (/dev/loop0,
/dev/sda1, etc) is reused, degraded mounts get confused.

It wasn't urgent before as degraded mounts were broken before Qu's chunk
check patch (that's not even merged yet) -- but once running degraded is
not an emergency, there'll be folks doing so for an extended time.

>    It's something I recall being talked about a bit, some years ago. I
> don't recall now why it was going to be useful, though. I think you
> have a good use-case for such a new ioctl (or extension to the
> SCAN_DEV ioctl) now, though.

Such an ioctl would be inherently racey.  Even current udev code is --
mounting right after losetup often fails, sometimes you even need to sleep
longer than 1 second.  With the above in mind, I see no way other than
invalidating and re-checking all known devices at mount time.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
