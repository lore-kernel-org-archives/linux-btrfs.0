Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65319 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753983AbeBGOqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 09:46:44 -0500
Subject: Re: [PATCH] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        ralphgauges@googlemail.com
References: <20180207091825.10144-1-wqu@suse.com>
 <20180207143536.GB3003@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e73f1311-6f60-ef51-dff1-eda03061df70@gmx.com>
Date: Wed, 7 Feb 2018 22:46:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180207143536.GB3003@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QBzZJDISXRNyTgnysToAHSsnlC74maPIb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QBzZJDISXRNyTgnysToAHSsnlC74maPIb
Content-Type: multipart/mixed; boundary="dLaOx8OTtjpNMVptSN26EKhAuzTpoA1eJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 ralphgauges@googlemail.com
Message-ID: <e73f1311-6f60-ef51-dff1-eda03061df70@gmx.com>
Subject: Re: [PATCH] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
References: <20180207091825.10144-1-wqu@suse.com>
 <20180207143536.GB3003@twin.jikos.cz>
In-Reply-To: <20180207143536.GB3003@twin.jikos.cz>

--dLaOx8OTtjpNMVptSN26EKhAuzTpoA1eJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8807=E6=97=A5 22:35, David Sterba wrote:
> On Wed, Feb 07, 2018 at 05:18:25PM +0800, Qu Wenruo wrote:
>> Strangely, we have level check in btrfs_print_tree() while we don't ha=
ve
>> the same check in read_node_slot().
>>
>> That's to say, for the following corruption, btrfs_search_slot() or
>> btrfs_next_leaf() can return invalid leaf:
>>
>> Parent eb:
>>   node XXXXXX level 1
>>               ^^^^^^^
>>               Child should be leaf (level 0)
>>   ...
>>   key (XXX XXX XXX) block YYYYYY
>>
>> Child eb:
>>   leaf YYYYYY level 1
>>               ^^^^^^^
>>               Something went wrong now
>>
>> And for the corrupted leaf returned, later caller can be screwed up
>> easily.
>>
>> Although the root cause (powerloss, but still something wrong breaking=

>> metadata CoW of btrfs) is still unknown, at least enhance btrfs-progs =
to
>> avoid SEGV.
>>
>> Reported-by: Ralph Gauges <ralphgauges@googlemail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  ctree.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/ctree.c b/ctree.c
>> index 4fc33b14000a..ddb1e9cc6d37 100644
>> --- a/ctree.c
>> +++ b/ctree.c
>> @@ -22,6 +22,7 @@
>>  #include "repair.h"
>>  #include "internal.h"
>>  #include "sizes.h"
>> +#include "messages.h"
>> =20
>>  static int split_node(struct btrfs_trans_handle *trans, struct btrfs_=
root
>>  		      *root, struct btrfs_path *path, int level);
>> @@ -640,7 +641,9 @@ static int bin_search(struct extent_buffer *eb, st=
ruct btrfs_key *key,
>>  struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
>>  				   struct extent_buffer *parent, int slot)
>>  {
>> +	struct extent_buffer *ret;
>>  	int level =3D btrfs_header_level(parent);
>> +
>>  	if (slot < 0)
>>  		return NULL;
>>  	if (slot >=3D btrfs_header_nritems(parent))
>> @@ -649,8 +652,16 @@ struct extent_buffer *read_node_slot(struct btrfs=
_fs_info *fs_info,
>>  	if (level =3D=3D 0)
>>  		return NULL;
>> =20
>> -	return read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
>> +	ret =3D read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
>=20
> The result of read_tree_block should be checked before use, by
> extent_buffer_uptodate, null check or IS_ERR at least (depending on the=

> context of use).

Right, just forgot that.

Will fix it in next version.

Thanks,
Qu

>=20
>>  		       btrfs_node_ptr_generation(parent, slot));
>> +	if (btrfs_header_level(ret) !=3D level - 1) {
>> +		error("child eb corrupted: parent bytenr=3D%llu item=3D%d parent le=
vel=3D%d child level=3D%d",
>> +		      btrfs_header_bytenr(parent), slot,
>> +		      btrfs_header_level(parent), btrfs_header_level(ret));
>> +		free_extent_buffer(ret);
>> +		return ERR_PTR(-EIO);
>> +	}
>> +	return ret;
>>  }
>> =20
>>  static int balance_level(struct btrfs_trans_handle *trans,
>> --=20
>> 2.16.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--dLaOx8OTtjpNMVptSN26EKhAuzTpoA1eJ--

--QBzZJDISXRNyTgnysToAHSsnlC74maPIb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp7EUMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjMjwf/eeoXXEC4zWJs7ax6K4+UmOl/
d0mJ+54APw/MKA8X0nHmb1Vr+lBr0HA/aqnJHKF1f2ziV8DaeQEtxka+yKH4oARL
4WhHSvK0n8818CEy77V6+NPlkV0lGCwGPXbgl8Hvjl+HOqsqJhGh2x/FAfZrqdWX
BAirUyfGTlCd7VMGphRquUuwh5UlOcOGJOKZDkMk/WK8OlpyLTocwTdvwpktGgSX
2OB+ZJF+Px8abZsVzxoLSZNXe6OMUTos8fpJ+A2q4a4bXpfz8wJNOEkabrDVyfXh
u+OowtYHqXxZSiYxbpEKenZSE/mtqbMxH07b47JlfNFYAm72ZfPIkoAkQy7Usg==
=4n5n
-----END PGP SIGNATURE-----

--QBzZJDISXRNyTgnysToAHSsnlC74maPIb--
