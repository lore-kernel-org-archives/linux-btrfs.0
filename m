Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34100 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752978AbbAGVlh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Jan 2015 16:41:37 -0500
Date: Wed, 7 Jan 2015 16:41:36 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (no
 complete lockups, "just" tasks stuck for some time)
Message-ID: <20150107214136.GD11632@hungrycats.org>
References: <3738341.y7uRQFcLJH@merkaba>
 <2191338.tRc7Jxvh05@merkaba>
 <20150106200322.GA12706@hungrycats.org>
 <1499386.KVI6lPzt8j@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
In-Reply-To: <1499386.KVI6lPzt8j@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 08:08:50PM +0100, Martin Steigerwald wrote:
> Am Dienstag, 6. Januar 2015, 15:03:23 schrieb Zygo Blaxell:
> > ext3 has a related problem when it's nearly full:  it will try to search
> > gigabytes of block allocation bitmaps searching for a free block, which
> > can result in a single 'mkdir' call spending 45 minutes reading a large
> > slow 99.5% full filesystem.
>=20
> Ok, thats for bitmap access. Ext4 uses extens.=20

=2E..and the problem doesn't happen to the same degree on ext4 as it did
on ext3.

> > So far I've found that problems start when space drops below 1GB free
> > (although it can go as low as 400MB) and problems stop when space gets
> > above 1GB free, even without resizing or balancing the filesystem.
> > I've adjusted free space monitoring thresholds accordingly for now,
> > and it seems to be keeping things working so far.
>=20
> Just to see whether we are on the same terms: You talk about space that B=
TRFS=20
> has not yet reserved for chunks, i.e. the difference between size and use=
d in=20
> btrfs fi sh, right?

The number I look at for this issue is statvfs() f_bavail (i.e. the
"Available" column of /bin/df).

Before the empty-chunk-deallocation code, most of my filesystems would
quickly reach a steady state where all space is allocated to chunks,
and they stay that way unless I have to downsize them.

Now there is free (non-chunk) space on most of my filesystems.  I'll try
monitoring btrfs fi df and btrfs fi show under the failing conditions
and see if there are interesting correlations.


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlStqBAACgkQgfmLGlazG5yYMQCg46gSTXtsH1dm1YhrSUAUeWQH
G7oAoJMq3UCyw77900VwRsFlrBNs9QeN
=BUtQ
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
