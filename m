From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: How file store when using Btrfs on multi-devices? What happen
 when a device fail?
Date: Thu, 3 May 2012 08:35:39 +0100
Message-ID: <20120503073539.GD9860@carfax.org.uk>
References: <CAGP-ymNoE1CtSTdYXJMgQ0k2HmRmDxq=zSxNE7pGonoTzrkNHw@mail.gmail.com>
 <CAG1y0sdkgJ9y=1Y=A+n8QAU73TKeBAej9GFJ26w7czOtDNzQ2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNQTSEo8WG/FKZ8E"
Cc: Chu Duc Minh <chu.ducminh@gmail.com>, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdkgJ9y=1Y=A+n8QAU73TKeBAej9GFJ26w7czOtDNzQ2g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--tNQTSEo8WG/FKZ8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 01:56:10PM +0700, Fajar A. Nugraha wrote:
> On Thu, May 3, 2012 at 1:46 PM, Chu Duc Minh <chu.ducminh@gmail.com> wrote:
> > Hi, i have some questions when using Btrfs on multi-devices:
> > 1. a large file will always be stored wholely on a device or it may
> > spread on some devices/partitions?
> 
> IIRC:
> - in raid1 mode, it will be written on all disks (or was it TWO disks,
> regarless how many device in a mirror? can't remember which).

   Any given block of the file will appear on two disks. There's no
guarantee that all the blocks of a file will be stored on the same two
disks, though.

> - in raid10 and raid0, it will always be spread, on a minimum of two devices

   Again, any given block of a file will appear on precisely two disks
(for RAID-10), or precisely one disk (for RAID-0). However, for a
sufficiently large file (i.e. multiples of the stripe size, which is
64KiB, I think), the blocks will be spread across all disks. If the
file is highly fragmented, this is a statistical statement; if the
file is contiguous, it is a guarantee.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- Ceci n'est pas une pipe:  | ---                   

--tNQTSEo8WG/FKZ8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPojVLIKyzvlFcI40RAoPoAJ9EFKIfDrTXDisSUNKCAFl+ecycawCgmzF9
7dGAkHpqLwolLkTsZkZCq0c=
=6X47
-----END PGP SIGNATURE-----

--tNQTSEo8WG/FKZ8E--
