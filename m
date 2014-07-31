Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41529 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaGaKLZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 06:11:25 -0400
Date: Thu, 31 Jul 2014 11:11:16 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
Message-ID: <20140731101116.GN31950@carfax.org.uk>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
 <CAPM=9ty2PhMdLykVX4c074Tdkyh0OO_jtfw-CAFHk8ANcZA4kQ@mail.gmail.com>
 <CAPDOMVgXChx5HST-jMEZmWDydWKe0Yv15pyTiPeOuQSVEjihFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zl+NncWK+U5aSfTo"
In-Reply-To: <CAPDOMVgXChx5HST-jMEZmWDydWKe0Yv15pyTiPeOuQSVEjihFA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Zl+NncWK+U5aSfTo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2014 at 10:05:16PM -0400, Nick Krause wrote:
> On Wed, Jul 30, 2014 at 7:30 PM, Dave Airlie <airlied@gmail.com> wrote:
> >> This patch removes the lines for releasing the page cache in certain
> >> files as this may aid in perfomance with writes in the compression
> >> rountines of btrfs. Please note that this patch has not been tested
> >> on my own hardware due to no compression based btrfs volumes of my
> >> own.
> >>
> >
> > For all that is sacred, STOP.
[snip]
> > But if you want to work on the kernel, this isn't the way to do it, and
> > nobody will ever take a patch from you seriously if you continue in this
> > fashion.
> >
> > Dave.
> Dave ,
> Seems I need to have tested this code first.

   You've said this before, having made exactly the same error (not
testing a patch). Yet you do it again. You seem to be ignoring all the
advice you've been given -- or at least not learning from it, and not
learning from your experiences. Could you please, for half an hour or
so, stop thinking about the immediate goal of getting a patch into the
kernel, and take a short while to think about your process of
learning. Look at all the advice you've had (from me, from Ted, from
others), actually understand it, and consider all the things you need
to do which *aren't* hacking up a lump of C. Actually learn these
things -- have them in your mind all the time.

   I would appreciate it if you could actually engage with someone
(doesn't have to be me) about this -- why are you ignoring the advice?
Is it because you don't understand it? Is it because you think you can
cut corners? Is it because you're concetrating on the code so much that
you're forgetting it?

   The main thing you're doing which is making people angry is not
because you're submitting bad patches (although you are). It's because
you're not listening to advice, and you're not apparently learning
anything from the feedback you're given. Your behaviour is not
changing over time, which makes you look like a waste of time to all
those people trying to help you.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- That's not rain, that's a lake with slots in it ---         

--Zl+NncWK+U5aSfTo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9oWRFheFHXiqx3kAQLSBA/8D7Ys85PUoJsEHc8r5zxqgtOxE2qJzg3p
vMc5KBu+7qQiBpqosQXPyOX3AkfeFDKeMIn0h2hSq0WPm4YRBOtwLpDm9q96nw1e
OnJv7a7mEePEl4it8LN0zW9TvzhR7IYJRigRse734r3H+NX4Rcpx3y/AGBPjsVJQ
33OspDUhi/40zS3RLb+3VTLJgxxp/XHyz/cKBJyJMb/IVQlzKaUZowVQgratjBGj
69HtNBuHTUGnLlVaXQjiSp2ya/XK1QaOw7BNJM96U1braQ+muzW1OnAI7afSvYkk
roCGu3N0gcTlPuG/N7/TOhTN/6VfZiCWrlTEfZxTUcTuQv2qgWsldrim739jO3YX
2UCfNqm22Ivw/7CD3fojqsBQsvsvgdtKg8EPpsAJPZg/yksfBc4Kn/FsHVv5dU12
ngvTxFahBYbDbh/HXMCyJeEy4W1Mra6cAsOkhhZXSJ64KsxPY1N/etkmMPOiBnaf
/z4+W3uG/LfHlBGbR5ZPCt8UooCoK6fGhCIH7R7D9npxsqUF1dyznBAfaBUk2/Dm
mOZ7KFhUcdeq6vE+ozKvKQShdjrmJOS7BKh4O677TMJB0AkdJnInyeWoJ2whlZe3
Mvx9KySsdX98+7pmghDBC5BzygwtAVvEDTTXJ2oArnxoTp0eq4VUIFihs0G8WO+A
xrMH4lSs7hU=
=BLJY
-----END PGP SIGNATURE-----

--Zl+NncWK+U5aSfTo--
