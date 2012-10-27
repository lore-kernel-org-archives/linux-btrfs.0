Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:45031
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160Ab2J0QJA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 12:09:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Naming of subvolumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com>
Date: Sat, 27 Oct 2012 10:08:57 -0600
Message-Id: <A171EE43-7547-4C01-9159-C55B706E5E35@colorremedies.com>
References: <1351168220.1923.6.camel@hughsie-work.lan> <64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com> <CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com> <B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com> <CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 26, 2012, at 7:58 PM, cwillu <cwillu@cwillu.com> wrote:
> 
> I'd argue that everything should be absolute references to subvolumes
> (/@home, /@, etc), and neither set-default nor subvolume id's should
> be touched.  

grub's core.img prefix is relative to the current default subvolume. I'm unaware of an absolute means of specifying the prefix.

In order to avoid using set-default, you end up with either the need to make a new core.img and install it, prior to every change in what subvolume to boot from (snapshot or other distribution), or do some fancy mv like you mention next.



> There's no need, as you can simply mv those around (even
> while mounted).

What if Ubuntu wants to use root and boot on the top level, but finds boot and root already exist there from Fedora 18? Will Ubunuto package them up properly into a folder or subvol in such a way that Fedora 18 can ever be used again without significant user knowledge about what likely happened?

I think this is untenable. Since set-default is valuable, and its use cannot correctly be proscribed for all time on boot volumes, it's better to figure out how to leverage it.

I think that the top level subvolumes should be named after the distribution: Fedora 18, Fedora 19, Ubuntu 12.04, Suse 12.x, etc. and possibly home can also be in the top level. And inside, can be whatever organization that distro wants. But negotiating generically named boot and root at the top level I think is long term problematic.

The small problem, presently, with Fedora is that grub is referred to as grub2. So the actual core.img prefix that's baked in is /boot/grub2, meaning that even if you change the set-default subvolume, that core.img is incompatible with finding another grub.cfg of the same version without baking a new core.img (or manually setting the prefix).


>  More importantly, it doesn't result in a case where
> the fstab in one snapshot points its mountpoint to a different
> snapshot, with all the hilarity that would cause over time, and also
> allows multiple distros to be installed on the same filesystem without
> having them stomp on each others set-defaults: /@fedora, /@rawhide,
> /@ubuntu, /@home, etc.

You'd have to use absolute paths if you're going to depend on every distro potentially mv'ing every other distros folders and subvolumes around, yes. If a distribution starts moving and renaming my subvolumes, I will not be using that distribution.


Chris Murphy