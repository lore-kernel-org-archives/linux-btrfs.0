Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gourmet.spamgourmet.com ([216.75.62.102]:41941 "EHLO
	gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758767AbbKSS4r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 13:56:47 -0500
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <linux-btrfs.tebulin@xoxy.net>)
	id 1ZzUNz-0004lA-Dx
	for linux-btrfs@vger.kernel.org; Thu, 19 Nov 2015 18:56:47 +0000
Date: Thu, 19 Nov 2015 18:56:45 +0000
From: linux-btrfs.tebulin@xoxy.net
To: linux-btrfs@vger.kernel.org
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Message-ID: <20151119185645.GF24333@carfax.org.uk>
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk>
 <564E085C.3060208@gmail.com>
 <20151119182850.GE24333@carfax.org.uk>
 <564E18B9.2020509@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ze9Y2znYQNnn3X7a"
In-Reply-To: <564E18B9.2020509@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ze9Y2znYQNnn3X7a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 19, 2015 at 07:45:13PM +0100, Ben Tebulin wrote:
> 
> >    It's just freed up lots of space. You'll probably find that your
> > "total" value for data in btrfs fi df is close to (but not exactly) 66
> > GiB now, if you've just run a full unfiltered balance. (The difference
> > being made up of metadata).
> 
> I think i need to dive more into the details of btrfs to finally grasp
> the details here
> 
> >    There's a repo of "useful btrfs scripts" that David Sterba looks
> > after. 
> 
> Great pointer!
> I think you refer to https://github.com/kdave/btrfsmaintenance and it
> indeed looks very promising.
> 
> >> Should I pick "btrfs show" in favor to "btrfs fi df" to learn about an impending "disk full" situation?  
> >    In the general case, you need both of them to make sense of it. 
> 
> Duh.... I'll better... ehh... try to find some backported btrfs-profs
> supporting `usage`.

   It's not massively more helpful -- you still need to understand the
relationships. It just uses slightly different language, and puts all
the information in one output instead of two.

   You start with a load of unused space -- that's the "total" for
each device in btrfs fi show. That space is allocated to specific
usages as the FS needs it. The allocated space is the "used" in btrfs
fi show for each device.

   Then we switch to looking at btrfs fi df. The "total" values are
the amount of the *allocated* space given to each type of storage.
Within those, actual stuff is stored (like your files), which is the
"used" value for each kind of storage.

   If you've ever played SimCity, the allocation process is like
zoning -- you say what kind of thing can go on the space, but it's not
actually used until something gets built on it.

   The problem you hit is when everything has been allocated, and
there's a need for more metadata space (usually), and there's lots of
unused data space. The balance operation moves some things around so
that some of the unused data allocation can be freed up, giving the FS
the ability to allocate more metadata space.

   Hugo.

> >> Will newer kernels do the balance on their own? 
> >    I think it's on the "projects" list on the wiki [..]  aware of anyone working on it.
> 
> Ok - which is another +1 for looking at David 's repo.
> 
> Thanks!
> - Ben

-- 
Hugo Mills             | 2 + 2 = 5, for sufficiently large values of 2.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ze9Y2znYQNnn3X7a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWThttAAoJEFheFHXiqx3kmIAP+wWnxMn4cCdDASGNISbUmD79
dMMovTdZo5y64Z2JmxbPWFLpMwGOayTRIH9aaDeBUGE6sh5aVgAk5IfJuHGLhFIM
B1acoTAtKReMNf0Z5mtkfMQm5CkFZ3XptqQyWSfb/5tk9/6nStxHOiQSBUzXP1R1
qrG5q7MhMflOJSFpOPQnMGFo+DZAxT6bhivvGzbOCyIYahyo638nRDg4Pj7Ja6gQ
Flj9LiZTypJAoOVOqpwIqUoHAEyLqiI1QYLrFP8mqeZ4Ou2zYWNfPin9Urqs9z40
1RZv4tYDTLNzSqyZJgvVh7iCvZCOno4qOptduJj+VDz8l/zSo5/uTPGAZMKHUWOY
LdoNTd2kl0hI+cYOC7Ys+9Ss/gAyrzKu4Yr0I58KiAtRXU6XlCREJxRefsXxpuOr
9WA8qwOZrX9rahzMhdZ+HfUoq0wdEh4W8KjFHOGvnhqCPkPY5cVwzuXz/UviHPbH
zxbXSQ7Cn4xDLyROXhH2EXzzNL7es4VghILV85mgS7k0ISlE5KOJCIFA+Pj8Weyb
K4fXt6ML32gvO3JJfMKlaIvfi8OVHbH0sOlipfLLQjh/UZF5fpaJxRXrPOnAgCfw
lkhcM+8GX7CZ2xm5X4TFMb3Q0Hp7DHDI8l+6qGfWUilBaC+iPqLQ8DsGq25g7YQU
SlFzxaP7fg2VSANqxJh3
=YJtc
-----END PGP SIGNATURE-----

--ze9Y2znYQNnn3X7a--

