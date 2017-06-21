Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41255 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751875AbdFUUOu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 16:14:50 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4A964AB43
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 20:14:49 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
To: linux-btrfs@vger.kernel.org
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
Date: Wed, 21 Jun 2017 16:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <1497455067-6050-1-git-send-email-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CVnXBW4h2fhwOuA1oVxEMPlckGmW1uJuN"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CVnXBW4h2fhwOuA1oVxEMPlckGmW1uJuN
Content-Type: multipart/mixed; boundary="FLNTnh79bbvdT4f03cNi03ILwflr6r0Rq";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
In-Reply-To: <1497455067-6050-1-git-send-email-jeffm@suse.com>

--FLNTnh79bbvdT4f03cNi03ILwflr6r0Rq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/14/17 11:44 AM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> In a heavy write scenario, we can end up with a large number of pinned
> bytes.  This can translate into (very) premature ENOSPC because pinned
> bytes must be accounted for when allowing a reservation but aren't
> accounted for when deciding whether to create a new chunk.
>=20
> This patch adds the accounting to should_alloc_chunk so that we can
> create the chunk.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index cb0b924..d027807 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4389,7 +4389,7 @@ static int should_alloc_chunk(struct btrfs_fs_inf=
o *fs_info,
>  {
>  	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rsv;
>  	u64 num_bytes =3D sinfo->total_bytes - sinfo->bytes_readonly;
> -	u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserved;
> +	u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserved + sin=
fo->bytes_pinned + sinfo->bytes_may_use;
>  	u64 thresh;
> =20
>  	if (force =3D=3D CHUNK_ALLOC_FORCE)
>=20


Ignore this patch.  It certainly allocates chunks more aggressively, but
it means we end up with a ton of metadata chunks even when we don't have
much metadata.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--FLNTnh79bbvdT4f03cNi03ILwflr6r0Rq--

--CVnXBW4h2fhwOuA1oVxEMPlckGmW1uJuN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWUrTtx57S2MheeWyAQhTig//fApUsePnoy0pGXPEpYhjQQjwPh2hcVEn
C1rH6uA33wjiq5q9iQ/6gno+FizFDboMB/xTzmpGg8ByBgRw0g2t/QINLRQsePos
2rew9sZqHCT3cw7Aj+HP5O8yJsxpsM1wPYTfe/HMo29mBotV6+LDVdKx7BYF4RZb
edOdcz17o6ErazVC1jDCdZIRpjZMtRNnwLw3i397LearFEj3S+qd8afFzyJqUrlU
UHXJ+ptieR/zIGw1PZnwb+dJ3SjkzY9vxgyL0cf/GpBaC0+eA0o40WS8vfT6WC1E
qkXCThtrCa75pW1My5Rn2ugebryAyd4VOIT5b03t0PLLR8VYseGVQJ9IQ5LxdMtB
FghcmZ0J0oE+giBpt/1r+9sSsS9GxAIk7+q0iVeXLtxIVT5sjeyVFsxODDqrGNkZ
3Emo8Oog4zR39wdC6Y65oQuBrIabSvJeUQET1LsU0WdOhWPrNXVkgln/XiIacMkI
QSBnl0wJez2K7MfJtuzrk7AqOhNJRoNRTveqxc7td+RfYZLbkYmQhE2neI/WNYKP
M5xBv+5GPB1YSPxjmqJhshG770Y067Z9BEQoLUjnUyXrD60G3vFUzNo6yEJm8a+3
3/s3QzIH9cFs2yJ6CDJeeAyacH7lt5TprIk+4P4k7H1/5pmSq3qQeOcXDeRaJrKc
fNlhHjZlCCE=
=cCvD
-----END PGP SIGNATURE-----

--CVnXBW4h2fhwOuA1oVxEMPlckGmW1uJuN--
