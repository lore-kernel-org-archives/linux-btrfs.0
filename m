Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:36533 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754331AbeDCFuj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 01:50:39 -0400
Subject: Re: [PATCH v2 2/2] btrfs: Validate child tree block's level and first
 key
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180327124419.28398-1-wqu@suse.com>
 <20180327124419.28398-2-wqu@suse.com> <20180328154949.GO30422@twin.jikos.cz>
 <7d95e99d-09bf-483f-2fa8-3ab658c2a8f5@gmx.com>
Message-ID: <68fae745-9599-ed92-43b9-5744295ed6f7@gmx.com>
Date: Tue, 3 Apr 2018 13:50:23 +0800
MIME-Version: 1.0
In-Reply-To: <7d95e99d-09bf-483f-2fa8-3ab658c2a8f5@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SkGimGhKb5mIm5dWDA9oU37nSm513o0gf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SkGimGhKb5mIm5dWDA9oU37nSm513o0gf
Content-Type: multipart/mixed; boundary="tPiPKAlvnS6fgitxULgTIIv3ICmW6hRl5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <68fae745-9599-ed92-43b9-5744295ed6f7@gmx.com>
Subject: Re: [PATCH v2 2/2] btrfs: Validate child tree block's level and first
 key
References: <20180327124419.28398-1-wqu@suse.com>
 <20180327124419.28398-2-wqu@suse.com> <20180328154949.GO30422@twin.jikos.cz>
 <7d95e99d-09bf-483f-2fa8-3ab658c2a8f5@gmx.com>
In-Reply-To: <7d95e99d-09bf-483f-2fa8-3ab658c2a8f5@gmx.com>

--tPiPKAlvnS6fgitxULgTIIv3ICmW6hRl5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8802=E6=97=A5 18:47, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8828=E6=97=A5 23:49, David Sterba wrote:
>> On Tue, Mar 27, 2018 at 08:44:19PM +0800, Qu Wenruo wrote:
>>> We have several reports about node pointer points to incorrect child
>>> tree blocks, which could have even wrong owner and level but still wi=
th
>>> valid generation and checksum.
>>>
>>> Although btrfs check could handle it and print error message like:
>>> leaf parent key incorrect 60670574592
>>>
>>> Kernel doesn't have enough check on this type of corruption correctly=
=2E
>>> At least add such check to read_tree_block() and btrfs_read_buffer(),=

>>> where we need two new parameters @level and @first_key to verify the
>>> child tree block.
>>>
>>> The new @level check is mandatory and all call sites are already
>>> modified to extract expected level from its call chain.
>>>
>>> While @first_key is optional, the following call sites are skipping s=
uch
>>> check:
>>> 1) Root node/leaf
>>>    As ROOT_ITEM doesn't contain the first key, skip @first_key check.=

>>> 2) Direct backref
>>>    Only parent bytenr and level is known and we need to resolve the k=
ey
>>>    all by ourselves, skip @first_key check.
>>>
>>> Another note of this verification is, it needs extra info from nodept=
r
>>> or ROOT_ITEM, so it can't fit into current tree-checker framework, wh=
ich
>>> is limited to node/leaf boundary.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> changelog:
>>> v2:
>>>   Make @level check mandatory, suggesed by Jeff and Nikolay.
>>>   Change parameter order as @level is now mandatory, put it in front =
of
>>>   @first_key.
>>>   Change verify_parent_level() to verify_key_level() to avoid confusi=
on
>>>   on the @level parameter.
>>>   Add btrfs_error() output for CONFIG_BTRFS_DEBUG to help debugging.
>>
>> That's much better overall, thanks. Adding it to next.
>=20
> Nikolay reported a case where @first_key check seems to cause false ale=
rt.
> (Although my xfstests check hasn't exposed it yet)
>=20
> Please discard this patch since it has the possibility to cause false
> alert for btrfs core functionality.

It turns out to be a racing related case in btree operations like
push_leaf_right().

So it indeed brings some clue here.
(Although still pretty hard to reproduce)

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--tPiPKAlvnS6fgitxULgTIIv3ICmW6hRl5--

--SkGimGhKb5mIm5dWDA9oU37nSm513o0gf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrDFh8ACgkQwj2R86El
/qiFBQf+KZEt954BoBUV4G2/DimB6cmfbugaOa2440oXaHgkI4F8tWCv+KxLrK5Q
03Cavu8RMe6XWt7mZhmrEZmVV6+SOXn0qIZ+0UT7PW+uye1chHC2ujF69KpUsdWJ
FpssiN5jS8sXYfXacDd0Q+EXCJplFhEK1tbysBJ5koTphdYXwWscVLQGShgPjHaI
uTyHYNZrnbvUWObV22LM10rspjEEV/+XOR+w5KzulPXoJvmmUSIa3BfkwmahuHgv
9im7XDWOeqkHaBGyMYAS8hM2fD0ITWE0d5M7lxqff6H2vfp9pCfRq45Hca/mB66L
pgw3jQJvU0SxbUopiJ2AdegRYXeUMw==
=F+vD
-----END PGP SIGNATURE-----

--SkGimGhKb5mIm5dWDA9oU37nSm513o0gf--
