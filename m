Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42306 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752215AbbAHSgW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 13:36:22 -0500
Date: Thu, 8 Jan 2015 13:36:21 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Message-ID: <20150108183620.GA12857@hungrycats.org>
References: <20150107174315.GA21865@gardel-login>
 <20150108155610.GA12859@hungrycats.org>
 <20150108165321.GA23339@gardel-login>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
In-Reply-To: <20150108165321.GA23339@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 05:53:21PM +0100, Lennart Poettering wrote:
> On Thu, 08.01.15 10:56, Zygo Blaxell (ce3g8jdj@umail.furryterror.org) wro=
te:
>=20
> > On Wed, Jan 07, 2015 at 06:43:15PM +0100, Lennart Poettering wrote:
> > > Heya!
> > >=20
> > > Currently, systemd-journald's disk access patterns (appending to the
> > > end of files, then updating a few pointers in the front) result in
> > > awfully fragmented journal files on btrfs, which has a pretty
> > > negative effect on performance when accessing them.
> > >=20
> > > Now, to improve things a bit, I yesterday made a change to journald,
> > > to issue the btrfs defrag ioctl when a journal file is rotated,
> > > i.e. when we know that no further writes will be ever done on the
> > > file.=20
> > >=20
> > > However, I wonder now if I should go one step further even, and use
> > > the equivalent of "chattr -C" (i.e. nocow) on all journal files. I am
> > > wondering what price I would precisely have to pay for
> > > that. Judging by this earlier thread:
> > >=20
> > >         http://www.spinics.net/lists/linux-btrfs/msg33134.html
> > >=20
> > > it's mostly about data integrity, which is something I can live with,
> > > given the conservative write patterns of journald, and the fact that
> > > we do our own checksumming and careful data validation. I mean, if
> > > btrfs in this mode provides no worse data integrity semantics than
> > > ext4 I am fully fine with losing this feature for these files.
> >=20
> > This sounds to me like a job for fallocate with FALLOC_FL_KEEP_SIZE.
>=20
> We already use fallocate(), but this is not enough on cow file
> systems. With fallocate() you can certainly improve fragmentation when
> appending things to a file. But on a COW file system this will help
> little if we change things in the beginning of the file, since COW
> means that it will then make a copy of those blocks and alter the
> copy, but leave the original version unmodified. And if we do that all
> the time the files get heavily fragmented, even though all the blocks
> we modify have been fallocate()d initially...

Hmmm...it seems the handwaving about tail-packing that I was previously
ignoring is important after all.

A few quick tests with filefrag show that btrfs isn't doing full
tail-packing, only small file allocation (i.e. files smaller than 4096
bytes get stored inline, and nothing else does, not even sparse files
with a single 1-byte extent at offset !=3D 0).  Thus the inline storage
avoids fragmentation only to the minimum extent possible.

Short appends to the end of the file effectively become modifications
of the last block of the file.  That triggers CoW on the append, and if
we're doing lots of tiny writes the file becomes extremely fragmented
(exactly the worst case of one fragment per block).  A mix of big and
small appends seems to use fallocated space for those writes that cover
complete blocks, which is arguably worse than not fallocating at all.

So fallocate will not help until btrfs learns to do tail-packing, or
some other way to avoid this problem.

> > This would work on ext4, xfs, and others, and provide the same benefit
> > (or even better) without filesystem-specific code.  journald would
> > preallocate a contiguous chunk past the end of the file for appends,
> > and
>=20
> That's precisely what we do. But journald's write pattern is not
> purely appending to files, it's "append something to the end, then
> link it up in the beginning". And for the "append" part we are
> fine with fallocate(). It's the "link up" part that completely fucks
> up fragmentation so far.

Wrong theory but same result.  The writes at the beginning just keep
replacing a single extent over and over, which has a worst-case effect
of adding a single fragment to the beginning of a file that would not
otherwise be fragmented.  The appends are causing fragmentation all
by themselves.  :-P

> Lennart
>=20
> --=20
> Lennart Poettering, Red Hat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSuziQACgkQgfmLGlazG5y0lwCgsvgQh/VYydW8TJU62MtZypUP
w7wAnjJz5lwb++yXX9dfOn3T7ldNZeIe
=wyp7
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
