Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53581 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcFZWiR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 18:38:17 -0400
Date: Sun, 26 Jun 2016 22:38:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Message-ID: <20160626223813.GA10223@carfax.org.uk>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
 <pan$60ea0$54eb541$a3b060fc$181835e5@cox.net>
 <CAN05THQCJS8x0yF6DjDFfsNWzp1u4edv5dH-BMb1TTofZdtjgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
In-Reply-To: <CAN05THQCJS8x0yF6DjDFfsNWzp1u4edv5dH-BMb1TTofZdtjgA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 26, 2016 at 03:33:08PM -0700, ronnie sahlberg wrote:
> On Sat, Jun 25, 2016 at 7:53 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> > Could this explain why people have been reporting so many raid56 mode
> > cases of btrfs replacing a first drive appearing to succeed just fine,
> > but then they go to btrfs replace a second drive, and the array crashes
> > as if the first replace didn't work correctly after all, resulting in two
> > bad devices once the second replace gets under way, of course bringing
> > down the array?
> >
> > If so, then it looks like we have our answer as to what has been going
> > wrong that has been so hard to properly trace and thus to bugfix.
> >
> > Combine that with the raid4 dedicated parity device behavior you're
> > seeing if the writes are all exactly 128 MB, with that possibly
> > explaining the super-slow replaces, and this thread may have just given
> > us answers to both of those until-now-untraceable issues.
> >
> > Regardless, what's /very/ clear by now is that raid56 mode as it
> > currently exists is more or less fatally flawed, and a full scrap and
> > rewrite to an entirely different raid56 mode on-disk format may be
> > necessary to fix it.
> >
> > And what's even clearer is that people /really/ shouldn't be using raid56
> > mode for anything but testing with throw-away data, at this point.
> > Anything else is simply irresponsible.
> >
> > Does that mean we need to put a "raid56 mode may eat your babies" level
> > warning in the manpage and require a --force to either mkfs.btrfs or
> > balance to raid56 mode?  Because that's about where I am on it.
> 
> Agree. At this point letting ordinary users create raid56 filesystems
> is counterproductive.
> 
> 
> I would suggest:
> 
> 1, a much more strongly worded warning in the wiki. Make sure there
> are no misunderstandings
> that they really should not use raid56 right now for new filesystems.

   I beefed up the warnings in several places in the wiki a couple of
days ago.

   Hugo.

> 2, Instead of a --force flag. (Users tend to ignore ---force and
> warnings in documentation.)
> Instead ifdef out the options to create raid56 in mkfs.btrfs.
> Developers who want to test can just remove the ifdef and recompile
> the tools anyway.
> But if end-users have to recompile userspace, that really forces the
> point that "you
> really should not use this right now".
> 
> 3, reach out to the documentation and fora for the major distros and
> make sure they update their
> documentation accordingly.
> I think a lot of end-users, if they try to research something, are
> more likely to go to <their-distro> fora and wiki
> than search out an upstream fora.

-- 
Hugo Mills             | "No! My collection of rare, incurable diseases!
hugo@... carfax.org.uk | Violated!"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                Stimpson J. Cat, The Ren & Stimpy Show

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXcFlVAAoJEFheFHXiqx3kl2wQALSz+ZLzOFLeaR4FIatBuBzi
P9k9uLHBk/vgK3UFD28pOwdFX4H2dkWyuzBVWprsb5wizoUYlP2FVe6SxYID/+h6
XrnGzzpF7YqbfSxSHr2D9vv02qjNc6e8DJsxTFBDJiiwiBYGon0glzmOHRi/fKwx
6aUMf+4FuO4P1Rc9qeMlwOIX3mIijuxlNjRWkLUMofslNHDUmN9+vCp4Bbt0j683
53Mmv/0KoBNvnVPkBzzUOMDcjQ8+Crc4h4Hh0yVPA36MX4nWfR12SF5KzUUT9GvN
hAgV2P61/7aeWU7cHxnOcEf/YkhZ22Om+kqkPjYOy/Mfh0IYhi+pObGyMxu4A+75
Ly21QDSvlixbqCzDF/bfW5I7UKNtXJ9IgcvapiWMMLKlYg5pBdFUwRleNSWj/pN+
/Q/6RX9zWE3JmvUtKM2+y8R0gYZnniMMvSGfxhAqUHf96wpOjgqz97/KI/WVJc3x
XKRK+PHVcGBvu/ftOy0KiU9Fy+lbhrcbdu+TQTo3RiMdCs1QbhJ1aep9cGy30cM/
dqFwtp+XWUxTMdO0fN0LryePYNJmATIJQVnoAWSvRk+5xQKeueYLqCYf/vEWxLSV
T56bKGLaZBdUNvWJaGLmiZGLu8FBuPAo5MjRw4DeYRkiP5xhFb0ph/+QhfZ31HDJ
ffSTrjuw5ZFJM1084ZZh
=Xvzo
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
