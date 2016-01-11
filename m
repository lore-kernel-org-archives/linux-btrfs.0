Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57309 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978AbcAKJDX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 04:03:23 -0500
Date: Mon, 11 Jan 2016 09:03:18 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: "cheater00 ." <cheater00@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Message-ID: <20160111090318.GG6060@carfax.org.uk>
References: <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
In-Reply-To: <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
> On Sat, Jan 9, 2016 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
> >> OK. How do we track down that bug and get it fixed?
> >
> >    I have no idea. I'm not a btrfs dev, I'm afraid.
> >
> >    It's been around for a number of years. None of the devs has, I
> > think, had the time to look at it. When Josef was still (publicly)
> > active, he had it second on his list of bugs to look at for many
> > months -- but it always got trumped by some new bug that could cause
> > data loss.
> 
> 
> Interesting. I did not know of this bug. It's pretty rare.

   Not really. It shows up maybe on average once a week on IRC. It
gets reported much less on the mailing list.

   Hugo.

-- 
Hugo Mills             | What part of "gestalt" don't you understand?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWk2/WAAoJEFheFHXiqx3kMYEQALMfiOVv/Vi+oSRGZLEO+/Gd
wLl/habEbGXwYhys5xp9KUif0G/n/J4LjKrSpYTVCgtX51f1iyCtOdrYVIic+kkw
abgbMOtUZm5R23VUZkymYYM9d15fzrpBgc5o4askqLfvW03cQG+ipN5JVQPPmDz0
iHGITmxSxGAZ9xNXJDB8zKVT2voq+zXQ167eU5tq2bH7YP2VxrvxImkNiQoJhL+H
gJkjgUY9mWcDl3mhzzMZ0fZ1d5YmB3Fg3Pa1u2BblYg7s65+PNM+OgeVuVDsa8XT
mRl4mWAQWJi0GnSG0dku4aejkaBsJmkBnLyUIcqM6ANXwwqK0csPTpEjIujPtMwJ
9KUxPoaf+mtOH4m4MnoQBAv+m4ckOBNd0yHit2drFCa4KlCqbfuXTOEmVbA6fgtF
Xrf6KsWFlY3NVQMuglcxiKCwKdyw8XGjRQpkwiURpzW6hmbYrbLZrKhvwL8cOw3L
7nuZ7WdFeKIa9zU2OEHv5a1lbYVAk5QR0tITDEX1IjCjDuUHOGyFNNWX8lq0yFAn
c13ZZKNzvq43ZKSYeYfzaz/nzu2PEr4apNSrTHQUQWtNjyYTTyyzrIdL7Jd/vpl9
ZDdzZwRkfiBLvzQpq18cVKyG96F4mLILjV1NfKc/w9nP7SV8XeGkeYPuYKNU8Xvh
RB+i2SOsPRdANZHzWiB/
=99VV
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
