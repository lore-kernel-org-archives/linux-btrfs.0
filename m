Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51785 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbbIYNvf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:51:35 -0400
Date: Fri, 25 Sep 2015 13:51:34 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sjoerd <sjoerd@sjomar.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Latest kernel to use?
Message-ID: <20150925135134.GF3749@carfax.org.uk>
References: <4362384.AA8xu4anSN@hoefnix>
 <3800342.Pn9bHBFuTx@hoefnix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Y7d0dPL928TPQbc"
In-Reply-To: <3800342.Pn9bHBFuTx@hoefnix>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1Y7d0dPL928TPQbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 25, 2015 at 03:36:18PM +0200, Sjoerd wrote:
> Thanks all for the feedback. Still doubting though to go for 4.2.1 or not. 
> Main reason is that I am currently running 4.1.7 on my laptop which seems to 
> work fine and had some issues with the 4.2.0 kernel. No issues I thing that 
> were btrfs related, but more related to my nvidia card. Anyway switching back 
> to 4.1.7 resolved those, so I am a bit holding back to try the 4.2.1 version 
> ;)
> Anyway I'll see and can always revert back if I don't like it ;)

   If 4.1.7 is working OK for you, stick with it. It's getting much
less important now, as btrfs matures, to keep up with the _very_
latest. Purely on gut feeling about issues we see on IRC and here,
3.19 or later would be reasonable at the moment.

   Compared to, say, 3 or 4 years ago when running late -rc kernels
was often preferable to running the latest stable, and things have
improved quite a bit. :)

   Hugo.

-- 
Hugo Mills             | For months now, we have been making triumphant
hugo@... carfax.org.uk | retreats before a demoralised enemy who is advancing
http://carfax.org.uk/  | in utter disorder.
PGP: E2AB1DE4          |                              Eric Frank Russell, Wasp

--1Y7d0dPL928TPQbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWBVFmAAoJEFheFHXiqx3kGQkP/1qGmcgtCnqX0WFYjtauYfCI
JohBe1TR6guZ9T9NZPDRkS6aDhZJsXZAkzu42hc7DTlO2zoWYF2Sok4TGF3I+fkw
n4ThdMcdynJNmPVxSj2NfhKXyIuZMYS4x9TuQ84dH3f1hwfwhuuacLmIkDV1pX2G
wBxNwdFKMlgizq8p1ypoYvUSb8lWp2GOkziuJ+mDPQWKJ/fG6VbjE9n19iIwyW01
2e82WPyhp8JJy+MDAY3WPK8YBzSz703sJhGhm8/VSzLARZmbsTUWr7AjU3hcq0Lo
KmWx6unAH7jeFhNejyT6DdrCqdV204d4Y/3mviBACeXEaQnVGRZQlHGNgVQIdCvA
nFM0QpuaHgwRhbKO9d7Y84OLr8mo3IjdekoIdUHhPtIfZ4g7WyUQiCgpLrfNwsxc
fbygjshgLX62ScaUS6YFIjJ5TomH+eK/euPnfXHzI/u7yH5IHALsiC2eBGpCw5oS
fPYqoPvTCjgGVNBZhNjsUzpbJ1jJTC4DCw08Eoc8UM6LgPGEnOpfboTIx2a1n1Kn
oAcCJGQni9179A8hUkSgEcaU2h0q2JGoyW18SYZmRvHkeARDfATtKldq4LyD2kAD
uHSgHZ9kF4OB8OgLOW3h7xlAMnRFf8oefsEeO+SsLFooJAecWxUH5IH+Epo8mJ5a
4ukLJa6RR8h467jHXCOK
=9IMR
-----END PGP SIGNATURE-----

--1Y7d0dPL928TPQbc--
