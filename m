Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:48111 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbeHIIhq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 04:37:46 -0400
Subject: Re: [PATCH v4] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1c76deaf-af9b-7c8c-e100-058d67f40fb5@gmx.com>
 <e5f6227a-cb6d-94e9-912a-60736499fd8b@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <da63c4e5-5cb0-d608-aca1-62d95f26f110@gmx.com>
Date: Thu, 9 Aug 2018 14:14:10 +0800
MIME-Version: 1.0
In-Reply-To: <e5f6227a-cb6d-94e9-912a-60736499fd8b@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="13p37F4oLo3JXQZoUScbGMC3atFlgVvaA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--13p37F4oLo3JXQZoUScbGMC3atFlgVvaA
Content-Type: multipart/mixed; boundary="JBzJ8MBl8icVHmpgL2CXDbE2R2WzHwU5H";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <da63c4e5-5cb0-d608-aca1-62d95f26f110@gmx.com>
Subject: Re: [PATCH v4] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1c76deaf-af9b-7c8c-e100-058d67f40fb5@gmx.com>
 <e5f6227a-cb6d-94e9-912a-60736499fd8b@jp.fujitsu.com>
In-Reply-To: <e5f6227a-cb6d-94e9-912a-60736499fd8b@jp.fujitsu.com>

--JBzJ8MBl8icVHmpgL2CXDbE2R2WzHwU5H
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/9/18 2:05 PM, Misono Tomohiro wrote:
> On 2018/08/09 14:47, Qu Wenruo wrote:
>>
>>
>> On 8/9/18 12:12 PM, Misono Tomohiro wrote:
>>> When qgroup is on, subvolume deletion does not remove qgroup items
>>> of the subvolume (qgroup info, limit, relation) from quota tree and
>>> they need to get removed manually by "btrfs qgroup destroy".
>>>
>>> Since level 0 qgroup cannot be used/inherited by any other subvolume,=

>>> let's remove them automatically when subvolume is deleted
>>> (to be precise, when the subvolume root is dropped).
>>>
>>> Note that qgroup becomes inconsistent in following case:
>>>   1. qgroup relation exists
>>>   2. and subvolume's excl !=3D rref
>>
>> That's a little strange.
>>
>> If a subvolume is completely dropped, its excl should be the same rfer=
,
>> all 0, and removing its relationship should not mark qgroup inconsiste=
nt.
>>
>> So the problem is the timing when btrfs_remove_qgroup() is called.
>>
>> Since qgroup accounting is only called at transaction commit time, and=

