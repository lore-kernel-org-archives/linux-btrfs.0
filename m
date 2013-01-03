Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38309 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3ACT2w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 14:28:52 -0500
Date: Thu, 3 Jan 2013 19:28:48 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Option LABEL
Message-ID: <20130103192848.GD19051@carfax.org.uk>
References: <20130103183341.GC19051@carfax.org.uk>
 <CO8j2OqeCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rAc+36e7LRL7Dg7x"
In-Reply-To: <CO8j2OqeCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rAc+36e7LRL7Dg7x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 03, 2013 at 08:08:00PM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 03.01.13:
> 
> >>>> But for what purpose offers "mkfs.btrfs" this option?
> 
> >>>    So that you don't have to run the label command immediately
> >>>    after making the filesystem.
> 
> 
> >> But other filesystems don't put the label onto more than 1 device.
> >> There's the problem for/with btrfs.
> 
> >    Aargh. How many times do I have to say this?
> 
> >    Devices are not given labels.
> >    *Filesystems* are given labels.
> 
> And "mkfs.btrfs" combines working with devices and working with a  
> filesystem.

   As do all mkfs implementations. They write a filesystem to a device
(or devices), and optionally give the filesystem a label. They don't
put labels on devices, except incidentally where each filesystem
exists on one or more devices.

>         blkid /dev/sdb
> 
> shows (if set) the label of a device (among other data).

   No, it shows the label of the filesystem that lives on that device.
Other devices may have another part of the same filesystem on them,
and will show the same label.

   I repeat: devices do not have labels.

> >> The label has to be unique for the whole machine.
> 
> >    Wrong. You can have several filesystems on a machine with the same
> > label.
> 
> On my machines that doesn't work when I use programs like "blkid" or  
> "findfs". They don't work when there is more than 1 device with the same  
> label. That's no special btrfs problem, that happens with (p.e.) ext4fs  
> too.

   OK, and that's a blkid problem, not a btrfs problem.

> > It doesn't mean that they're easily managable, but there's
> > nothing that will stop it from happening.
> 
> >    If you want a unique label for a *device*, take a look at the
> > symlinks in /dev/disk/by-id, and the udev rules that generate them.
> 
> Sorry - I don't use "udev" (I've told it long time ago). And I still  
> believe that "btrfs" doesn't depend on "udev".

   No, btrfs doesn't depend on udev.

   However, trying to make a unique device label out of a filesystem
label won't work. This isn't a bug, it's not something that was ever
guaranteed, it's just the wrong approach. You need to find another
one -- see below for the options that I can see.

> > Trying to use filesystem labels to give unique and stable device IDs
> > is the wrong tool for the job.
> 
> I beg to differ. On my machines it's the simpliest way, and it's a sure  
> way.

   No, because *it* *doesn't* *work*. This is not a bug. This is how
things have always behaved -- you're relying on an assumption (one FS
per device) which simply isn't true any longer.

   You may think it's simpler, but that's because your assumptions are
incorrect. The world does not work the way you think it does. I'm
sorry this makes things hard for you, but what you're asking for is
not in scope for a filesystem -- any filesystem.

> [...]
> 
> 
> >    As I said above, you're expecting something which just isn't true.
> > Filesystems have labels, not devices. If you want to have unique
> > labels on devices, then you're going to have to write some udev rules
> > to generate them for you, and then refer to /dev/helmuts-devices/foo
> > (or whatever you want to call them).
> 
> And how is the way for a system which doesn't use "udev"?

   There isn't one ready-made. Your options are:

 * run udev

 * write something which uses (e.g.) SMART information on block
   devices to extract a unique ID, and convert that into a stable
   device label (which is effectively what udev does)

 * find some piece of the device which isn't going to be overwritten
   by partition tables, GPTs, filesystems, or other kinds of metadata,
   and write your label into there; again, you will need to develop
   your own tool for reading/writing this information

> Labelling via "btrfs filesystem label <device> <label>" works well.

   Clearly it doesn't, because you're having problems with it. The
behaviour where only one device in the FS gets the label, immediately
after a btrfs label command, is a bug -- *all* of the devices in the
FS should get the label. You're trying to rely on the behaviour of a
bug, not on the designed behaviour of the system.

   You need to find some other way of doing this. btrfs is working as
it should, and I'm afraid you're using the wrong tools for the job
you're trying to do.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                     --- O tempura! O moresushi! ---                     

--rAc+36e7LRL7Dg7x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUOXb8L9z9OVl50rAAQIADBAApMH3iLw6IJkG9nG+1slDlrXpPV79r/Qm
ahTc3iRmQe3CxARuVdj95DPizz7WNOJFRs+pD5RHu9VC5M6CmShggGe7PpTa3m+Q
TOGcC/loZrerHdqjgkH3xLEHxCOHZGn4FLsqQtMWCUw9fm4uV9cpWIa9kcCNSZ7k
JcDEs7LgdWAPXCUzwew7KUXW4T+pw5HhPw+8UteLYlgAooamptuODWf7fd89P/g+
IV0YxlFXMgyG+bzUSZLacDish7OXFBU2PpxVNsGLiWoNiyAoz4pUl0z0cAIoNfXX
oMfNBU5xkksAn57uiKcWb2N+8va2wF5tlnFFDpR4jnE2wN+No192FMpWO3FhE81F
HHB6KTRc+8K2e90nTYPHXItXhoVmLU8P7Ggm5yGAJI0Y6WJpg/N7bvXGb4qqK1Ij
Q68kIffVkvKw/mw2toSLAsC7x5VhaF6Tsn4zYL8rXZ6G3T7920aHGBYfhqw1dXCP
LZVL/uP+Qi7vF79a7SYtIkpVMGMk5PJG9bVnOUU+mKIzq2bjpqI8uEPSUvoF5dUS
a6KFwm2m7z3yXozUAKFsXTf1Xc0t6lfiB1ggltYfBbv8ikiVvnz9wdmfHnkPE3QV
7okbNII3/Lkdh0X+W2ZVL7LxdLX8yf3X6h2fbkr7LO6q9opYI5F/0b8X4khXebEO
hiTWtZxj4DI=
=8vYv
-----END PGP SIGNATURE-----

--rAc+36e7LRL7Dg7x--
