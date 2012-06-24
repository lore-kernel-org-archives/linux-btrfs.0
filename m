Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35532 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677Ab2FXWx6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 18:53:58 -0400
Message-ID: <1340578406.741.53.camel@deadeye.wl.decadent.org.uk>
Subject: Re: btrfs: filenames collide with snapshot/subvolume names
From: Ben Hutchings <ben@decadent.org.uk>
To: dave@jikos.cz
Cc: linux-btrfs@vger.kernel.org, gpall@ccf.auth.gr, 663067@bugs.debian.org,
        miaox@cn.fujitsu.com
Date: Sun, 24 Jun 2012 23:53:26 +0100
In-Reply-To: <20120614102835.GP32402@twin.jikos.cz>
References: <1339648469.4942.71.camel@deadeye.wl.decadent.org.uk>
	 <20120614102835.GP32402@twin.jikos.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cDC5bxfcjTKMtQy+7iRQ"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-cDC5bxfcjTKMtQy+7iRQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-14 at 12:28 +0200, David Sterba wrote:
> On Thu, Jun 14, 2012 at 05:34:29AM +0100, Ben Hutchings wrote:
> > ?????????????? (Giorgos?) reports:
> > > Namely, being inside a snapshot directory, I can't create a file/dire=
ctory
> > > with the name of the snapshot directory.
> > >=20
> > > For example, inside /mnt/aSnap, I can't create a file named 'aSnap', =
so I'm
> > > filling this bug report.
> >=20
> > It seems that the snapshot directory is partially created before the
> > snapshot is taken, so that the snapshot directory half-exists (can be
> > looked up, but doesn't appear in listings) inside the snapshot itself.
>=20
> I think it's this one, not merged so far (author CCed)
> http://www.spinics.net/lists/linux-btrfs/msg15195.html

Thanks, that sounds like it addresses this.  I'll wait for that patch or
another fix to be applied, as I am not able to assess whether it's
reasonable.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-cDC5bxfcjTKMtQy+7iRQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+eaZue/yOyVhhEJAQpznQ//W4UUTP95jJApOaH1/YoTuKRHT0rqcvKu
unKKyu1rWcitUGb8JWztkt6oZqZSUVRvWm1oUiWvtdThF1JBqLvCQ8NgE2y4eaxe
Z7C2sTlBwvDqEmjS/yIjvOOi13nk5BL8m9WlEOHm6oIJybJpxRsdzJVootcl4100
B+D2/b0OHKrxCx3w6GzYKvdKPiZMWo3GzqDUdRxYqlHI8kBSOcHhwdZazOKOEgkr
VsIJrs5QkVkelXj4ta+2GRZ/l5Axs18ZzFfGFlS5xt9BkSkEhIsmQ60GQipYyc/h
EJLKzTL7DsSMksshLMBTJv/XNa7qUMFTsegcUidFsYBjbDG4FRUfd8VasMpXEwVr
Jv1xVIkES2Q+63x6F3UkkM/SozzczmKOG38kWZnecBbxDf83icPrWYipDcLS+NFy
Bet3CqyaXjyo+10a/lUDIYoGSPdVIgydN56/mb0NuitrlzqG+ac9nG3BvHZ6FVTO
A3HAmW7xBL0sPsA3UBdRvFMS9KebE+lTIX7NP+J7i/aJ1slBGg+TTf6wPbXK6Uv0
YC4pt4Td3e1w/lmYQh5qKdUZcDcHXSWU+xpGnvlnQgd4sZTdcC33uAs9fWNhju27
Iuy144F8vgUfNS1Q/DX49g1eVRh3c8ztpmR6bVGEd9e4VJNTSzx/X4fW2Xr+3t5G
iBWJf/UvVIU=
=Ygbu
-----END PGP SIGNATURE-----

--=-cDC5bxfcjTKMtQy+7iRQ--
