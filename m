Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from attic.omnifarious.org ([206.124.142.227]:38398 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3AOWGH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 17:06:07 -0500
Date: Tue, 15 Jan 2013 14:06:01 -0800
From: hopper@omnifarious.org
To: linux-btrfs@vger.kernel.org
Subject: Re: Rendering a btrfs filesystem unmountable with the btrfs command
Message-ID: <20130115220601.GD18291@omnifarious.org>
References: <20130115204436.GC18291@omnifarious.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
In-Reply-To: <20130115204436.GC18291@omnifarious.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 12:44:36PM -0800, hopper@omnifarious.org wrote:
> Help!  BTW, I'm not a mailing list subscriber.

Here is a sample fix that I believe will allow the offending filesystem
to at least be mounted.  It hasn't been tested at all.

----------------------------
diff -ur kernel-3.7.fc17.orig/linux-3.7.2-201.fc17.x86_64/fs/btrfs/qgroup.c=
 kernel-3.7.fc17/linux-3.7.2-201.fc17.x86_64/fs/btrfs/qgroup.c
--- kernel-3.7.fc17.orig/linux-3.7.2-201.fc17.x86_64/fs/btrfs/qgroup.c	2012=
-12-10 19:30:57.000000000 -0800
+++ kernel-3.7.fc17/linux-3.7.2-201.fc17.x86_64/fs/btrfs/qgroup.c	2013-01-1=
5 14:02:39.643630137 -0800
@@ -379,8 +379,13 @@
=20
 		ret =3D add_relation_rb(fs_info, found_key.objectid,
 				      found_key.offset);
-		if (ret)
+		/* Failing to add a relation because one side or the other
+		 * doesn't exist isn't a fatal error here. */
+		if (ret) {
+			if (ret =3D=3D -ENOENT)
+				ret =3D ENOENT;
 			goto out;
+		}
 next2:
 		ret =3D btrfs_next_item(quota_root, path);
 		if (ret < 0)
----------------------------


--=20
"They who can give up essential liberty to obtain a little temporary
 safety, deserve neither liberty nor safety." -- Benjanmin Franklin
-- Eric Hopper (http://www.omnifarious.org/~hopper) --

--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQGcBAEBCAAGBQJQ9dLJAAoJEA0oytveg7Kqy+4L/jZQ2p5FEyiRu4m8il+8o1cO
iAe2283n25TznWElWOfdjRX2iPDHEu/rLa61dApuUZlBNa/si7eSFdyZutzG79Nw
e11NA0zquZwEdwN/4u/Un8SoDnIQEeHxM/WTWIa4y3IeSeSftT0bsiR59BE96csr
F4X1U1SQiTY2dZz8bnKexG33nFpQo6L42DvF3fMDxOi4QA+O/geiGBSipc/Xoo2b
0+gnPeH3Nm66XdSCn0OyHCMYuaZDOArz2hIPtmfoDygFrTvkGOyqG+vCrsGK3yNV
fHeh7OxlND5NTpv50+St4LyjajGyc0VoJQy92XOJymux0PIr2/pv6vMC1AuhYGxG
SHkWeYBtCIAKD/T8GCJiiTvvmdrirUaYWvfZbGjKkOjSNudnDWVsx4LUA9RN2mSo
JTYzFUSopQAkFaOgLnXvQ0N+1EXL5fqb09xHkTmAM29W0kFb8GxzNMnD9+57I0bF
CwMJwUHqW5/wGOINEZCS5Ijc2hTkHgERWL2BYsE7yQ==
=I2zN
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
