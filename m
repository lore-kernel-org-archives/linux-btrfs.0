Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56049 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbbKXV1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 16:27:54 -0500
Date: Tue, 24 Nov 2015 21:27:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        Nils Steinger <nst@voidptr.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
Message-ID: <20151124212746.GS24333@carfax.org.uk>
References: <56530608.50906@gmail.com>
 <20151123211012.GA12286@ny.voidptr.de>
 <pan$7e9cd$79273243$6e85efe7$7ee378ef@cox.net>
 <56545C1B.1080507@gmail.com>
 <1448390914.21291.42.camel@scientia.net>
 <5654CC1B.4030209@gmail.com>
 <1448398257.21291.63.camel@scientia.net>
 <5654CF58.8080207@gmail.com>
 <1448399833.21291.84.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYiX8PV3zo/VeWJR"
In-Reply-To: <1448399833.21291.84.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aYiX8PV3zo/VeWJR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2015 at 10:17:13PM +0100, Christoph Anton Mitterer wrote:
> On Tue, 2015-11-24 at 15:58 -0500, Austin S Hemmelgarn wrote:
> > I had tried using send/receive once with -p, but had numerous issues.
> =A0
> > The incrementals I've been doing have used -c instead, and I hadn't had=
=A0
> > any issues with data loss with that.=A0=A0The issue outlined here was o=
nly a=A0
> > small part of why I stopped using it for backups.=A0=A0The main reason =
was=A0
> > to provide better consistency between my local copies and what I upload=
=A0
> > to S3/Dropbox, meaning I only have to test one back up image per=A0
> > filesystem backed-up, instead of two.
>=20
> Okay maybe I just don't understand how to use send/receive correctly...
>=20
>=20
> What I have is about the following (simplified):
>=20
> master-fs:
> 5
> |
> +--data (subvol, my precious data)
> |
> +--snapshots
> =A0 =A0|
> =A0 =A0+--2015-11-01 (suvol, ro-snapshot of /data)
>=20
> So 2015-11-01 is basically the first snapshot ever made.
>=20
> Now I want to have it on:
> backup-fs
> +--2015-11-01 (suvol, ro-snapshot of /data)
>=20
>=20
> So far I did
> btrfs send /master-fs/snapshots/2015-11-01 | btrfs receive /backup-fs/201=
5-11-01
>=20
>=20
>=20
>=20
> Then time goes by and=A0I get new content in the data subvol, so what
> I'd like to have then is a new snapshot on the master-fs:
> 5
> |
> +--data (subvol, more of my precious data)
> |
> +--snapshots
> =A0 =A0|
> =A0 =A0+--2015-11-01 (suvol, ro-snapshot of /data)
> =A0 =A0+--2015-11-20 (suvol, ro-snapshot of /data)
>=20
> And this should go incrementally on backup-fs:
> backup-fs
> +--2015-11-01 (suvol, ro-snapshot of /data)
> +--2015-11-20
> (suvol, ro-snapshot of /data)
>=20
> So far I used something like:
> btrfs send -p=A02015-11-01 /master-fs/snapshots/2015-11-20 | btrfs receiv=
e /backup-fs/2015-11-20
>=20
> And obviously I want it to share all the ref-links and stuf...
>=20
>=20
> So in other words, what's the difference between -p and -c? :D

   -p only sends the file metadata for the changes from the reference
snapshot to the sent snapshot. -c sends all the file metadata, but
will preserve the reflinks between the sent snapshot and the (one or
more) reference snapshots. You can only use one -p (because there's
only one difference you can compute at any one time), but you can use
as many -c as you like (because you can share extents with any number
of subvols).

   In both cases, the reference snapshot(s) must exist on the
receiving side.

   In implementation terms, on the receiver, -p takes a (writable)
snapshot of the reference subvol, and modifies it according to the
stream data. -c makes a new empty subvol, and populates it from
scratch, using the reflink ioctl to use data which is known to exist
in the reference subvols.

   Hugo.

--=20
Hugo Mills             | Anyone who claims their cryptographic protocol is
hugo@... carfax.org.uk | secure is either a genius or a fool. Given the
http://carfax.org.uk/  | genius/fool ratio for our species, the odds aren't
PGP: E2AB1DE4          | good.                                  Bruce Schne=
ier

--aYiX8PV3zo/VeWJR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVNZSAAoJEFheFHXiqx3ksLoP/iDzOdyoXGSxoj9JIeO8M5K2
0FoWAWx9kJyhtMvTE/ZZmoM/ihgXJ/CkCpzHcjsWHMyjcAny3bi+BwS23PCt6nKM
0eeg9shEFMk61uQshMZKJbvQw6vaLnuViuskiI933SfEOX5wIVAAfbHWOfOem7qt
XaJxq9aYpKSzfHVsMyF49NE6Ewac4UZZcTSOMs/pox0g8uz1aYBJXINTHlBOAKJf
CYp2BPktztl+x3cUQAv01gjkyzN3iesEvMpQYD2viIXXiwfg2JPO3B5l+g+OB9a+
sATk+jrWslRsW7aAjZ+qHvqwHeT1vmWSPozYnNiSFmtEJOHf/tlCaijZvJ/euZrK
ddPGp0dDZ4Ak2IdGOChxBWTPPPPEi6xS5P3wpWd/+vUIrWxKtw6DC1Ar5Uk42JY/
/Vcl/7I907E/ewLHH6Yk6K1C2MuXdKTihgFS2KZ7UKLjlhtXlMSBbo95xQZgHrvJ
lJF1/WQ6wdfWi5XHXQ6nNljp4O2s6tbt6DwmWDhgInJ461Fd1+6GwxvBbUQhnB1v
4pSgM+MT0ohTzNoGmyHWR9K5J3HMIjBBZRDShFDw6WGNL1YQIWwtp1cSckx9PlSr
X2cj0qsow0fxU9x3AEXh+i/txObuN4R3OnYnCL0XWdBXMnbKFpWMYzUZd/Qns1Lf
E6kgUQ1GFBmsSwuxEhsu
=njfT
-----END PGP SIGNATURE-----

--aYiX8PV3zo/VeWJR--
