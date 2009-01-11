From: Valdis.Kletnieks@vt.edu
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Sun, 11 Jan 2009 17:45:34 -0500
Message-ID: <100584.1231713934@turing-police.cc.vt.edu>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu>
            <49677CB1.3030701@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231713934_4078P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: Your message of "Fri, 09 Jan 2009 08:34:57 PST."
             <49677CB1.3030701@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>

--==_Exmh_1231713934_4078P
Content-Type: text/plain; charset=us-ascii

On Fri, 09 Jan 2009 08:34:57 PST, "H. Peter Anvin" said:

> A lot of noise is being made about the naming of the levels (and I
> personally believe we should have a different annotation for "inline
> unconditionally for correctness" and "inline unconditionally for
> performance", as a documentation issue), but those are the four we get.

I know we use __builtin_return_address() in several places, and several
other places we introspect the stack and need to find the right frame entry.
Are there any other places that need to be inlined for correctness?

--==_Exmh_1231713934_4078P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJanaOcC3lWbTT17ARAhshAJ9EuXy6AsnovZqJBsb30GqNfgRW6QCgvxMc
9XcAbNlET4hJRlR00Jexkjk=
=CaEV
-----END PGP SIGNATURE-----

--==_Exmh_1231713934_4078P--
