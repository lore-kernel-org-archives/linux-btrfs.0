Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48624 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3LLWU3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 17:20:29 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so1266183pde.28
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2013 14:20:28 -0800 (PST)
Content-Type: multipart/signed; boundary="Apple-Mail=_2497A949-F032-4168-AB30-39568BBCED2B"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH 3/4 v3] btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <297798211d549d0c0c32994fd0de0ab24c765e77.1386778303.git.dsterba@suse.cz>
Date: Thu, 12 Dec 2013 15:20:15 -0700
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Mark Fasheh <mfasheh@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
Message-Id: <3ED3160D-5290-4A40-88D2-4EA5C31F7A91@dilger.ca>
References: <cover.1386778302.git.dsterba@suse.cz> <297798211d549d0c0c32994fd0de0ab24c765e77.1386778303.git.dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_2497A949-F032-4168-AB30-39568BBCED2B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 12, 2013, at 8:26 AM, David Sterba <dsterba@suse.cz> wrote:
> Set the EXTENT_DATA_COMPRESSED flag together with EXTENT_ENCODED as
> defined by fiemap spec.
>=20
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> fs/btrfs/extent_io.c |    9 +++++++--
> 1 files changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5ea0ef5..8a28f15 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
>=20
> @@ -4220,9 +4222,12 @@ int extent_fiemap(struct inode *inode, struct =
fiemap_extent_info *fieinfo,
>=20
> 			if (ref_cnt > 1)
> 				flags |=3D FIEMAP_EXTENT_SHARED;
> +			em_phys_len =3D em->block_len;
> 		}
> -		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
> +		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
> 			flags |=3D FIEMAP_EXTENT_ENCODED;
> +			flags |=3D FIEMAP_EXTENT_DATA_COMPRESSED;

(minor nit) Could combine these (not sure it makes a difference to the =
compiler):

			flags |=3D (FIEMAP_EXTENT_ENCODED |
				  FIEMAP_EXTENT_DATA_COMPRESSED);

Cheers, Andreas






--Apple-Mail=_2497A949-F032-4168-AB30-39568BBCED2B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUqo2n3Kl2rkXzB/gAQIVgA/+I26/5L3HYKnvsV1htF1oY3eR7HWICQq9
VwPz7dvmb2lcPmL7vy4id/E/mT5A5zUJGh835HqpdR9i7o0AV6B38PCC9qXcEWpY
UOoC5E09cEPGUXhdXP9boOEanEfuPE3SJNDyiP0X4aXg/Kf7s2icHCW3Kgys7Mae
XVL1Cw/Y+1vNQhR6J94cjBgOeY9YbcnXI0KTYs+ap45OIvnO4qiUOhvasEjTeMaD
yiKCygxG4Mg7FYS7djHchB8bENtOpL4RSN9RqY+/g3AF+NIZjKwnzg7KqjZSaYXB
RJD3wGEPv/8dHD82Gz69BmNC+TS07bvloOzjBUyTBbwNQ1zERTk0J3Az3aAunzc5
kdxYhfHnSgj/OF19A5A5IHNU+8X4MdjtUZqDO421CEbN66jn73GvIwqKY0ZPw9Um
C9u6yhPpLCvFKjRtMqNV/i4jNf1+UY5fytZjQVnExefNkaRK88fGzV+nIbXsNNtB
R1tnDvPft8zv9BaqCFgWbRoDL+GOwRyl6JToBurhuQ89GMY599rIYjKL1ScJcPrU
ubB6hqZjPnpfsPf1l51a3isFAmFUms+nSgRYIKcvmjupFfo37Rj5CWdjFXDh/1AI
hL6EaFepeTJvHi9gGk003R2t3jKic1uP0jnMwzyWTzrziI8pEuRHokXlyVgzN9XV
560F03ZRIzE=
=fN5q
-----END PGP SIGNATURE-----

--Apple-Mail=_2497A949-F032-4168-AB30-39568BBCED2B--
