Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55717 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdFTPP2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 11:15:28 -0400
Date: Tue, 20 Jun 2017 15:15:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alexander Peganz <a.peganz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: does using different uid/gid/forceuid/... mount options for
 different subvolumes work / does fuse.bindfs play nice with btrfs?
Message-ID: <20170620151526.GC7140@carfax.org.uk>
References: <CADtmLM_wcKDix3RJz3m0_=YiZ=kFtvvT8p359PNq30BusPdHFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
In-Reply-To: <CADtmLM_wcKDix3RJz3m0_=YiZ=kFtvvT8p359PNq30BusPdHFA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 20, 2017 at 04:35:48PM +0200, Alexander Peganz wrote:
> Hello everyone,
> 
> I intend to provide different "views" of the data stored on btrfs subvolumes.
> e.g. mount a subvolume in location A rw; and ro in location B while
> also overwriting uids, gids, and permissions.
> In the past I have been using fuse.bindfs for this. Now I'm trying to
> find out if there is a 'native' way to do this in btrfs, and if it
> works by design or by accident (I wouldn't want to rely on something
> that might go away in a newer kernel version).
> 
> So here goes:
> Do different uid/gid/... mount options for different subvolumes work?

   No. uid= and gid= mount options don't work at all for btrfs (or on
most other filesystems with their own concept of file ownership). You
can't arbitrarily change the ownership of files like this -- except
for filesystems like FAT, which don't have the concept at all.

> Or does the first mounted subvolume "win"?

   See above. The options don't do anything.

> Can a subvolume be mounted more than once (I guess not, but btrfs
> might surprise me)?

   Yes.

> Is there some completely different way I don't know about to do this
> in btrfs that might not even have anything to do with mount options?

   If you want to do it, it'll _have_ to be done without mount
options, because the options you're proposing to use don't work.

   As far as I know, there's no mount option for this in btrfs (or any
other POSIX filesystem), and there are no plans to implement such a
feature.

> If there is no magical btrfs way, does fuse.bindfs play nice with
> btrfs or should I be worried?

   We haven't had any complaints about it that I'm aware of.

   Hugo.

-- 
Hugo Mills             | I believe that it's closely correlated with the
hugo@... carfax.org.uk | aeroswine coefficient
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Adrian Bridgett

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZSTwOAAoJEFheFHXiqx3k964P+gKJSrWbuiyxURrFtIvpBBLj
Yf8U4sieO3OVyPjk5zFbGIHX2ar48TJbedT8EFBom0jUCojp28ZSppNPK9biW7bP
17gI7BV0LPLkH4XjVtWkRBpuuEwILOiQP1c304RkS9ZuKeKaQacHCYQDW0dHl2Ym
7s/9HUASNvrOdfPaYSwjdRfgA4h+ga9np2P8Fjunmm9wb7m82YpO8ok93K0P1Er/
5Itpo6d7FSkKwts++n2w8s7p9E/bWP4fcMvvZHh5UZwXLwpoUv1/varU2Zlzeeb6
1mBgBfzv3fEdd4RNNZU3Y8/01nqAD9ZfAs8JxhZA9PgGvxoEF1/Mh7LMirElFIHJ
SOVFZRNh3GkXciR0/66hZu4brf0ZxpqGYq0+TL29ayzRi3/lEbe4KIPl1t837zdf
CuXLZxCnUjkoQFpi2IL+2escEodWeb15iGIznocTX+tsx5WL2vKuuUCzluj2fPjZ
hq9pvYttHlYzsWeMb4EuZBGkA7Ant9FhHE2/mlhCp5i3RzwBpH/+wRm0hetpQEIz
zEUCwi0nZX7pnSXucUcyCLrKjmB1vdCHYHZS7wbVI0sXyBwqnIGTaapEWGLOGsaM
0WFlIgf9yWqaS066wer5TXyj6oNLUyHKd6XIktuxD2fGTATmozouKXKgVumGOalI
NIfpbJ6UhE5laL7YwH1b
=YdNP
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
