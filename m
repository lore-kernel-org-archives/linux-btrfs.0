Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:46237 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752023AbeBFBaH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 20:30:07 -0500
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
 <fd31d262-3b22-dbc0-6315-3ce734334625@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b905db35-f6c6-2de3-f1fb-154d697cc747@gmx.com>
Date: Tue, 6 Feb 2018 09:29:55 +0800
MIME-Version: 1.0
In-Reply-To: <fd31d262-3b22-dbc0-6315-3ce734334625@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6M1IT02ihO6pmd9JLmwJTNOyJIM01j06P"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6M1IT02ihO6pmd9JLmwJTNOyJIM01j06P
Content-Type: multipart/mixed; boundary="PwE3ujK4ISzV1zPzCUxvyWIa4YePmqP01";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b905db35-f6c6-2de3-f1fb-154d697cc747@gmx.com>
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
 <fd31d262-3b22-dbc0-6315-3ce734334625@suse.com>
In-Reply-To: <fd31d262-3b22-dbc0-6315-3ce734334625@suse.com>

--PwE3ujK4ISzV1zPzCUxvyWIa4YePmqP01
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8806=E6=97=A5 00:20, Nikolay Borisov wrote:
>=20
>=20
> On 15.12.2017 12:05, Nikolay Borisov wrote:
>> Currently when enoscp_debug mount option is turned on we do not print
>> any debug info in case metadata reservation failures happen. Fix this
>> by adding the necessary hook in reserve_metadata_bytes.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>> ---
>>  fs/btrfs/extent-tree.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 4497f937e8fb..7a281fc97bc5 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -5382,10 +5382,15 @@ static int reserve_metadata_bytes(struct btrfs=
_root *root,
>>  		    !block_rsv_use_bytes(global_rsv, orig_bytes))
>>  			ret =3D 0;
>>  	}
>> -	if (ret =3D=3D -ENOSPC)
>> +	if (ret =3D=3D -ENOSPC) {
>>  		trace_btrfs_space_reservation(fs_info, "space_info:enospc",
>>  					      block_rsv->space_info->flags,
>>  					      orig_bytes, 1);
>> +
>> +		if (btrfs_test_opt(fs_info, ENOSPC_DEBUG))
>> +			dump_space_info(fs_info, block_rsv->space_info,
>> +					orig_bytes, 0);
>> +	}
>>  	return ret;
>>  }
>> =20
>>
>=20
> Ping
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--PwE3ujK4ISzV1zPzCUxvyWIa4YePmqP01--

--6M1IT02ihO6pmd9JLmwJTNOyJIM01j06P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp5BRMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjFBgf/XdYpGKE1ywJTon/Ji5FwdvbB
MdjKMYTlxyNq5CesfotVRterKj+JafMXqh0Gn/uY3yy5IkJ9moB6ST6XuZF6oP5R
QNWxgwsmEggsv3FVD1QUdBYjtkGpOT+Mo0EL3UxJc7sQeFET+6MHUVVq+4yfxU6Y
o63k5VCvCr0czG+zuu0M7VAh45r2VfdNTL++DxrqOO48ti5l7pEKZTozuV6sIMNG
G7Hlnaa/Xk6OW1XNXDn1Frhdzvc3xk1GpOlHNwsBWNI6f4IIGBryHdSODivzegSB
as23iDcc65q/Wz+oepxwxc/Dee1naVRLWpJVjWMiSbIZuZfvXuoeiUdKBppJ2g==
=hKPo
-----END PGP SIGNATURE-----

--6M1IT02ihO6pmd9JLmwJTNOyJIM01j06P--
