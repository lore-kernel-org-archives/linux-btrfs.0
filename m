Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41459 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752345AbaJTOEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 10:04:39 -0400
Date: Mon, 20 Oct 2014 10:04:37 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Hugo Mills <hugo@carfax.org.uk>, Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141020140437.GC29401@hungrycats.org>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
 <20141017080202.GA3604@localhost.localdomain>
 <20141017081009.GC582640@mother.pipebreaker.pl>
 <20141017081737.GC29594@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
In-Reply-To: <20141017081737.GC29594@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 08:17:37AM +0000, Hugo Mills wrote: > On Fri, Oct 1=
7, 2014 at 10:10:09AM +0200, Tomasz Torcz wrote:
> > On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
> > > >   Recently I've observed some corruptions to systemd's journal
> > > > files which are somewhat puzzling. This is especially worrying
> > > > as this is btrfs raid1 setup and I expected auto-healing.
> > > >=20
> > > >   System details: 3.17.0-301.fc21.x86_64
> > > > btrfs: raid1 over 2x dm-crypted 6TB HDDs.
> > > > mount opts: rw,relatime,seclabel,compress=3Dlzo,space_cache
> > > >   Reads with cat, hexdump fails with:
> > > > read(4, 0x1001000, 65536)               =3D -1 EIO (Input/output er=
ror)
> > > >=20
> > > Does scrub work for you?
> >=20
> >   As there seem to be no way to scrub individual files, I've started
> > scrub of full volume.  It will take some hours to finish.
> >=20
> >   Meanwhile, could you satisfy my curiosity what would scrub do that
> > wouldn't be done by just reading the whole file?
>=20
>    It checks both copies. Reading the file will only read one of the
> copies of any given block (so if that's good and the other copy is
> bad, it won't fix anything).

Really?  One of my earliest btrfs tests was to run a loop of 'sha1sum
-c' on a gigabyte or two of files in one window while I used dd to
write random data in random locations directly to one of the filesystem
mirror partitions in the other.  I did this test *specifically* to
watch the automatic checksumming and self-healing features of btrfs
in action.  A complete 'sha1sum' verification of the filesystem contents
passed even though the kernel log was showing checksum errors scrolling
by faster than I could read, which strongly implies that read() normally
does check both mirrors before returning EIO.  This was on kernel version
3.12.21 or so, so it should be working on 3.17 too.

Thomasz reports using 'nocow', which breaks the data integrity checks.
I'd expect the read() to return success and provide garbage data, but the
observed behavior is EIO instead.  The underlying device doesn't seem
to be generating the I/O errors, so it's probably metadata corruption
of some kind.  Are there btrfs kernel messages in dmesg?


--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRFFnUACgkQgfmLGlazG5zl5gCgpvf6KlZVtPb6WFnQ4vNlH8cq
zcIAn0DdABtmz0zU+kEB9etLJiQQi2Oe
=vvc8
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
