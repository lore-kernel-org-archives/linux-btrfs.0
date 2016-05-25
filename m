Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36348 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbcEYJaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 05:30:03 -0400
Date: Wed, 25 May 2016 09:29:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Copy on write of unmodified data
Message-ID: <20160525092958.GH16712@carfax.org.uk>
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JI+G0+mN8WmwPnOn"
In-Reply-To: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JI+G0+mN8WmwPnOn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 25, 2016 at 01:58:15AM -0700, H. Peter Anvin wrote:
> Hi,
>=20
> I'm looking at using a btrfs with snapshots to implement a generational
> backup capacity.  However, doing it the na=EFve way would have the side
> effect that for a file that has been partially modified, after
> snapshotting the file would be written with *mostly* the same data.  How
> does btrfs' COW algorithm deal with that?  If necessary I might want to
> write some smarter user space utilities for this.

   Sounds like it might be a job for one of the dedup tools
(deupremove, bedup), or, if you're writing your own, the safe
deduplication ioctl which underlies those tools.

   Hugo.

--=20
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Go=
ons

--JI+G0+mN8WmwPnOn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXRXCWAAoJEFheFHXiqx3kkDEP/iyG1+ETs5ySpX0gOI2jJt5v
bAVa3XQFJOaDlt0ov+pXkyRd2QGY7hW5dgi5AAcWk0Mw/66JrAQnzX+1Csq/Cmby
2OBCRRZzTeyWhMr2WGwig7nfqjFUAYlYN7xd7gA5Cs1zzJSdb8EdQ+WUnqaefmIT
fnK0+KjO8nOwMl0USkbBEskWqCbksZfGYrM4Nlr+ywd6RKSBjqF+p2P25scmybWR
TWPUOaQePz2wqXRbXp4NfMvLptVeDtTbSFQHKZhVecbk6HctWTKc2abUtsDI2I68
RIcNkofy57pW1k+87tMMGyZOjiY5i/9bph3HEiAY7UWwrfh/PlwYSjpEjgWPp7NK
3Xl/rmURE3Hq2XqCju7X9nWSxcW4k9C+x/N8yRBqZNvnQJw96OddzCehDqwvytif
xdyd3zbCd2EZXCmYKCpTts6EEVtexRtesSTsFli5qb6o67gSxDebIwQ0n7O5OhIy
pxseJDoj9gZOjobogqf0BuyvN6i+AHVq+pm2envd4lrUoAduGd1a6BI2RHbQ2Zze
lWHYMGvO/ShJsiev+R8RDpUeKpnghQIsW/W4XQSNJxP7iKpsk32Pts3dSfWDbHpi
PU8nuOICgxZ01nK5klsH8FI3oi8R2uwPgSZ4OS86HI1cTzAqXYeY8yUo8L0kblss
BfaiiVJ1jzN8v7mf433/
=Fnd1
-----END PGP SIGNATURE-----

--JI+G0+mN8WmwPnOn--
