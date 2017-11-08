Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62556 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753216AbdKHAKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 19:10:18 -0500
Subject: Re: [PATCH] btrfs: tree-checker: Fix false panic for sanity test
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        lakshmipathi.g@gmail.com, Filipe Manana <fdmanana@gmail.com>
References: <20171106054717.18952-1-wqu@suse.com>
 <20171107211252.GG27557@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <63f336a3-c83d-ded6-4cc8-f63084a34c41@gmx.com>
Date: Wed, 8 Nov 2017 08:10:03 +0800
MIME-Version: 1.0
In-Reply-To: <20171107211252.GG27557@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ePAqlTpDGg0qwjrVrA79Of23MFjtInVJl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ePAqlTpDGg0qwjrVrA79Of23MFjtInVJl
Content-Type: multipart/mixed; boundary="IthFshwCTHC4im1L1FHNbv3EJcI7odwdw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 lakshmipathi.g@gmail.com, Filipe Manana <fdmanana@gmail.com>
Message-ID: <63f336a3-c83d-ded6-4cc8-f63084a34c41@gmx.com>
Subject: Re: [PATCH] btrfs: tree-checker: Fix false panic for sanity test
References: <20171106054717.18952-1-wqu@suse.com>
 <20171107211252.GG27557@twin.jikos.cz>
In-Reply-To: <20171107211252.GG27557@twin.jikos.cz>

--IthFshwCTHC4im1L1FHNbv3EJcI7odwdw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8808=E6=97=A5 05:12, David Sterba wrote:
> On Mon, Nov 06, 2017 at 01:47:17PM +0800, Qu Wenruo wrote:
>> [BUG]
>> If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=3Dy, it will
>> instantly cause kernel panic like:
>=20
> Which patch causes that?

To be specific, the file extent item checker. (As that's the first patch
to check item members)
But to be honest, any checker checks member value will cause it.

> The selftests used to catch various errors when
> the original dir_item verification patches were merged. Plus some
> fstests were failing. I burned a lot of time on that and don't want to
> repeat that, so I expect that all tree-checker patches pass self-test
> (incrementally, not just the whole series) and all relevant fstests.

OK, I'll enable selftest in my kernel config.

>=20
>>
>> ------
>> ...
>> assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
>> ...
>> Call Trace:
>>  btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
>>  setup_items_for_insert+0x385/0x650 [btrfs]
>>  __btrfs_drop_extents+0x129a/0x1870 [btrfs]
>> ...
>> -----
>>
>> [Cause]
>> Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to che=
ck
>> if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=3Dy.
>>
>> However quite some btrfs_mark_buffer_dirty() callers(*) don't really
>> initialize its item data but only initialize its item pointers, leavin=
g
>> item data uninitialized.
>>
>> This makes tree-checker catch uninitialized data as error, causing
>> such panic.
>>
>> *: These callers include but not limited to
>> setup_items_for_insert()
>> btrfs_split_item()
>> btrfs_expand_item()
>>
>> [Fix]
>> Add a new parameter @check_item_data to btrfs_check_leaf().
>> With @check_item_data set to false, item data check will be skipped an=
d
>> fallback to old btrfs_check_leaf() behavior.
>=20
> So this looks like a patch ordering problem. The weaker version of
> btrfs_check_leaf needs to come first and then the improved checks that
> cause the crashes.

Yes, that should be the case.

>=20
>> So we can still get early warning if we screw up item pointers, and
>> avoid false panic.
>>
>> Cc: Filipe Manana <fdmanana@gmail.com>
>> Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c      |  5 +++--
>>  fs/btrfs/tree-checker.c | 16 +++++++++++-----
>>  fs/btrfs/tree-checker.h |  3 ++-
>>  3 files changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index efce9a2fa9be..c65b63d6df27 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -610,7 +610,7 @@ static int btree_readpage_end_io_hook(struct btrfs=
_io_bio *io_bio,
>>  	 * that we don't try and read the other copies of this block, just
>>  	 * return -EIO.
>>  	 */
>> -	if (found_level =3D=3D 0 && btrfs_check_leaf(root, eb)) {
>> +	if (found_level =3D=3D 0 && btrfs_check_leaf(root, eb, true)) {
>>  		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>>  		ret =3D -EIO;
>>  	}
>> @@ -3848,7 +3848,8 @@ void btrfs_mark_buffer_dirty(struct extent_buffe=
r *buf)
>>  					 buf->len,
>>  					 fs_info->dirty_metadata_batch);
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>> -	if (btrfs_header_level(buf) =3D=3D 0 && btrfs_check_leaf(root, buf))=
 {
>> +	if (btrfs_header_level(buf) =3D=3D 0 &&
>> +	    btrfs_check_leaf(root, buf, false)) {
>>  		btrfs_print_leaf(buf);
>>  		ASSERT(0);
>>  	}
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index 114fc5f0ecc5..a4c2517fa2a1 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -242,7 +242,8 @@ static int check_leaf_item(struct btrfs_root *root=
,
>>  	return ret;
>>  }
>> =20
>> -int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *l=
eaf)
>> +int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *l=
eaf,
>> +		     bool check_item_data)
>=20
> The bool arguments are usally not very descriptive, I suggest to add
>=20
> static inline int btrfs_check_leaf_relaxed(struct btrfs_root *root, str=
uct extent_buffer *leaf)
> {
> 	return btrfs_check_leaf_root, leaf, false);
> }
>=20
> to tree-check.h and use where appropriate.

OK, I'll update the patch.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--IthFshwCTHC4im1L1FHNbv3EJcI7odwdw--

--ePAqlTpDGg0qwjrVrA79Of23MFjtInVJl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloCS1sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qigiwgAjhPpeCsSVQnpquikJxcQj9dL
q2y0Gebc0KR5MJwH8sHCNPg0xaEkbTXE+lc35+VJ6I59XNVKKCG0rxtmqSezBthW
Mjq3X1Mf6e/8XJVSxWzpYrYtworcUMtckG6lXJtE+RiYM8glsYajNrSyH+DnLIzl
RwOxJaEGCERw8GFFYaV99MAwEyroh9uZzlRRrujjGI3qLVV+V7lMMpvlZZ1xzJnS
yyATVB4UJ/Om76wXIw+o2KBFkgQ1ZTZeu1MIbHGOzkz9SakmeohOJZIuSxT1nOir
7jFOsqhAuJeGAPr9hQVyy/NDfUDQGB55nNO9OUNEUXlYH8dkieUXnps1oSg1ug==
=9tq3
-----END PGP SIGNATURE-----

--ePAqlTpDGg0qwjrVrA79Of23MFjtInVJl--
