From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH -v6][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 09:33:52 -0500
Message-ID: <49660ED0.2000909@novell.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231366716.11687.377.camel@twins> <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5E660CF9ECE186DBA70E4DB2"
Cc: Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090108141808.GC11629@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5E660CF9ECE186DBA70E4DB2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>  =20
>> * WOW *
>>    =20
>
> WOW indeed - and i can see a similar _brutal_ speedup on two separate=20
> 16-way boxes as well:
>
>   16 CPUs, running 128 parallel test-tasks.
>
>   NO_OWNER_SPIN:
>   avg ops/sec:               281595
>
>   OWNER_SPIN:
>   avg ops/sec:               524791
>
> Da Killer!
>  =20

This jives with our findings back when we first looked at this
(200%-300% speedups in most benchmarks), so this is excellent that it is
yielding boosts here as well.

> Look at the performance counter stats:
>
>  =20
>>    12098.324578  task clock ticks     (msecs)
>>
>>            1081  CPU migrations       (events)
>>            7102  context switches     (events)
>>            2763  pagefaults           (events)
>>    =20
>
>  =20
>>    22280.283224  task clock ticks     (msecs)
>>
>>             117  CPU migrations       (events)
>>            5711  context switches     (events)
>>            2781  pagefaults           (events)
>>    =20
>
> We were able to spend twice as much CPU time and efficiently so - and w=
e=20
> did about 10% of the cross-CPU migrations as before (!).
>
> My (wild) guess is that the biggest speedup factor was perhaps this lit=
tle=20
> trick:
>
> +               if (need_resched())
> +                       break;
>
> this allows the spin-mutex to only waste CPU time if there's no work=20
> around on that CPU. (i.e. if there's no other task that wants to run) T=
he=20
> moment there's some other task, we context-switch to it.
>  =20
Well, IIUC thats only true if the other task happens to preempt current,
which may not always be the case, right?  For instance, if current still
has timeslice left, etc.  I think the primary difference is actually the
reduction in the ctx switch rate, but its hard to say without looking at
detailed traces and more stats.  Either way, woohoo!

-Greg


--------------enig5E660CF9ECE186DBA70E4DB2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklmDtEACgkQlOSOBdgZUxlK0ACeMYCUpaXFJJSQNjD3ZVUjwsqP
9MUAn1pTr0JFVrBA3G3f3flf5aXRjgHP
=YpO9
-----END PGP SIGNATURE-----

--------------enig5E660CF9ECE186DBA70E4DB2--
