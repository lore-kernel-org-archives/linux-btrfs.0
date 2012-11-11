Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44482 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2KKPhp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 10:37:45 -0500
Date: Sun, 11 Nov 2012 15:37:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cache problem
Message-ID: <20121111153738.GB5604@carfax.org.uk>
References: <509ED1D6.8010903@petaramesh.org>
 <20121111152006.GA5604@carfax.org.uk>
 <509FC436.6080205@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
In-Reply-To: <509FC436.6080205@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 11, 2012 at 04:28:54PM +0100, Sw=E2mi Petaramesh wrote:
> Le 11/11/2012 16:20, Hugo Mills a =E9crit :
> > You only need to mount with space_cache once, and after that it's
> > "sticky". What's probably happening is that you're mounting with
> > space_cache, which rebuilds the cache. Then, if you reboot before it's
> > finished rebuilding the cache, the cache isn't complete, and (I think)
> > it causes the above message -- which is harmless. The same applies to
> > the inode cache options. Try mounting with clear_cache *once*, then
> > remounting with space_cache,inode_cache *once*, and waiting for it to
> > finish rebuilding the cache. Finally, remove all mention of the caches
> > from your fstab and kernel command line before you next mount the FS.
> > Hugo.=20
>=20
> Thanks very much Hugo, I'll give this a try. Should I assume that the
> cache clearing / building is complete as soon as the disk is idle ?

   I'm not sure. Probably. There is probably (I haven't checked
recently) a kernel process which does the rebuilding.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Great oxymorons of the world, no. 8: The Latest ---        =20
                          In Proven Technology                          =20

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJ/GQr9z9OVl50rAAQKuihAAn/FB4tZRdpBOHIUdjUn0/1StZZf4+fN3
vVypd9HtFWe6smUVV0DCdijDwGaHjynvpEAd3/qyr52fyZhPBcqMPVxliJfYEQ/x
s/fY3rcq0OPTKDEfJuPwTEDsQ+vhoa/dgYVk8t6Z7vQk9LnVQPIra+6l8GeLL2sE
6leGZg1lcZKGLbxmpK1w4Q29ACtpuQHE7cQdDjdkU6yyqO0JSP2fncd7wFd1+e3z
fci8WVAKHdUQ3Ybc+5EdJqVG4dwcEs9OdAwEIE3ytc/7QllLUMZ9vQfU2eKZBSyH
sxQxpgRZ6HgGWm8vzU9wyVKD25lq+XB9Z/JmoLw8FicCJEUtpa/wpgJJMnndS5F4
zBLVtpFt9r9gRHZtPEyTl2YHTpQzL5t0ih/LXD/C8sknJyZNLMKR8DdS13cbjoE3
aUV50paGmpjttt0e7a6ATgv/2iiQF/HFeCruyRsFHdRo88wlcAOTzNHv/O5GCOOn
VSoyCCHN9qIiqEf1ytUQn5ae+elchgv1yswMGgE+1Pi2ckCqA9auNlTMLW8wsV8O
cH+yCVqWY1+LLJcYJe7qG+9lFaqHMSy6t6oJPC/i0PwuKfmLZEAPJHTkD6ImrS6b
v5dRpP1RsncULNhHwgdgkwUISI89UUwu9qkjA7cwixhrvBGj38ulFcWg/KROrTE3
IBZCAc1jJUc=
=D42W
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
