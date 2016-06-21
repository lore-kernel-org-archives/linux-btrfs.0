Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36612 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbcFURXi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 13:23:38 -0400
Received: by mail-lf0-f45.google.com with SMTP id q132so33928706lfe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 10:23:36 -0700 (PDT)
Received: from intelfx-laptop.local ([77.41.63.43])
        by smtp.gmail.com with ESMTPSA id dw5sm1773825lbc.26.2016.06.21.10.23.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jun 2016 10:23:34 -0700 (PDT)
Message-ID: <1466529808.27445.14.camel@intelfx.name>
Subject: Rescue a single-device btrfs instance with zeroed tree root
From: Ivan Shapovalov <intelfx@intelfx.name>
Reply-To: intelfx@intelfx.name
To: linux-btrfs@vger.kernel.org
Date: Tue, 21 Jun 2016 20:23:28 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dZenbF97IXtiqnbShwnW"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-dZenbF97IXtiqnbShwnW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

So this is another case of "I lost my partition and do not have
backups". More precisely, _this_ is the backup and it turned out to be
damaged.

(The backup was made by partclone.btrfs. Together with a zeroed out
tree root, this asks for a bug in partclone...)

So: the tree root is zeroes, backup roots are zeroes too,
btrfs-find-root only reports blocks of level 0 (needed is 1).
Is there something that can be done? Maybe it is possible to
reconstruct the root from its children?
Operations log following.
Please Cc: me in replies as I'm not subscribed to the list.

1. regular mount

# mount /dev/loop0p3 /mnt/temp

=3D=3D=3D dmesg =3D=3D=3D
[106737.299592] BTRFS info (device loop0p3): disk space caching is enabled
[106737.299604] BTRFS: has skinny extents
[106737.299884] BTRFS error (device loop0p3): bad tree block start 0 162633=
449472
[106737.299888] BTRFS: failed to read tree root on loop0p3
[106737.314359] BTRFS: open_ctree failed
=3D=3D=3D end dmesg =3D=3D=3D

2. mount with -o recovery

# mount -o recovery /dev/loop0p3 /mnt/temp

=3D=3D=3D dmesg =3D=3D=3D
[106742.305720] BTRFS warning (device loop0p3): 'recovery' is deprecated, u=
se 'usebackuproot' instead
[106742.305722] BTRFS info (device loop0p3): trying to use backup root at m=
ount time
[106742.305724] BTRFS info (device loop0p3): disk space caching is enabled
[106742.305725] BTRFS: has skinny extents
[106742.306056] BTRFS error (device loop0p3): bad tree block start 0 162633=
449472
[106742.306060] BTRFS: failed to read tree root on loop0p3
[106742.306069] BTRFS error (device loop0p3): bad tree block start 0 162633=
449472
[106742.306071] BTRFS: failed to read tree root on loop0p3
[106742.306084] BTRFS error (device loop0p3): bad tree block start 0 162632=
237056
[106742.306086] BTRFS: failed to read tree root on loop0p3
[106742.306097] BTRFS error (device loop0p3): bad tree block start 0 162626=
682880
[106742.306100] BTRFS: failed to read tree root on loop0p3
[106742.306111] BTRFS error (device loop0p3): bad tree block start 0 162609=
168384
[106742.306114] BTRFS: failed to read tree root on loop0p3
[106742.327272] BTRFS: open_ctree failed
=3D=3D=3D end dmesg =3D=3D=3D


3. btrfs-find-root

# btrfs-find-root /dev/loop0p3
Couldn't read tree root
Superblock thinks the generation is 22332
Superblock thinks the level is 1
Well block 162633646080(gen: 22332 level: 0) seems good, but generation/lev=
el doesn't match, want gen: 22332 level: 1
Well block 162633596928(gen: 22332 level: 0) seems good, but generation/lev=
el doesn't match, want gen: 22332 level: 1
Well block 162633515008(gen: 22332 level: 0) seems good, but generation/lev=
el doesn't match, want gen: 22332 level: 1

Thanks,
--=20

Ivan Shapovalov / intelfx /
--=-dZenbF97IXtiqnbShwnW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXaXgQAAoJEHveF8jk4w6dV6wQAKzZjXR+7ifq29RGTXcEZEq2
xG0Yp54FCRu0cAKq69WDbkC1VIUrt4/ZXIplUpwDBsSVYTbcUbjB2Fydl5S9cagX
x9Nf3Td5IZV1rdzjkIj6pw4H7+6SMj2UKHmjVDwjzDJ5Uo1i6Rq1yMAbi8TqYd31
ARa0LJ2cQnOmwa/Xy3B0phNiahjSTbRcsksZ8g6YHeIvEWz4sPbz/Y5orQ2+s3o8
ZBYz3sWh020wSLILKdTvyxAxmWWv5Xv9kxCcfVQBfKiVO/Anj/EZS8FPIohUZavR
GMBKSjc63um2e4eEHBYGnH102WWxZruHnrlArKRy63UEb3U9R1Ii2CGg4LMzV3kV
Y8344fDi0a0/+UAs5XWt4LUmgbg5sF6cDWOSkmINZFgsdmsjXQns3wsaFM/qQeJg
mXtTxfuTHNx7f/MwOo7RSyp3zbj9uzefz2L7HU0XuPAqC39eMZxP8fi9mIUaylWy
loymFuUvV9ep1rMmG0K9zkYikMZhv1hih2qBdN6DbgwKnat0Ml/yNqQHzTR/k0Zr
nst7gK3tB7BncZwHS3VtyAUHcvRsQuEwncxVJ2QyZUSxQCFsrF33ZB4l2YMKtKWd
cEZ4aX/vkE8kuMJS3hJIjuWrQFZmMp8sMfFDc0sX5Xlzdv7gtmTMM+SwJI6e9dh5
dkmOyh5T7PCnYxojv4LG
=cm9U
-----END PGP SIGNATURE-----

--=-dZenbF97IXtiqnbShwnW--

