Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab3IJEeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:34:03 -0400
Message-ID: <522EA128.50904@suse.com>
Date: Tue, 10 Sep 2013 00:33:44 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clmason@fusionio.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] ctree: fix broken macros for compat_ro
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="K3g0ELjCrCTXTqCl3V5beVvR1lRt5xgH3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K3g0ELjCrCTXTqCl3V5beVvR1lRt5xgH3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The macro for compat_ro had the right name but was modifying compat inste=
ad.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 0b0d701..8ef45f3 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1912,7 +1912,7 @@ BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct =
btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block=
,
-			 compat_flags, 64);
+			 compat_ro_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,=

 			 incompat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
--=20
1.8.1.4


--=20
Jeff Mahoney
SUSE Labs


--K3g0ELjCrCTXTqCl3V5beVvR1lRt5xgH3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQIcBAEBAgAGBQJSLqEqAAoJEB57S2MheeWyR6AQAIKoOJXJWezaGXXjraxC7swZ
v8yGE2nKaMzKE+4Q0wJDmmwjwLj4sjwV3NAfqWLwuM/FmRUtLffn0YwfHm70WMtK
2iVbH7V38vekt3wf2wNBeT8P3D3Nqdlek2zIGgEdhaESoGAm7S5lZ/P0/QK8Zc1x
l6ebrp3VGWk1MuV7sJi3KAKytluGl7UqkaYcBDM6f8fbb6MoFYsijr/mItGD6f9x
oe0Jos6DvZnX2zGcytMBm9QkeQBjI/XDlAlmO68zuMxEWZGwNxTtCXHrmvqR1b2p
b1Yx3BSity3TKhwBV9w/gBsWtHHBIAvMg39DfX444LRBQ3yzW0v0cnNKGHF1gqxq
uAKf0go9HF2RtVBfjvXpBPWSeHmExlnZY0KqRviW6hfkLHw9LrMXf1ZV6rLb/1Vr
QCMQv3imcqpoN2GtNomwPzv0EVUleKGJKpVA3s6PsqStXRs5g9EWZqFq91Rexg9A
Zc+gzRoAAYdtyMYEznXgPGh7Eb7kIXxyeSNJJlXaYFM5h3i9i60nUpkCneLAJaiv
x1DWwm+1m12AyRpyo05XCTJ3j2ExfknJmk3Q2/13geNS3VKpcmScnN1tH4zoYpJw
mts7cdWxFJaTomKoArVHSFoobTUxFZwsR6C12IpIPN50oFflKVUnNMMVOK9XI1mn
MocJpEyBGVfG3TQ/Ruwj
=j8Df
-----END PGP SIGNATURE-----

--K3g0ELjCrCTXTqCl3V5beVvR1lRt5xgH3--
