Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36181 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750936AbcE2A4l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 May 2016 20:56:41 -0400
Date: Sat, 28 May 2016 20:56:39 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Message-ID: <20160529005639.GA3576@hungrycats.org>
References: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
 <20160527000401.GW7633@wotan.suse.de>
 <20160528015922.GI15597@hungrycats.org>
 <20160529002103.GA31105@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
In-Reply-To: <20160529002103.GA31105@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 29, 2016 at 02:21:03AM +0200, Adam Borowski wrote:
> On Fri, May 27, 2016 at 09:59:22PM -0400, Zygo Blaxell wrote:
> > I wonder if there is a risk of damaging files like this:
> >=20
> > 	open A O_RDWR
> >=20
> > 	open B O_RDONLY
> >=20
> > 	copy B to A
> >=20
> > 	do _not_ call fsync() here
> >=20
> > 	dedup(A, B)
> >=20
> > 	do _not_ call fsync() here either
> >=20
> > 	some time passes
> >=20
> > 	power fail
> >=20
> > If A's extent isn't flushed to disk, what happens to B?  Does dedup imp=
ly
> > fsync or data ordering such that A is written to disk before the extent
> > ref in B is updated, or can the content of B change?  If root is running
> > dedup, we can assume that whoever authorized root code execution also m=
ade
> > sure that this case never arises (e.g. by ensuring the dedup agent alwa=
ys
> > calls fsync, or otherwise ensuring that the extent at A is stable on di=
sk
> > before calling dedup).  If we allow non-root to do this then we have no
> > such assurance--but on the other hand maybe the assurance is weak and
> > bad things can happen here already even if we require root privilege.
>=20
> I don't think this can happen on btrfs: the superblock is updated only af=
ter
> a barrier when both the data and extent refs are already on the disk.

If and only if the filesystem is mounted with the flushoncommit option,
that's true.  This is not the default, though, and I lost a fair amount
of time and data before I discovered this.

> > I also wonder what happens if an executable that has called
> > mlockall(MCL_FUTURE) gets its pages replaced by a deduped extent while
> > it's running...do the replaced pages become un-mlockall-ed?  Is the VFS
> > smart enough to swap in the new pages?  Am I just silly and insane for
> > expecting shared mmap() to have meaningful real-time properties on btrf=
s?
>=20
> mmap() has currently no relation to extents, even entirely identical files
> don't share any pages:
>=20
> dd if=3D/dev/urandom of=3Da bs=3D1048576 count=3D1024  # 1GB of junk
> cp --reflink a b
> time cat a >/dev/null  # all in page cache -- fast
> time cat b >/dev/null  # every extent is shared with a, but...

That's precisely my point.  If we've called mlockall(MCL_FUTURE), the
executable pages are locked into RAM.  If we then replace the underlying
physical pages, this would normally invalidate the page cache for the
replaced extent; however mlockall(MCL_FUTURE) and the exec() DENYWRITE
lock combined mean that such an invalidation should not be possible.
So what happens?

(now that I think of it, whatever happens would be the same thing that happ=
ens
during device delete or balance, so it's probably OK, maybe)

> In any case, this patch doesn't introduce any cases not already triggerab=
le
> by root.

It allows non-root to trigger cases that previously could only be
triggered by root.

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldKPkcACgkQgfmLGlazG5xS3ACgnt0ZZBgwsUhZ0A9dIBBZk+AW
QCAAoIZywtQsny+rb133kZrezjwmUJAq
=0aix
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
