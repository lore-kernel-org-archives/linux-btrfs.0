Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56904 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaKQLg5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 06:36:57 -0500
Date: Mon, 17 Nov 2014 11:36:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Konstantin <newsbox1026@web.de>
Cc: Josef Bacik <jbacik@fb.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: Two persistent problems
Message-ID: <20141117113653.GE32735@carfax.org.uk>
References: <20141114215159.GA32735@carfax.org.uk>
 <54667B7A.8050704@fb.com>
 <5469D524.7010808@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
In-Reply-To: <5469D524.7010808@web.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 11:59:48AM +0100, Konstantin wrote:
> Josef Bacik wrote on 14.11.2014 at 23:00:
> > On 11/14/2014 04:51 PM, Hugo Mills wrote:
[snip]
> >> Problem 2: Unexplained zeroes
> >>
> >>     Failure to mount. Transid failure, "expected xyz, have 0". Chris
> >> looked at an early one of these (for Ke, on IRC) back in September
> >> (the 27th -- sadly, the public IRC logs aren't there for it, but I can
> >> supply a copy of the private log). He rapidly came to the conclusion
> >> that it was something bad going on with TRIM, replacing some blocks
> >> with zeroes. Since then, I've seen a bunch of these coming past on
> >> IRC. It seems to be a 3.17 thing. I can successfully predict the
> >> presence of an SSD and -odiscard from the "have 0". I've successfully
> >> persuaded several people to put this into bugzilla and capture
> >> btrfs-images.  btrfs recover doesn't generally seem to be helpful in
> >> recovering data.
[snip]
> > So for #2 I've been looking at that the last two weeks.  I'm always
> > paranoid we're screwing up one of our data integrity sort of things,
> > either not waiting on IO to complete properly or something like that.
> > I've built a dm target to be as evil as possible and have been running
> > it trying to make bad things happen.  I got slightly side tracked
> > since my stress test exposed a bug in the tree log stuff an csums
> > which I just fixed.  Now that I've fixed that I'm going back to try
> > and make the "expected blah, have 0" type errors happen.
[snip]
> For #2, I had a strangely damaged BTRFS I reported a week or so ago
> which may have similar background. Dmesg gives:
> 
> parent transid verify failed on 586239082496 wanted 13329746340512024838
> found 588
> BTRFS: open_ctree failed
> 
> The thing is that btrfsck crashes when trying to check this. As nobody
> seemed to be interested I reformatted this disk today.

   Whilst that's a genuine problem, it's not specifically the one I
was referring to here, which shows up with "want=X, have=0" from btrfs
check, and seems to be related to TRIM on SSDs.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Turning,  pages turning in the widening bath, / The spine ---    
        cannot bear the humidity. / Books fall apart; the binding        
            cannot hold. / Page 129 is loosed upon the world.            

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUad3TAAoJEFheFHXiqx3k1roP/RviWt38S/HoMTesEfN78QzA
WEmOjLPyx6qfLGDlCj2x7R+bqlQ6f8LktGPtgs/HQCIyKGMYT4C1FozkrAMJMQz0
i4G4IAe6+HX4FKJ85uhjYSQdFm30M0SowbkSPNOW/9VuUNk/OGlBp1Txug7MChxY
dKYvMxfj9GB7vm7G7CQZxNcPXxS8C7V16kDMmRbCWc20B7M7m+sGvxH0Tgtb/VOO
JqMvGh6wYZs1n0ozP7PShLf8J88oE5Mx21CMlgMjw2vdqYCxpZpiWNvqEN8qtcHt
B1wZaz7Fk1deoqkyV7AumwvB3+t1rxiTjXT4+XskhhPK/01LVvSJ7JQRhoR0nvpI
IVqIOQhIrkHaRelq89SzlsCw7Jj5jwVyBUXqF4Tyfr7d8tR0DVL2B86+nb2zxyO8
xHyjnYqf8jTXJwTvdetNsRLit1g95er8ZaMoLbz37+2bdkwQO8Eovri6D5+wJ9rk
r2pP4fADatUi+LOvuB67ChlHpjCcac7QUTbXjI86h7ZL8OpRKxmlmws3c7Fd4NXh
yX7WqSWaP2FjDD/ulHQ8Qcd+X0aHgia/HrGfmZZzANU8XcxDvIIYSs87rd9HQFru
8MsGkduc2CBd4LeMUL7zv5KtAehr/TGO2qRXJxwc8VX3vjy82yBfxrx9ZDbXw7fF
q3d8il9PsAstT6QXEh2x
=ypPG
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
