From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 06 Jan 2009 09:15:53 -0500
Message-ID: <49636799.1010109@novell.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>	 <1230765549.7538.8.camel@think.oraclecorp.com>	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>	 <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>	 <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>	 <4963584A.4090805@novell.com>  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA10599BC4DA0548C63EADD23"
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231248041.11687.107.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA10599BC4DA0548C63EADD23
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Tue, 2009-01-06 at 14:16 +0100, Ingo Molnar wrote:
>  =20
>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>
>>    =20
>>> Ingo Molnar wrote:
>>>      =20
>>>> There's no time or spin-rate based heuristics in this at all (i.e. t=
hese=20
>>>> mutexes are not 'adaptive' at all!),
>>>>        =20
>>> FYI: The original "adaptive" name was chosen in the -rt implementatio=
n=20
>>> to reflect that the locks can adaptively spin or sleep, depending on =

>>> conditions.  I realize this is in contrast to the typical usage of th=
e=20
>>> term when it is in reference to the spin-time being based on some=20
>>> empirical heuristics, etc as you mentioned.  Sorry for the confusion.=

>>>      =20
>> the current version of the -rt spinny-mutexes bits were mostly written=
 by=20
>> Steve, right? Historically it all started out with a more classic=20
>> "adaptive mutexes" patchset so the name stuck i guess.
>>    =20
>
> Yeah, Gregory and co. started with the whole thing and showed there was=

> significant performance to be gained, after that Steve rewrote it from
> scratch reducing it to this minimalist heuristic, with help from Greg.
>
> (At least, that is how I remember it, please speak up if I got things
> wrong)
>  =20
Thats pretty accurate IIUC.  The concept and original patches were
written by myself, Peter Morreale and Sven Dietrich (cc'd).  However,
Steve cleaned up our patch before accepting it into -rt (we had extra
provisions for things like handling conditional compilation and run-time
disablement which he did not care for), but its otherwise the precise
core concept we introduced.  I think Steven gave a nice attribution to
that fact in the prologue, however.  And I also ACKed his cleanup, so I
think all is well from my perspective.

As a historical note: It should be mentioned that Steven also introduced
a really brilliant optimization to use RCU for the owner tracking that
the original patch as submitted by my team did not have.  However, it
turned out to inadvertently regress performance due to the way
preempt-rcu's rcu_read_lock() works so it had to be reverted a few weeks
later to the original logic that we submitted (even though on paper his
ideas in that area were superior to ours).  So whats in -rt now really
is more or less our patch sans the conditional crap, etc.=20

Hope that helps!

-Greg


--------------enigA10599BC4DA0548C63EADD23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkljZ5kACgkQlOSOBdgZUxlxqQCfY2ZZfOExwh4MCCd0u88kobhK
dZAAnjuCdDJ/B2LHRwdAkwYAoerUh8wQ
=k4K3
-----END PGP SIGNATURE-----

--------------enigA10599BC4DA0548C63EADD23--
