Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:43981 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbeD3Dvg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 23:51:36 -0400
Subject: Re: [PATCH 3/3] btrfs-progs: print-tree: Enhance btrfs_print_tree()
 check to avoid out-of-boundary memory access
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180430031545.29891-1-wqu@suse.com>
 <20180430031545.29891-3-wqu@suse.com>
 <747b3412-e111-8075-20fd-656e76cdb2b0@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3d5df980-bd16-e28c-f342-922db55f63f2@gmx.com>
Date: Mon, 30 Apr 2018 11:51:19 +0800
MIME-Version: 1.0
In-Reply-To: <747b3412-e111-8075-20fd-656e76cdb2b0@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qKFSvapevWgMtFaDCQJNipabwxnsi35Qr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qKFSvapevWgMtFaDCQJNipabwxnsi35Qr
Content-Type: multipart/mixed; boundary="KqVqFzpocGbpnH1Qegrl9ikCopfEGHZ25";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <3d5df980-bd16-e28c-f342-922db55f63f2@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: print-tree: Enhance btrfs_print_tree()
 check to avoid out-of-boundary memory access
References: <20180430031545.29891-1-wqu@suse.com>
 <20180430031545.29891-3-wqu@suse.com>
 <747b3412-e111-8075-20fd-656e76cdb2b0@cn.fujitsu.com>
In-Reply-To: <747b3412-e111-8075-20fd-656e76cdb2b0@cn.fujitsu.com>

--KqVqFzpocGbpnH1Qegrl9ikCopfEGHZ25
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8830=E6=97=A5 11:49, Su Yue wrote:
>=20
>=20
> On 04/30/2018 11:15 AM, Qu Wenruo wrote:
>> For btrfs_print_tree(), if nr_items is corrupted, it can easily go
>> beyond extent buffer boundary.
>>
>> Add extra nr_item check, and only print as many valid slots as possibl=
e.
>>
>=20
> Make sense.
>=20
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 print-tree.c | 11 ++++++++++-
>> =C2=A0 1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/print-tree.c b/print-tree.c
>> index 31a851ef4413..55db80bebb2a 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -1376,6 +1376,11 @@ void btrfs_print_tree(struct extent_buffer *eb,=

>> int follow)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_print_lea=
f(eb);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 /* We are crossing eb boundary, this node must be =
corrupted */
>> +=C2=A0=C2=A0=C2=A0 if (nr > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 warning(
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "node nr_items corrupted, =
has %u limit %u, continue print
>> anyway",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nr=
, BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb));
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printf("node %llu level %d items %d fre=
e %u generation %llu
>> owner ",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 (unsigned long long)eb->start,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 btrfs_header_level(eb), nr,
>> @@ -1386,7 +1391,11 @@ void btrfs_print_tree(struct extent_buffer *eb,=

>> int follow)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_uuids(eb);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fflush(stdout);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 blocknr =3D btrfs_node=
_blockptr(eb, i);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 blocknr;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (i > BTRFS_NODEPTRS_PER=
_EXTENT_BUFFER(eb))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
>=20
> Should it be i >=3D BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb)?

BTRFS_NODEPTRS_PER_EXTENT_BUFFER() provides the maximum valid number.
So it 's >=3D.

>=20
> Here BTRFS_NODEPTRS_PER_EXTENT_BUFFER() is called during iterations.
> The judement can be calculated in advance like:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0ptr_num =3D BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb=
);
> =C2=A0=C2=A0=C2=A0=C2=A0...
> =C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < nr && i < ptr_num=C2=A0 ; i++=
) {

Indeed looks better.

Thanks,
Qu

>=20
> Thanks,
> Su
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blocknr =3D btrfs_node_blo=
ckptr(eb, i);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_node_key(=
eb, &disk_key, i);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_disk_key_=
to_cpu(&key, &disk_key);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printf("\t");
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--KqVqFzpocGbpnH1Qegrl9ikCopfEGHZ25--

--qKFSvapevWgMtFaDCQJNipabwxnsi35Qr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrmkrgACgkQwj2R86El
/qgeXgf/Vl9vHsxKAyC8sIJPviGrBZsH7jd6n24kivNaiq2qUn81sCuikKdceIgG
kiNI/T+/y9FiLSlscPT7hFWTiOpLmjJ2aXdcHkXPbgKpi/H511WRAtruWw9zIkVH
HDBYO3MjK6dU0qQe6tW3ZxvvfRYIavowQknXtuU/OKG+U+5EVId4YJ+rvr4tw6Ds
vubI9LcHeINC8irmBM5Kdxb/ww0DQZQH95W7PLQfnvWNsQulseUeFxAAHD7InM15
soM61nHGGU2A3vOCpbwazhz5hXDyO7UdkiBGwPItUIOKSRwqJZKffUJDQvDg5vvE
cZtXZFz2DDCUfmevrjvnzFs0C6++vw==
=A1NY
-----END PGP SIGNATURE-----

--qKFSvapevWgMtFaDCQJNipabwxnsi35Qr--
