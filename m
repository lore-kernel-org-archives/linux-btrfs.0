Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56490 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3LIUI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Dec 2013 15:08:59 -0500
Date: Mon, 9 Dec 2013 20:08:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Cirillo Costantino <linoc@pacbell.net>
Cc: "\"linux-btrfs@vger.kernel.org\"" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs questions
Message-ID: <20131209200856.GF9738@carfax.org.uk>
References: <1386615086.1044.YahooMailNeo@web180901.mail.ne1.yahoo.com>
 <1386619322.61331.YahooMailNeo@web180902.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xs+9IvWevLaxKUtW"
In-Reply-To: <1386619322.61331.YahooMailNeo@web180902.mail.ne1.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xs+9IvWevLaxKUtW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 12:02:02PM -0800, Cirillo Costantino wrote:
>=20
>=20
> i am looking at using btrfs for a new project and i have a few questions:
>=20
> =A0=A0=A0=A0* i have heard that as it currently stands Btrfs has some iss=
ues to be used as a Lustre file system; is he aware of the issues and any p=
lans to address these and integrate Btrfs in to Lustre

   I don't recall seeing any Lustre-specific issues being reported
here. Do you have any links to bug reports with this configuration?

> =A0=A0=A0=A0* any plans to support=A0native=A0clustering on Btrfs

   No: https://btrfs.wiki.kernel.org/index.php/FAQ#Will_Btrfs_become_a_clus=
tered_file_system

> =A0=A0=A0=A0* on ZFS the ZIL is a separate device, any plans to implement=
 a the B-Tree log on a separate device?

   Not that I'm aware of, but it may come out of the work below.

> =A0=A0=A0=A0* any plans to allow to have a file system metadata be placed=
 on a separate device

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Device_IO_Priorities

   ... but it's not being worked on right now.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no.  5: Manifesto Promise ---    =20

--xs+9IvWevLaxKUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUqYjV1heFHXiqx3kAQJ1txAAkV1UvdEb2ibnZuixdHJAImoZEMzfWCgI
p7VgGpnYLfVvf9ruybwjTDCWCq5OTftnXx34gEg62Z3kuGbPo9V3NvtjX00wP7rz
i7CmvSuETTUBVR0Acjj4HjETAG2gDeQhStmaPIAZV68RQbx+UTrMVdlHHObpMLgt
QT/GWj1huS7DeE4v2av8uSzQHT/ubI5Az2mtFpRoeTw7DA36p7vGncSggvbeqS6D
mabxxZxF73hRgJ75ioK0Pv99pf2aNSW4pEhcaPg7dKgIZcGyEW9Zs97sP0q9hRum
ddUm99YDRYbZnlwvxnjwqL13dEFJ4vGPd6tuvCDq1gw+NOXjrdTmQCnvHb3XK3L1
ZBnxt+TqYF5WEowEZI9uxAcfhRP3fFhVJjmgOWt1WSQkBTVc1spinqgAaTDrhmwk
qXOu6LZzLYLDmW+cJUF5Fr+Yw0kiF4lbmIr6CXwIOA95W0YMg452v3zfoy9mBjsJ
wRAChry6xmSx0yvs+NQevOhMqaYlL4FPsmiWtstrP2JKuRX44Xi1FHTKbCFYn2Or
4dEjAXM4KkJJaXPP+Yop/gWRNkFBgf/N2pCd8veT7KvSAZV9P7OwCk9z2r3ub9JN
s1lRjkjMKenhOPLkfeN3o6UWSw2eQpSjGq1P1/3CZehoP1BsUvBwl6k6i7YJ0zRj
ljVFQZ47RYk=
=+HuK
-----END PGP SIGNATURE-----

--xs+9IvWevLaxKUtW--
