Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:47220 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3K3LnP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Nov 2013 06:43:15 -0500
Message-ID: <5299CF4F.10706@friendlyvirus.org>
Date: Sat, 30 Nov 2013 11:43:11 +0000
From: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: avoid using btrfs internal subvolume
 path to send
References: <1385743045-2969-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1385743045-2969-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="JQBAH64b7nv3vC6hF9WgaNHOXVSxW1BsX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JQBAH64b7nv3vC6hF9WgaNHOXVSxW1BsX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Em 29-11-2013 16:37, Wang Shilong escreveu:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>=20
> Steps to reproduce:
> 	# mkfs.btrfs -f /dev/sda
> 	# mount /dev/sda /mnt
> 	# btrfs subvolume create /mnt/foo
> 	# umount /mnt
> 	# mount -o subvol=3Dfoo /dev/sda /mnt
> 	# btrfs sub snapshot -r /mnt /mnt/snap
> 	# btrfs send /mnt/snap > /dev/null
>=20
> We will fail to send '/mnt/snap',this is because btrfs send try to
> open '/mnt/snap' by btrfs internal subvolume path 'foo/snap' rather
> than relative path based on mounted point, this will return us 'no
> such file or directory',this is not right, fix it.

I was going to write to the list to report exactly this issue. In my
case, this happens when the default subvolume has been changed from id 5
to some other id. I get the error 'no such file or directory'. Currently
my workaround is to mount the root subvolume with -o subvolid=3D5 and the=
n
do the send.

Also, I'd like to ask, are there plans to make the send and receive
commands resumeable somehow (or perhaps it is already, but couldn't see
how) ?

best,
Miguel Negr=E3o




--JQBAH64b7nv3vC6hF9WgaNHOXVSxW1BsX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSmc9SAAoJEPo6SjfPe12DjhMIAKJbs3a74MoCfwB/PYhbx6pz
O8a5JS/srpldJZ3VEuBD8K2nnwq7hVpU8kotnP0wtbfQMjN/9JUVQYLHQixrQtW6
oeo9hgyTaqFtovRLXEKIOlFnPZfrjgFQui8NTosBpsoIl+RCoowE/Xqul5Wdwr2/
5YGQns4G+cQQB1g9kdQdSTOQX7Iz0sJujy44YXOEbNop/aHNGb/6ygf92M5weGdI
Hy7ql+Ir5d8gv1Aop7n7FCqqTV3FqcR3HtWW0Q7NNVTd0S9RXlUfcujAhHeCximN
axThgNprz2M0JldVmioYX43nBMzjAm29t8J4IZWc9lOw8rWc3E0YQraATm/Ps9c=
=mMHn
-----END PGP SIGNATURE-----

--JQBAH64b7nv3vC6hF9WgaNHOXVSxW1BsX--
