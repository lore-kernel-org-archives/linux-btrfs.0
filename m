Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:35099 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab2I1DSE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 23:18:04 -0400
Date: Fri, 28 Sep 2012 09:17:59 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: kreijack@inwind.it
Cc: kreijack@libero.it,
        =?UTF-8?B?U8OpYmFzdGllbg==?= Maury <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
Message-ID: <20120928091759.6d096016@natsu>
In-Reply-To: <5064BEEB.1090707@libero.it>
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
 <5064B96B.7060502@libero.it>
 <5064BEEB.1090707@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tT81LTdYk7685eXc/nioZEz"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/tT81LTdYk7685eXc/nioZEz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Sep 2012 23:02:35 +0200
Goffredo Baroncelli <kreijack@libero.it> wrote:

> Sorry for the space error:
> Below a more correct example
>=20
> $ btrfs filesystem disk-free /
> Summary:
>     Total:             	        135.00GB
>     Allocated:             	 10.51GB
>     Unallocated:            	124.49GB
>     Free_(Estimated)              86.56GB
>     Average_disk_efficiency:         62 %

How do you estimate "Free" here? Sorry I didn't check the source code in gi=
t,
but from the "Details" below nothing leads me to believe that this FS is
doomed to only be able to usefully utilize only ~86GB of the partition, and=
 not
more.

Are you ready to answer the flood of questions from people why their disk is
only 62% efficient, and how to tune it to 100%? :-)

Why use underscores instead of spaces?


>=20
> Details:
>     Chunk-type    Mode       Allocated        Used        Free
>     ----------    ----       ---------    --------   ---------
>     Data          Single        4.01GB      2.16GB      1.87GB
>     System        DUP          16.00MB      4.00KB      7.99MB
>     System        Single        4.00MB        0.00      4.00MB
>     Metadata      DUP           6.00GB    429.16MB      2.57GB
>     Metadata      Single        8.00MB        0.00      8.00MB

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/tT81LTdYk7685eXc/nioZEz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBlFucACgkQTLKSvz+PZwiPyQCeIM8wAb54Pws5E4Ay/lbhKCwT
2OMAni3xF4oT/NtC/EGsewGmezypxB/w
=2lw+
-----END PGP SIGNATURE-----

--Sig_/tT81LTdYk7685eXc/nioZEz--
