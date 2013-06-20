Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37500 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3FTKeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 06:34:07 -0400
Date: Thu, 20 Jun 2013 11:34:05 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
Message-ID: <20130620103404.GN11290@carfax.org.uk>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
 <20130620091622.GL11290@carfax.org.uk>
 <kpul4f$ei7$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DH4/xewco2zMcht6"
In-Reply-To: <kpul4f$ei7$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DH4/xewco2zMcht6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 10:22:07AM +0000, Gabriel de Perthuis wrote:
> On Thu, 20 Jun 2013 10:16:22 +0100, Hugo Mills wrote:
> > On Thu, Jun 20, 2013 at 10:47:53AM +0200, Clemens Eisserer wrote:
> >> Hi,
> >> 
> >> I've observed a rather strange behaviour while trying to mount two
> >> identical copies of the same image to different mount points.
> >> Each modification to one image is also performed in the second one.
> 
> >> touch m2/hello
> >> ls -la m1  //will now also include a file calles "hello"
> >> 
> >> Is this behaviour intentional and known or should I create a bug-report?
> > 
> >    It's known, and not desired behaviour. The problem is that you've
> > ended up with two filesystems with the same UUID, and the FS code gets
> > rather confused about that. The same problem exists with LVM snapshots
> > (or other block-device-layer copies).
> > 
> >    The solution is a combination of a tool to scan an image and change
> > the UUID (offline), and of some code in the kernel that detects when
> > it's being told about a duplicate image (rather than an additional
> > device in the same FS). Neither of these has been written yet, I'm
> > afraid.
> 
> To clarify, the loop devices are properly distinct, but the first
> device ends up mounted twice.
> 
> I've had a look at the vfs code, and it doesn't seem to be uuid-aware,
> which makes sense because the uuid is a property of the superblock and
> the fs structure doesn't expose it.  It's a Btrfs problem.

   Yes, it is. (I didn't intend, however obliquely, to imply that it
wasn't).

> Instead of redirecting to a different block device, Btrfs could and
> should refuse to mount an already-mounted superblock when the block
> device doesn't match, somewhere in or below btrfs_mount.  Registering
> extra, distinct superblocks for an already mounted raid is a different
> matter, but that isn't done through the mount syscall anyway.

   The problem here is that you could quite legitimately mount
/dev/sda (with UUID=AA1234) on, say, /mnt/fs-a, and /dev/sdb (with
UUID=AA1234) on /mnt/fs-b -- _provided_ that /dev/sda and /dev/sdb are
both part of the same filesystem. So you can't simply prevent mounting
based on the device that the mount's being done with.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- I know of three kinds: hot, ---                   
                cool,  and what-time-does-the-tune-start?                

--DH4/xewco2zMcht6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUcLanFheFHXiqx3kAQIRBRAAmxPR/refi43dwKB8QTtGo3qnCJi9Vijn
IEiLM+aA1leAcs7C3v0WLHWjnRa0fSR0FqGL3Z+XS16M0yfiT8P/eRSEsy3xQXG6
eq/W2n8cALPAzz4ygR2vIowWmmmN5Qdt+KflpCNksHJ++km5bd9/bDHGl+zkfu2P
wZtOAVPyScvmxRu+OOAOyzkAjuTKWijRNqE9JW26THEUgikw25WIJSv02qbSqYeX
2ZCzXCDBZ/LsuHDHvmXrgXgFGcBNyCTpXa/sDjjn7WikqMuBHh30HSkt5Z18Q+KL
EZ3BAAJ2lJY4thkzniGpLI23R8MPU1sawHrtbeObkM5/28BMCRrqcuene4MPjiD3
o15j3qLXJqrPxPnQfJ2wNP6iegF1SzfbQH9dbxyCxssP6Qi+BDx/ac3jGv1hqd2E
G43R+BKDWZRcEpy13STEzUueZhNg893op1LIsuJyMiZz5v2Y7PbuSJzFzCHd8UtC
yStoS0M0wNkV3wb+YF51AevVKThFHZcKVLg7SvmMnBtRkRWtwAVqw+bSIXynmyKy
EVectlXAgd6R195CQaewyoB2Dbjk77prbNKur4/sLpRbAKYAjAVT6+nWp2p7O/FC
gwKl6ltKMSwQWkz3XFYKsC5e7DvwMkHbGS+e9me+3N3rzpeiqLdzPxLBLYaclzah
89A7CVzDgGc=
=dOIg
-----END PGP SIGNATURE-----

--DH4/xewco2zMcht6--
