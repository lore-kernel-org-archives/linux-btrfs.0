Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49FBC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 12:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A182920818
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 12:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfBVMxc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:53:32 -0500
Received: from mout.gmx.net ([212.227.17.20]:48587 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfBVMxc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 07:53:32 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHrk1-1gtbYQ3Ger-003eK5; Fri, 22
 Feb 2019 13:53:20 +0100
Subject: Re: [PATCH 5/5] btrfs: extent_io: Unify the return value of
 btrfs_clone_extent_buffer() with alloc_extent_buffer()
To:     Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
 <20190222101645.4403-6-wqu@suse.com>
 <a0226a9c-d842-457d-240a-89d622476065@gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <a6f6ac7a-a77a-43af-9ead-6c0fd3014c60@gmx.com>
Date:   Fri, 22 Feb 2019 20:53:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <a0226a9c-d842-457d-240a-89d622476065@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TSVcte75Zvw1LFDIWJwJTJAkj7Xwpjz7n"
X-Provags-ID: V03:K1:8GxTTGON2a7wNkGMJs2bzqyJ+9dMK3o7loMZeeL9abN7BPXmZ2e
 tdGiVFTFIpwwCBcF/M74uPew3ay7DqX1pTExQ4tgh8g6ATKrRCPB5xBLep3wvLskTEYQQVc
 8QZlFBq6erv0M5hK/Mnmil5LBcV9QnPDHnPpxNNoDGmU1obbiaholrB/oYsa2v673Lt72fk
 IESFuSBbnJzhhG5IjzaRQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aQMvT3zvBXI=:h9o00bgDjHfdt8DLajcmUP
 EUp1L1fc2/ZDc7tt5qPH8u4eDrnUivKfqfiSu8cJwl3wz7mvkDSNjjsfEEAUSwOLdBpNc/lAm
 hf5fov2qJAOcc/Xbm2Px5GHSpiK7CRFIBnnyuHJsqrPigcnKmNacOukMVDEox9pbIFzhEvA0b
 6jECorMfo9ekNqxbCzWScUkyXzdMxWRuIm2GrbF/Yqhi/HW+GM3DPMk0tF6BKUb6wfQdjvN1n
 c1KxLG0ECVTGXDcY6WbX0NC1jFnO5m7onaQHoLZ8CBlEAbJkuy0ZD1BC3DEe2XraI2poa9eXV
 E9cunCKXY48YYzltWJ321mWRN7tXXKYZlwf+qJF0bApB2uPupMBo8mQy8cTC1pYXAdD9HkrHW
 iBy8OYZIwvR94k3h1bl2ERm6Pyy5hUISCp+mL0AVE/viurS1vVnJMO/Zrb6Pw08Axg2Fe907M
 ErFUeecZf+p4Gbv79AN0Bh0XRP8Nio2n9DhmOKNAOsy+0eiMlKUOO4WY1bZznO6/kJXsx52zd
 CwdS50klWLbSzmjxFZKcKt/FGF4+05xXy/0V0HUxj304IRbFoZzNDyqutRV/xLp/5JrA4CYNI
 sWfv/91c7AmrgYnxhaMgnyteDsZWi1YFjaqLlepeZx4XvXyNOuYlJFhjb/ApcbkHHxNu+yVio
 eAM+pU7X8qO36RrhoZQ20hyh5602xHEu0dXyG19zqkLHIP+uD6Yw63mZxoViTvOWalWRFDekQ
 yL1ldiP0iyrcVyB2biGndQgrdHY412fYp7Y+mC2HGqlhfvbDEnaMvbKTq8ACmQFUxwNvGBj0J
 KAl5HieIU/Ha2ZxGBgfGACjJNp7SmdksNoJeX8qdZ5qbeyg/giTqxW7vPvyjsIbluUnUzDTM2
 ADLw7lt/32ge2UrqHrLpLExiU+suTukwfHsFkLERQu9azzvjeri1VpXEWY944B
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TSVcte75Zvw1LFDIWJwJTJAkj7Xwpjz7n
Content-Type: multipart/mixed; boundary="Y77m44DqHMwwpAmTF0VFfFxBdJUA373dX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dan.carpenter@oracle.com
Message-ID: <a6f6ac7a-a77a-43af-9ead-6c0fd3014c60@gmx.com>
Subject: Re: [PATCH 5/5] btrfs: extent_io: Unify the return value of
 btrfs_clone_extent_buffer() with alloc_extent_buffer()
References: <20190222101645.4403-1-wqu@suse.com>
 <20190222101645.4403-6-wqu@suse.com>
 <a0226a9c-d842-457d-240a-89d622476065@gmail.com>
In-Reply-To: <a0226a9c-d842-457d-240a-89d622476065@gmail.com>

--Y77m44DqHMwwpAmTF0VFfFxBdJUA373dX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/22 =E4=B8=8B=E5=8D=888:47, Nikolay Borisov wrote:
>=20
>=20
> On 22.02.19 =D0=B3. 12:16 =D1=87., Qu Wenruo wrote:
>> The direct callers are:
>> 1) qgroup_rescan_leaf()
>> 2) btrfs_compare_trees()
>>    These two call sites are stubs.
>>
>> 3) tree_mod_log_rewind()
>> 4) get_old_root()
>>    These two doesn't follow the name pattern *_extent_buffer(), thus w=
e
>>    don't need to unify their return value.
>>    However for get_old_root(), all its eb assignment can no longer be
>>    NULL, change its IS_ERR_OR_NULL() to IS_ERR().
>>
>> 5) btrfs_search_slot_get_root()
>>    This is a stub. The only caller has already handled the return valu=
e.
>>
>> This patch should cover all the call sites of
>> btrfs_clone_extent_buffer().
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/backref.c   |  8 ++++----
>>  fs/btrfs/ctree.c     | 14 ++++++++------
>>  fs/btrfs/extent_io.c |  4 ++--
>>  fs/btrfs/qgroup.c    |  5 +++--
>>  4 files changed, 17 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 78556447e1d5..b6e469a12011 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -2016,8 +2016,8 @@ static int iterate_inode_refs(u64 inum, struct b=
trfs_root *fs_root,
>>  		parent =3D found_key.offset;
>>  		slot =3D path->slots[0];
>>  		eb =3D btrfs_clone_extent_buffer(path->nodes[0]);
>> -		if (!eb) {
>> -			ret =3D -ENOMEM;
>> +		if (IS_ERR(eb)) {
>> +			ret =3D PTR_ERR(eb);
>>  			break;
>>  		}
>>  		btrfs_release_path(path);
>> @@ -2075,8 +2075,8 @@ static int iterate_inode_extrefs(u64 inum, struc=
t btrfs_root *fs_root,
>> =20
>>  		slot =3D path->slots[0];
>>  		eb =3D btrfs_clone_extent_buffer(path->nodes[0]);
>> -		if (!eb) {
>> -			ret =3D -ENOMEM;
>> +		if (IS_ERR(eb)) {
>> +			ret =3D PTR_ERR(eb);
>>  			break;
>>  		}
>>  		btrfs_release_path(path);
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 3276b743f40a..ea7ff0012007 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -1384,7 +1384,7 @@ get_old_root(struct btrfs_root *root, u64 time_s=
eq)
>>  		free_extent_buffer(eb_root);
>>  	}
>> =20
>> -	if (IS_ERR_OR_NULL(eb))
>> +	if (IS_ERR(eb))
>>  		return NULL;
>>  	btrfs_tree_read_lock(eb);
>>  	if (old_root) {
>> @@ -2624,8 +2624,8 @@ static struct extent_buffer *btrfs_search_slot_g=
et_root(struct btrfs_root *root,
>>  			down_read(&fs_info->commit_root_sem);
>>  			b =3D btrfs_clone_extent_buffer(root->commit_root);
>>  			up_read(&fs_info->commit_root_sem);
>> -			if (!b)
>> -				return ERR_PTR(-ENOMEM);
>> +			if (IS_ERR(b))
>> +				return b;
>> =20
>>  		} else {
>>  			b =3D root->commit_root;
>> @@ -5431,7 +5431,8 @@ int btrfs_compare_trees(struct btrfs_root *left_=
root,
>>  			btrfs_clone_extent_buffer(left_root->commit_root);
>>  	if (!left_path->nodes[left_level]) {
>>  		up_read(&fs_info->commit_root_sem);
>> -		ret =3D -ENOMEM;
>> +		ret =3D PTR_ERR(left_path->nodes[left_level]);
>> +		left_path->nodes[left_level] =3D NULL;
>=20
> If we go into this branch this means left_path->nodes[left_level] was
> NULL. PTR_ERR of NULL is, well, NULL and then you also set the
> left_level to NULL. This is pointless...

Oh, previous "!left_path->nodes[left_level]" should be
"IS_ERR(left_path->nodes[left_level]".

That should explain all the problem.

Thanks,
Qu

>=20
>>  		goto out;
>>  	}
>> =20
>> @@ -5439,9 +5440,10 @@ int btrfs_compare_trees(struct btrfs_root *left=
_root,
>>  	right_root_level =3D right_level;
>>  	right_path->nodes[right_level] =3D
>>  			btrfs_clone_extent_buffer(right_root->commit_root);
>> -	if (!right_path->nodes[right_level]) {
>> +	if (IS_ERR(right_path->nodes[right_level])) {
>=20
> And here you do change the check to IS_ERR but only for the right_Path
> and not left path this introduces asymmetry which makes code harder to
> comprehend.
>=20
>>  		up_read(&fs_info->commit_root_sem);
>> -		ret =3D -ENOMEM;
>> +		ret =3D PTR_ERR(right_path->nodes[right_level]);
>> +		right_path->nodes[right_level] =3D NULL;
>>  		goto out;
>>  	}
>>  	up_read(&fs_info->commit_root_sem);
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index a19bd8bc3b32..dbdb649f1957 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4713,13 +4713,13 @@ struct extent_buffer *btrfs_clone_extent_buffe=
r(struct extent_buffer *src)
>> =20
>>  	new =3D __alloc_extent_buffer(src->fs_info, src->start, src->len);
>>  	if (IS_ERR(new))
>> -		return NULL;
>> +		return new;
>> =20
>>  	for (i =3D 0; i < num_pages; i++) {
>>  		p =3D alloc_page(GFP_NOFS);
>>  		if (!p) {
>>  			btrfs_release_extent_buffer(new);
>> -			return NULL;
>> +			return ERR_PTR(-ENOMEM);
>>  		}
>>  		attach_extent_buffer_page(new, p);
>>  		WARN_ON(PageDirty(p));
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 4e473a998219..ccfa992a10bf 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -3105,8 +3105,9 @@ static int qgroup_rescan_leaf(struct btrfs_trans=
_handle *trans,
>>  	fs_info->qgroup_rescan_progress.objectid =3D found.objectid + 1;
>> =20
>>  	scratch_leaf =3D btrfs_clone_extent_buffer(path->nodes[0]);
>> -	if (!scratch_leaf) {
>> -		ret =3D -ENOMEM;
>> +	if (IS_ERR(scratch_leaf)) {
>> +		ret =3D PTR_ERR(scratch_leaf);
>> +		scratch_leaf =3D NULL;
>>  		mutex_unlock(&fs_info->qgroup_rescan_lock);
>>  		goto out;
>>  	}
>>


--Y77m44DqHMwwpAmTF0VFfFxBdJUA373dX--

--TSVcte75Zvw1LFDIWJwJTJAkj7Xwpjz7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxv8LYACgkQwj2R86El
/qiQLQf+IYv6U08jELx4Kj5gnR3QVPd5N1zNFcy6/7os9OrFOKBirJj60aPDwBHw
C39q/Q73+DCMH186j9pxlHxqv5axaBI4B2KGr+8+ngDH8qg9fu902ugsOeFDHvKC
72/teL/Ik5lIjLABOWvbKJpiuNt1v+VhUIVFe/Ur4k5RS57z0WXy9VlrVas4l1Wm
7/KkrRIBtfPCK7s2XuqyClSXNOgrIyjUTkE7cQraWzkXIQQP7G6XCSfe8BMvac0x
KxL0GhL1E93xOrJ6mgkSG/Xsv6djq7BgJ523KNF17L2IYlk90eOAyEDw6rGNmXrd
cjKG6QvsJhGCB07dNRV7o5HrV/n7sA==
=/Cst
-----END PGP SIGNATURE-----

--TSVcte75Zvw1LFDIWJwJTJAkj7Xwpjz7n--
