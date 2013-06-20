Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38352 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab3FTN2e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 09:28:34 -0400
Date: Thu, 20 Jun 2013 14:28:29 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: "Kevin O'Kelley" <kevin@kevinokelley.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
Message-ID: <20130620132829.GP11290@carfax.org.uk>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
 <20130620091622.GL11290@carfax.org.uk>
 <kpul4f$ei7$1@ger.gmane.org>
 <20130620103404.GN11290@carfax.org.uk>
 <kpum9h$ei7$2@ger.gmane.org>
 <20130620105607.GO11290@carfax.org.uk>
 <FDFB4977-0209-4F58-92CB-EF80E3575873@kevinokelley.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JF+ytOk7PH04NsRm"
In-Reply-To: <FDFB4977-0209-4F58-92CB-EF80E3575873@kevinokelley.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JF+ytOk7PH04NsRm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 08:22:12AM -0500, Kevin O'Kelley wrote:
> Thank you for your reply. I appreciate it. Unfortunately this issue
> is a deal killer for us. The ability to take very fast snapshots and
> replicate them to another site is key for us. We just can't us Btrfs
> with this setup. That's too bad. Good luck and thank you.

   If you want to make fast atomic incremental copies of btrfs to a
remote system, then btrfs send/receive may be what you're looking for.

   Hugo.

> Sent from my iPhone
> 
> On Jun 20, 2013, at 5:56 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Thu, Jun 20, 2013 at 10:41:53AM +0000, Gabriel de Perthuis wrote:
> >>>> Instead of redirecting to a different block device, Btrfs could and
> >>>> should refuse to mount an already-mounted superblock when the block
> >>>> device doesn't match, somewhere in or below btrfs_mount.  Registering
> >>>> extra, distinct superblocks for an already mounted raid is a different
> >>>> matter, but that isn't done through the mount syscall anyway.
> >>> 
> >>>   The problem here is that you could quite legitimately mount
> >>> /dev/sda (with UUID=AA1234) on, say, /mnt/fs-a, and /dev/sdb (with
> >>> UUID=AA1234) on /mnt/fs-b -- _provided_ that /dev/sda and /dev/sdb are
> >>> both part of the same filesystem. So you can't simply prevent mounting
> >>> based on the device that the mount's being done with.
> >> 
> >> Okay.  The check should rely on a list of known block devices
> >> for a given filesystem uuid.
> > 
> >   And this is where we fail currently -- that list is held by the
> > btrfs module in the kernel, and is constructed on the basis of what
> > "btrfs dev scan" finds by looking at superblocks on block devices.
> > Currently, there's no method implemented for determining whether a
> > block device with a legitimate btrfs superblock on it is a duplicate
> > of another device, or whether it's a newly-discovered device which is
> > part of an as-yet incompletely specified multi-device FS.
> > 
> >   I think it should be possible to look up the device ID as well, and
> > complain (loudly, to the user, and in the kernel) at btrfs dev scan
> > time if we see duplicates. That would deal with the problem at the
> > earliest point of confusion.
> > 
> >   Hugo.
> > 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---     
                     astronomy is about telescopes.                      

--JF+ytOk7PH04NsRm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUcMDfVheFHXiqx3kAQKP9g//SMy2K3PkB7W9d0kJRPMUs6p/4SLThe0O
YzjnR82b21oaXdhC4pWjMan38yWGbWvvW0oa5O+w0OrrV0Ja88Q/Qt4KIhmMtvLj
nOcwKh755/Y3fvRHi/ta8O5CpXu1PLLmfP39Wq+jgw6mlogCnhocB5cBk+prBPSN
Jag37JgUlqm84fblnPxwXNpDoKojoMY2Wnvrb0XDwGq0bWJ+87PC9KwLw8QxrdpW
TvP3jP4H7qjlNPExAl4yO67Pn9nwpJdP/TkhlGmp4UwM+Fla3eKRTChKIaE0+40j
qH/YoCiHWHePoD/CHxxr/IYB/y7M37AhBKish8kQ9P5WB0i46P+ZIqx7Te6zQ+U8
ZGRE49N7Y2N175xujYWD+QOJXxMveaTRxYoCF5K5eOG/Md+xDSdGgl5Pg+/mrjDH
lxF4urqjBl44pE1RqFlD11UUAoKpTmaJoqHKrGt8zTDx4ckpTRhXbPBgKZiH+nvC
hraI5bBMhfOO5GGH+cXQ4Kacyk3+qwCALmfRJY0sHCScVH69ksbb5vejaw/lpY3i
433t7kC55Z426OxMGyJW/oV2XLBxT1b9WXrNRW653v0qrfpebcjdImpD8UQwoKQI
SXta4zAcNM5T987lnO1GRAseurbL4UDUFcfNeIiGWU9GEn21snAgi1ipauivSoPq
Ysofp8QQbl0=
=CO8Y
-----END PGP SIGNATURE-----

--JF+ytOk7PH04NsRm--
