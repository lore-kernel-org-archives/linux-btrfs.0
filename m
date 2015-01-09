Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41989 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754989AbbAIQPB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 11:15:01 -0500
Date: Fri, 9 Jan 2015 11:14:59 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, Lennart Poettering <lennart@poettering.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Message-ID: <20150109161457.GB12857@hungrycats.org>
References: <20150107174315.GA21865@gardel-login>
 <20150108155610.GA12859@hungrycats.org>
 <20150108165321.GA23339@gardel-login>
 <20150108183620.GA12857@hungrycats.org>
 <20150109154103.GA3685@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
In-Reply-To: <20150109154103.GA3685@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 04:41:03PM +0100, David Sterba wrote:
> On Thu, Jan 08, 2015 at 01:36:21PM -0500, Zygo Blaxell wrote:
> > Hmmm...it seems the handwaving about tail-packing that I was previously
> > ignoring is important after all.
> >=20
> > A few quick tests with filefrag show that btrfs isn't doing full
> > tail-packing, only small file allocation (i.e. files smaller than 4096
> > bytes get stored inline, and nothing else does, not even sparse files
> > with a single 1-byte extent at offset !=3D 0).  Thus the inline storage
> > avoids fragmentation only to the minimum extent possible.
>=20
> That's right, btrfs does not do the reiserfs-style tail packing, and
> IMHO will never do that. This brings a lot of code complexity than it's
> worth in the end.

If the file has been fallocated past EOF, it may make sense to do the
extra work of maintaining a tail fragment in metadata until it's bigger
than a block, and therefore large enough to write to the fallocated
extent.  At least in that case the application has explicitly asked
the filesystem for more optimization than in the general append case.
Otherwise, what are fallocations past EOF for?

If the application appends 4K blocks all the time everything is fine,
but that requirement might not work for journald, and doesn't work for
rsyslog, mboxes, and many other long-running small-write use cases
that append in non-block-sized units.

On the other hand...it could be easier to handle such cases with a special
case of autodefrag--one that focuses on appends, so it can be enabled
by default earlier than the other problematic autodefrag use cases.
It may even be faster to defragment in small batches (coalescing a few
hundred blocks at a time near the end of file) than to do tail-packing
on every append, especially if metadata blocks have much more overhead
than data blocks (e.g. dup metadata with single data on spinning rust).
The fallocate would be wasted in this case, but the number of fragments
in the final file would be reasonably sane.

> > > > This would work on ext4, xfs, and others, and provide the same bene=
fit
> > > > (or even better) without filesystem-specific code.  journald would
> > > > preallocate a contiguous chunk past the end of the file for appends,
> > > > and
> > >=20
> > > That's precisely what we do. But journald's write pattern is not
> > > purely appending to files, it's "append something to the end, then
> > > link it up in the beginning". And for the "append" part we are
> > > fine with fallocate(). It's the "link up" part that completely fucks
> > > up fragmentation so far.
> >=20
> > Wrong theory but same result.  The writes at the beginning just keep
> > replacing a single extent over and over, which has a worst-case effect
> > of adding a single fragment to the beginning of a file that would not
> > otherwise be fragmented.  The appends are causing fragmentation all
> > by themselves.  :-P
>=20
> OTOH, the appending write and the header rewrite happen at roughly same
> time so the actual block allocations may end up close to each other as
> well. But yes, one cannot rely on that.

The header rewrite is close to the last append, but that's not really
useful.  There will be one header near one appending write, but there are
also thousands of other appending writes separated in time and space on
the disk, even after fallocate preallocated contiguous space for the file.


--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSv/oEACgkQgfmLGlazG5xqgACdH0hkfDo4CC/PgHppIgoxJ+k0
GXAAn1X5Rmpvrk1vslTomwF+M7iSqSHZ
=mH8t
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
