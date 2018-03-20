Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:47753 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbeCTFYA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 01:24:00 -0400
Subject: Re: [PATCH v2] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        ralphgauges@googlemail.com
References: <20180208005940.11551-1-wqu@suse.com>
 <20180319123651.GA6955@twin.jikos.cz>
 <a5a54dc7-b3ab-d22a-f7e6-2bef8e215ffd@gmx.com>
Message-ID: <8d1a4475-8f50-480d-183b-ebd6f08df788@gmx.com>
Date: Tue, 20 Mar 2018 13:23:46 +0800
MIME-Version: 1.0
In-Reply-To: <a5a54dc7-b3ab-d22a-f7e6-2bef8e215ffd@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="naMc1r2BHKT3A9wUAEPZMgjxRZ9ujyLkq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--naMc1r2BHKT3A9wUAEPZMgjxRZ9ujyLkq
Content-Type: multipart/mixed; boundary="oGcBQdHDL1HZ7bSE8CgpfCLrDqcj2494J";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 ralphgauges@googlemail.com
Message-ID: <8d1a4475-8f50-480d-183b-ebd6f08df788@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
References: <20180208005940.11551-1-wqu@suse.com>
 <20180319123651.GA6955@twin.jikos.cz>
 <a5a54dc7-b3ab-d22a-f7e6-2bef8e215ffd@gmx.com>
In-Reply-To: <a5a54dc7-b3ab-d22a-f7e6-2bef8e215ffd@gmx.com>

--oGcBQdHDL1HZ7bSE8CgpfCLrDqcj2494J
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8820=E6=97=A5 13:16, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8819=E6=97=A5 20:36, David Sterba wrote:
>> On Thu, Feb 08, 2018 at 08:59:40AM +0800, Qu Wenruo wrote:
>>> Strangely, we have level check in btrfs_print_tree() while we don't h=
ave
>>> the same check in read_node_slot().
>>>
>>> That's to say, for the following corruption, btrfs_search_slot() or
>>> btrfs_next_leaf() can return invalid leaf:
>>>
>>> Parent eb:
>>>   node XXXXXX level 1
>>>               ^^^^^^^
>>>               Child should be leaf (level 0)
>>>   ...
>>>   key (XXX XXX XXX) block YYYYYY
>>>
>>> Child eb:
>>>   leaf YYYYYY level 1
>>>               ^^^^^^^
>>>               Something went wrong now
>>>
>>> And for the corrupted leaf returned, later caller can be screwed up
>>> easily.
>>>
>>> Although the root cause (powerloss, but still something wrong breakin=
g
>>> metadata CoW of btrfs) is still unknown, at least enhance btrfs-progs=
 to
>>> avoid SEGV.
>>>
>>> Reported-by: Ralph Gauges <ralphgauges@googlemail.com>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Applied, thanks.
>>
>>> ---
>>> changlog:
>>> v2:
>>>   Check if the extent buffer is up-to-date before checking its level =
to
>>>   avoid possible NULL pointer access.
>>> ---
>>>  ctree.c | 16 +++++++++++++++-
>>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/ctree.c b/ctree.c
>>> index 4fc33b14000a..430805e3043f 100644
>>> --- a/ctree.c
>>> +++ b/ctree.c
>>> @@ -22,6 +22,7 @@
>>>  #include "repair.h"
>>>  #include "internal.h"
>>>  #include "sizes.h"
>>> +#include "messages.h"
>>> =20
>>>  static int split_node(struct btrfs_trans_handle *trans, struct btrfs=
_root
>>>  		      *root, struct btrfs_path *path, int level);
>>> @@ -640,7 +641,9 @@ static int bin_search(struct extent_buffer *eb, s=
truct btrfs_key *key,
>>>  struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
>>>  				   struct extent_buffer *parent, int slot)
>>>  {
>>> +	struct extent_buffer *ret;
>>>  	int level =3D btrfs_header_level(parent);
>>> +
>>>  	if (slot < 0)
>>>  		return NULL;
>>>  	if (slot >=3D btrfs_header_nritems(parent))
>>> @@ -649,8 +652,19 @@ struct extent_buffer *read_node_slot(struct btrf=
s_fs_info *fs_info,
>>>  	if (level =3D=3D 0)
>>>  		return NULL;
>>> =20
>>> -	return read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
>>> +	ret =3D read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),=

>>>  		       btrfs_node_ptr_generation(parent, slot));
>>> +	if (!extent_buffer_uptodate(ret))
>>> +		return ERR_PTR(-EIO);
>>> +
>>> +	if (btrfs_header_level(ret) !=3D level - 1) {
>>> +		error("child eb corrupted: parent bytenr=3D%llu item=3D%d parent l=
evel=3D%d child level=3D%d",
>>
>> Please unindent the strings that are do not fit 80 chars on the line.
>> I've fixed that now, but I do that too often despite this has been kno=
wn
>> to be the preferred style.
>=20
> Sorry for the extra trouble.
>=20
> But I'm still a little uncertain about the correct way to handle such
> long string.
> It would be pretty nice to have some recommendation for the following c=
ases:
>=20
> 1) Super long, already over 80 chars even without indent
>    No indent at all or just normal indent?

And in that case, should we move the string to a new line?
As neither way, it's already over 80 chars.

Thanks,
Qu

>=20
> 2) Short enough to have some indent, but can't be aligned to the bracke=
t
>    Should we use as much indent as possible or leave no indent at all?
>=20
> Thanks,
> Qu
>=20
>>
>>> +		      btrfs_header_bytenr(parent), slot,
>>> +		      btrfs_header_level(parent), btrfs_header_level(ret));
>>> +		free_extent_buffer(ret);
>>> +		return ERR_PTR(-EIO);
>>> +	}
>>> +	return ret;
>>>  }
>>> =20
>>>  static int balance_level(struct btrfs_trans_handle *trans,
>>> --=20
>>> 2.16.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--oGcBQdHDL1HZ7bSE8CgpfCLrDqcj2494J--

--naMc1r2BHKT3A9wUAEPZMgjxRZ9ujyLkq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqwmuIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhZiAgAq8GndRKKdPBro5wl8T6ro/9w
NwH610nR61nb0iZ8AuZExiwj1ULn4gchBWihWRSuKA2Jmy0yL+VaAOOkquhorPUh
tlQMVT2lgx8PKN+Lgn7wSZLse+aZ1wkeR/dx+lgAlaWldGVwzKKwOLTjFneoGeU2
z3RUrjDWoooJeUKqzfcIOMX3uErNpkwi68a7t6ER52yhlDE/lw+vvQE5YjoB4wIm
k0Q0hWS3rgnoVU6e17rO/EU2eFLmnu8IDZT2NK80oy/qSmVwu5tSw4CM4Rqsp4MM
aNMrrkLAzdgG2OtlSrASJ3nZy2RVrOVXA55+6gCMLnSymV0W+eqSf/Pt4kJHiA==
=IVn9
-----END PGP SIGNATURE-----

--naMc1r2BHKT3A9wUAEPZMgjxRZ9ujyLkq--
