Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:35469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933631AbeBMIfX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 03:35:23 -0500
Subject: Re: [PATCH] btrfs: Verify extent allocated by find_free_extent()
 won't overlap with extents from previous transaction
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180213011332.13287-1-wqu@suse.com>
 <9fe4ab5f-d066-55e2-23f8-4037e63a5343@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56bb5172-1058-9768-e928-6b8f3d9cbb7b@gmx.com>
Date: Tue, 13 Feb 2018 16:35:06 +0800
MIME-Version: 1.0
In-Reply-To: <9fe4ab5f-d066-55e2-23f8-4037e63a5343@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L5JQkgYl0QMlpBA8c4mZkQdgY6vtXSHGr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L5JQkgYl0QMlpBA8c4mZkQdgY6vtXSHGr
Content-Type: multipart/mixed; boundary="uAttRRqbbCwLDTLyd2MTf9pFGAe31CBUs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <56bb5172-1058-9768-e928-6b8f3d9cbb7b@gmx.com>
Subject: Re: [PATCH] btrfs: Verify extent allocated by find_free_extent()
 won't overlap with extents from previous transaction
References: <20180213011332.13287-1-wqu@suse.com>
 <9fe4ab5f-d066-55e2-23f8-4037e63a5343@suse.com>
In-Reply-To: <9fe4ab5f-d066-55e2-23f8-4037e63a5343@suse.com>

