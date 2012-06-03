Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:57712 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab2FCXgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Jun 2012 19:36:38 -0400
Date: Mon, 4 Jun 2012 02:36:25 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Non-root can create, but not delete, btrfs snapshots?
Message-ID: <20120603233624.GB8079@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I noticed that a non-root user is able to create (but not delete)
snapshots of a root btrfs filesystem on kernel 3.4.0.

I'm not sure I understand the security model correctly, but letting
unprivileged users create snapshots of the entire filesystem seems...
wrong. Is this intentional?

------------------------------------------------------------
~/test$ ls -la
total 0
drwxr-xr-x 1 sliedes sliedes    0 Jun  4 02:28 .
drwxr-xr-x 1 sliedes sliedes 7352 Jun  4 02:27 ..
~/test$ whoami
sliedes
~/test$ groups
sliedes dialout cdrom floppy audio src video plugdev kvm wireshark sbox
~/test$ btrfs subvolume snapshot / newsnap
Create a snapshot of '/' in './newsnap'
~/test$ ls -la
total 32
drwxr-xr-x 1 sliedes sliedes   14 Jun  4 02:28 .
drwxr-xr-x 1 sliedes sliedes 7352 Jun  4 02:27 ..
drwxr-xr-x 1 root    root     336 Jun  2 05:32 newsnap
~/test$ btrfs subvolume delete newsnap
Delete subvolume '/home/sliedes/test/newsnap'
ERROR: cannot delete '/home/sliedes/test/newsnap' - Operation not permitted
~/test$ sudo btrfs subvolume delete newsnap
Delete subvolume '/home/sliedes/test/newsnap'
~/test$=20
------------------------------------------------------------

	Sami

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPy/T4AAoJEKLT589SE0a08gUQAMT/xcNj4KYUZmSHYW6izwm/
bo/u5zZPfvbpiKIkjdyj7e5NeM59zKCHXO83yRxBiQxeAqxA0OeKKBk5r2NMPIAO
n6QV2IZuWMkavXCEhvXRA5UZOxWDHfhmp/USs4nwDxOdqVUYvBVnCcN4fpR8dspg
Jmlopsak6geIfZ86PbtzjmH4rYz95n9VrE+IfH4C0ianQaIHjs08KmJwN+epYFan
AFulPStD4A/g8QrVZB8y8VSCzy7oaXrbb0s+UBUXV0ZsHeWlnCNkWPruJaIBT11N
XJgPWdGHSfuF3J4TPhMrUkKQBh4w5QeX/wZMm9fPDXdclaxDVLBZuwN/ypYhKbyn
Qg8o6GeCk85/pdaRhcYWvq63Xy1rMAvJDjCS4+HgR3tmgrS/i0Hy4LM6lQNlCkCi
GEgpWYcoBzL6mjIERz3GH7WqVkJr42HhwT9ZV1Gpbg5DM4g2kScO4B9U3mhL06W8
94bLD1/0EUtTi3VNx9+R1r05iWxI/ZPxa05GNTrewQhJLV7UhZYQqmelVaYu1E+/
QwtzMmSo24XXtmnaXE1yzbPjxSXeubMYI2u7Y+ZWB9NosV7M9gt4rZkT7ke/A/qY
p/xGlrhd6Gl7frjTY8WmkarqmR6IXNCUk4KLEYJtHBQ/UoYwhfvsiJdzdhDcmyx6
HK1A6wZ7NeKe9NaFMwSf
=pSkV
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
