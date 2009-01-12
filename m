From: Chris Samuel <chris@csamuel.org>
Subject: Hard to debug kernel issues (was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning)
Date: Mon, 12 Jan 2009 18:59:16 +1100
Message-ID: <200901121859.20893.chris@csamuel.org>
References: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090110030216.GW26290@one.firstfloor.org> <1231676801.25018.150.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4283922.WHj4pGa4DB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: David Woodhouse <dwmw2@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231676801.25018.150.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4283922.WHj4pGa4DB
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, 11 Jan 2009 11:26:41 pm David Woodhouse wrote:

> Sometimes you weren't going to get a backtrace if something goes wrong
> _anyway_.

Case in point - we've been struggling with some of our SuperMicro based=20
systems with AMD Barcelona B3 k10h CPUs *turning themselves off* when runni=
ng=20
various HPC applications.

Nothing in the kernel logs, nothing in the IPMI controller logs. It's just=
=20
like someone has wandered in and held the power button down (and no, it's n=
ot=20
that).

It's been driving us up the wall.

We'd assumed it was a hardware issue as it was happening with all sorts of=
=20
kernels but today we tried 2.6.29-rc1 "just in case" and I've not been able=
 to=20
reproduce the crash (yet) on a node I can crash in about 30 seconds, and=20
rebooting back into 2.6.28 makes it crash again.

If the test boxes are still alive tomorrow I might see if we can attempt so=
me=20
form of a reverse bisect to track down what commit fixed it (git doesn't se=
em=20
to support that so we've going to have to invert the good/bad commands).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart4283922.WHj4pGa4DB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASWr4WI1yjaOTJg85AQKTcAf+P0AcoISkYMQNMd/A77CGGEABURCdPauB
I1VLpvvN4DteXebOhYQDvSU8VOP4nlQQUus1YQWiIMIfOh+jd+6c7RIfnMJVZY+6
HHzKLLuk4EcS/vIfCI9PEGySqmn1rFAo6Z/TAry1xXF6ihgle1f/QtbGqM72JCJT
djYDJ8OmA2dFF8cq6lLz8lTWZTG9CEuYJU88dwjLmCr+DU6rJ543xd1QOeQSe0iP
8oqjIjtqnHvSa6hQul611JZ72pZh+VqvKO5SG1zNtETVKC2eyfsumys6qgrcocyr
h4QcdDiu5fZMmWSRC0lVzhEzJ/Ve0Qh/EmtRkTvs8x6HtPyrggpo9A==
=h4j+
-----END PGP SIGNATURE-----

--nextPart4283922.WHj4pGa4DB--
