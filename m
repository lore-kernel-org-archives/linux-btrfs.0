Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47724 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751276AbbDUBbT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 21:31:19 -0400
Date: Mon, 20 Apr 2015 21:31:16 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Message-ID: <20150421013116.GC20194@hungrycats.org>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
 <49296740.rPqQP4vAjc@merkaba>
 <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
 <20150420042731.GA20194@hungrycats.org>
 <pan$f3383$b95d8948$e810e90b$680e5c5d@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
In-Reply-To: <pan$f3383$b95d8948$e810e90b$680e5c5d@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2015 at 06:07:09AM +0000, Duncan wrote:
> 4.0 is out.  There's reason people may want to stick one version back by=
=20
> default, to 3.19 currently, since it can take a few weeks for early=20
> reports to develop into a coherent problem, and sticking one stable=20
> series back allows for that, and deciding exactly when one is comfortable=
=20
> upgrading.  But in btrfs context anyway, with 4.0 out, if you're not on=
=20
> at least 3.19 yet, you should be able to point to the bug explaining
> /why/.  If you can't, arguably, you should be either upgrading yesterday=
=20
> if not sooner, or you really should choose some other filesystem, as=20
> btrfs simply isn't at the stability required for your use-case yet, and=
=20
> you unnecessarily risk data loss to already found and fixed bugs as a=20
> result.

I'm not sure that "run the latest kernel" or even "run the latest kernel
minus N weeks or months" is good advice for user data integrity at
present.  It's certainly unsupported by any test data I'm seeing.

If the intention is to discover and report or fix btrfs bugs, or confirm
that known bugs have been corrected, then the latest kernel (or a -next
integration branch) is the only one to run.  If the intention is to
use btrfs for data storage, then the kernel selection process is much
different.

In the stable kernels (the v3.xx.y Git tags with no other patches)
in the last year, there have been a number of btrfs regressions, from
memory leaks to deadlocks to filesystem-crashing corruption issues:

	2 severe corruption (i.e. destroy the filesystem) or memory leak
	issues (i.e. leak all the RAM and crash slowly and messily)
	I've encountered in my own testing,

	2 kernel panic or memory leak issues that I avoided by accident
	because the fix came out before I could pull the regression into
	a build,

	3 failure modes in new code leading to deadlock or temporary
	inability to retrieve stored data that first appeared in v3.13
	or v3.15, and as of today are not yet resolved.

My testing process runs like this (slightly simplified):

	1.  Build stable and/or Linus tagged kernels + integration-queue
	patches + locally-generated patches if any.

	2.  Run these kernels on various machines with workloads,
	observe and analyze failures.

	3.  When a machine fails to do its work due to a kernel issue,
	restart at step 1 with a different version or more patches.
	Note this includes more issues than btrfs; e.g. sometimes
	a kernel is not usable because of ACPI or WiFi issues that make
	btrfs test results irrelevant.

	4.  If a kernel build succeeds for N or more days, expand the set
	of test machines to get more test coverage, and go back to step 2.

	5.  If N >=3D 60 with no (severe) problems, consider that kernel
	stable and bless it for production.

Linux kernels getting to step 5 are rare and precious things even when
not testing btrfs.  The last kernel to reach step 5 for me was v3.12.x.
Before that was 835 days of searching for a successor to the kernel I
was running in production at the time.  :-/


> --=20
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlU1qGQACgkQgfmLGlazG5yIvwCdE2/jCrsdhItlcEjSTK4JCHZn
WNUAn1Q47YIv9WDjTGgJUjxRcD+s4kzQ
=a5tz
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
