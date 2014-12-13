Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nala.villavu.com ([188.165.243.101]:47342 "EHLO
	nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbaLMOzQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 09:55:16 -0500
Received: from a82-161-36-93.adsl.xs4all.nl ([82.161.36.93] helo=[192.168.178.31])
	by nala.villavu.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80.1)
	(envelope-from <merlijn@wizzup.org>)
	id 1Xznni-0007bh-QF
	for linux-btrfs@vger.kernel.org; Sat, 13 Dec 2014 15:36:06 +0100
Message-ID: <548C4E9D.2080309@wizzup.org>
Date: Sat, 13 Dec 2014 15:35:09 +0100
From: Merlijn Wajer <merlijn@wizzup.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [RFC] btrfs-progs: Support for musl libc (and perhaps also uclibc)
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="U2Kcn04rSS87U9qV28sV0B54PForoAHT3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U2Kcn04rSS87U9qV28sV0B54PForoAHT3
Content-Type: multipart/mixed;
 boundary="------------090203090900010608010506"

This is a multi-part message in MIME format.
--------------090203090900010608010506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I've been experimenting with musl-libc Gentoo systems. I used the HEAD
of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

I found that btrfs-progs does not compile with musl-libc, for a few reaso=
ns:

* It makes use of the private glibc __always_inline macro.

* Various headers that should be included are not included:
linux/limits.h and limits.h. (for XATTR_SIZE_MAX and PATH_MAX)

* backtrace() using execinfo.h is enabled by default; execinfo.h is
glibc-specific and thus does not work on other libc's. musl does not
support it, and I think uclibc also does not support it.

I have worked around the problems in the following way:

* Define __always_inline if __glibc__ is not defined. This is arguably
the most clean solution. It would be better to simply not use the
__always_inline macro (instead, use __attribute__) throughout
btrfs-progs, but I was not sure what the developers would prefer. This
is currently done in kerncompat.h, but you may want to move that to
another file.

* Include various headers where required.

* If __glibc__ is not defined, define BTRFS_DISABLE_BACKTRACE. Currently
the define magic happens in kerncompat, because that also where BTRFS
includes execinfo. Personally, I think it would make more sense to
always disable backtrace instead of enabling it by default -- but
perhaps in a testing phase, enabling it by default in the sensible choice=
=2E

Attached are the two patches generated with git format-patch. I am aware
that this may not be required format for submitting patches -- but
please give me some time to get used to the etiquette. :-)

Please let me know if musl-libc (or any other libc) is a supported
platform, and if so, if and how I can improve on said patches.

Regards,
Merlijn

--------------090203090900010608010506
Content-Type: text/x-patch;
 name="0001-Include-headers-required-for-musl-libc.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-Include-headers-required-for-musl-libc.patch"

=46rom da43021732fab3f70c75f155bded8e5f35fdffe3 Mon Sep 17 00:00:00 2001
From: Merlijn Wajer <merlijn@wizzup.org>
Date: Sat, 13 Dec 2014 15:07:25 +0100
Subject: [PATCH 1/2] Include headers required for musl-libc.

This fixes various compilation errors where PATH_MAX and XATTR_SIZE_MAX
were missing. To my knowledge, this should have no bad side effects.
---
 btrfs-convert.c | 1 +
 help.c          | 1 +
 mkfs.c          | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 02c5e94..7b69a13 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -31,6 +31,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
+#include <linux/limits.h>
=20
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/help.c b/help.c
index fab942b..56aaf9c 100644
--- a/help.c
+++ b/help.c
@@ -17,6 +17,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
=20
 #include "commands.h"
 #include "utils.h"
diff --git a/mkfs.c b/mkfs.c
index e10e62d..6343831 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -35,6 +35,8 @@
 #include <uuid/uuid.h>
 #include <ctype.h>
 #include <sys/xattr.h>
+#include <limits.h>
+#include <linux/limits.h>
 #include <blkid/blkid.h>
 #include <ftw.h>
 #include "ctree.h"
--=20
2.0.4


--------------090203090900010608010506
Content-Type: text/x-patch;
 name="0002-Disable-backtrace-and-define-__always_inline.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0002-Disable-backtrace-and-define-__always_inline.patch"

=46rom 01d0bfe48dc78b66b6e86d4935d9b9d20194b135 Mon Sep 17 00:00:00 2001
From: Merlijn Wajer <merlijn@wizzup.org>
Date: Sat, 13 Dec 2014 15:08:43 +0100
Subject: [PATCH 2/2] Disable backtrace and define __always_inline

Disable backtrace and define __always_inline when glibc is not used as
libc. This, together with some header changes allows btrfs-progs to
compile with musl-libc.
---
 kerncompat.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kerncompat.h b/kerncompat.h
index 8afadc8..05823a7 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -29,6 +29,12 @@
 #include <stddef.h>
 #include <linux/types.h>
 #include <stdint.h>
+
+#ifndef __glibc__
+#define BTRFS_DISABLE_BACKTRACE
+#define __always_inline __inline __attribute__ ((__always_inline__))
+#endif
+
 #ifndef BTRFS_DISABLE_BACKTRACE
 #include <execinfo.h>
 #endif
--=20
2.0.4


--------------090203090900010608010506--

--U2Kcn04rSS87U9qV28sV0B54PForoAHT3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUjE6dAAoJEHmTPmZXIL57BhsQAIUcqFPZjaC/P2Y5RzVrtM6+
0YEA8R/hc8eM3RE57Kcvkp3Zj9QRXFktYFuz55LUN7KAeYhdBrFHwRKBf6FP0hXJ
a7WSXOthXI6xk8QSZTpeLRJSgSq40RASNB7UmBza7BiZ1zamLu0Epa/a2DeR8qLY
pOEWJRP97tP2vzMM3HF6v+Halnes88WmQyHil71qRbXnx+BpkuwAs15FWhh/ruo4
oucqqC83JCkZz6zh8Ch2yBHjDD9xDmg0cEzFL5O6GBhHpKB4BgW4fUCNxQUWeo3x
zaiYxLEqt6YnvNq9pGCvZBPgJOKFODxQXHxXl5XFMALDLyLjZGiVsbBPnQYcaVw+
mi2ifMFXbftOmlLXaYiCeb07XYuwZGJpIR5YgDYRc1A4U9uFvjHdV5sqJmH5JQe9
IP+Vc6mE9JfkeBVmvNLR5t4V6WfPaNeXGUeZFJIS/AQLh7+pPiRIs+ouKprbduOK
UXFxOX29AhI4JGbFhFuit6BYhtMjvvhK2wsWrmFnlZYpwujYymQf7Rv6iHBZG0Pp
Z5U16a5fVyYXuuo8XRmgHeEtvMxkEiWr8HCKmxNzca+OksVVoipSEAOzDDD0NCkZ
38GJk2E+D/Se5VtFgeWDKG1qhlRdGSrhMEwGgAM3+kBka43KGwdPp9C+pfDwdm13
GqUuaJdKHNzHEmbXf20s
=q+PO
-----END PGP SIGNATURE-----

--U2Kcn04rSS87U9qV28sV0B54PForoAHT3--
