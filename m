Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39903 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752435AbbIPWVD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 18:21:03 -0400
Date: Wed, 16 Sep 2015 18:08:56 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: FYIO: A rant about btrfs
Message-ID: <20150916220856.GA23830@hungrycats.org>
References: <20150916144355.GA1285@invalid>
 <55F988A6.8070109@gmail.com>
 <A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com>
 <55F9B357.4070505@gmail.com>
 <54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
In-Reply-To: <54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 16, 2015 at 03:04:38PM -0400, Vincent Olivier wrote:
> > On Sep 16, 2015, at 2:22 PM, Austin S Hemmelgarn <ahferroin7@gmail.com>=
 wrote:
> > On 2015-09-16 12:51, Vincent Olivier wrote:
> >>> On Sep 16, 2015, at 11:20 AM, Austin S Hemmelgarn <ahferroin7@gmail.c=
om> wrote:
> >>> On 2015-09-16 10:43, M G Berberich wrote:
> >>> It is worth noting a few things that were done incorrectly in this te=
sting:
> >>> 1. _NEVER_ turn off write barriers (nobarrier mount option), doing so=
 subtly breaks the data integrity guarantees of _ALL_ filesystems, but espe=
cially so on COW filesystems like BTRFS.  With this off, you will have a mu=
ch higher chance that a power loss will cause data loss.  It shouldn't be t=
urned off unless you are also turning off write-caching in the hardware or =
know for certain that no write-reordering is done by the hardware (and almo=
st all modern hardware does write-reordering for performance reasons).
> >> But can the =E2=80=9Cnobarrier=E2=80=9D mount option affect performanc=
es negatively for Btrfs (and not only data integrity)?
> > Using it improves performance for every filesystem on Linux that suppor=
ts it.  This does not mean that it is _EVER_ a good idea to do so.  This mo=
unt option is one of the few things on my list of things that I will _NEVER=
_ personally provide support to people for, because it almost guarantees th=
at you will lose data if the system dies unexpectedly (even if it's for a r=
eason other than power loss).
>=20
> OK fine. Let it be clearer then (on the Btrfs wiki): nobarrier is an abso=
lute no go. Case closed.

Sometimes it is useful to make an ephemeral filesystem, i.e. a btrfs on a
dm-crypt device with a random key that is not stored.  This configuration
intentionally and completely destroys the entire filesystem, and all
data on it, in the event of a power failure.  It's useful for things like
temporary table storage, where ramfs is too small, swap-backed tmpfs is
too slow, and/or there is a requirement that the data not be persisted
across reboots.

In other words, nobarrier is for a little better performance when you
already want to _intentionally_ destroy your filesystem on power failure.


--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlX56HgACgkQgfmLGlazG5xGhACggW3EX2WbiBzuNlnQ8c2spzEC
QbUAoJk8PBBL95h/sblNi+pazofKLPDp
=5dNM
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