>> we're holding a trans handler, it's almost ensured we can't commit thi=
s
>> transaction, thus the number is not updated yet (still not 0)
>>
>> So that's why qgroup is inconsistent.
>>
>> What about commit current transaction and then call btrfs_remove_qgrou=
p()?
>>
>> (Sorry I didn't catch this problem last time I reviewed this patch)
>=20
> well, I'm little confusing about flow of transaction commit.
> btrfs_drop_snapshot() is called from cleaner_kthread and
> is it ok to commit transaction in it?

Not completely clear of the cleaner_kthread(), but from what I see in
btrfs_drop_snapshot(), btrfs_end_transaction_throttle() itself could
commit current transaction.

So in theory we should be OK to finish all the original work of
btrfs_drop_snapshot(), and then commit current transaction, and finally
do the qgroup cleanup work.

But I could totally be wrong, and feel free to point what I'm missing.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>> In this case manual qgroup rescan is needed.
>>>
>>> Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>> ---
>>> Hi David,
>>> It turned out that this patch may cause qgroup inconsistency in case
>>> described above and need manual rescan. Since current code will keep =

>>> qgroup items but not break qgroup consistency when deleting subvolume=
,
>>> I cannot clearly say which behavior is better for qgroup usability.
>>> Can I ask your opinion?
>>>
>>> v3 -> v4:
>>>   Check return value of btrfs_remove_qgroup() and if it is 1,
>>>   print message in syslog that fs needs qgroup rescan
>>>
>>>  fs/btrfs/extent-tree.c | 22 ++++++++++++++++++----
>>>  1 file changed, 18 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 9e7b237b9547..828d9e68047d 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *ro=
ot,
>>>  	struct btrfs_root_item *root_item =3D &root->root_item;
>>>  	struct walk_control *wc;
>>>  	struct btrfs_key key;
>>> +	u64 objectid =3D root->root_key.objectid;
>>>  	int err =3D 0;
>>>  	int ret;
>>>  	int level;
>>>  	bool root_dropped =3D false;
>>> =20
>>> -	btrfs_debug(fs_info, "Drop subvolume %llu", root->objectid);
>>> +	btrfs_debug(fs_info, "Drop subvolume %llu", objectid);
>>> =20
>>>  	path =3D btrfs_alloc_path();
>>>  	if (!path) {
>>> @@ -9030,7 +9031,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>>>  		goto out_end_trans;
>>>  	}
>>> =20
>>> -	if (root->root_key.objectid !=3D BTRFS_TREE_RELOC_OBJECTID) {
>>> +	if (objectid !=3D BTRFS_TREE_RELOC_OBJECTID) {
>>>  		ret =3D btrfs_find_root(tree_root, &root->root_key, path,
>>>  				      NULL, NULL);
>>>  		if (ret < 0) {
>>> @@ -9043,8 +9044,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>>>  			 *
>>>  			 * The most common failure here is just -ENOENT.
>>>  			 */
>>> -			btrfs_del_orphan_item(trans, tree_root,
>>> -					      root->root_key.objectid);
>>> +			btrfs_del_orphan_item(trans, tree_root, objectid);
>>>  		}
>>>  	}
>>> =20
>>> @@ -9056,6 +9056,20 @@ int btrfs_drop_snapshot(struct btrfs_root *roo=
t,
>>>  		btrfs_put_fs_root(root);
>>>  	}
>>>  	root_dropped =3D true;
>>> +
>>> +	 /* Remove level-0 qgroup items since no other subvolume can use th=
em */
>>> +	ret =3D btrfs_remove_qgroup(trans, objectid);
>>> +	if (ret =3D=3D 1) {
>>> +		/* This means qgroup becomes inconsistent by removing items */
>>> +		btrfs_info(fs_info,
>>> +		    "qgroup inconsistency found, need qgroup rescan");
>>> +	} else if (ret =3D=3D -EINVAL || ret =3D=3D -ENOENT) {
>>> +		/* qgroup is not enabled or already removed, just ignore this */
>>> +	} else if (ret) {
>>> +		btrfs_abort_transaction(trans, ret);
>>> +		err =3D ret;
>>> +	}
>>> +
>>>  out_end_trans:
>>>  	btrfs_end_transaction_throttle(trans);
>>>  out_free:
>>>
>>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--JBzJ8MBl8icVHmpgL2CXDbE2R2WzHwU5H--

--13p37F4oLo3JXQZoUScbGMC3atFlgVvaA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltr27IACgkQwj2R86El
/qgtFggAlpi8TLxJFayXtejBhAkvtjhrTSyJIvl1B22vfeVcqcUCFvM7Wy6/UfNq
N1OZgCDnqE49J8aaOHs3ugv4TWzBZQ4rUyhKqXzF5zP5c5CGIGMctZf+wZemkva3
ReF1hotUX3xBqTTVg+XbXbZz6f4OOYu7m3tPAGm1VpOYrXZBt91LFb0it6Y6uYcj
nNAC85lX0spBnL+apG2T6Y48L0J+LhY8sVPz/E4CY9l10oAtR3/ZK/tDDFagg32o
dKG7IR0iDfySxllt5WuX8OtGnDA1Q104G6bbb5QkKW2KhA4u+/wW9e9J4WG/2gys
YNwCrqLrb0qU0tuCysFObiP44mkxjw==
=M/rY
-----END PGP SIGNATURE-----

--13p37F4oLo3JXQZoUScbGMC3atFlgVvaA--
