Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34072 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbcF0JXo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 05:23:44 -0400
Received: by mail-lf0-f51.google.com with SMTP id h129so152358778lfh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 02:23:43 -0700 (PDT)
Received: from intelfx-laptop.local ([93.175.7.90])
        by smtp.gmail.com with ESMTPSA id g28sm3085854ljg.24.2016.06.27.02.23.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jun 2016 02:23:41 -0700 (PDT)
Message-ID: <1467019414.17298.6.camel@intelfx.name>
Subject: Re: Rescue a single-device btrfs instance with zeroed tree root
From: Ivan Shapovalov <intelfx@intelfx.name>
Reply-To: intelfx@intelfx.name
To: linux-btrfs@vger.kernel.org
Date: Mon, 27 Jun 2016 12:23:34 +0300
In-Reply-To: <1466529808.27445.14.camel@intelfx.name>
References: <1466529808.27445.14.camel@intelfx.name>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WwvNO+52vrGD3bMtY1lv"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-WwvNO+52vrGD3bMtY1lv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 2016-06-21 at 20:23 +0300, Ivan Shapovalov wrote:
> Hello,
>=20
> So this is another case of "I lost my partition and do not have
> backups". More precisely, _this_ is the backup and it turned out to
> be
> damaged.
>=20
> (The backup was made by partclone.btrfs. Together with a zeroed out
> tree root, this asks for a bug in partclone...)
>=20
> So: the tree root is zeroes, backup roots are zeroes too,
> btrfs-find-root only reports blocks of level 0 (needed is 1).
> Is there something that can be done? Maybe it is possible to
> reconstruct the root from its children?
> Operations log following.
> Please Cc: me in replies as I'm not subscribed to the list.


Anyone? I'd appreciate any advice on how to rebuild the tree roots.

I'd even write some code if someone tells me the disk format and
logical tree constraints (i. e. in which order to put pointers to child
nodes).

BTW, it looks like all tree roots are lost, i. e. btrfs-find-root with
any objectid (extent tree, subvolume tree, anything in ctree.h) finds
only level 0 nodes.

It should be possible to rebuild intermediate nodes, isn't it? Do they
contain valuable information?

Please Cc: me in replies as I'm not subscribed to the list.

Thanks,
--=20

Ivan Shapovalov / intelfx /

>=20
> 1. regular mount
>=20
> # mount /dev/loop0p3 /mnt/temp
>=20
> =3D=3D=3D dmesg =3D=3D=3D
> [106737.299592] BTRFS info (device loop0p3): disk space caching is
> enabled
> [106737.299604] BTRFS: has skinny extents
> [106737.299884] BTRFS error (device loop0p3): bad tree block start 0
> 162633449472
> [106737.299888] BTRFS: failed to read tree root on loop0p3
> [106737.314359] BTRFS: open_ctree failed
> =3D=3D=3D end dmesg =3D=3D=3D
>=20
> 2. mount with -o recovery
>=20
> # mount -o recovery /dev/loop0p3 /mnt/temp
>=20
> =3D=3D=3D dmesg =3D=3D=3D
> [106742.305720] BTRFS warning (device loop0p3): 'recovery' is
> deprecated, use 'usebackuproot' instead
> [106742.305722] BTRFS info (device loop0p3): trying to use backup
> root at mount time
> [106742.305724] BTRFS info (device loop0p3): disk space caching is
> enabled
> [106742.305725] BTRFS: has skinny extents
> [106742.306056] BTRFS error (device loop0p3): bad tree block start 0
> 162633449472
> [106742.306060] BTRFS: failed to read tree root on loop0p3
> [106742.306069] BTRFS error (device loop0p3): bad tree block start 0
> 162633449472
> [106742.306071] BTRFS: failed to read tree root on loop0p3
> [106742.306084] BTRFS error (device loop0p3): bad tree block start 0
> 162632237056
> [106742.306086] BTRFS: failed to read tree root on loop0p3
> [106742.306097] BTRFS error (device loop0p3): bad tree block start 0
> 162626682880
> [106742.306100] BTRFS: failed to read tree root on loop0p3
> [106742.306111] BTRFS error (device loop0p3): bad tree block start 0
> 162609168384
> [106742.306114] BTRFS: failed to read tree root on loop0p3
> [106742.327272] BTRFS: open_ctree failed
> =3D=3D=3D end dmesg =3D=3D=3D
>=20
>=20
> 3. btrfs-find-root
>=20
> # btrfs-find-root /dev/loop0p3
> Couldn't read tree root
> Superblock thinks the generation is 22332
> Superblock thinks the level is 1
> Well block 162633646080(gen: 22332 level: 0) seems good, but
> generation/level doesn't match, want gen: 22332 level: 1
> Well block 162633596928(gen: 22332 level: 0) seems good, but
> generation/level doesn't match, want gen: 22332 level: 1
> Well block 162633515008(gen: 22332 level: 0) seems good, but
> generation/level doesn't match, want gen: 22332 level: 1
>=20
> Thanks,
--=-WwvNO+52vrGD3bMtY1lv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXcPCWAAoJEHveF8jk4w6dX+0P/1uabgzqMmp3EG9Ul77Blk52
pGW0tW/5xdJb+t7Ilv9OOQgFuTpnARIhTNC0+HKs35zvBkNnwgrYfeWV0vXjHrQM
/yvoWWiUcHMxvGMtdRnE1dXuyJFJQWo1du10dxBKQkMNehfPqW0hUjP3L6zLLyK3
9A53z19Wy+6rAw2wE84vRDt9dLs4b4SFfNrmK3iERww/MQcQyXnQC8ifjfM7iVNg
A/NKjZdIHX98/y3Zn9WywZMCV/I8GHORzimkd1cUWsvOQlzeIRjjEUhYRNOucH9z
EOLQRGejBgBb9Qea7rSxi8n9y4klfVh63ro1IRqh+PFTX3nMkaNCFobHmzQjhGbE
8P6wL3KNMWhSLBv03vuLozdFMLn5XG85G3rDtQEAOTLBerIWHak2XOb4wWUXK8Ef
LEG7oKzzb/pRGEb/LMIhra5w1LNvR/TozU/Jq5/eftO2t1VfGXvN95K5mbmIH3c2
0b2gOeU6/AWSjPpNzsjfGnl+QRMZYMDM58FeEdxkoNI7XGkVlGQV24zah18oUhWB
L9t7mou+9w1zTvQSt3/L6/0MUKEe9hv58w8PueBWi7zLmuk11nMtOWFCPfxcyH6u
bZVYihRPPFRsovnZKcul/YC8wD33s7AN+Xixq3vSo65xzKeI6rksI0aL71AU5w4H
8uIS3gAb6c9lvggWxA9a
=Z+kX
-----END PGP SIGNATURE-----

--=-WwvNO+52vrGD3bMtY1lv--

