Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:38095 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422944AbeCBIeg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 03:34:36 -0500
Subject: Re: [PATCH 5/5] btrfs: Show more accurate max_inline
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-6-wqu@suse.com>
 <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b9f5f159-156d-1346-a4fa-d1eadf3223f4@gmx.com>
Date: Fri, 2 Mar 2018 16:34:15 +0800
MIME-Version: 1.0
In-Reply-To: <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l9Etw4aHhqbaqnDDlEZRnKJzHRKUFEYCW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l9Etw4aHhqbaqnDDlEZRnKJzHRKUFEYCW
Content-Type: multipart/mixed; boundary="fLkGgwrcaSs8sChDU9GhEy7JWEbHateQ3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <b9f5f159-156d-1346-a4fa-d1eadf3223f4@gmx.com>
Subject: Re: [PATCH 5/5] btrfs: Show more accurate max_inline
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-6-wqu@suse.com>
 <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
In-Reply-To: <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>

--fLkGgwrcaSs8sChDU9GhEy7JWEbHateQ3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 16:21, Misono, Tomohiro wrote:
> On 2018/03/02 14:22, Qu Wenruo wrote:
>> Btrfs shows max_inline option into kernel message, but for
>> max_inline=3D4096, btrfs won't really inline 4096 bytes inline data if=

>> it's not compressed.
>=20
> Hello,
> I have a question.
>=20
> man mount(8) says:=20
>    max_inline=3Dbytes
>           Specify  the  maximum  amount  of space, in bytes, that can b=
e
>           inlined in a metadata B-tree leaf.  The value is specified  i=
n
>           bytes,  optionally with a K, M, or G suffix, case insensitive=
=2E
>           In practice, this value is limited by the  root  sector  size=
,
>           with  some  space  unavailable  due to leaf headers.  For a 4=
k
>           sectorsize, max inline data is ~3900 bytes.
>=20
> So, is the size of 4k-(size of leaf header) actually the maximum value
> of max_inline instead of 4095 for 4k sectorsize?

Not exactly.

For 4K nodesize, max_inline would be 3960 bytes.
As leaf header and EXTENT_ITEM header takes extra bytes.

For 16K nodesize (default), we can go up to 4095 bytes then.

And that man page needs updated, as it should be 4K *nodesize*.

Thanks,
Qu

>=20
> Thanks,
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--fLkGgwrcaSs8sChDU9GhEy7JWEbHateQ3--

--l9Etw4aHhqbaqnDDlEZRnKJzHRKUFEYCW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqZDIcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh1uAf+PbtZ5P0vk6cf+QIDlocVA7lR
O0vhy3VtNwcSOYh7etdHmDGemClmYJvmXVJMJQCFzXse92zyTmYlBJnbLz+CouBM
ldk6+i/ld7k48xlMc0D6BnfAdEXAOdi2y56I1ymNs/HrRoWIWLYYetX5vUAWKPaQ
X19iXnNaFfCGnqgTTVhq71QizALc4ONf6ViUvFf4Ehh9erBRur2RlA4Pudi4lCjU
OClLCTfOzUr6xTOm20lG9I2F26OfFvMihEgp2Cc/vuwXaW6rwOYqyBqzmELhPcSQ
y0WDW4Gtv3IQ0v0BBeB4yuTCtRvoCSs1AbSre7i6SknrNGZaUAtwJXS9pGFETQ==
=OYgT
-----END PGP SIGNATURE-----

--l9Etw4aHhqbaqnDDlEZRnKJzHRKUFEYCW--
