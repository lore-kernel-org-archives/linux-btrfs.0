Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49948 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762622AbcLPXSl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 18:18:41 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MQ2Wx-1cER0U2LBb-005Ei8 for
 <linux-btrfs@vger.kernel.org>; Sat, 17 Dec 2016 00:18:33 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-check finds file extent holes
Date: Sat, 17 Dec 2016 00:18:13 +0100
Message-ID: <6935146.pedKUuRHNK@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3849436.OO6qEtAKF4"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3849436.OO6qEtAKF4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello,

After my backup drive displayed a weird issue (programs accessing it su=
ddenly=20
started zombifying, but it worked fine after a reboot), I decided to ch=
eck the=20
file system.  The initial results with btrfs-check's low-memory mode fo=
und=20
reference count mismatches, but that seems to have been a false positiv=
e,=20
since btrfs-check's normal mode does not find them.  Instead, it compla=
ins=20
about several file extent holes:

# btrfs check /dev/sdd2      =20
Checking filesystem on /dev/sdd2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
checking extents
checking free space cache
checking fs roots
root 30634 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30635 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30636 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30657 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30746 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30747 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30764 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30834 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30835 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30915 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30916 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30942 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31038 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31053 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31366 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31367 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31368 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31385 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31425 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31473 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31499 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31554 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31572 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31606 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31653 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31680 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096

(The check is still not done, it's been running for about 24 hours now.=
)

Is this something that btrfs-check can safely repair, or that is perhap=
s even=20
harmless?

% uname -a
Linux thetick 4.8.14-gentoo #1 SMP PREEMPT Sun Dec 11 17:09:09 CET 2016=
 x86_64=20
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux
% /sbin/btrfs --version
btrfs-progs v4.8.5

I can't show any other output because btrfs-check is still running.  I =
can=20
only say that the file system is 1TB large and about 88% full (fuller t=
han=20
normal, which is about 85%).

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart3849436.OO6qEtAKF4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYVHY1AAoJEL/Q5oYsiHj0gF0QAIQz4+CxK3DevTyL50xnrcOp
UQfd1BR1+jLsJruJoRw53B/PFT2HirCx2VBiUtYDHQmTMLBugkJ4SAgG9L655+oV
iVhALANcrXq+ivsIaHcubPbf5tVEbissO+QJ54d2JiJ4XQmIt6g7ADqmhQv0nV1T
JhcpMTNN+x6aMAUKtTGTO5qzOMG3JX8mVTA70ZJ0OSlogqQgmc23oAnWD2jQIZ87
7PmK7/9vTQ4D0Lhf+OxydOKY6HAmYgF+WhkrdEM1pxKf5VOOwmf9cfmJ5EgIxW23
K/4INCKWjM3+TaSPwaZCtiopf9lW+3bIHuAAMFQpbABmUh7NL0JlMJu7HuAkniK8
pLmUB+53BIbOM61e0hbaBZdouAx9n3J6hKi8v1JJs13I59OqyzIFVGcWLOmbVJcr
V7fHrNU9hMMmtWP5LF68KSjivQqdcCBZcQsTh8mKTexU89wBNuQeBIr7jxv5mmmv
Z8YRFwIki5jqhv+C5TKvpI16g79kCt7GiAaBooI4H9forg6Miu/Dz9UykIcQ9alR
xi7TOambSbTLwuWusT8hlGhVyD6Jdb6mWQflu1zxzPS8jW/X+ow/DSw+xa52+hWO
mMjrJ7LBaC+DYdHj4mueOsVW9g02Rpjmvwe84reOiyM/KdNMZUfvn1TjGIdZiyho
XtL9vEqYN1GCVswZWvS4
=Ff8X
-----END PGP SIGNATURE-----

--nextPart3849436.OO6qEtAKF4--

