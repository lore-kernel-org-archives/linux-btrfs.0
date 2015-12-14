Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60954 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbbLNIf3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 03:35:29 -0500
Date: Mon, 14 Dec 2015 08:35:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel lockup, might be helpful log.
Message-ID: <20151214083524.GD26782@carfax.org.uk>
References: <566DF757.8020807@birds-are-nice.me>
 <pan$42e96$8159f644$233ed3aa$27e4f2e6@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
In-Reply-To: <pan$42e96$8159f644$233ed3aa$27e4f2e6@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 14, 2015 at 06:51:41AM +0000, Duncan wrote:
> Birdsarenice posted on Sun, 13 Dec 2015 22:55:19 +0000 as excerpted:
> 
> > Meanwhile, I did get lucky: At one crash I happened to be logged in and
> > was able to hit dmesg seconds before it went completely. So what I have
> > here is information that looks like it'll help you track down a
> > rarely-encountered and hard-to-reproduce bug which can cause the system
> > to lock up completely in event of certain types of hard drive failure.
> > It might be nothing, but perhaps someone will find it of use - because
> > it'd be a tricky one to both reproduce and get a good error report if it
> > did occur.
> > 
> > I see an 'invalid opcode' error in here, that's pretty unusual
> 
> Disclaimer:  I'm a list regular and (small-scale) sysadmin, not a dev, 
> and most certainly not a btrfs dev.  Take what I saw with that in mind, 
> tho I've been active on-list for over a year and thus now have a 
> reasonable level of practical sysadmin configuration and crisis recovery 
> level btrfs experience.
> 
> You could well be quite correct with the unusual crash log and its value, 
> I'll leave that up to the devs to decide, but that "invalid opcode: 0000" 
> bit is in fact not at all unusual on btrfs.  Tho I can say it fooled me 
> originally as well, because it certainly /looks/ both suspicious and in 
> general unusual.
> 
> Based on how a dev explained it to me, I believe btrfs actually 
> deliberately uses opcode 0000 to trigger a semi-controlled crash in 
> instances where code that "should never happen" actually gets executed 
> for some reason, leaving the kernel is an unknown and thus not 
> trustworthy enough to reliably write to storage devices and do a 
> controlled shutdown.  That's of course why the tracebacks are there, to 
> help the devs figure out where it was and what triggered it, but the 0000 
> opcode itself is actually quite frequently found in these tracebacks, 
> because it's the method chosen to deliberately trigger them.

   It's not just btrfs. Invalid opcode is the way that the kernel's
BUG and BUG_ON macro is implemented.

   Hugo.

-- 
Hugo Mills             | Great oxymorons of the world, no. 10:
hugo@... carfax.org.uk | Business Ethics
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWbn9MAAoJEFheFHXiqx3kFqkP/0lRIWuQFfAU+CgxCKsuryjb
kcNfk3owKvAQvyZM//aQiFbPgAseQHMlirPjUsEO8pXx04Q38T9FFK0lXuRDTuVL
3XZ4FLHuu0RFej/pFlIY4oi8Nqj56gErI2vq4f/KoxhdyhlgwdPA2JskgFuxmwsp
dL6X1Z1dF0KoBLLBoqV15j8Y2zuLV5Mi9Xu/v9PkcpmotWs1TwONIxM43ocub8uV
I1oTE4c9uCVtzUGqXNjp06SGo5O4AOF7tfg07U4uYX7wO7nSAx8/udposmVGTHms
fs7lhlPeP2fmui2SbudmGqVmwqpy8HOv8mMM2KAMewfeA1uJq3OAL/4wKKHyH1lD
YNuoUqJ+Jx5FSWtngIoFjxmdDDK22twoSut3VMR9Y8x+2NchJ82RxScJDheMrY1J
9KtsL+YZwLphgFUhe7tI+ya8LSjRXigBjsfLeEWqg/lyNNkkg4vkzjOeA6yKzv+D
SF1ewmeNQZ7OcjXt7udmmFDnVvBxbwKiNBj46Cl51mEAqZJJYHntARSnkLEUNvd3
ErT+BneeLoaOrr4znW3h/c7oLH01avha8ZX6KpRm8wSp1I5DS/t9TschddCeLYm4
TwXhXh4dII19M8IAFUGLH2iccHkJB9BcrO6RQNbB2jNVBZLfa7wnCiSz4Lm1gzqs
jagpZI3xYf6k/2Ef3wOu
=kDwi
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
