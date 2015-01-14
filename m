Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nala.villavu.com ([188.165.243.101]:51388 "EHLO
	nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbbANMWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 07:22:54 -0500
Message-ID: <54B65F5E.6020103@wizzup.org>
Date: Wed, 14 Jan 2015 13:21:50 +0100
From: Merlijn Wajer <merlijn@wizzup.org>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: merlijn@wizzup.org, dsterba@suse.cz, Josef Bacik <jbacik@fb.com>
Subject: [PATCH] Restore backtrace functionality on glibc
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="C0BsVl1i4dXwRemMobTBxrE876ImURbgu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C0BsVl1i4dXwRemMobTBxrE876ImURbgu
Content-Type: multipart/mixed;
 boundary="------------060302030708070804080309"

This is a multi-part message in MIME format.
--------------060302030708070804080309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi David, Josef,

Please find attached a patch that restores backtrace functionality when
using glibc. Note that "#include <features.h>" is included in this
patch, but this is not necessary. That is, on glibc systems, stdlib.h
and other headers also include this header (And only on glibc systems we
care about __GLIBC__ being defined). Nevertheless, I decided to include
the include directive as well, for completeness sake.

Josef, can you verify that this patch restores the backtrace functionalit=
y?

I'm sorry that my previous patch broke the backtrace functionality -- I
guess that sometimes trivial patches can still be wrong. :-)

Regards,
Merlijn

--------------060302030708070804080309
Content-Type: text/x-patch;
 name="0001-Restore-backtrace-functionality-on-glibc.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-Restore-backtrace-functionality-on-glibc.patch"

=46rom 66bec5ce01f650839b3cbd88ac40594daaab0299 Mon Sep 17 00:00:00 2001
From: Merlijn Wajer <merlijn@wizzup.org>
Date: Wed, 14 Jan 2015 13:13:15 +0100
Subject: [PATCH] Restore backtrace functionality on glibc.

Originally broke in commit c2691f807ddd2c6b261c5707f6838a45d9275390

__glibc__ should have been __GLIBC__

We also include features.h ; although most includes (at least stdlib.h)
typically already include it -- at least on glibc, where it matters.

Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
---
 kerncompat.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kerncompat.h b/kerncompat.h
index 7397274..314ea02 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -30,7 +30,9 @@
 #include <linux/types.h>
 #include <stdint.h>
=20
-#ifndef __glibc__
+#include <features.h>
+
+#ifndef __GLIBC__
 #define BTRFS_DISABLE_BACKTRACE
 #define __always_inline __inline __attribute__ ((__always_inline__))
 #endif
--=20
2.0.5


--------------060302030708070804080309--

--C0BsVl1i4dXwRemMobTBxrE876ImURbgu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUtl9eAAoJEHmTPmZXIL57b3kP/iNn5TK7W5Yw+CBEVylGQLlz
+UckwFwZrhfGYywtbUhmfUt6f+Glz1TecXAQaVKVHWtsIuzkPrHxzei6besIvkEC
yH975CG1jBDXeErN+ytnxi8n7b3XdQUIhRvuiaUW6MaLoMp8JrVGcYCGcX675sOk
dtozDG4uZ6JMJfkXS4sKb5pGs7nn/UBA+Gpg9/fOZQCjaI7tOUFXC6jR/eJAeV8+
bukQEtpYL4QfZVrlPT1byV/H7KrCBEl+/H1koHRlzhBYmxc1/HWFg0HUf2yWx4GA
XjHi79Kg0Ee/7U6cEXJOiD2K6prhvvI4TkT7Wyb9JaQl9YYklhx+2EaLfY8fCmjY
MmNPvDUikcuLwamrt2iB3dxjxMpnzC2GFN3tMKLGrLzjji6EdKPxW9LDz4JTREoN
nfAjgEgBf/yInA3VWg9URBADWmfS7dXclrtG/WuElZdyzbPD7KF0dVgd5QaJNkbM
sRO8k+R1kOYHda9krrNRzVS3A4i0EmRUPnVaEpkS6gsmGn2XCLAddZfD3o969gsF
Yei/pE08CYfzKrNDrbRbOWnyJv/q+Pf6zj/zrrEg0z4O8+kgFpcpKmytL+wNXrZS
PNgZlo9buweI5idmzrIbb0zk8pC+rjHWckmNYB/mgptvI2BXiM4YFsubDQWe75Uc
qEs8yalOc3g+UDdwW7wz
=0SUp
-----END PGP SIGNATURE-----

--C0BsVl1i4dXwRemMobTBxrE876ImURbgu--
