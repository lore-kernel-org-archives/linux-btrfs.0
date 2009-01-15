From: Chris Samuel <chris@csamuel.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 23:53:02 +1100
Message-ID: <200901152353.05990.chris@csamuel.org>
References: <20090114105300.66bd014d.akpm@linux-foundation.org> <ac3eb2510901141350x16c0f67cp46376e57062eaef9@mail.gmail.com> <20090114223408.GA19173@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5190305.3EItt4FeP3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tglx@linutronix.de, npiggin@suse.de, pmorreale@novell.com,
	SDietrich@novell.com, dmitry.adamushko@gmail.com,
	hannes@cmpxchg.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114223408.GA19173@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart5190305.3EItt4FeP3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 15 Jan 2009 9:34:08 am Ingo Molnar wrote:

> So the 3 main Linux distros, generating ~95% of the kerneloops.org
> feedback traffic, all have SCHED_DEBUG=3Dy, and at least two have
> !DEBUG_MUTEXES. (possibly Ubuntu has that disabled it too)

That looks correct for Ubuntu:

chris@mythtv:~$ grep CONFIG_DEBUG_MUTEXES /boot/config-2.6.2*
/boot/config-2.6.24-21-generic:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.27-7-generic:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.27-9-generic:# CONFIG_DEBUG_MUTEXES is not set


=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart5190305.3EItt4FeP3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASW8xsY1yjaOTJg85AQJttggAjdGnncYFLUopmVOqSR1+znnTz4IoAGGz
5B58r35VpgvlIqZoldWMzCqK99aDyt2eLc4I+vcpr54za29UgAytrquGR1S9MzDv
VC/Mm4SfYPAPZ9anbowMUEKQD+rSXXq02yEprcSEE3TyWH9EoqMZoehVkkegJFzd
ZSXtU/vhZQ4DJavu0FF6xRwvGR2IlDBqCNeDbTFxQAUuXe1HEFqsdqHlLgRKbk2v
JNB8s+Q3QpGugElMEdK/bXbxm5V3lWioKHM7jOjJWtvYuUGlCXR8ZY5ajHHiTkE2
VnmqiTEiuBPfKK+wZVkcmGdwyWkqCXUy2+dT6AV4LQwXCbQxr6gANA==
=bTVt
-----END PGP SIGNATURE-----

--nextPart5190305.3EItt4FeP3--
