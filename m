Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36313 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3BUUqO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 15:46:14 -0500
Date: Thu, 21 Feb 2013 20:46:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
Message-ID: <20130221204610.GG14283@carfax.org.uk>
References: <51264146.3070504@petaramesh.org>
 <1361462073.18057.23.camel@cwalton-XPS-8300>
 <512644DA.3050409@petaramesh.org>
 <20130221163844.GD14283@carfax.org.uk>
 <51265355.1020409@petaramesh.org>
 <20130221172502.GF14283@carfax.org.uk>
 <51265DB0.2060407@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
In-Reply-To: <51265DB0.2060407@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2013 at 06:47:28PM +0100, Sw=C3=A2mi Petaramesh wrote:
> Le 21/02/2013 18:25, Hugo Mills a =C3=A9crit :
> > Correct. But btrfs isn't at that stage yet. It's getting visibly
> > closer, but it's not quite there. Hence the very strong recommendation
> > to keep up with the latest code. Hugo.=20
>=20
> The matter is that BTRFS had many early adopters just because it is -
> and has been for long now - in the mainline Linux kernel, so supposed
> stable and good choice for the future.

   I'm afraid that's not actually a valid conclusion. Just because
something makes it into the mainline kernel, it doesn't mean that it's
considered stable -- just that any instabilities aren't going to
affect the rest of the kernel.

> To be honest (and not wanting to troll, promised) this is the only
> single reason for which I use BTRFS on 5 of my 6 machines at home - just
> because I thought that "Just upgrade the distro every 6 months and it
> will become better and better over time, no hassle, make my life easy".

   That approach means you're still somewhere between 1 and 3 kernel
versions out of date, on something which is still undergoing
significant changes on most kernel releases.

> OTOH my 6th machine runs native ZFS on Linux, and I have to tell that it
> shows orders of magnitude better performance and never gave me a single
> problem in several (3 ?) years. Only upgrading the distro is always a
> big frightening and problematic. And initial installation was a bit trick=
y.

   ZFS has had something like an extra 5 years of development on it,
so it's not surprising that it's more stable.

> Probably a lot of BTRS early adopters choosed it for the same reason why
> I did : Included in the standard kernel, easy to install, and *expected*
> to improve quickly

   But you don't get the improvements if you don't get the kernels...

> - yes, I already made the move back and forth twice,
> between ext4 and BTRFS, on 2 machines... About one year ago I choosed to
> jump "for good" and stay, but performance degrades so quickly and so
> much that every couple of days I wonder if I won't rollback to ex4 again
> (and again), or shift to ZFS once for all and just forget about it...

   Performance was greatly improved in 3.7. You may also find
performance problems with a very full filesystem, or with workloads
which write heavily to one file (databases, and bitcoin's DB in
particular). The latter issue can largely be dealt with by judicious
use of nocow attributes. Plus go for 3.7 or later anyway.

> Everytime I show my Linux machines to friends and say : =E2=80=9CHey, I g=
ot the
> most advanced filesystem on earth !=E2=80=9D I soon get the answer =E2=80=
=9COh boy,
> that's the slowest machine boot and FS I've ever seen since I was
> reading floppy disks on my 386SX in 1991 ! Can you really live with this =
?=E2=80=9D
>=20
> So, for "not quite there" and the return codes "+20" that have been a
> minor pain in the arse for a couple years but the line is still in the
> code...

   There's been about one question (not even complaint) about that
return code every... maybe 3-6 months? It's not high on the list of
priorities of things to fix, compared to some of the other problems
that have shown up, or even the repeated questions (like
mis-interpretation of the output of df, btrfs fi df and btrfs fi
show).

>  I can understand developer's PoV, been there, done that, but
> still, BTRFS might in the end lose a numer of its early adopters if it
> keeps being "not quite there" too long.
>=20
> Shitfing to ZFS is just a PPA and 2 apt-get install commands away... It
> will definitely be easier than start playing with mainline PPA Ubuntu
> kernels...

   Well, given that btrfs is still getting at least one significant
fix to a major bug or set of fixes in every release, it would still
seem sensible to keep up with the latest developments. If that's not
what you expected, then I'm sorry if we've failed to get the point
across. We do try to manage expectations on the btrfs website, and
we're quite up-front about the need for keeping up with releases
there.

   If that's more than you want to do, that's OK -- I wouldn't expect
it to be something that everyone would want to do. Many people do keep
up with the kernels through the Ubuntu PPA (or other, similar
repositories for other distributions), and don't have problems. If it
doesn't work out for you, then parting company without rancour or
prejudice may be the best thing. Temporarily, I hope, of course.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I get nervous when I see words like 'mayhaps' in a novel, ---   =20
                because I fear that just round the corner               =20
                          is lurking 'forsooth'                         =20

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUBUSaHkr9z9OVl50rAAQIx2A/2NurV7nSc1DcA+HohnHUGW7wV8eRKG5vm
mQZZ7850NlTdU+sIIg31Pp4qbKEtOXsGBjnBxJoLpnoOoMzuFbtrTX7WggAohkCo
7Tq85Q1ptsq400fLhDZk5v3oCtckiYeQ/6saookek0Cc59D0W06FWc1YzkwueQ8/
WP9gEhw/pnv/899j+Gu+vIuVBq/R7CCaza2+L0/f40FXLaeRywPz0Tgzx11sgzW3
tUniO5UB+Xa66LR08ja82J+oLnNwpGwUngVUIOwPT/XdQGNtIHUX3hAbcdGDPXVt
QVBUW22k22kngWbPPenrfIQvBjWvXYmvHs5PLDR9BdSA3gdJukEjoQN3dRgHRT93
l+DZYhPnoA6KfLjC5SpBM0gzZNJtZCkv27FYVGF+C9lQXPnLkROujp/Wata/yQjg
6mPXrqk+jDF29qpwMmnLQMDy8lUmeSpaz4384oettHoUtNNU/52mjRN7fSplGVx5
So/Zdk4hhqabFwtnRebacMmoyVHWiyI8NpkZqW4M2H24ncFnxMr6fca3ZvpCQ+3Z
SmSy65ApCWSKIkjTBmFzSV68XShEaNxec7Aqmlh1pgmBCXrVQMxqkZxP+ZIil8eU
D9qfS0dT80wTCwvbE5Y0ckbhDznNgr6QyEueNUgc7ETyw11n5JxA/Y5JV3L5AU9T
6CwwkHzZJQ==
=6pG+
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
