Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55199 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbeBIKCo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 05:02:44 -0500
Subject: Re: [PATCH v2] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-2-wqu@suse.com>
 <f3a7a7a3-1fbb-714a-e857-00d606310b95@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <63380daf-6fe0-8d22-c867-41885bccde03@gmx.com>
Date: Fri, 9 Feb 2018 18:02:31 +0800
MIME-Version: 1.0
In-Reply-To: <f3a7a7a3-1fbb-714a-e857-00d606310b95@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="urgfqIVPtz9Dksx61ALuXW9Hmffk7L32b"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--urgfqIVPtz9Dksx61ALuXW9Hmffk7L32b
Content-Type: multipart/mixed; boundary="UMUwRaskklRXR8u0AATDbmD58praeW7yM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <63380daf-6fe0-8d22-c867-41885bccde03@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-2-wqu@suse.com>
 <f3a7a7a3-1fbb-714a-e857-00d606310b95@suse.com>
In-Reply-To: <f3a7a7a3-1fbb-714a-e857-00d606310b95@suse.com>

--UMUwRaskklRXR8u0AATDbmD58praeW7yM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8809=E6=97=A5 16:09, Nikolay Borisov wrote:
>=20
>=20
> On  9.02.2018 09:44, Qu Wenruo wrote:
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
>> changlog:
>> v2:
>>   Check if the extent buffer is up-to-date before checking its level t=
o
>>   avoid possible NULL pointer access.
>> ---
>>  ctree.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
> That was sent separately so I'd assume it was in the wrong dir ;)

Yep, my bad habit of putting all patches in project dir.

Thanks,
Qu

>=20
>>
>> diff --git a/ctree.c b/ctree.c
>> index 4fc33b14000a..430805e3043f 100644
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
>> @@ -649,8 +652,19 @@ struct extent_buffer *read_node_slot(struct btrfs=
_fs_info *fs_info,
>>  	if (level =3D=3D 0)
>>  		return NULL;
>> =20
>> -	return read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
>> +	ret =3D read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
>>  		       btrfs_node_ptr_generation(parent, slot));
>> +	if (!extent_buffer_uptodate(ret))
>> +		return ERR_PTR(-EIO);
>> +
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
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--UMUwRaskklRXR8u0AATDbmD58praeW7yM--

--urgfqIVPtz9Dksx61ALuXW9Hmffk7L32b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp9cbcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qggIQf/R43+54YwVzXUDgDyVAO28W7s
BEcijx3XsXZXEmieFcnBPpiNEAELoQwVF+BVoEgDUAaCuhArAg2Vb6F8kwvDjqjd
gN6HVYz+M8ijTDmYG3ctAZ5ivG/UHJHxrJLpX8uNy7zz1KNo13GNtR4lhKViV2Vh
y1tTS5PnfwE6VNYBy91mYKWr6REp3cce03jzr+5Wp+IQv1CQOH2q+/lA7ZQNlqwA
Sc0hjVi59Q/KFcqroRMQ5nnzQj66mARQkATBKkb5TotMwN03BessVQv7jm7H01kt
nvz2da7fz5gH9jCcMs52RmBuNHDtKT+308eTTgHmrHVKk7+OM+ZPCNQ0RZbAvg==
=3W4K
-----END PGP SIGNATURE-----

--urgfqIVPtz9Dksx61ALuXW9Hmffk7L32b--
