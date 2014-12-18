Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nala.villavu.com ([188.165.243.101]:51572 "EHLO
	nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaLRKaj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 05:30:39 -0500
Message-ID: <5492AC94.8050104@wizzup.org>
Date: Thu, 18 Dec 2014 11:29:40 +0100
From: Merlijn Wajer <merlijn@wizzup.org>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs-progs: Support for musl libc (and perhaps also uclibc)
References: <548C4E9D.2080309@wizzup.org> <20141217164924.GB27601@twin.jikos.cz>
In-Reply-To: <20141217164924.GB27601@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QiCbPW2jRPgFJDxhhSJWV6HcUHtChLxFj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QiCbPW2jRPgFJDxhhSJWV6HcUHtChLxFj
Content-Type: multipart/mixed;
 boundary="------------080407060801000301050308"

This is a multi-part message in MIME format.
--------------080407060801000301050308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 17/12/14 17:49, David Sterba wrote:
> On Sat, Dec 13, 2014 at 03:35:09PM +0100, Merlijn Wajer wrote:
> [snip]
>=20
>> Attached are the two patches generated with git format-patch. I am awa=
re
>> that this may not be required format for submitting patches -- but
>> please give me some time to get used to the etiquette. :-)
>=20
> Thanks, there are minor things that I won't bother to point out to
> occasional contributors and fix them myself. The only formal requiremen=
t
> is the Signed-off-by tag, you can find the description eg. here
>=20
> http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L3=
58

Alright, cool. I've rebased my two patches and used --signoff when
amending the commit. Please find the new patches attached.


>> Please let me know if musl-libc (or any other libc) is a supported
>> platform, and if so, if and how I can improve on said patches.
>=20
> I'm not aware of non-glibc users, but I don't see any problem to add
> support for more libc implementations. However, I won't regularly verif=
y
> that it builds so it might break.

That is fine; at this point there are not a lot of people using an
alternative libc, so this is common practice. I'll be here with a new
round of patches if it breaks in a future release; it shouldn't really
break too often. :)


> Seems that only standardized library calls are used in btrfs-progs so
> any kind of support is probably going to be satisfied by #ifdefs.
> Your patches are simple so I'll try to schedule them to some 3.18.x
> update.

That would be great; thank you.

Regards,
Merlijn

--------------080407060801000301050308
Content-Type: text/x-patch;
 name="0001-Include-headers-required-for-musl-libc.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-Include-headers-required-for-musl-libc.patch"

=46rom 0109fd7ce62eee8b16aa5bdf78f3de54011e00f3 Mon Sep 17 00:00:00 2001
From: Merlijn Wajer <merlijn@wizzup.org>
Date: Sat, 13 Dec 2014 15:07:25 +0100
Subject: [PATCH 1/2] Include headers required for musl-libc.

This fixes various compilation errors where PATH_MAX and XATTR_SIZE_MAX
were missing. To my knowledge, this should have no bad side effects.

Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
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


--------------080407060801000301050308
Content-Type: text/x-patch;
 name="0002-Disable-backtrace-and-define-__always_inline.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0002-Disable-backtrace-and-define-__always_inline.patch"

=46rom 5ae5cfa3af473625ef5b31daf5f229f12be753d2 Mon Sep 17 00:00:00 2001
From: Merlijn Wajer <merlijn@wizzup.org>
Date: Sat, 13 Dec 2014 15:08:43 +0100
Subject: [PATCH 2/2] Disable backtrace and define __always_inline

Disable backtrace and define __always_inline when glibc is not used as
libc. This, together with some header changes allows btrfs-progs to
compile with musl-libc.

Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
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


--------------080407060801000301050308--

--QiCbPW2jRPgFJDxhhSJWV6HcUHtChLxFj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUkqyXAAoJEHmTPmZXIL57yBYQAIdC/L0TwxFQxUTgAy4hw0Kh
xg2k03zCDhL2/2kYRA1lVaSr3yDfgGIXWiGnRYtcsIjMaszklm3hYUBr6g1WUoQz
NmdQz5InHIs51hymYaqFEubQlQxNUnkyKa4WBmdj7tH1NfXGWZRsGku4nfpPPzfJ
jTDzYWXpCUlFGrkgsupR20VuqVj1u/TqGgKHakEUrg9ZGQnOdhvCvveY9bXylmW8
JYwFNUrmK7OdSAhSa9wNPSdO2+a26ITCwycAPZSACjxLblSkjlG95rMC6ismcDxh
zVxTcFbpvOYOjrT283DKWhaBX7RavuJ68dKREZkdiTN5+JooJckN1LKnLaNW6r/O
xjoXdJQwL4wcJk/A4o34XdxLlPYeclszZDcqsLz54gkPpRiYwTKV98FD2AV05U8+
eUnKSnmg+pOAwI7sNObqRyvDW+preW4VuNThOXDlicDs/pEGL5kZYORiKnfG9yen
+Vmbyuz0JPSiOXrnATTbelBxW5RiNlphDid6OsiazEKaKv92TigsWvWxAywwuboj
4ZD7tyEmDkScCzy9DCmfOyAbtDRYLEzfqQBdOJtNUHGs1d624MAXPWbyXprC9N7b
4PAbgCPDxhBQvcUgRG7VsbtOj6bImcqyIhpkpcnX3sufnyYPxJcQy7mgNCQLNd3A
bggSXZiV3fwEu3KAMRCa
=A7G3
-----END PGP SIGNATURE-----

--QiCbPW2jRPgFJDxhhSJWV6HcUHtChLxFj--
