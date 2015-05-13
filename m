Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48432 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322AbbEMQf4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:35:56 -0400
Date: Wed, 13 May 2015 16:35:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Learner Study <learner.study@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>
Subject: Re: de-duplication algos
Message-ID: <20150513163553.GV18480@carfax.org.uk>
References: <CAP8+hKVLpwT7fFqMods0++SKqQSXF5Z1tXNcAgFw_i3utfFeVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NBQMqqtZQBFxm+aD"
In-Reply-To: <CAP8+hKVLpwT7fFqMods0++SKqQSXF5Z1tXNcAgFw_i3utfFeVQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NBQMqqtZQBFxm+aD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 13, 2015 at 09:24:17AM -0700, Learner Study wrote:
> Hello,
> 
> I have been reading on de-duplication and how algorithms such as Bloom
> and Cuckoo filters are used for this purpose.
> 
> Does BTRFS dedup use any of these, or are there plans to incorporate
> these in future?

   There was a long discussion on IRC about different approaches that
could be taken. I think Mark Fasheh captured most of that somewhere --
I thought he'd put it on the duperemove github site somewhere, but I
can't see it right now.

   One outcome of the discussion is that a probabilistic set
implementation is potentially useful, but there's still a lot of work
that needs to be done around those core algorithms to make a useful
deduplicator. A related outcome was that there's a lot of different
approaches that are possible, which can optimise for RAM, storage
space (both at runtime, and in the resulting deduplicated FS), or
execution time in different ways. I think we ended up with about 7 or
8 different possible algorithms by the end of it, even before looking
at the implementation details of which probabilistic set algorithm to
pick.

   If Mark doesn't have those notes any more, I can try to dig out the
original IRC discussion.

   Hugo.

-- 
Hugo Mills             | My code is never released, it escapes from the git
hugo@... carfax.org.uk | repo and kills a few beta testers on the way out.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             Diablo-D3

--NBQMqqtZQBFxm+aD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVU31pAAoJEFheFHXiqx3kOvsP/iNhUGGr4M78w8wfaqjzRL9y
vmz65IZiOa7CXSbcXN28OdffmcB15INZGZRXuhXEDTJFC5B8uwjBCv4tPpUI5EJq
OooJObl2xvBVYCkbIvUtpj9qQgETDd4Q6G1Hk+m2lGfLU/3HmH4BUDlOlulT0Lgt
ZeV41KT+lFsTdh+c2t3a5kzf3GflRWpjRjiOPz4wxqj+niULsXLi6rnfb2N16KVi
4CTmNu1beZvm97R4FcgccK/H7TLfOlZFvNOBH2a0jYEl0UUNl6dAVxHHe3jcYeJM
3ZZF28XVOxL5bY7FQqutxZG123aBP64P1cpPme7VNQ//4f+soObfUBaBJuqltLpO
R2OLPonMB+zOyqpxdKCWW6tQJdzKOCgeZRtpkpLfcnNXH3zYkMtB3aCoS92lc2zt
FKUO3aflvoZ+5LNJ1u7nZ2J1vnKoZUwzufQGt9MwauSIaJpnNcEXxUED9/ItV8lJ
2bLOuXVKybvTgJsEmQg23ILxlK7K8B0J/qRERHMsL+9mle0Ij2yzG1LhhS0cC+Hr
06X2lK+CVdRhHrI/2+kIQUH2cuTbXU27y9lziy+5zjl0FFnRsRS1PdHzk5y7aY88
UL/xYAKKkoKFvObW1TmEqlaDiXCuszHIx2gaZC5F5EEHOVpQZhEvr5kAX5ZXbqm0
KsX8jH0geXEXeFz7wfeG
=9Jll
-----END PGP SIGNATURE-----

--NBQMqqtZQBFxm+aD--
