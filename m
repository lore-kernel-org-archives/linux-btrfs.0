Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:38423 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbeCOBCn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 21:02:43 -0400
Subject: Re: [PATCH] btrfs: Verify extent allocated by find_free_extent()
 won't overlap with extents from previous transaction
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180213011332.13287-1-wqu@suse.com>
 <20180314210929.GU32007@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <278a00f5-09aa-a261-29f4-9676820beb87@gmx.com>
Date: Thu, 15 Mar 2018 09:02:28 +0800
MIME-Version: 1.0
In-Reply-To: <20180314210929.GU32007@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YZMxLyOwe0r6RvKJR9myC930GVMB9KRqq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YZMxLyOwe0r6RvKJR9myC930GVMB9KRqq
Content-Type: multipart/mixed; boundary="PvZPJxiSQdgI3xWLI3kLX25MDX9ifvaOO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <278a00f5-09aa-a261-29f4-9676820beb87@gmx.com>
Subject: Re: [PATCH] btrfs: Verify extent allocated by find_free_extent()
 won't overlap with extents from previous transaction
References: <20180213011332.13287-1-wqu@suse.com>
 <20180314210929.GU32007@twin.jikos.cz>
In-Reply-To: <20180314210929.GU32007@twin.jikos.cz>

--PvZPJxiSQdgI3xWLI3kLX25MDX9ifvaOO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8815=E6=97=A5 05:09, David Sterba wrote:
> On Tue, Feb 13, 2018 at 09:13:32AM +0800, Qu Wenruo wrote:
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
>=20
> I don't understand this, can you please clarify? It's not clear where
> does the (u64)-1 come from.

Sorry, left over comment.
The original search key is using (u64)-1.


>=20
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
>=20
> The sanity tests are run at module load time, but the new check you are=

> adding is a runtime one, so I think the right ifdef is
> CONFIG_BTRFS_DEBUG.

I'll use CONFIG_BTRFS_DEBUG.

But the patch is causing rcu problems under heavy load, so I'm afraid it
is not suitable to be merged.

Please discard this until I found a solution to the RCU problem.

Thanks,
Qu

>=20
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


--PvZPJxiSQdgI3xWLI3kLX25MDX9ifvaOO--

--YZMxLyOwe0r6RvKJR9myC930GVMB9KRqq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqpxiQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjk5ggAhAJZbBto5guBoxX5TINgrnUp
apAK7kaHdXKyXCkiUQPZUQXk1HwLD51O8NwXj5hnMNAfDoRAE7cYJhNMiySYmM3m
ULnOParE42l/jL/eOkO8qWSzBe6dJK5XmCt0YbokpGLBiz8dFe8zLocetY07hP5G
xnPmS4LzjXIfZt2r5DYZRfQVJLxa8selSC/F4iwjsSMAiXZl/WGPwE0c2ANnz9nH
4PwoCjSEIz3/J6Kd5F+UEU/4/DVDttlGol6bTMZNEG7ZpMk2st33SveXjmpxPjYn
mR/dpIm8IImAwvH2r4NzJgf8mV9vld1LJCAQhMa+ZYunSAMeq0/5CLJs3897OA==
=bc/0
-----END PGP SIGNATURE-----

--YZMxLyOwe0r6RvKJR9myC930GVMB9KRqq--
