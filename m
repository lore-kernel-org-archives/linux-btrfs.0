Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751589AbeBBLuB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 06:50:01 -0500
Subject: Re: [PATCH 5/7] btrfs-progs: volumes: Allow find_free_dev_extent() to
 return maximum hole size
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-6-wqu@suse.com>
 <295a561d-dc4c-8a05-ac51-02d3ab24c278@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8507fe44-9a1e-c36f-bd09-89ab6344a25b@gmx.com>
Date: Fri, 2 Feb 2018 19:49:47 +0800
MIME-Version: 1.0
In-Reply-To: <295a561d-dc4c-8a05-ac51-02d3ab24c278@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J0NbpbpIc08mECBwnMwpcLGsNsAjOmabS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J0NbpbpIc08mECBwnMwpcLGsNsAjOmabS
Content-Type: multipart/mixed; boundary="vcpL32TUhtQxRPiyfoAim2hKzS4zp9OvT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <8507fe44-9a1e-c36f-bd09-89ab6344a25b@gmx.com>
Subject: Re: [PATCH 5/7] btrfs-progs: volumes: Allow find_free_dev_extent() to
 return maximum hole size
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-6-wqu@suse.com>
 <295a561d-dc4c-8a05-ac51-02d3ab24c278@suse.com>
In-Reply-To: <295a561d-dc4c-8a05-ac51-02d3ab24c278@suse.com>

--vcpL32TUhtQxRPiyfoAim2hKzS4zp9OvT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8802=E6=97=A5 19:41, Nikolay Borisov wrote:
>=20
>=20
> On  2.02.2018 10:19, Qu Wenruo wrote:
>> Just as kernel find_free_dev_extent(), allow it to return maximum hole=

>> size for us to build device list for later chunk allocator rework.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  volumes.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/volumes.c b/volumes.c
>> index b47ff1f392b5..f4009ffa7c9e 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -516,10 +516,10 @@ out:
>>  }
>> =20
>>  static int find_free_dev_extent(struct btrfs_device *device, u64 num_=
bytes,
>> -				u64 *start)
>> +				u64 *start, u64 *len)
>>  {
>>  	/* FIXME use last free of some kind */
>> -	return find_free_dev_extent_start(device, num_bytes, 0, start, NULL)=
;
>> +	return find_free_dev_extent_start(device, num_bytes, 0, start, len);=

>=20
> Why do we need the free_dev_extent() wrapper over free_dev_extent_start=

> at all?

Because kernel part still needs find_free_dev_extent(), in extent-tree.c.=


I'd prefer to keep the function across kernel and btrfs-progs.

Thanks,
Qu

>>  }
>> =20
>>  static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>> @@ -543,7 +543,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_tra=
ns_handle *trans,
>>  	 * is responsible to make sure it's free.
>>  	 */
>>  	if (!convert) {
>> -		ret =3D find_free_dev_extent(device, num_bytes, start);
>> +		ret =3D find_free_dev_extent(device, num_bytes, start, NULL);
>>  		if (ret)
>>  			goto err;
>>  	}
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--vcpL32TUhtQxRPiyfoAim2hKzS4zp9OvT--

--J0NbpbpIc08mECBwnMwpcLGsNsAjOmabS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp0UFsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi3sQgAgLSSWNDG99+G1fTWCq3gkMsc
NBiH+eNFswkMwfNeBQ/rA9MXe9nShNg340fChyc6J/ulDXgwfE4BLlBpeQLUADME
anaKDh5wwMgBrGHfo5TP0EJeqDO46oFqK51iqKdYj4UHfG85Q3YaiSM6ElHswdj0
1KVjWdCDrPhTyENkNw05rWV+vEzcvJk78szijVPVwMCfkeC/y+AGdVlkqyj0xBZ4
i2mX72nqJnpHbSsIfcW65uItUI202r/mkBgVEvNaumna9lrgYxbcY/T342Mnfwcg
3yaB/7z/RXZIfV6lVgzyWvGPF8TqOZQR+cV49NnDYrG8OpwZ1MdpWd4B+K85IQ==
=g34S
-----END PGP SIGNATURE-----

--J0NbpbpIc08mECBwnMwpcLGsNsAjOmabS--
