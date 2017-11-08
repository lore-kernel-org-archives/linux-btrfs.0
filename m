Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49405 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbdKHRWT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Nov 2017 12:22:19 -0500
Date: Wed, 8 Nov 2017 17:22:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problem with file system
Message-ID: <20171108172217.GH27985@carfax.org.uk>
References: <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <CAH=dxU4MOWGZ0JSZ-ZV004p5EnH_aOnZ7XEo2rSOmbXJZJmwBA@mail.gmail.com>
 <CAJCQCtTOefBfRpfb0h1H6SQxzGd9j-7ZSM07iA37xhy3+Lm=fw@mail.gmail.com>
 <CAH=dxU61J94HCnr+UUokBsxqNMjKQBdz8xE2WNbWAHOtKP4w0w@mail.gmail.com>
 <2164b4b2-1447-3670-73ae-465404754b87@gmail.com>
 <CAJCQCtQk4tZ7hVD-1T+TiFKQ9uX5eyBJvwkJoZ+Sxpo=gq3tHQ@mail.gmail.com>
 <e590a036-f5ba-d8d5-7b7f-c14e15b0b5ee@gmail.com>
 <CAJCQCtRq783s=KgF6XPySva=OvhgLDfmsP_VFCtygmhe2Pr-tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="U3BNvdZEnlJXqmh+"
In-Reply-To: <CAJCQCtRq783s=KgF6XPySva=OvhgLDfmsP_VFCtygmhe2Pr-tg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--U3BNvdZEnlJXqmh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 08, 2017 at 10:17:28AM -0700, Chris Murphy wrote:
> On Wed, Nov 8, 2017 at 5:13 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
> >> It definitely does fix ups during normal operations. During reads, if
> >> there's a UNC or there's corruption detected, Btrfs gets the good
> >> copy, and does a (I think it's an overwrite, not COW) fixup. Fixups
> >> don't just happen with scrubbing. Even raid56 supports these kinds of
> >> passive fixups back to disk.
> >
> > I could have sworn it didn't rewrite the data on-disk during normal usage.
> > I mean, I know for certain that it will return the correct data to userspace
> > if at all possible, but I was under the impression it will just log the
> > error during normal operation.
> 
> No, everything except raid56 has had it since a long time, I can't
> even think how far back, maybe even before 3.0. Whereas raid56 got it
> in 4.12.

   Yes, I'm pretty sure it's been like that ever since I've been using
btrfs (somewhere around the early neolithic).

   Hugo.

-- 
Hugo Mills             | Turning, pages turning in the widening bath,
hugo@... carfax.org.uk | The spine cannot bear the humidity.
http://carfax.org.uk/  | Books fall apart; the binding cannot hold.
PGP: E2AB1DE4          | Page 129 is loosed upon the world.               Zarf

--U3BNvdZEnlJXqmh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaAz1JAAoJEFheFHXiqx3knPIP/iEErVuJYO72lPmAip6dafLN
ifUEhdJmaKGvDyjruoiQGeN7RGmcLjR12UsFgT1ldlCxEC8N5tG0axE8uQjOUUpz
GFs6kQiNjMp90A9+BSCNLuVqIAQlmcnBYfCYzdCOtLqbZfYSyuHly0tI34xiwCVT
l9w0cp922pAlHTYHejsm43KDcFia0Aupl1i93ML7dqjuoLnsx48MctkTaY1YmCvG
7lHWPV3MpZbQ86r3y2OJA4WtgcNZGAxLgrCJByin/jJ2II158E1u6vjHj0HB1l5c
4V95O4DUOUxmvC+viVrO11cmOYfVR2HOFgDpMffMfXe4aHh6ODK7wS0eAVfIY+F3
15oAahLncj4s55l1Lb2x5yVfp5tXaanfKXLcee4m1K2kfnA1KB5MJdLtYfLQhO3Y
LQudzNlBsxN/yUXrWxA7zJWhXST/IzZd73/8qTUpKX8i9os/1M73Hh9KYZU+1CEy
quumTKWyLKVqcwbGDv5jbG6GPC0g9tJu7okClsH5Zm/ehdeoyrdaG0NDF9zEDUjr
U+lxuntrZgA4QpBOnbj43eGItkI8h39sURQQxjVawezgdvCwelTbjHFnRZkRuEmB
PZM8bThYOeOF/SG15I4YCWRO0yBjBztFUsBM8dPo54bZFHHKL4/0q8HpMyarhawT
eurW0eUpgFCrjlLOXA5b
=iD2c
-----END PGP SIGNATURE-----

--U3BNvdZEnlJXqmh+--
