Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40720 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753135AbcK2DTL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 22:19:11 -0500
Date: Mon, 28 Nov 2016 22:19:08 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Message-ID: <20161129031908.GP8685@hungrycats.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <1480304269.6254.6.camel@scientia.net>
 <2b15ae6f-51ce-45ff-47c0-699506de4e56@inwind.it>
 <20161128214829.GO8685@hungrycats.org>
 <1480384367.6747.46.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="acOuGx3oQeOcSZJu"
In-Reply-To: <1480384367.6747.46.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--acOuGx3oQeOcSZJu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2016 at 02:52:47AM +0100, Christoph Anton Mitterer wrote:
> On Mon, 2016-11-28 at 16:48 -0500, Zygo Blaxell wrote:
> > If a drive's
> > embedded controller RAM fails, you get corruption on the majority of
> > reads from a single disk, and most writes will be corrupted (even if
> > they
> > were not before).
>=20
> Administrating a multi-PiB Tier-2 for the LHC Computing Grid with quite
> a number of disks for nearly 10 years now, I'd have never stumbled on
> such a case of breakage so far...

In data centers you won't see breakages that are common on desktop and
laptop drives.  Laptops in particular sometimes (often?) go to places
that are much less friendly to hardware.

All my NAS and enterprise drives in server racks and data centers just
wake up one morning stone dead or with a few well-behaved bad sectors,
with none of this drama.  Boring!

> Actually most cases are as simple as HDD fails to work and this is
> properly signalled to the controller.
>=20
>=20
>=20
> > If there's a transient failure due to environmental
> > issues (e.g. short-term high-amplitude vibration or overheating) then
> > writes may pause for mechanical retry loops.=A0=A0If there is bitrot in
> > SSDs
> > (particularly in the address translation tables) it looks like a wall
> > of random noise that only ends when the disk goes offline.=A0=A0You can
> > get
> > combinations of these (e.g. RAM failures caused by transient
> > overheating)
> > where the drive's behavior changes over time.
> >=20
> > When in doubt, don't write.
>=20
> Sorry, but these cases as any cases of memory issues (be it main memory
> or HDD controller) would also kick in at any normal writes.

Yes, but in a RAID1 context there will be another disk with a good copy
(or if main RAM is failing, the entire filesystem will be toast no matter
what you do).

> So there's no point in protecting against this on the storage side...
>=20
> Either never write at all... or have good backups for these rare cases.
>=20
>=20
>=20
> Cheers,
> Chris.



--acOuGx3oQeOcSZJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg886wACgkQgfmLGlazG5xE5ACfeyg6jtyhLGwrCGcmxP01Jd17
pg8AoI45+BltjyL+fyuN9U8Xbccn6wBp
=KB55
-----END PGP SIGNATURE-----

--acOuGx3oQeOcSZJu--
