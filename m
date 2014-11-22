Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50859 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaKVMN3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 07:13:29 -0500
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MBZ9u-1Xky1I1dR8-00ATVE for
 <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 13:13:26 +0100
Date: Sat, 22 Nov 2014 13:13:18 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub status misreports as "interrupted"
Message-ID: <20141122131318.05609d5f@marcec.fritz.box>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LtHZkSqk2p_ufqeSKU7ZAvf"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LtHZkSqk2p_ufqeSKU7ZAvf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

While I haven't gotten any "scrub already running" type errors any more, I =
do
get one strange case of state misreport.  When running scrub on /home (btrfs
RAID10), after 3 of 4 drives have completed, the 4th drive (sdb) will repor=
t as
interrupted, despite still running:

# btrfs scrub status -d /home
scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
scrub device /dev/sda (id 1) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380 seconds
	total bytes scrubbed: 252.86GiB with 0 errors
scrub device /dev/sdb (id 2) status
	scrub started at Sat Nov 22 11:57:34 2014, interrupted after 3698 seconds,=
 not running
	total bytes scrubbed: 217.50GiB with 0 errors
scrub device /dev/sdc (id 3) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013 seconds
	total bytes scrubbed: 252.85GiB with 0 errors
scrub device /dev/sdd (id 4) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994 seconds
	total bytes scrubbed: 252.85GiB with 0 errors

The funny thing is, the time will still update as the scrub keeps going:

# btrfs scrub status -d /home
scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
scrub device /dev/sda (id 1) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380 seconds
	total bytes scrubbed: 252.86GiB with 0 errors
scrub device /dev/sdb (id 2) status
	scrub started at Sat Nov 22 11:57:34 2014, interrupted after 4136 seconds,=
 not running
								     ^^^^^^^^^^^^
	total bytes scrubbed: 239.44GiB with 0 errors
scrub device /dev/sdc (id 3) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013 seconds
	total bytes scrubbed: 252.85GiB with 0 errors
scrub device /dev/sdd (id 4) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994 seconds
	total bytes scrubbed: 252.85GiB with 0 errors

This has happened a few times, and when sdb finally finishes, the status is=
 then
reported correctly as "finished":

# btrfs scrub status -d /home              =20
scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
scrub device /dev/sda (id 1) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380 seconds
	total bytes scrubbed: 252.86GiB with 0 errors
scrub device /dev/sdb (id 2) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 4426 seconds
	total bytes scrubbed: 252.88GiB with 0 errors
scrub device /dev/sdc (id 3) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013 seconds
	total bytes scrubbed: 252.85GiB with 0 errors
scrub device /dev/sdd (id 4) history
	scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994 seconds
	total bytes scrubbed: 252.85GiB with 0 errors

Kernel and btrfs-progs version:

# uname -a
Linux marcec 3.16.7-gentoo #1 SMP PREEMPT Fri Oct 31 22:45:54 CET 2014 x86_=
64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux

# btrfs --version
Btrfs v3.17.1

Should I open a report on bugzilla?

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/LtHZkSqk2p_ufqeSKU7ZAvf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUcH3kAAoJEL/Q5oYsiHj0kq8QAJ+gYKtngtbEKQ363aGQ2aFd
UjKwpLCSVHWaW9gP8WHNVE1kDsDdivNoEl4hp1zaGp3FQefDNBgdYQ/vL+6MC24z
Wrj9nK4wHk8Z37OrZCJ12v7fhNls4CvEZGaO5Lxr01NhUu01rvQop1w15sR5Oies
3dYafvKb33WYAz+K8VCriXgI2NSvotcXxDQ1Elh/NY+Bnz6oCMQR4Z5/RENWu/gD
+2PMH9z3pJfAwAnZCcBtNF29suYD075UJCglNNCaNxrWPn3BY0xbQ2IS2Y1YiOKn
Bqt6k05qw7NOeAFMiz8zHui9/ABYSKOCddYn/ncz0YhdJSZQj4hTWQsoz0U+7aLE
cxbX9jSUV4GwQLLZhAwTenwvxCCQ026wHmxLoIQmdEeZ1peUAWnb8/MRNlSXnyPO
u0jpojITVHl3/oXgnUHsTo83Ma9W4JbSMtKF5yLS/4bV9FIAARrL9E8wKB0x/ojF
XcGES+n02Yp0InwYkfmg6Lw85GxTC6TM+ZggENUCjGhgsihSzqH165S3zVLWVujc
BqcsbWQKA2R8q0GwndUx9Uznf00sN4Ts6yp81vuzk3jSMSWoejXh1DMHmQ6Fg6fa
NRX7B6+3yCE2XHWSkdpDXnO5NINlsvBhy4sbOi5JYwpBd6FwHxwqbx4Wb57YvjVz
AnDhzuvWtL62iDwUqi/K
=phLa
-----END PGP SIGNATURE-----

--Sig_/LtHZkSqk2p_ufqeSKU7ZAvf--
