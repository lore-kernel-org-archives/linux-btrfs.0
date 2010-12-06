From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: 800 GByte free, but "no space left"
Date: Mon, 6 Dec 2010 11:41:28 +0000
Message-ID: <20101206114128.GA4273@carfax.org.uk>
References: <BbJPrrUD1uB@helmut.hullen.de>
 <4CFCB34F.1090504@xyzw.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Cc: helmut@hullen.de, Helmut Hullen <Hullen@t-online.de>,
	linux-btrfs@vger.kernel.org
To: Brian Rogers <brian@xyzw.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CFCB34F.1090504@xyzw.org>
List-ID: <linux-btrfs.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 06, 2010 at 01:56:31AM -0800, Brian Rogers wrote:
> On 12/05/2010 10:26 AM, Helmut Hullen wrote:
> >>So, by far the simplest solution would be to re-create your file
> >>system with "single" mode,
> >Can I add or delete hard disks/partitions to the two devices/partitions
> >in your example?
> 
> You can add, but you'll want to avoid deleting, balancing, and
> shrinking. From my testing, any of these operations will convert the
> chunks they relocate to raid0. Then, once you have any raid0 data,
> btrfs will want to allocate all new chunks as raid0 and you'll have
> the unusable space problem again.

   That's a known bug. Josef even posted a patch for it (but it's
apparently not doing the right thing yet).

> >I've studied the man page and the Wiki but didn't find any help.
> >
> >And in my special case I have to add at least yearly new disks and from
> >time to time remove the smallest disks from this bundle.
> 
> With the current state of btrfs, you could do this as long as you
> never reduce the total number of disks. When you want to replace an
> old disk with a new one, just go around btrfs: take the filesystem
> offline and copy the old disk's partition into a full-sized
> partition on the new disk. Then remove the old disk and bring the
> filesystem online again.
> 
> It will remember the old size at first, but that can be fixed with
> 
> btrfs filesystem resize <devid>:max <path>

   This doesn't work on multi-volume filesystems (yet).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- We believe in free will because we have no choice. ---        

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM/MvoIKyzvlFcI40RAmJaAJ9VI1Q4cDHXwycinDCGMOR8JKsi+wCgxyV8
fZYKAX25bixamfm83EoXSOo=
=57QI
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
