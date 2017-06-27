Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44813 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753295AbdF0VLD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 17:11:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D054ABB1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 21:11:01 +0000 (UTC)
Subject: Re: [PATCH 08/13] btrfs: convert prelimary reference tracking to use
 rbtrees
To: dsterba@suse.cz, Edmund Nadolski <enadolski@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
 <20170627164920.GZ2866@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <8365c713-dd8a-6778-401e-45cd0fc43ef0@suse.com>
Date: Tue, 27 Jun 2017 17:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170627164920.GZ2866@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aAalbSasA0Ih7UpMc29rRxBbnS5O8l9Dt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aAalbSasA0Ih7UpMc29rRxBbnS5O8l9Dt
Content-Type: multipart/mixed; boundary="enxnqSccpO4e8B6PxN1IughSDXGAI41hr";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Edmund Nadolski <enadolski@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <8365c713-dd8a-6778-401e-45cd0fc43ef0@suse.com>
Subject: Re: [PATCH 08/13] btrfs: convert prelimary reference tracking to use
 rbtrees
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
 <20170627164920.GZ2866@twin.jikos.cz>
In-Reply-To: <20170627164920.GZ2866@twin.jikos.cz>

--enxnqSccpO4e8B6PxN1IughSDXGAI41hr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/27/17 12:49 PM, David Sterba wrote:
> On Tue, Jun 20, 2017 at 10:06:48AM -0600, Edmund Nadolski wrote:
>> It's been known for a while that the use of multiple lists
>> that are periodically merged was an algorithmic problem within
>> btrfs.  There are several workloads that don't complete in any
>> reasonable amount of time (e.g. btrfs/130) and others that cause
>> soft lockups.
>>
>> The solution is to use a pair of rbtrees that do insertion merging
>> for both indirect and direct refs, with the former converting
>> refs into the latter.  The result is a btrfs/130 workload that
>> used to take several hours now takes about half of that. This
>> runtime still isn't acceptable and a future patch will address that
>> by moving the rbtrees higher in the stack so the lookups can be
>> shared across multiple calls to find_parent_nodes.
>>
>> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/backref.c | 415 ++++++++++++++++++++++++++++++++++----------=
---------
>>  1 file changed, 267 insertions(+), 148 deletions(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 0d1e7cb..daae7b6 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -129,7 +129,7 @@ static int find_extent_in_eb(const struct extent_b=
uffer *eb,
>>   * this structure records all encountered refs on the way up to the r=
oot
>>   */
>>  struct prelim_ref {
>> -	struct list_head list;
>> +	struct rb_node rbnode;
>>  	u64 root_id;
>>  	struct btrfs_key key_for_search;
>>  	int level;
>> @@ -139,6 +139,17 @@ struct prelim_ref {
>>  	u64 wanted_disk_byte;
>>  };
>> =20
>> +struct preftree {
>> +	struct rb_root root;
>> +};
>> +
>> +#define PREFTREE_INIT	{ .root =3D RB_ROOT }
>> +
>> +struct preftrees {
>> +	struct preftree direct;    /* BTRFS_SHARED_[DATA|BLOCK]_REF_KEY */
>> +	struct preftree indirect;  /* BTRFS_[TREE_BLOCK|EXTENT_DATA]_REF_KEY=
 */
>> +};
>> +
>>  static struct kmem_cache *btrfs_prelim_ref_cache;
>> =20
>>  int __init btrfs_prelim_ref_init(void)
>> @@ -158,6 +169,108 @@ void btrfs_prelim_ref_exit(void)
>>  	kmem_cache_destroy(btrfs_prelim_ref_cache);
>>  }
>> =20
>> +static void release_pref(struct prelim_ref *ref)
>> +{
>> +	kmem_cache_free(btrfs_prelim_ref_cache, ref);
>=20
> This is a bit confusing, 'release' in btrfs code is used to release the=

> resources but not to actually free the memory. See eg.
> btrfs_release_path and btrfs_free_path. As the helper is trivial and I
> don't see any other additions to it in the followup patches, I suggest
> to drop and opencode it.

I don't mind renaming it to free_pref, but free_pref(ref) is a whole lot
easier to read and write than the alternative.

>> @@ -429,38 +560,58 @@ unode_aux_to_inode_list(struct ulist_node *node)=

>>  }
>> =20
>>  /*
>> - * resolve all indirect backrefs from the list
>> + * We maintain two separate rbtrees: one for indirect refs and one fo=
r
>> + * direct refs. Each tree does merge on insertion.  Once all of the
>> + * refs have been located, we iterate over the indirect ref tree, res=
olve
>> + * each reference and remove it from the indirect tree, and then inse=
rt
>> + * the resolved reference into the direct tree, merging there too.
>> + *
>> + * New backrefs (i.e., for parent nodes) are added to the direct/indi=
rect
>> + * rbtrees as they are encountered.  The new, indirect backrefs are
>> + * resolved as above.
>>   */
>>  static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
>>  				 struct btrfs_path *path, u64 time_seq,
>> -				 struct list_head *head,
>> +				 struct preftrees *preftrees,
>>  				 const u64 *extent_item_pos, u64 total_refs,
>>  				 u64 root_objectid)
>>  {
>>  	int err;
>>  	int ret =3D 0;
>> -	struct prelim_ref *ref;
>> -	struct prelim_ref *ref_safe;
>> -	struct prelim_ref *new_ref;
>>  	struct ulist *parents;
>>  	struct ulist_node *node;
>>  	struct ulist_iterator uiter;
>> +	struct rb_node *rnode;
>> =20
>>  	parents =3D ulist_alloc(GFP_NOFS);
>>  	if (!parents)
>>  		return -ENOMEM;
>> =20
>>  	/*
>> -	 * _safe allows us to insert directly after the current item without=

>> -	 * iterating over the newly inserted items.
>> -	 * we're also allowed to re-assign ref during iteration.
>> +	 * We could trade memory usage for performance here by iterating
>> +	 * the tree, allocating new refs for each insertion, and then
>> +	 * freeing the entire indirect tree when we're done.  In some test
>> +	 * cases, the tree can grow quite large (~200k objects).
>>  	 */
>> -	list_for_each_entry_safe(ref, ref_safe, head, list) {
>> -		if (ref->parent)	/* already direct */
>> -			continue;
>> -		if (ref->count =3D=3D 0)
>> +	while ((rnode =3D rb_first(&preftrees->indirect.root))) {
>> +		struct prelim_ref *ref;
>> +
>> +		ref =3D rb_entry(rnode, struct prelim_ref, rbnode);
>> +		if (WARN(ref->parent,
>> +			 "BUG: direct ref found in indirect tree")) {
>=20
> Is this meant as an assertion or do you expect this could also happen
> during normal operation?

This one was mine.

It's not meant to be countered in normal operation, but I've been trying
to (and not always succeeding at) taking Linus's advice about gracefully
recovering from errors rather than crashing.  Our other two tools are
BUG_ON, which will crash the kernel or ASSERT, which will crash the
kernel only if the check is enabled and happily break otherwise.
> Overall, the patch appears big but I don't see a good way to split it,
> only to introduce the helpers separately, not much else seems to be
> independent.

Is that a request to split the helpers out or an observation that doing
so would be the only reason to make it smaller?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--enxnqSccpO4e8B6PxN1IughSDXGAI41hr--

--aAalbSasA0Ih7UpMc29rRxBbnS5O8l9Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWVLJ4x57S2MheeWyAQiX0g//b87HYfs/beI3ZCwMhtuLIg9EPrcxVV+9
piHQX1bCoes0V8Ij1A05BEK1c9VaqIccelZ/7fqIkRuaDPDzSiOyaFGBNbTai0b1
ovFWnflz7QCJPi3jU4cv5z0eBnWVJ0axH/spfhtwW2yw9fb4GBGxQH4CMFcLsaKm
tJwREYHg76Y5tfvFk4D2cqC1WNL55pwsu4K2EAbEGCQr8tWdbxQjULGIo90UaAfz
I1PXqrX4jknQ5bsovGhHvnOilc5449EaNNWEqdRL/D04Fttg2LRmHvsi3bsYCj3y
PPE0aoB2BzMj/uQFgPcJfwK4rwftytY9OrXGXtBc3cp+CizvI4ajCA2xQnVFoV4t
yjBygXb7CB3FEH1mA1tnuU5Fh7XnCq+st1A8wbwy7hHd2Zx/YiVNlmR+o9udkySu
QvYaznEEcqmhxNf0ChcL3oJkuvGQqyqrcYnZWErgCPDFE+2HHJOVH1SHdfTTXqup
CUzwYCTFsDR08BcxHb6d+7U8uT05auq9EXKHXswnawaS1cEF/Ri8rXATiMdpBSfB
FnvGldj5o3+WUzt2Uldj+cKb+TxBbYIKk5udPYUMSvqeEhJ/JWlZK2sCtwu806Qo
0zJw6iuyHQ6Risi2qHK7hwJI5c3NYucFC3MDNNOYfyCqmm9srQF6gYo69UdMTopQ
adUIUVixmuQ=
=Tmcy
-----END PGP SIGNATURE-----

--aAalbSasA0Ih7UpMc29rRxBbnS5O8l9Dt--
