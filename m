Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57646 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdBKBDA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 20:03:00 -0500
Date: Sat, 11 Feb 2017 00:24:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: John Hendy <jw.hendy@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol
 root?
Message-ID: <20170211002459.GL4249@carfax.org.uk>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
 <20170210234927.GK4249@carfax.org.uk>
 <CA+M2ft8-nS4dy-XgAjZmMG=hLMMdr1jk_4wZnVE+H-+Ojz3jAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
In-Reply-To: <CA+M2ft8-nS4dy-XgAjZmMG=hLMMdr1jk_4wZnVE+H-+Ojz3jAQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2017 at 06:05:57PM -0600, John Hendy wrote:
> On Fri, Feb 10, 2017 at 5:49 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Fri, Feb 10, 2017 at 11:40:41AM -0600, John Hendy wrote:
> >> Greetings,
> 
> 
> >    Just as an aside -- it doesn't affect you here, but you might want
> > to be aware -- syslinux doesn't support multi-device btrfs. I've been
> > bitten by that before, and it's a consideration for you should you
> > wish to add another device to this FS. Also, I haven't tried it, but I
> > suspect that it may not support compression in btrfs either.
> 
> Aside appreciated! I don't plan to add a second device, so that's alright.
> 
> I've run into the statement on compression as well... does this mean
> the device it's *on* or the device I want to mount as root?

   The FS that the kernel and initramfs live on.

   The bootloader is responsible for finding the two files containing
the kernel and the initramfs on the FS and loading/running them. (It
may also need to find some components if itself on there; GRUB looks
for config files, for example). Once the kernel and initramfs have
started, it's up to the kernel and the early userspace environment to
deal with, and it's not the bootloader's problem.

> I have to assume the former, and ran across this in my preparation,
> which is why I used ext4. Given that I've been able to specify
> rootflags=compress=lzo in my APPEND line, this is also in /etc/fstab
> and it booted... I'm using this as evidence that it must support
> compression on a root btrfs device? Any reason to think otherwise?
> Their wiki appears to talk about just the boot device:
> - http://www.syslinux.org/wiki/index.php?title=Filesystem#Btrfs

   rootflags=... is ignored by the bootloader and is passed to the
initramfs environment.

> Even with ext4, my current arch install is < May 2016 which is when
> mkfs.ext4 auto-implemented some sort of new 64bit feature so that
> caught me off guard. Initially syslinux just spit out a "can't find
> ldlinux.sys" or similar.
> 
> Given I'm early enough here to abort the plan without much fuss, this
> sort of aside is quite nice to consider if there's something
> inherently wrong with this! So far I have a booting arch and I'm using
> debootstrap to manually install Ubuntu since it's installer has ~zero
> customization options to prep your mount points if you've already got
> them ready...

   The main problem with multi-boot environments on btrfs is that most
distribution installers don't know about btrfs subvols, and won't
install on them. debootstrap is about the only way I know of that will
cope with it. (Although I suspect that some of the from-source
distributions like Gentoo will manage it given enough persuasion).

   A secondary problem is that every distribution assumes that it's
the only thing that's managing /boot and the corresponding bootloader,
kernel and initramfs. This has always been problematic -- it was a
problem when I was multi-booting back in 1999 -- and isn't restricted
to btrfs-based environments. I don't have a good solution for managing
it, I'm afraid.

   Hugo.

-- 
Hugo Mills             | For months now, we have been making triumphant
hugo@... carfax.org.uk | retreats before a demoralised enemy who is advancing
http://carfax.org.uk/  | in utter disorder.
PGP: E2AB1DE4          |                              Eric Frank Russell, Wasp

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYnlnbAAoJEFheFHXiqx3kX8wP/Rk9qHHXijA9a3SB7BOdHQAZ
emZMtCG7OI7eQI2ZQmEQofXZcE+e8AKdbHskuPmWIGIg4ZyRhpW7W9KiYeWyheAl
lPUKBIE6ZrI+ee+eN0XzuLQpNg8qRmNWytAWw3LqHUbOJREuXEWEmWTNR8AyGuoK
0ejnxm3Nqd6wHPvkkcb2Mnp9BtWfrECHL3EvMeoHIXlK23OOrn4nUEVuX6CCpIMm
24+WSTCaDpopTbBr5SgO+c1SVZ8bjMLFYRpcixRnoY/VIsU9xJB2i2WfsXQCBfV7
BgQcZa+IRn6m0qsvsSp56zBmPEvxKYjgY8JqI1cLHwlbXb2zS1vR+/LZTn9z6J8P
yoc/ydqdjIX3Zr0IW0SoOHpf+4E/jY24tH6f5h7f8uRn3zqdJYKuwVHDGaQi1q/2
N5EuXZLZWYNR5ci8ry3T2FRnFfV59RatQmNxoHjwaFV7sZt01KgM/gTVUnDPptSy
J43ASRmhetRfqMtGgHYhnhfoHRAt3KXqgBLGyIoqwfEo5CUGZg5SNOu+qcXPe0Gi
oBm1YBRX9qarD3IF1VF1Ezn9n8wOG8ol0qSiz39efveptjXPnE6ZMdMzgvi7KBpa
SPddGDsgj1fn7i6TEbcbWok/Nx4xzbinlqcfGYXJspFGd+IIbUiV5oBo07r/Mrp0
2lzprW9o51cFLnvV9eZT
=ZouY
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--
