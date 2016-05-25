Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36592 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbcEYM2R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 08:28:17 -0400
Date: Wed, 25 May 2016 12:28:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-btrfs@vger.kernel.org
Subject: Re: Copy on write of unmodified data
Message-ID: <20160525122811.GL16712@carfax.org.uk>
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
 <f5b65a85-7d52-1aae-f976-f46179426b0a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KSn4sQg3MnruwCB4"
In-Reply-To: <f5b65a85-7d52-1aae-f976-f46179426b0a@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KSn4sQg3MnruwCB4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 25, 2016 at 07:45:23AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-05-25 04:58, H. Peter Anvin wrote:
> >Hi,
> >
> >I'm looking at using a btrfs with snapshots to implement a generational
> >backup capacity.  However, doing it the na=EFve way would have the side
> >effect that for a file that has been partially modified, after
> >snapshotting the file would be written with *mostly* the same data.  How
> >does btrfs' COW algorithm deal with that?  If necessary I might want to
> >write some smarter user space utilities for this.
> >
> I might be completely incorrect about this, but here's what I
> believe happens in this case:
> 1. If the file is small enough that it gets stored in-line in the
> metadata, you can't avoid COW for the whole file.
> 2. If the file is less than the block size (16k is the current
> default in mkfs.btrfs for reasonably sized filesystems), then you
> also can't avoid COW for the whole file.
> 3. If the file is larger than the block size, COW will only happen
> per-block, and extents will get split at block boundaries to
> minimize the amount of duplication.
>=20
> This of course requires that the updates are done by partial
> re-writes instead of a replace-by-rename semantic which is
> particularly popular among various software tools.

   The reason it's popular is that it can be made atomic -- either the
updates all make it to the named file, or they don't (obviously, only
if it's done in the right way, which many applications don't). If you
overwrite in place, then it can't be an atomic update.

   You could get both effects (minimal replacement and atomic update)
if you reflink copy the file, update in place on the copy, and then
replace it atomically, but that of course needs the tool to support it
and fall back to a sane default if reflinks aren't available.

   Hugo.

> FWIW, while I don't use BTRFS like this (I just use snapshots to get
> a consistent state to copy out for backups, usually doing the actual
> backup using SquashFS), one of my friends uses rsync together with
> BTRFS to do incremental backups of his personal systems.  He runs
> rsync with --in-place on the system being backed up to copy things
> out to a dedicated subvolume on his backup device, and then
> snapshots the subvolume after each backup (and uses a snapshot
> thinning system similar to that used by snapper).  While it's not
> quite as efficient as it could be, it's still works well.
>=20
> Alternatively, if you're backing up a BTRFS filesystem to another
> one, you can keep around the previous backup snapshot and do an
> incremental send against that, which will result in proper sharing
> of blocks.  I used to use this before I decided that I wanted better
> space efficiency for backups than BTRFS can currently offer.

--=20
Hugo Mills             | A diverse working environment: Di longer you vork
hugo@... carfax.org.uk | here, di verse it gets
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--KSn4sQg3MnruwCB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXRZpbAAoJEFheFHXiqx3kXaoP/1HIOij5MtHy8IIGqh8VJpTv
w1KSlEykCpwAucjq6O87tibFYb5Tpx1Y/f/3kbDKoWGpLH9OCtyeNH/xAiEv7PXZ
0YWykDvRfh4O7CjyjVkSkZgWL2czJ+1LQHdeIeFPUwCIVx8Zt/Y1dbcOuz/jARRe
jNDdI5tE5OaFO4TqnUXyPqa8HXdqo0RQBlfO2tqP4//ANlXklLXH4x86YilCCleP
ItaJb5dNfLc4PDy78UMAN/rGl2za5NNY5Owwt4c6lwgF07zng5nSkJpn3ShFBFUs
wJmq0i60s0CjTiyJAFPOCQoUeuw0ouvRFcti3UYyTkrz2fBWV/4owk95o9u3oDli
InEMQYSXn4+MaAusSZ68ffbSh2yqy8pTtVpapGmQeWkUxyTCivvogbJiD5finq5A
O2coqCzE41HNLi5dUSw5wE3GuZU+6Z6pNqcy6YIe4zr56kU7mpFVqOe6Dk76Bc2D
IZkYXC66KgrAL6Aqg9K/3Oj7ZCeGcEcXQAcX1F1IHnYQIOzVUaPR7rp+82DrKsTc
Qc+dEnqrjID/xVRU6zGsIhGrAA22bTu8rkK3C34EOsTu9vTdpH+sPE5KqZn6cz5C
idpR/qtBqxklP4zMpUz2THkmYmivaSlHDyzpjggvpJyPVDnwq2AxeGGCF5kFbuwB
M19AgiVrHZcVSSIW9wGc
=pWzr
-----END PGP SIGNATURE-----

--KSn4sQg3MnruwCB4--
