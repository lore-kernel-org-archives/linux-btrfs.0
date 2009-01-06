From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 06 Jan 2009 08:10:34 -0500
Message-ID: <4963584A.4090805@novell.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig13FC11A962D1BDDF958F15C6"
Cc: Peter Zijlstra <peterz@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090106121052.GA27232@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig13FC11A962D1BDDF958F15C6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> There's no time or spin-rate based heuristics in this at all (i.e. thes=
e=20
> mutexes are not 'adaptive' at all!),

FYI: The original "adaptive" name was chosen in the -rt implementation
to reflect that the locks can adaptively spin or sleep, depending on
conditions.  I realize this is in contrast to the typical usage of the
term when it is in reference to the spin-time being based on some
empirical heuristics, etc as you mentioned.  Sorry for the confusion.

Regards,
-Greg


--------------enig13FC11A962D1BDDF958F15C6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkljWEoACgkQlOSOBdgZUxn72ACfS2VJ9HA2Q3Ud+FqozlY40nMI
+EYAn0l0nsRQfX7uZlf6PYlqYL9fGuNb
=hQ/V
-----END PGP SIGNATURE-----

--------------enig13FC11A962D1BDDF958F15C6--