--uAttRRqbbCwLDTLyd2MTf9pFGAe31CBUs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 15:20, Nikolay Borisov wrote:
>=20
>=20
> On 13.02.2018 03:13, Qu Wenruo wrote:
>> There are reports in mail list, even with latest mainline kernel, btrf=
s
>> can't survive a power loss.
>>
>> Unlike journal based filesystem, btrfs doesn't use journal for such
>> work. (log tree is an optimization for fsync, not to keep fs healthy)
>> In btrfs we use metadata CoW to ensure all tree blocks are as atomic a=
s
>> superblock.
>>
>> This leads to an obvious assumption, some code breaks such metadata Co=
W
>> makes btrfs no longer bullet-proof against power loss.
>>
>> This patch adds extra runtime selftest to find_free_extent(), which
>> will check the range in commit root of extent tree to ensure there is =
no
>> overlap at all.
>>
>> And hopes this could help us to catch the cause of the problem.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Unfortunately, no new problem exposed yet.
>> ---
>>  fs/btrfs/extent-tree.c | 118 ++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  1 file changed, 118 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 2f4328511ac8..3b3cd82bce3a 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7458,6 +7458,114 @@ btrfs_release_block_group(struct btrfs_block_g=
roup_cache *cache,
>>  	btrfs_put_block_group(cache);
>>  }
>> =20
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +/*
>> + * Verify if the given extent range [@start, @start + @len) conflicts=
 any
>> + * existing extent in commit root.
>> + *
>> + * Btrfs doesn't use journal, but depends on metadata (and data) CoW =
to keep
>> + * the whole filesystem consistent against powerloss.
>> + * If we have overwritten any extent used by previous trans (commit r=
oot),
>> + * and powerloss happen we will corrupt our filesystem.
>=20
> Currently do we know if the corruption is caused due to extent overlap
> or some other subtle bug?

No direct evidence yet.

But some strange behavior like valid tree block but wrong level (parent
level is 1, leave level is still 1, but otherwise completely valid)
happens after power loss.

And I strongly suspect transid error after powerloss can be related to th=
is.

Overwriting commit root is just one possible cause.
This patch is just trying to catch some clue.

I am also working on new test case using dm-flakey and dm-log to try to
create some crazy powerloss test case to try to reproduce it.

> I.e is there a guarnteee that this self-check
> should trigger?

No guarantee yet.

But at least for normal tree allocation and new data extent allocation,
it is going through such call chain and should trigger this self-check:

For tree allocation:

btrfs_alloc_tree_block()
|- btrfs_reserve_extent()
   |- find_free_extent()
      |- check_extent_conflicts()

For data extent, there are several cases:

For prealloc
btrfs_prealloc_file_range() or btrfs_prealloc_file_range_trans()
|- __btrfs_prealloc_file_range()
   |- btrfs_reserve_extent()

For data CoW:
cow_file_range()
|- btrfs_reserve_extent()

For compression:
submit_compressed_extents()
|- btrfs_reserve_extent()

For direct:
btrfs_new_extent_direct()
|- btrfs_reserve_extent()

So btrfs_reserve_extent() should be a quite good entry point, although
I'm still not 100% sure if there is any other case which could reserve
extent without calling btrfs_reserve_extent()

If we could found that, it may be the cause.

Thanks,
Qu
>=20
>> + *
>> + * Return 0 if nothing wrong.
>> + * Return <0 (including ENOMEM) means we have something wrong.
>> + * Except NOEMEM, this normally means we have extent conflicts with p=
revious
>> + * transaction.
>> + */
>> +static int check_extent_conflicts(struct btrfs_fs_info *fs_info,
>> +				  u64 start, u64 len)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_path *path;
>> +	struct btrfs_root *extent_root =3D fs_info->extent_root;
>> +	u64 extent_start;
>> +	u64 extent_len;
>> +	int ret;
>> +
>> +	path =3D btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +
>> +	key.objectid =3D start + len;
>> +	key.type =3D 0;
>> +	key.offset =3D 0;
>> +
>> +	/*
>> +	 * Here we use extent commit root to search for any conflicts.
>> +	 * If extent commit tree is already overwritten, we will get transid=

>> +	 * error and error out any way.
>> +	 * If extent commit tree is OK, but other extent conflicts, we will
>> +	 * find it.
>> +	 * So anyway, such search should be OK to find the conflicts.
>> +	 */
>> +	path->search_commit_root =3D true;
>> +	ret =3D btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
>> +
>> +	if (ret < 0)
>> +		goto out;
>> +	/* Impossible as no type/offset should be (u64)-1 */
>> +	if (ret =3D=3D 0) {
>> +		ret =3D -EUCLEAN;
>> +		goto out;
>> +	}
>> +	ret =3D btrfs_previous_extent_item(extent_root, path, start);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (ret =3D=3D 0) {
>> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +		extent_start =3D key.objectid;
>> +		if (key.type =3D=3D BTRFS_EXTENT_ITEM_KEY)
>> +			extent_len =3D key.offset;
>> +		else
>> +			extent_len =3D fs_info->nodesize;
>> +		goto report;
>> +	}
>> +	/*
>> +	 * Even we didn't found extent starts after @start, we still need to=

>> +	 * ensure previous extent doesn't overlap with [@start, @start + @le=
n)
>> +	 */
>> +	while (1) {
>> +		extent_len =3D 0;
>> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +		if (key.type =3D=3D BTRFS_EXTENT_ITEM_KEY)
>> +			extent_len =3D key.offset;
>> +		else if (key.type =3D=3D BTRFS_METADATA_ITEM_KEY)
>> +			extent_len =3D fs_info->nodesize;
>> +
>> +		if (extent_len) {
>> +			if (extent_len + key.objectid <=3D start) {
>> +				ret =3D 0;
>> +				goto out;
>> +			}
>> +			extent_start =3D key.objectid;
>> +			goto report;
>> +		}
>> +		if (path->slots[0] =3D=3D 0) {
>> +			ret =3D btrfs_prev_leaf(extent_root, path);
>> +			if (ret > 0) {
>> +				ret =3D 0;
>> +				goto out;
>> +			}
>> +			if (ret < 0)
>> +				goto out;
>> +		} else {
>> +			path->slots[0]--;
>> +		}
>> +	}
>> +out:
>> +	btrfs_free_path(path);
>> +	return ret;
>> +report:
>> +	WARN(1,
>> +"broken CoW detected: old extent [%llu, %llu) new extent [%llu, %llu)=
\n",
>> +	     extent_start, extent_start + extent_len, start, start + len);
>> +	btrfs_free_path(path);
>> +	return -EEXIST;
>> +}
>> +#endif
>> +
>>  /*
>>   * walks the btree of allocated extents and find a hole of a given si=
ze.
>>   * The key ins is changed to record the hole:
>> @@ -7949,6 +8057,16 @@ static noinline int find_free_extent(struct btr=
fs_fs_info *fs_info,
>>  		spin_unlock(&space_info->lock);
>>  		ins->offset =3D max_extent_size;
>>  	}
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +	if (!ret) {
>> +		/*
>> +		 * Any extent allocated must not conflict with any extent in
>> +		 * commit root
>> +		 */
>> +		ret =3D check_extent_conflicts(fs_info, ins->objectid,
>> +					     ins->offset);
>> +	}
>> +#endif
>>  	return ret;
>>  }
>> =20
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--uAttRRqbbCwLDTLyd2MTf9pFGAe31CBUs--

--L5JQkgYl0QMlpBA8c4mZkQdgY6vtXSHGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCozoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjqKwf+MU569GJBqIBAHBOP0A6ozKZB
IlA6we6VGk6+ceeOQrNdalfXA0UEnwfG8kBTX4ciRCsh93vYneGaCwcjzDLT3arh
Lihcvnn2oX8OIB2JSOjjnNWXKVFqXP0MJ1OrPUiVkrkXGGxiunrDMy08aoOcZ9K9
0BEBvE8YGUYt/yEMfV5vROUtp+49pXwS+O1JpPcy6pcSLHbWVF4eDvWeckJMcYJ1
6yijj+Wrf99QCI18I5PaeeMU7qJWA9IMP3+zeZeruJkruUiJMw3MG0ZZgDKVzAcO
gU40O/Qpdvhf3kEIRpllWQ9ytnxEnj3GyzH4jo8Yp1PAWS57h+D4JKp7qa+aUw==
=9PUH
-----END PGP SIGNATURE-----

--L5JQkgYl0QMlpBA8c4mZkQdgY6vtXSHGr--
