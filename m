Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33695 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbbLFEGK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 23:06:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5QaL-0004e1-9R
	for linux-btrfs@vger.kernel.org; Sun, 06 Dec 2015 05:06:05 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 05:06:05 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 05:06:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: attacking btrfs filesystems via UUID collisions? (was:
 Subvolume UUID, data corruption?)
Date: Sun, 6 Dec 2015 04:06:00 +0000 (UTC)
Message-ID: <pan$ddc43$45608356$bf638c60$d3fc60dc@cox.net>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	<1449366680.3183.37.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sun, 06 Dec 2015 02:51:20 +0100 as
excerpted:

> You have things like ATMs, which are physically usually quite well
> secured, but which do have rather easily accessible maintenance ports.
> All of us have seen such embedded devices rebooting themselves, where
> you see kernel messages.
> That's the point where an attacker could easily get the btrfs UUID:
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.2.0-1-amd64
> root=UUID=bd1ea5a0-9bba-11e5-82fa-502690aa641f
> 
> If you can attack such devices already by just having access to a USB
> port... then holly sh**...

There's actually a number of USB-based hardware and software vulns out
there, from the under $10 common-component-capacitor-based charge-and-zap
(charges off the 5V USB line, zaps the port with several hundred volts
reverse-polarity, if the machine survives the first pulse and continues
supplying 5V power, repeat...), to the ones that act like USB-based input
devices and "type" in whatever commands, to simple USB-boot to a forensic
distro and let you inspect attached hardware (which is where the encrypted
storage comes in, they've got everything that's not encrypted),
to the plain old fashioned boot-sector viruses that quickly jump to
everything else on the system that's not boot-sector protected and/or
secure-boot locked, to...

Which is why most people in the know say if you have unsupervised physical
access, you effectively own the machine and everything on it, at least
that's not encrypted.

There's a reason some places hot-glue the USB ports.  If you're plugging
anything untrusted into them... and that's a well known social engineering
hack as well, simply drop a few thumb drives in the target parking lot and
wait to see who picks them up and plugs them in, so they can call home... 
Pen-testers do it.  NSA does it.  It's said a form of that is how they
bridged the air-gap to the Iranian centrifuges...

If you haven't been keeping up, you really have some reading to do.  If
you're plugging in untrusted USB devices, seriously, a thumb drive with a
few duplicated btrfs UUIDs is the least of your worries!

>> The only real alternative if you don't like it is using a different
>> filesystem.

> As I've said, I don't have a problem with UUIDs... I just can't quite
> believe that btrfs and the userland cannot be modified so that it
> handles such cases gracefully.

As I implied,  UUIDs usage is so deeply embedded, fixing btrfs to not work
that way is pretty much impossible.  You'd be pretty much starting from
scratch and using some of the same ideas; it wouldn't be btrfs any longer.

> If not, than, to be quite honest, that would be really a major
> showstopper for many usage areas.

Consider the show stopped, then.

> And I'm not talking about ATMs (or any other embedded devices where
> people may have non-supervides access - e.g. TVs in a mall,
> entertainment systems in planes) but also the normal desktops/laptops
> where colleagues, fellow students, etc. may want to play some "prank".

As I said, if you're plugging in or allowing to be plugged in untrusted
USB devices, show's over, they're already playing pretty much any prank
they want, including zapping the hardware.  USB's now less trusted than a
raw Internet hookup with all services exposed.  The only controlling
factor now is the physical presence limitation, and if you're plugging in
devices you get for instance as "gifts just for trying us out" or
whatever, that someone mails to you... worse than running MS and
mindlessly running any exe someone sends you.


BTW, this is documented (in someone simpler "do not do XX" form) on the
wiki, gotchas page.

https://btrfs.wiki.kernel.org/index.php/Gotchas#Block-level_copies_of_devices


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

