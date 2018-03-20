Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37721 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbeCTFQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 01:16:33 -0400
Subject: Re: [PATCH v2] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        ralphgauges@googlemail.com
References: <20180208005940.11551-1-wqu@suse.com>
 <20180319123651.GA6955@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a5a54dc7-b3ab-d22a-f7e6-2bef8e215ffd@gmx.com>
Date: Tue, 20 Mar 2018 13:16:19 +0800
MIME-Version: 1.0
In-Reply-To: <20180319123651.GA6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wdeb3JalWtBgpIam9O6kCoO2jwGfJK0A9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wdeb3JalWtBgpIam9O6kCoO2jwGfJK0A9
Content-Type: multipart/mixed; boundary="oxhQ0wdAIKf92kyERYMpZm9wYeWLFBPbO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 ralphgauges@googlemail.com
Message-ID: <a5a54dc7-b3ab-d22a-f7e6-2bef8e215ffd@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
References: <20180208005940.11551-1-wqu@suse.com>
 <20180319123651.GA6955@twin.jikos.cz>
In-Reply-To: <20180319123651.GA6955@twin.jikos.cz>

--oxhQ0wdAIKf92kyERYMpZm9wYeWLFBPbO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8819=E6=97=A5 20:36, David Sterba wrote:
> On Thu, Feb 08, 2018 at 08:59:40AM +0800, Qu Wenruo wrote:
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
>=20
> Applied, thanks.
>=20
>> ---
>> changlog:
>> v2:
>>   Check if the extent buffer is up-to-date before checking its level t=
o
>>   avoid possible NULL pointer access.
>> ---
>>  ctree.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
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
>=20
> Please unindent the strings that are do not fit 80 chars on the line.
> I've fixed that now, but I do that too often despite this has been know=
n
> to be the preferred style.

Sorry for the extra trouble.

But I'm still a little uncertain about the correct way to handle such
long string.
It would be pretty nice to have some recommendation for the following cas=
es:

1) Super long, already over 80 chars even without indent
   No indent at all or just normal indent?

2) Short enough to have some indent, but can't be aligned to the bracket
   Should we use as much indent as possible or leave no indent at all?

Thanks,
Qu

>=20
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


--oxhQ0wdAIKf92kyERYMpZm9wYeWLFBPbO--

--wdeb3JalWtBgpIam9O6kCoO2jwGfJK0A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqwmSMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qihMwf/X5hvicab5qpWfNCw8S2CZkTc
kv4WlKJsO18g2/m08qqDI7ImTEebTLv8P3tuhGf905//jCzB4Vr2T2UrOMO0qSxR
Uz3nBKjBsEiBn+I1JEdeJ2+QzzPeP3pk6JqwlVX/sk/J5D7gWMBXzPvUkt+7j3KW
7OMI3YKOFMJ2GnYhh5ad2Tvjjou5hL+rI3jr+o9B3NI4t+EBbXTdNhzidcV+IHWS
ttDO3UFsPuVRExJKMBjDaLdh8XyDUYizHHwxhhB0Ou2ayIwaU5RcMR+FxIuXS/kO
x97S7Qv5B2TQGZFcc21JIyrEBfC1ETf0kRs67pUNq27g7NcH+q0Mi9PM860lMw==
=wacq
-----END PGP SIGNATURE-----

--wdeb3JalWtBgpIam9O6kCoO2jwGfJK0A9--
