Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51061 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481AbcBCV1m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 16:27:42 -0500
Date: Wed, 3 Feb 2016 21:27:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Question about a specific error.
Message-ID: <20160203212740.GC30635@carfax.org.uk>
References: <56AFB598.2020307@gmail.com>
 <20160201202112.GB8313@carfax.org.uk>
 <56B0A881.5080403@gmail.com>
 <CAJCQCtQ_c1-ck6=_XasvDVwEepXQjB7V4jfxJ9Fe_pPmExtG=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
In-Reply-To: <CAJCQCtQ_c1-ck6=_XasvDVwEepXQjB7V4jfxJ9Fe_pPmExtG=A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 03, 2016 at 02:17:06PM -0700, Chris Murphy wrote:
> On Tue, Feb 2, 2016 at 6:00 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 2016-02-01 15:21, Hugo Mills wrote:
> >>
> >> On Mon, Feb 01, 2016 at 02:44:24PM -0500, Austin S. Hemmelgarn wrote:
> >>>
> >>> In the process of trying to debug issues I'm having on one of my
> >>> systems with a new kernel version, I decided to do a dry run check on
> >>> the root filesystem.  'btrfs check' returned a bunch of lines like:
> >>>
> >>> root 257 inode XXXXXX errors 2000, link count wrong
> >>>          unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0
> >>> errors 3, no dir item, no dir index
> >>>
> >>> I got about 20 messages like this with varying values for everything
> >>> except the filetype and error counts.  Based on what I can tell, these
> >>> look like orphaned inodex, but I'm not certain.
> >>> Is it safe to tell BTRFS to try and fix these errors?
> >>
> >>
> >>     Yes, those are errors I'd expect btrfs check --repair to handle
> >> properly.
> >>
> > OK, it looks like things were fixed safely, but I'm not 100% certain that it
> > fixed things the way it should have.  All of the files it reported got moved
> > to /lost+found (which makes me think it thought they were orphaned items),
> > but none of the files themselves showed any issues in regular usage (they
> > were all perfectly visible beforehand in the regular directory structure,
> > and there were no errors accessing them). On top of that, it pulled out two
> > different versions of each one, one from more than a year ago, and one
> > current version.  I think btrfs check may have gotten either confused or
> > over-zealous and just decided it needed to pull out the current, perfectly
> > fine versions of the files as well.
> 
> The problems look different. You're reporting errors 2000. I'm seeing
> errors 2001. I'm not sure what the distinction is; but in my case,
> cancelling btrfs check and just rerunning it gives different results.
> https://bugzilla.kernel.org/show_bug.cgi?id=111841

   The "errors" field in the output of btrfs check is a hex
(strange... I thought it was octal...) bit-field indicating the set of
error types encountered. They're defined in #defines at the top of
cmds-check.c. 2000 is I_ERR_SOME_CSUM_MISSING, 1 is I_ERR_NO_INODE_ITEM.

   Hugo.

-- 
Hugo Mills             | You are not stuck in traffic: you are traffic
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                    German ad campaign

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWsnDMAAoJEFheFHXiqx3kXqsP/RlIlmrRPe/exrvrHQnMyaI9
e84gFzoI3Sz/EjekRzzgQamV18wSIjgXDBFumQddt5L4vBUDgPmb5rFvBoO20838
dSQu7VqkSoeklHqY6LR5+cjNVYmK3P0wxHtR/gEbytcAtTNRThBzvlgUn7V6o6yK
qXqW06zmFwRWdfr5X/P6McJFfqTo9sloKl0n/16z8bFmKC6NG6pD70hcGsaDrGqX
UIjPb+hiSEjWWab8fLmvgEHu2MH7jRjc536LojwATxxlY7sgr02BGCpPxz8drXLV
6V34ZHr+JexrF+N1CmICNPlmp+BghO/CeVjsN0d1MlXD/wB/QH3hMp3Q5fpvFeG6
kk2PUOtqjWiZhOXHEnFHXAVK/Gr8lgXI/xz5vdo3PQJ/k7Zl+WjL+eLyPwGwvgif
b3qBhQe/J8jCv71OCqjy9tvmCJwwVjof96ty4P4JMCmthEHLMvqCkY5AiQ25woK6
htypw6EkyG+WreA5GjrT7Fu2MJ8K0X2xFvbPXK/Zn/750S/4uSkJamqJC+dMLJPy
6bHJDW663M6yZ8Bh4h49dBsZ+bBACOAkfMRY+nVKA6vSh3bRQF61cTXbRe2t9Xvr
DOWgz3EeQ4NEc3ogdSJa4pRS1htBVHIGXowJn9S78eXW5nc/rYBuyV9iwTyhsJuW
kOwlrD/QhZWf7/UrshrJ
=FVn4
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
