Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46476 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751366AbdJ2RPY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 13:15:24 -0400
Message-ID: <1509297309.2721.73.camel@decadent.org.uk>
Subject: [stable] btrfs name length fixes
From: Ben Hutchings <ben@decadent.org.uk>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stable <stable@vger.kernel.org>
Date: Sun, 29 Oct 2017 17:15:09 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-GaITHfYr6cBbH4tjqGI+"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-GaITHfYr6cBbH4tjqGI+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You recently made a number of fixes to validation and use of name
lengths in btrfs:

286b92f43c0d btrfs: tree-log.c: Wrong printk information about namelen
19c6dcbfa746 btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyo=
nd boundary
e79a33270d05 btrfs: Check name_len with boundary in verify dir_item
26a836cec2ea btrfs: Check name_len on add_inode_ref call path
8ee8c2d62d5f btrfs: Verify dir_item in replay_xattr_deletes
3c1d41844896 btrfs: Check name_len in btrfs_check_ref_name_override
59b0a7f2c7c1 btrfs: Check name_len before read in iterate_dir_item
488d7c456653 btrfs: Check name_len before reading btrfs_get_name
64c7b01446f4 btrfs: Check name_len before in btrfs_del_root_ref
fbc326159a01 btrfs: Verify dir_item in iterate_object_props

The bugs these are fixing probably should also be fixed on the affected
stable branches.  Do you agree?  Can you provide any guidance about how
far back these fixes would be needed?

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your
sig.


--=-GaITHfYr6cBbH4tjqGI+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAln2DJ0ACgkQ57/I7JWG
EQmk0g/9HT99n7FrRWFaHmvEbf0Bmnq6ns2n68cx94JfYXJBNAAIig3FS151X/pV
ULwdaPCU1ii3Y1m9rrJXmTwisrf6v6M2xTPzXou4yIgxuuUgJ0J33NqTmd7lNwRh
goHGaBkyel4dgDKj8s0uPBgvYhDqq7ELQ7EMFPXXw8mX5Nz4n+Mq9MnjPpu2/cTY
Hw/qKai9dhvnmf4ZKEqW22SfFGF7Xke1g7JLG66EK+N0Awm67iv9deNsjp94vbjW
UOuCIDyqOJgAW+uRZ/eSSwoGJNWJmVo8mOZBA3sqJUr2h3S0jE9+za5KT8dojCnT
DOswkYY+UTqXNkXGQHzLsh1lStkFxO/YGbqop2JWOtO6FzhWNWz2BKuX0ciHjKm9
+wmQLqo8mGcYaOA/3Zkfm1DSMG4PL8X+5QtPgRRpKcjlhLt88Z3xUfykFhg1ydCq
LtRejn/HbS/iaC4Klozqd5AkctFVIC4TwSE73hzd3UETb13JEazPd2yVrmWa2UE5
xrVLQB4f4ehw+2OeEHa0kMfR0jvoz/4G4fd9WXEMWq2OqcagwnJhkF1Z4mQWi6WO
faRp2Veu0d+zHiQqyRWj8AFx3gZJ2S4k0qmy5a/rigPmXwKXy5tvhsy5PojlqFzc
29hDGxqsHCk/TkocMAmc0DaDFs+2EI3XWkGWE4fi17JAFTxbzqc=
=S6yo
-----END PGP SIGNATURE-----

--=-GaITHfYr6cBbH4tjqGI+--
