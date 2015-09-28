Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37378 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbI1XQO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 19:16:14 -0400
Date: Mon, 28 Sep 2015 23:16:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs: obtain block checksums from user space
Message-ID: <20150928231612.GB25907@carfax.org.uk>
References: <mu1e38$io1$1@ger.gmane.org>
 <5604427D.1000708@gmail.com>
 <CAJs94EbJV+VX16dnkFqH21OMV=uLYSCKnG9KNUCrs7B=rULYLg@mail.gmail.com>
 <1443481911.12614.4.camel@kepstin.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
In-Reply-To: <1443481911.12614.4.camel@kepstin.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2015 at 07:11:51PM -0400, Calvin Walton wrote:
> On Thu, 2015-09-24 at 21:48 +0300, Matwey V. Kornilov wrote:
> > 2015-09-24 21:35 GMT+03:00 Austin S Hemmelgarn <ahferroin7@gmail.com>
> > :
> > > On 2015-09-24 14:06, Matwey V. Kornilov wrote:
>=20
> > > It's worth noting that the way btrfs does checksums isn't per-file,=
=20
> > > it's
> > > per-block. This means that:
> [...]
> > > All in all, this means that if you just want a checksum of the
> > > contents of
> > > the file, it's almost certainly better to just do it in userspace.
> > > If you're trying to figure out what changed, using send/receive and
> > > snapshots is more efficient (usually).
> >=20
> > I want the checksums of the every block of the file to see which part
> > has been changed.
> > I cannot use send/receive because my other file replica is on the
> > remote host but not on the same filesystem. Compare with how rsync
> > works. It calculates checksums of the chunks of both versions of the
> > file and then syncs different chunks over the network. I just want to
> > utilize the fact that btrfs already has the data I need to calculate.
>=20
> The problem with trying to use btrfs checksums to compare two different
> files is that the blocks might not match up, if only due to
> fragmentation. E.g., the same 1gb file might be stored like this on one
> machine:
>=20
> [ 256MB ][ =A0 =A0512 MB =A0 =A0][ 256MB ]
>=20
> And like this on the other:
> [ =A0 =A0 512MB =A0 =A0 ][ =A0 =A0 512MB =A0 =A0 ]
>=20
> Since the checksums are per block, and the blocks can be different
> arrangements on different machines, they're not really all that useful
> for doing comparisons like you want.

   No, those are extents, not blocks, and the FS doesn't checksum in
extents. :) Blocks are 4 KiB in size.

   Hugo.

--=20
Hugo Mills             | SCSI is usually fixed by remembering that it needs
hugo@... carfax.org.uk | three terminations: One at each end of the chain.
http://carfax.org.uk/  | And the goat.
PGP: E2AB1DE4          |                             Andrew McDonald, Hants=
LUG

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWCco8AAoJEFheFHXiqx3kl+QQAKpI7OkPK4D0navNO57/8MoR
A56gPISYM+xBWaQoqnrV9shzMBtrr34bl4a7Tk5/P1swMRA3VcyDHVmxg7O9Iykh
aCnaFZ2ssrMTESgHWWPVy5bbQiniEKl5ExBZv1UGXQH1BcdNI/dTyFABzhdUEADW
x6c+VPJVwyB8k/wheSzVCieHYr38vzkOhGMrwYv26sWxAdJPN0errS8eBNz/HeAX
J4gW5vm+rPkox3kYJPr5NEsvZNGZFj9IArcSjJEzevnjcRGmH1sClx8Kcvz1ISv0
qe7WD6gHv6zFb4WcQOeAN1OlyD5B6yDSuhInVq242lLnlHvFeE8/jQ15E+tIvW3u
SzmKtaPYEaoNI9tWdk+RyeaB7K9ZIhT2NLFeKf6XslYfuQSns5jydF83ctmb6n07
w2FL7ICtJKvvBCWSN+Tzd6VQ8II7CMb0M6Um7k/ORBDQ/qVjTyBtkFUuZyQtZT/R
XlzkMlMMkOdDP00HW+jDeutcK2RX8s97tYR99a6cVKd4ZN2WLtc1/qGn/XWBZff9
y18tKjFBVyO7taqEuTyHpGMD629z+L/AxEndrgaIt3JHVQW0sL9mKAoYxYOY84PZ
mgB9CAwfQhwi/t99jEMjson0yGY4rFLnwbzjprhTNSWSltG5BTpl0cz0HpVBDZA1
IR0FAz+UuIBd2O7oxelS
=zgPc
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
