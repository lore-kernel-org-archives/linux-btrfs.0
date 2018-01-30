Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55955 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752000AbeA3J7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 04:59:38 -0500
Subject: Re: [PATCH 2/3] btrfs: Unexport get_block_group_index()
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Anand Jain <anand.jain@oracle.com>
References: <20180130074039.24987-1-wqu@suse.com>
 <20180130074039.24987-2-wqu@suse.com>
 <995dc89a-2f5e-28c0-70e5-f7b18719c1a0@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0742c05a-31eb-ec35-21c9-e35934a98039@gmx.com>
Date: Tue, 30 Jan 2018 17:59:15 +0800
MIME-Version: 1.0
In-Reply-To: <995dc89a-2f5e-28c0-70e5-f7b18719c1a0@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ihnEdbJVN9xwKOINcZvu1jtP6i62iYQVL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ihnEdbJVN9xwKOINcZvu1jtP6i62iYQVL
Content-Type: multipart/mixed; boundary="bl8KisEWe00TYKd4XrCsaqQPGmZfT9ET6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz,
 Anand Jain <anand.jain@oracle.com>
Message-ID: <0742c05a-31eb-ec35-21c9-e35934a98039@gmx.com>
Subject: Re: [PATCH 2/3] btrfs: Unexport get_block_group_index()
References: <20180130074039.24987-1-wqu@suse.com>
 <20180130074039.24987-2-wqu@suse.com>
 <995dc89a-2f5e-28c0-70e5-f7b18719c1a0@suse.com>
In-Reply-To: <995dc89a-2f5e-28c0-70e5-f7b18719c1a0@suse.com>

--bl8KisEWe00TYKd4XrCsaqQPGmZfT9ET6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8830=E6=97=A5 16:18, Nikolay Borisov wrote:
>=20
>=20
> On 30.01.2018 09:40, Qu Wenruo wrote:
>> That function is only used inside extent-tree.c.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/ctree.h       | 1 -
>>  fs/btrfs/extent-tree.c | 3 ++-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 13c260b525a1..27249240fa3e 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -2629,7 +2629,6 @@ struct btrfs_block_group_cache *btrfs_lookup_blo=
ck_group(
>>  						 u64 bytenr);
>>  void btrfs_get_block_group(struct btrfs_block_group_cache *cache);
>>  void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
>> -int get_block_group_index(struct btrfs_block_group_cache *cache);
>>  struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handl=
e *trans,
>>  					     struct btrfs_root *root,
>>  					     u64 parent, u64 root_objectid,
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index e9c31b567a9c..6e1128aa29d6 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7346,7 +7346,8 @@ wait_block_group_cache_done(struct btrfs_block_g=
roup_cache *cache)
>>  	return ret;
>>  }
>> =20
>> -int get_block_group_index(struct btrfs_block_group_cache *cache)
>> +static enum btrfs_raid_types
>> +get_block_group_index(struct btrfs_block_group_cache *cache)
>>  {
>>  	return btrfs_bg_flags_to_raid_index(cache->flags);
>>  }
>=20
> I'd rather you removed this function and used bg_flags_to_raid_index
> directly. Otherwise we have yet another level of indirection with a
> rather wrong name - "block_group_index" ?

Right, also pointed out by Anand, I'll just remove it.

Thanks,
Qu

>=20
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--bl8KisEWe00TYKd4XrCsaqQPGmZfT9ET6--

--ihnEdbJVN9xwKOINcZvu1jtP6i62iYQVL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpwQfMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgSTwf+Ixzp4YDfOPnkOCA1hKIgYc3C
gJvUMwn6yuJY9usdYGd2IB9TotQiL123IyRENC+prXyMNV7iGdTzMFkpQXX3BMoK
TYg7Yg8aPbRyb+W1GbjfxkxU8n5h5DmzntqaaE6tIZOW2vMFpSzVdMmmU/fGNHps
BpUJSIMT79uMk1TX4oUhbVLJ6Ec9/qdPIb7wDNFvI6+E+oyqEkd/Gl+TxCxEhMH9
ou2+Gn0vgbmXOi+GC+b7KCeWRZ0pj3G+brunokWapCscB8wmQMG/ezZml2Zz8ZYw
M89/wlxil06OH+o1I1W2nhqxkigTXUE32MuTaKZIhTlKoK++4l3tRxGdz78A5Q==
=5HbX
-----END PGP SIGNATURE-----

--ihnEdbJVN9xwKOINcZvu1jtP6i62iYQVL--
