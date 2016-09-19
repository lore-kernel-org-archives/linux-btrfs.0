Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42954 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbcISS6C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 14:58:02 -0400
Date: Mon, 19 Sep 2016 14:57:33 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160919185733.GH21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160917065831.GA14388@google.com>
 <nriqf8$da6$2@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jHkwA2TBA/ec6v+"
In-Reply-To: <nriqf8$da6$2@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9jHkwA2TBA/ec6v+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 17, 2016 at 07:13:45AM +0000, Alex Elsayed wrote:
> IMO, this is already a flawed framing - in particular, if encrypting at=
=20
> the extent level, one _should not_ be encrypting (or authenticating)=20
> individual pages. The meaningful unit is the extent, and encrypting at=20
> page granularity puts you right back where dmcrypt is: dealing with fixed-
> size space, and needing to find somewhere else to put the auth tag.
>=20
> This is not a good place to be, and I strongly suspect it motivated=20
> choosing XTS in the first place - something I feel is an _error_ in the=
=20
> long run, and a dangerous one. (IMO, anything _but_ AEAD should be=20
> forbidden in FS-level encryption.)
>=20
> In a nonce-misuse-resistent AEAD, there _is_ no auth tag: There's some=20
> amount of inherent ciphertext expansion, and the ciphertext _cannot be=20
> decrypted at all_ unless all of it is present. In essence, a built-in all-
> or-nothing transform.
>=20
> You could, potentially, chop off part of that and store it elsewhere, but=
=20
> now you're dealing with significant added complexity, for absolutely zero=
=20
> gain.

That would be true if the problem were not already long solved in btrfs.
The 32-bit CRC tree stores 4 bytes per block separately and efficiently.
With minor changes it can store a 32-byte HMAC for each block.

> If you're _not_ using a nonce-misuse-resistant AEAD, it's even worse:=20
> keeping the tag out-of-band makes it far too easy to fail to verify it,=
=20
> or verify it only after decrypting the ciphertext to plaintext. Bluntly:=
=20
> that is an immediate security vulnerability.
>=20
> tl;dr: Don't encrypt pages, encrypt extents. They grow a little for the=
=20
> auth tag, and that's fine.
>=20
> Btrfs already handles needing to read the full extent in order to get a=
=20
> page out of it with compression, anyway.

It does, but compressed extents are limited to 128K.  Uncompressed extents
come in sizes up to 128M, far too large to read in their entirety for
many applications.


--9jHkwA2TBA/ec6v+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgNR0ACgkQgfmLGlazG5w60QCfWDNZmLstTX9my7Iof2SL6ign
kSEAn02fy9+WXKaNHZbfBNrYFwKkd8kc
=cwDE
-----END PGP SIGNATURE-----

--9jHkwA2TBA/ec6v+--
