Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56703 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032485AbeE0BZn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 May 2018 21:25:43 -0400
Subject: Re: [PATCH v2] btrfs: Use btrfs_mark_bg_unused() to replace open code
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180522084347.3381-1-wqu@suse.com>
 <20180522121455.GH6649@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <be92bc31-f617-254b-a1b8-2f92de764295@gmx.com>
Date: Sun, 27 May 2018 09:25:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180522121455.GH6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="59RqMedD296KLOsvmBrOwTY9BXbFa9xwJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--59RqMedD296KLOsvmBrOwTY9BXbFa9xwJ
Content-Type: multipart/mixed; boundary="SCyL9gGyGVaWCZN6vRZ6HuqFWc4EIcEjZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <be92bc31-f617-254b-a1b8-2f92de764295@gmx.com>
Subject: Re: [PATCH v2] btrfs: Use btrfs_mark_bg_unused() to replace open code
References: <20180522084347.3381-1-wqu@suse.com>
 <20180522121455.GH6649@twin.jikos.cz>
In-Reply-To: <20180522121455.GH6649@twin.jikos.cz>

--SCyL9gGyGVaWCZN6vRZ6HuqFWc4EIcEjZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8822=E6=97=A5 20:14, David Sterba wrote:
> On Tue, May 22, 2018 at 04:43:47PM +0800, Qu Wenruo wrote:
>> Introduce a small helper, btrfs_mark_bg_unused(), to accquire needed
>> locks and add a block group to unused_bgs list.
>=20
> The helper is nice but hides that there's a reference taken on the 'bg'=
=2E
> This would be good to add at least to the function comment or somehow
> squeeze it into the function name itself, like
> btrfs_get_and_mark_bg_unused.

That btrfs_get_block_group() call is only for later removal.
The reference will be removed in btrfs_delete_unused_bgs().

So I don't think the function name needs the "_get" part.

Although I could add more comment about the btrfs_get_block_group() call.=


How do you think about this?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--SCyL9gGyGVaWCZN6vRZ6HuqFWc4EIcEjZ--

--59RqMedD296KLOsvmBrOwTY9BXbFa9xwJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsKCQUACgkQwj2R86El
/qhqfQf+PYzBR1rgvUlG9XbwEvCx8QKY8BaSq9vaU2/nr2yQWfks/NDseGMwqSzW
YZUoy2GCXx7rwxU35QVwgsFZsmyEtnj8Dfw2sCTQydUoJHxaF1h/XoT3ZQ7Rxipp
ulF7BRg1R3GFa/d13E1TpzV9c1OReR/YrZNTNdD+r6dWl4IKO3HCy5iQ1MxQKYV/
RDDoZvFMad4vXp0G1T8j70twmY1duiz3vtTOvIVVO+IABQmUJSTzuWZUQk4z+csU
oF2pohl2zQ/YJz38mB6QOPXpEUvSZjoaY6jQL80B42rUakzZ8lbaQzavGoaaDJmO
GpYJoNuGuvf3xHeGnhARbNttgiv5yg==
=hqVF
-----END PGP SIGNATURE-----

--59RqMedD296KLOsvmBrOwTY9BXbFa9xwJ--
