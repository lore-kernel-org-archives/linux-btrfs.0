Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40202 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750706AbaKYFN5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 00:13:57 -0500
Date: Tue, 25 Nov 2014 00:13:53 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <clm@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141125051353.GV17395@hungrycats.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <1416859665.3019.6@mail.thefacebook.com>
 <20141124205825.GX32735@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1PHmS26pdpOR3Xc0"
In-Reply-To: <20141124205825.GX32735@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1PHmS26pdpOR3Xc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 08:58:25PM +0000, Hugo Mills wrote:
> On Mon, Nov 24, 2014 at 03:07:45PM -0500, Chris Mason wrote:
> > On Mon, Nov 24, 2014 at 12:23 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > >This brings a strong-but-slow checksum algorithm, sha256.
> > >
> > >Actually btrfs used sha256 at the early time, but then moved to
> > >crc32c for
> > >performance purposes.
> > >
> > >As crc32c is sort of weak due to its hash collision issue, we need
> > >a stronger
> > >algorithm as an alternative.
> > >
> > >Users can choose sha256 from mkfs.btrfs via
> > >
> > >$ mkfs.btrfs -C 256 /device
> >=20
> > Agree with others about -C 256...-C sha256 is only three letters more ;)
> >=20
> > What's the target for this mode?  Are we trying to find evil people
> > scribbling on the drive, or are we trying to find bad hardware?
>=20
>    You're going to need a hell of a lot more infrastructure to deal
> with the first of those two cases. If someone can write arbitrary data
> to your storage without going through the filesystem, you've already
> lost the game.

If the filesystem can be arranged as a Merkle tree then you can store a
copy of the root SHA256 with a signature to detect arbitrary tampering.
Of course the magnitude of the "If" in that sentence is startlingly
large, especially if you are starting from where btrfs is now.  ;)

>    I don't know what the stats are like for random error detection
> (probably just what you'd expect in the naive case -- 1/2^n chance of
> failing to detect an error for an n-bit hash). More bits likely are
> better for that, but how much CPU time do you want to burn on it?

crc64 should be more than adequate for simple disk corruption errors.
crc32's error rate works out to one false positive per dozen megabytes
*of random errors*, and crc64 FP rate is a few billion times lower
(one FP per petabyte or so).  If you have the kind of storage subsystem
that corrupts a petabyte of data, it'd be amazing if you could get
anything out of your filesystem at all.

>    I could see this possibly being useful for having fewer false
> positives when using the inbuilt checksums for purposes of dedup.

Even then it's massive overkill.  A 16TB filesystem will average about
one hash collision from a good 64-bit hash.  Compared to a 256bit hash,
you'd be continuously maintaining a data structure on disk that is 96GB
larger than it has to be to save an average of *one* 4K read during a
full-filesystem dedup.

If your users are filling your disks with data blocks that all have
the same 64-bit hash (with any algorithm), SHA256 could be more
attractive...but you'd probably still be OK at half that size.

>    Hugo.
>=20
> --=20
> Hugo Mills             | That's not rain, that's a lake with slots in it
> hugo@... carfax.org.uk |
> http://carfax.org.uk/  |
> PGP: 65E74AC0          |



--1PHmS26pdpOR3Xc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR0EBAACgkQgfmLGlazG5xUJwCfSC2yuA+vbzBRrTqCxtvPezqT
oJwAnRYP7+LyKdMRngg49Aez+QT7KCsW
=GTZO
-----END PGP SIGNATURE-----

--1PHmS26pdpOR3Xc0--
