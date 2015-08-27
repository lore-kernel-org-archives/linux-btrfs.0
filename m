Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34392 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbbH0Ss3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 14:48:29 -0400
Date: Thu, 27 Aug 2015 18:48:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: carlo von lynX <lynX@time.to.get.psyced.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Impossible to mount two different copies of the same btrfs
Message-ID: <20150827184828.GM23769@carfax.org.uk>
References: <20150827173229.GA30068@lo.psyced.org>
 <CAJCQCtQx+L1JauS=cC1crPQDpOO+t5SqHAg8Z8Q6K5KPKPW6TQ@mail.gmail.com>
 <20150827175947.GL23769@carfax.org.uk>
 <20150827184415.GA31439@lo.psyced.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zHDeOHGDnzKksZSU"
In-Reply-To: <20150827184415.GA31439@lo.psyced.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zHDeOHGDnzKksZSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2015 at 08:44:15PM +0200, carlo von lynX wrote:
> Thanks for the feedback. I thought I had bumped into a totally excentric
> use case but really I am making a most average beginner's mistake. I
> should have noticed when my thinking was in terms of rsync. btrfs-tune
> would be the hack I first thought of, but I realize that is the wimp's
> way to go.
> 
> So now I'm trying it the btrfs way. I made a fresh snapshot of the
> current state, created a send file (one gig! ;)) from the previous
> snapshot. Then I unmounted the source fs and mounted the dest copy.
> Unfortunately I cannot 'btrfs receive' since I didn't have read-only
> snapshots and making them from existing ones does not yield the same
> parent ids.
> 
> Looks like I have to format a new target btrfs and start anew with
> a full snapshot send... then at least I get to use a pipe instead of
> storing the send on disk.  ;)

   You need one full send to start off the process. After that, you
can use the incremental feature.

> On Thu, Aug 27, 2015 at 05:59:47PM +0000, Hugo Mills wrote:
> >    See my other email in this thread. :)
> 
> Didn't get that. Should I?

   Yes, you should have got it. You were cc'd. It's the one that
starts "Thanks for the thought."

   Hugo.

-- 
Hugo Mills             | "What's so bad about being drunk?"
hugo@... carfax.org.uk | "You ask a glass of water"
http://carfax.org.uk/  |                                         Arthur & Ford
PGP: E2AB1DE4          |                 The Hitch-Hiker's Guide to the Galaxy

--zHDeOHGDnzKksZSU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV31t8AAoJEFheFHXiqx3kXZEP+gLmTuXnyjEy6CIOsugrNp2/
KwQfRIdfV180qYxccuwLN1sIIf67hMmtJd4WK0W9c1bWKHB0secxSLO7fM5/FFuq
bTHtpinMZSaGVzbDoGSSYUhXO1PF+w4Y1pbwkTHfrAziMkCswXcdRO8IyMI6apYZ
+2ljdBb98Bjd2gO1f5mvy3VWTJv5+sUe2psHv8UOZROTTJkrgRG7urReACBCo3vf
bLCKAd4h/I+2KC4xTBPFlH15kPtST5s8CFdsQrNk1wYKHnN65pBu16nLljdZgYTn
1X+c9qtNruoGgtrHTvno/B5PDIxyzg7K/HXjkT3muNcvV7qv1UAhD0AQzRzzbhB7
vH5VIBHfsNVIO40mrtOcRnJS6RUN2nPOdl3IR4z5kwHrlDXSZxX/iju5c8wUCesW
dTQWLrsoCkse2ogfoBAX9JrAAm8KYtobSWVNFS6XZM/xKw9zldY4aSp4PJzUlnoT
rB5v94pr7UpWfysWU4RfAoamXPlT/hhDbboR4c0BUcEtUiqcubislc67X/ryYILz
4vjEKvHiTD1m+mTib30gzsh+vz3LSGcLENpCuGy6d/nY+GpTzTgTzh+xeTWlBzK8
MOUx46Gl6l3UCxDhCfKdYllNQHriQHy8SEh1bfQQL0UTfwwYlXJ1xOwUgHIqOD6c
4L7rGHFEZBonlzsLJOoT
=VhjY
-----END PGP SIGNATURE-----

--zHDeOHGDnzKksZSU--
