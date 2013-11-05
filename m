Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49440 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3KEMFI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 07:05:08 -0500
Received: from samson ([77.22.8.42]) by mail.gmx.com (mrgmx102) with ESMTPA
 (Nemesis) id 0M7DVi-1VsHiO1V1a-00x4fE for <linux-btrfs@vger.kernel.org>; Tue,
 05 Nov 2013 13:05:06 +0100
Date: Tue, 5 Nov 2013 13:04:59 +0100
From: Dennis Schridde <devurandom@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: Partition broken, btrfsck segfaults or asserts
Message-ID: <20131105130459.133d538e@samson>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aasEQJJZPwCmrRkD7QFJTZl"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/aasEQJJZPwCmrRkD7QFJTZl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello!

I have a serious problem with inaccessible data and segfaulting btrfsck
for the /var partition on my computer.

The reason is not entirely clear to me. The only extraordinary things
happening today were an empty CMOS battery and me accidentally enabling
C1E support when reconfiguring the BIOS. Afterwards the computer did
not boot properly anymore (some GPU lockup thingy and the whole system
locked up hard before X would start) and when I cut the power and setup
the BIOS again (this time without C1E support), /var would be broken in
the state I describe below.

I can mount it, and dmesg says the following, which seems normal:
---
device label var devid 1 transid 393536 /dev/sda7
btrfs: use lzo compression
btrfs: enabling auto defrag
---

When I access certain directories, however, I get a message like this
one:
ls: cannot access /var/log: Stale NFS file handle

When I run btrfsck --repair it asserts, and when I just run btrfsck
without extra options it segfaults. Sadly I do not have debug symbols
installed, so the backtrace is probably useless. I attached the
stdout/err output of both runs to the bugzilla report:
https://bugzilla.kernel.org/show_bug.cgi?id=3D64411

# btrfs --version
Btrfs v0.20-rc1-358-g194aa4a

# uname -r
3.11.6-gentoo

I would be thankful if you could help me to get as much as possible of
my data back. And please CC me, as I am not subscribed to the list.

Best regards,
Dennis

P.S: I already sent an email yesterday, but it did not arrive in the
archives, so I assume it was blocked by the list for the two ~125kB
attachments.

--Sig_/aasEQJJZPwCmrRkD7QFJTZl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSeN7rAAoJEGIxC0Gvwa5aoC8QAKjfmlFheFq6hF9U7v4xfS1t
s/bk8hR57hC53/3Po7TNDfP1fQ36ULQwtaZ4dtIGsM/jFFQe+w6tKhp9UpbepxvY
JbNZRrqNNnMmXK3C6W22qcfcKwyvvFv1WUCrbaZ9mTMDxTi2fqB9XZqArkb89KXm
xLnjRCnyy9VRSOu1aLiKzyv33Feg0kz+QdKn9MJbVFpYxq6OM5jvesq37WFIlT34
nrOLcjNRMu5zgVivBTVpsUA5HFYGCCJar68fzwA6rjUcZnvkKji54sjalj98Skki
zBlQW0ZqQ/6RqfAdiTvwZCrxId3h4wyIPlWCApOOo8Ehi1X0se3X4Wsa78vKFVlI
rUcDr8wbI3ufxJlIXViXwZf6enAh6z4XGR/h2bHUsLD8SYYDKuAsfqDPPWXIJkFy
DgxFPbhAsn394kq5VuVO7sfMW47rlzFmMea9pTStS/8BRxXhkaRaR1ExWoPPxa0J
v95u1UDluSkX4YfWvYD60vSI9ub90DPkatltG2cG7sDv6U3BDXNNbkjRLCnBfUoH
AHulCepqU13VtxT8kPSNm92LGquTz/eitoDn3Qm9iqa5XbFRnqT84oaWsu+r/kW9
IA+t6Rdd7j0ktMwQ9cHLLTHD6vaYnDkW/++S6NUjxYCFH8pVlZ70BvpWeu5n0m9k
xbLiC5lK39LFznnClCyq
=3tmZ
-----END PGP SIGNATURE-----

--Sig_/aasEQJJZPwCmrRkD7QFJTZl--
