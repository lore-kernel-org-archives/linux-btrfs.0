Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40036 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932333AbcISWMX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 18:12:23 -0400
Date: Mon, 19 Sep 2016 18:12:22 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160919221221.GI21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160917065831.GA14388@google.com>
 <nriqf8$da6$2@blaine.gmane.org>
 <20160919185733.GH21290@hungrycats.org>
 <nrpfhf$g72$1@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="o7gdRJTuwFmWapyH"
In-Reply-To: <nrpfhf$g72$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--o7gdRJTuwFmWapyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 07:50:07PM +0000, Alex Elsayed wrote:
> > That would be true if the problem were not already long solved in btrfs.
> > The 32-bit CRC tree stores 4 bytes per block separately and efficiently.
> > With minor changes it can store a 32-byte HMAC for each block.
>=20
> I disagree that this "solves" it - in particular, the fact that the fsck=
=20
> tool support dropping/regenerating the extent tree is wildly unsafe in=20
> the face of this.

Those fsck features should no longer work on the AEAD tree (or would
require the keys to work if there was enough filesystem left to salvage).

> For an AEAD that lacks nonce-misuse-resistance, it's "merely" downgrading=
=20
> security from AEAD to simple encryption (GCM, for instance, becomes=20
> exactly CTR). This would be almost okay (it's a fsck tool, after all),=20
> but the fact that it's a fsck tool makes the next part worse.
>=20
> In the case of nonce-misuse-resistant AEAD, it's much worse: Dropping the=
=20
> checksum tree would permanently and irrevocably corrupt every single=20
> extent, with no data recoverable at all. This is the _exact_ opposite of=
=20
> _anything_ you would _ever_ want a fsck tool to do.

So...don't put those features in fsck?

In my experience, if you're dropping the checksum or especially the
extent tree, your filesystem is already so badly damaged you might as
well mkfs+restore the filesystem.  It'll take longer to reverify the
data at the application level or compare with the last backup.

An AEAD tree would just be like that, except there's no point in even
offering the option.  It would just be "rebuilding the AEAD tree will
erase all your encrypted data, leaving only plaintext data on the
filesystem if you had any, are you very sure about this y/N"

> This is, fundamentally, the problem with treating an "auth tag" as a=20
> separate thing: It's only separate at all in weaker systems, and the act=
=20
> of separating the data induces incredibly nasty failure modes.
>=20
> It gets even worse if you consider _why_ that option exists for the fsck=
=20
> tool: Because of the possibility that the _structure_ of the checksum=20
> tree becomes corrupted. As a result, two bit-flips (one for each=20
> duplicate of the metadata) would be entirely capable of irrevocably=20
> destroying _all encrypted data on the FS_.

That event already destroys a btrfs filesystem, even without encryption.
btrfs already includes much of the verification process of a Merkle tree,
with weak checksums and no auth.  Currently, if you lose both copies of an
interior tree node, it is only possible to recover the filesystem offline
by brute-force search of the metadata.  It's one of the reasons why it's
so important to have duplicate metadata even on a single disk.

The only difference with encryption is that recovery would be
theoretically impossible instead of just practically infeasible.

> Separating the "auth tag" - simply considering an "auth tag" a separate=
=20
> thing from the overall ciphertext - is a dangerous thing to do.
>=20
> >> If you're _not_ using a nonce-misuse-resistant AEAD, it's even worse:
> >> keeping the tag out-of-band makes it far too easy to fail to verify it,
> >> or verify it only after decrypting the ciphertext to plaintext.
> >> Bluntly: that is an immediate security vulnerability.
> >>=20
> >> tl;dr: Don't encrypt pages, encrypt extents. They grow a little for the
> >> auth tag, and that's fine.
> >>=20
> >> Btrfs already handles needing to read the full extent in order to get a
> >> page out of it with compression, anyway.
> >=20
> > It does, but compressed extents are limited to 128K.  Uncompressed
> > extents come in sizes up to 128M, far too large to read in their
> > entirety for many applications.
>=20
> Er, yes, and? Just as compressed extents have a different cap for reasons=
=20
> of practicality, so too can encrypted extents.

=2E..which very inefficient space usage for short extents.

--o7gdRJTuwFmWapyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgYsUACgkQgfmLGlazG5xDpACgi0e49WPzEiO23fUNHjLKuBrr
INkAnArBC7EVVDVlLyCT688H+L9Sws5l
=8tCB
-----END PGP SIGNATURE-----

--o7gdRJTuwFmWapyH--
