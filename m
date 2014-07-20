Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52480 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbaGTTot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 15:44:49 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0M0tr1-1WFsRM3kkB-00v8kF for
 <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 21:44:48 +0200
Date: Sun, 20 Jul 2014 21:44:40 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140720214440.398e7e68@marcec>
In-Reply-To: <20140720134054.3cd6cef3@marcec>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec>
	<20140720134054.3cd6cef3@marcec>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/fVcS=iUP4xWkT9rAM3pEJsM"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fVcS=iUP4xWkT9rAM3pEJsM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sun, 20 Jul 2014 13:40:54 +0200
schrieb Marc Joliet <marcec@gmx.de>:

> Am Sun, 20 Jul 2014 12:22:33 +0200
> schrieb Marc Joliet <marcec@gmx.de>:
>=20
> [...]
> > I'll try this and see, but I think I have more files >1GB than would ac=
count
> > for this error (which comes towards the end of the balance when only a =
few
> > chunks are left).  I'll see what "find /mnt -type f -size +1G" finds :)=
 .
>=20
> Now that I think about it, though, it sounds like it could explain the su=
dden
> surge in total data size: for one very big file, several chunks/extents a=
re
> created, but the data cannot be copied from the original ext4 extent.

Well, turns out that was it!

What I did:

- delete the single largest file on the file system, a 12 GB VM image, along
  with all subvolumes that contained it
- rsync it over again
- start a full balance

This time, the balance finished successfully :-) .

I'll do another full balance in a few days, to see if it sticks, otherwise,
thanks for all the help!

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/fVcS=iUP4xWkT9rAM3pEJsM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzBwuAAoJEL/Q5oYsiHj03EIP/098iSriKirvAPZEtAwNlg0H
KV1faxTGdR+CIERhRp7nukuXRWOTsxAC6a8lqsonOtDhlnB+8jcsQrKcGhs+VELx
WULR2Zo/Nx/JcBBg2QXxLQ9dkwe9FhwwcQ+hRKBKwAICQnPEvTJLP812vd0ATLEX
8W7iRG/gPXKnnl0LF0K7qb3QuslU2vHUTXk0MRNhg2tTjDrYZtIl3Y221yKRsPKk
6kzzNAQlJyvNLGMh12p09b/pIgxL/GTwq4bn03CeMjvEgF7xCzJzbs8VJt3w512D
LOTR3iJLSkdyAwWzaI1cx813U/qj0Y11IKTsR4RGyI08AnX6LVLWA4Yon4AUo+VG
Lqfj1eCwpcrvoXKLpsFE6k4eCqufO/spgtL9gldoOwoateM9QhdtwxHbJhWwu9Qe
rbPAxYN4PBj3rYUFo7S9liotLEAGSRy6f76FeQwNNgwbgLOIktHpjOUapBw0M4QP
Mu9QdYGEyO9PsXo0OFwlnk2nwJ7AMz9BeDgaTrGN2ZGjMYq38IEsXb8Sjo+Xba88
g6dKxlE5Z6+1quRC31PX3LIREIZRrgKR0uqRoskQGuEm3bTNK/7BgUJgNtbbOX3m
hEqXWbbdmYh/v7A5IIohKYmC4Oz1N24S/ddSAJq4+PAV3nrCnnm1YvuHXG/iH7EY
2Ur6cHTlgXgG39xUjz2y
=Ivik
-----END PGP SIGNATURE-----

--Sig_/fVcS=iUP4xWkT9rAM3pEJsM--
