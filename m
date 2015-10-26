Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35566 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbbJZJY7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 05:24:59 -0400
Date: Mon, 26 Oct 2015 09:24:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recover btrfs volume which can only be mounded in read-only mode
Message-ID: <20151026092457.GA11331@carfax.org.uk>
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
 <561E6969.40500@oracle.com>
 <561EBAB1.6030600@gmail.com>
 <pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net>
 <CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com>
 <pan$e78b7$efe06fb0$f477bf4e$85f224c0@cox.net>
 <562369E8.60709@gmail.com>
 <pan$5181$c6023994$2cb7128f$59b43d97@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
In-Reply-To: <pan$5181$c6023994$2cb7128f$59b43d97@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 26, 2015 at 09:14:00AM +0000, Duncan wrote:
> Dmitry Katsubo posted on Sun, 18 Oct 2015 11:44:08 +0200 as excerpted:
> 
> >> Meanwhile, the present btrfs raid1 read-scheduler is both pretty simple
> >> to code up and pretty simple to arrange tests for that run either one
> >> side or the other, but not both, or that are well balanced to both.
> >> However, it's pretty poor in terms of ensuring optimized real-world
> >> deployment read-scheduling.
> >> 
> >> What it does is simply this.  Remember, btrfs raid1 is specifically two
> >> copies.  It chooses which copy of the two will be read very simply,
> >> based on the PID making the request.  Odd PIDs get assigned one copy,
> >> even PIDs the other.  As I said, simple to code, great for ensuring
> >> testing of one copy or the other or both, but not really optimized at
> >> all for real-world usage.
> >> 
> >> If your workload happens to be a bunch of all odd or all even PIDs,
> >> well, enjoy your testing-grade read-scheduler, bottlenecking everything
> >> reading one copy, while the other sits entirely idle.
> > 
> > I think PID-based solution is not the best one. Why not simply take a
> > random device? Then at least all drives in the volume are equally loaded
> > (in average).
> 
> Nobody argues that the even/odd-PID-based read-scheduling solution is 
> /optimal/, in a production sense at least.  But at the time and for the 
> purpose it was written it was pretty good, arguably reasonably close to 
> "best", because the implementation is at once simple and transparent for 
> debugging purposes, and real easy to test either one side or the other, 
> or both, and equally important, to duplicate the results of those tests, 
> by simply arranging for the testing to have either all even or all odd 
> PIDs, or both.  And for ordinary use, it's good /enough/, as ordinarily, 
> PIDs will be evenly distributed even/odd.
> 
> In that context, your random device read-scheduling algorithm would be 
> far worse, because while being reasonably simple, it's anything *but* 
> easy to ensure reads go to only one side or equally to both, or for that 
> matter, to duplicate the tests, because randomization, by definition 
> does /not/ lend itself to duplication.

   For what it's worth, David tried implementing round-robin (IIRC)
some time ago, and found that it performed *worse* than the pid-based
system. (It may have been random, but memory says it was round-robin).

   Hugo.

-- 
Hugo Mills             | Great films about cricket: The Umpire Strikes Back
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWLfFpAAoJEFheFHXiqx3kHnMP/3Oi+chybcLdm4rYgLme+bHL
sLce7UscLND13+T0p1vUn2u0yR3rs1Y1L3Ke++o0LB+1dYn86M/Kb3jXX2/Bu5h3
+vVqvc0/cb1OTH+GD0z7MO/UBjHVN2sSlDpgIvTTqcZH/mvGtd1xfbsIcf9zGcpA
jSiay3qcSiksQwTXHDpn6qm3ejnM/bswvKY3aHwaH9ugauxNIJLUfJKVYC5wAE0D
hTD3q11bWfkw+YJMjRIhBk6yTwKJ1AvpTxcOeWIflLXFZpsaozd5g3mE5qMTA8Zt
RgLj+tpKsyiO0WgYLfGpEW95YihqPfp6Ku8l6N6wyAmU2jZmaij8zQl/T5T5rLdo
gDodGd4djfz9lepLAnO72nxd078A9kQReHsZJbUe0kcUpgVFBpLXgUDtNS9tzc45
EMkweGI3rAyzQnLfxnSWc7nLiy5GvyT91Kkj5tYWnfo3JamL1iy5v94CQod88mF6
QfPImBlyJVLtqFSHWknF7+Jq1xV0dBePdM7wbt6OXd4zJOMkkcOiMMVdPgFmzCsa
wLIAshwd1x9YnAiB6maPDqxZqyT+o/7Syrrya1zVmL6DHQvvlQeagwKEKjMJZRP0
MkHNaH/xtoweeBqFJm+otK4hbl0btGCttQ3snV4T4z5JgsKU3fFSbfHt2AqMBIwT
YYt1HBOid6fBofNegF/V
=xdfR
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
