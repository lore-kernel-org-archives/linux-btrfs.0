Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09A0C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 641692086E
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:44:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 641692086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbeIZU5T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 16:57:19 -0400
Received: from mout.gmx.net ([212.227.15.15]:38483 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbeIZU5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 16:57:19 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MO7im-1gAfDs4C04-005WgO; Wed, 26
 Sep 2018 16:43:53 +0200
Subject: Re: [PATCH v3 4/7] btrfs: qgroup: Use generation aware subtree swap
 to mark dirty extents
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180911053818.10191-1-wqu@suse.com>
 <20180911053818.10191-5-wqu@suse.com> <20180926143504.GL3255@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <771e228a-a4f7-3e0d-fbbe-d175a79d7d52@gmx.com>
Date:   Wed, 26 Sep 2018 22:43:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180926143504.GL3255@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="npxOq19gYNbWPeiXoPCRToImu9yg1tMXI"
X-Provags-ID: V03:K1:L5zQr8cdoyv5wW8Y19OLWgQxKZg4Kl5r2iaES8VhylqyRACcbAO
 CibbaYUtA3hoxAbXRKEqKeGthvlNaa1AJeN8rwt8k4WZGRvisQFPcrT2jYuvq8r8GDgV0HQ
 ZNAb6vAW7dyvipGkklen+PcXn5W2L1roQqB1eBXwtDTCqqDuW/8lHQDoUnWRp5fzLEmbMXm
 AGGMfvWfnMNLq28YrRlJQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Wjw2CvSM+M4=:o9dEcXZPGVzjEabirCaGnj
 PQ5LH8M2fd3iqUu4t3T2CkUG45iOzC/gaaLijx233oXMApMFVJJUA6/M1zDyc6dkW3N05E2hf
 WGkOvj5y8wolmXXiBfnzsy/Oee3Q1FXJh4JWmdePh44H1L8QYEdtWebki727trbrscRmfXckG
 O5eUWQ1CzPY1uIhPWXn00cCvNa8lTRb6Fxf87EYZerfK0wv2fh7cCfh406k+f5Kag8rO5JMbX
 wbzyUQh1ljQuGVaM9DFYCI4SB1VaQ8BkZHUstcyZJgexVt68/yabaue4XDyt8ZuRbMByMdjEh
 cDQCPCWz+44At0db2sRg1G8mMP3QjlGWiOnIKJgq5A0uiW7gnAnNeo+uhsKQ5YFnpFVxpkiU/
 tHnpIMtSpILR7o2gBlTNHvdYgdIewTWYGjGnvUAB44WWhIad89vJx4SDYbyVuH7n1XDYN8scm
 OZDGMHjo+ErpiNkJCgvRE2MhoWr46B5XwWJhU+Hi6YellvO7Pql6RLLPy6ZLIRTdOKRSL+osW
 VkgDM5kHA3JAHRuIzTQSUQa7Ubmv9DlEp8o81PRQmPnfF6Ik6EohrRAt3WmtbFKPzbqDuknjd
 4Mxw7mMzxtR3kZGX/tnx9U6+0sm5+fctAY5mZb4NIMdLIl5lxpGt5txBMEn69epVJGpDsRB0a
 CXJkqRzp7svhVMrUHRCRu9EI2dpKkiaQB67txjnbk0nrD8MFx6OTP9IG1WwlkFh+53C50eMUS
 XcEHFvj1YOobshTrSTxHdv60fU4L2AoSe3vsVAQr3Rgy9j0LQQou4FIoDVHXjsDt4D3IBcmEv
 ZpgsfJ9mWETvx8k5nV01A/Vpv5czw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--npxOq19gYNbWPeiXoPCRToImu9yg1tMXI
Content-Type: multipart/mixed; boundary="vbLD5DUCBfEqMkEJOtPyJmwxm2zbZBYx4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <771e228a-a4f7-3e0d-fbbe-d175a79d7d52@gmx.com>
Subject: Re: [PATCH v3 4/7] btrfs: qgroup: Use generation aware subtree swap
 to mark dirty extents
References: <20180911053818.10191-1-wqu@suse.com>
 <20180911053818.10191-5-wqu@suse.com> <20180926143504.GL3255@twin.jikos.cz>
In-Reply-To: <20180926143504.GL3255@twin.jikos.cz>

--vbLD5DUCBfEqMkEJOtPyJmwxm2zbZBYx4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/26 =E4=B8=8B=E5=8D=8810:35, David Sterba wrote:
> On Tue, Sep 11, 2018 at 01:38:15PM +0800, Qu Wenruo wrote:
>> Before this patch, for quota enabled balance, btrfs needs to mark the
>> whole subtree dirty for quota.
>>
>> E.g.
>> OO =3D Old tree blocks (from file tree)
>> NN =3D New tree blocks (from reloc tree)
>>
>>         File tree (src)		          Reloc tree (dst)
>>             OO (a)                              NN (a)
>>            /  \                                /  \
>>      (b) OO    OO (c)                    (b) NN    NN (c)
>>         /  \  /  \                          /  \  /  \
>>        OO  OO OO OO (d)                    OO  OO OO NN (d)
>>
>> For old balance + quota case, quota will mark the whole src and dst tr=
ee
>> dirty, including all the 3 old tree blocks in reloc tree.
>>
>> It's doable for small file tree or new tree blocks are all
>> located at lower level.
>>
>> But for large file tree or new tree blocks are all located at higher
>> level, this will lead to mark the whole tree dirty, and be unbelievabl=
y
>> slow.
>>
>> This patch will change how we handle such balance with quota enabled
>> case.
>>
>> Now we will search from (b) and (c) for any new tree blocks whose gene=
ration
>> is equal to @last_snapshot, and only mark them dirty.
>>
>> In above case, we only need to trace tree blocks NN(b), NN(c) and NN(d=
).
>> (NN(a) will be traced when CoW happens for nodeptr modification).
>> And also for tree blocks OO(b), OO(c), OO(d). (OO(a) will be traced wh=
en
>> CoW happens for nodeptr modification)
>>
>> For above case, we could skip 3 tree blocks, but for larger tree, we c=
an
>> skip tons of unmodified tree blocks, and hugely speed up balance.
>>
>> This patch will introduce a new function,
>> btrfs_qgroup_trace_subtree_swap(), which will do the following main
>> work:
>>
>> 1) Read out real root eb
>>    And setup basic dst_path for later calls
>> 2) Call qgroup_trace_new_subtree_blocks()
>>    To trace all new tree blocks in reloc tree and their counter
>>    parts in file tree.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c     | 94 ++++++++++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/qgroup.h     | 10 +++++
>>  fs/btrfs/relocation.c | 11 ++---
>>  3 files changed, 107 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 0702953d70a7..a94027b2620e 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1953,6 +1953,100 @@ static int qgroup_trace_new_subtree_blocks(str=
uct btrfs_trans_handle* trans,
>>  	return ret;
>>  }
>> =20
>> +/*
>> + * For balance subtree swap.
>> + *
>> + * Will go down the tree block pointed by @dst_eb (pointed by @dst_pa=
rent and
>> + * @dst_slot), and find any tree blocks whose generation is at @last_=
snapshot,
>> + * and then go down @src_eb (pointed by @src_parent and @src_slot) to=
 find
>> + * the conterpart of the tree block, then mark both tree blocks as qg=
roup dirty,
>> + * and skip all tree blocks whose generation is smaller than last_sna=
pshot.
>> + *
>> + * This would skip tons of tree blocks of original btrfs_qgroup_trace=
_subtree(),
>> + * which is the culprit of super slow balance if the file tree is lar=
ge.
>> + *
>> + * @src_parent, @src_slot: pointer to src (file tree) eb.
>> + * @dst_parent, @dst_slot: pointer to dst (tree reloc tree) eb.
>> + */
>> +int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,=

>> +				struct extent_buffer *src_parent, int src_slot,
>> +				struct extent_buffer *dst_parent, int dst_slot,
>> +				u64 last_snapshot)
>> +{
>> +	struct btrfs_fs_info *fs_info =3D trans->fs_info;
>> +	struct btrfs_path *dst_path =3D NULL;
>> +	struct btrfs_key first_key;
>> +	struct extent_buffer *src_eb =3D NULL;
>> +	struct extent_buffer *dst_eb =3D NULL;
>> +	u64 child_gen;
>> +	u64 child_bytenr;
>> +	int level;
>> +	int ret;
>> +
>> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
>> +		return 0;
>> +
>> +	/* Wrong parameter order */
>> +	BUG_ON(btrfs_node_ptr_generation(src_parent, src_slot) >
>> +		btrfs_node_ptr_generation(dst_parent, dst_slot));
>=20
> If this is to catch errors development-time errors, then an ASSERT is
> probably better, but it looks like this needs to be an ordinary runtime=

> sanity check too.

For runtime check, it's already done before entering real relocation code=
=2E

Relocation will check tree generation before really doing the swap.

So it is a development time error.

>=20
>> +
>> +	/* Read out real @src_eb, pointed by @src_parent and @src_slot */
>> +	child_bytenr =3D btrfs_node_blockptr(src_parent, src_slot);
>> +	child_gen =3D btrfs_node_ptr_generation(src_parent, src_slot);
>> +	btrfs_node_key_to_cpu(src_parent, &first_key, src_slot);
>> +
>> +	src_eb =3D read_tree_block(fs_info, child_bytenr, child_gen,
>> +			btrfs_header_level(src_parent) - 1, &first_key);
>> +	if (IS_ERR(src_eb)) {
>> +		ret =3D PTR_ERR(src_eb);
>> +		goto out;
>> +	}
>> +
>> +	/* Read out real @dst_eb, pointed by @src_parent and @src_slot */
>> +	child_bytenr =3D btrfs_node_blockptr(dst_parent, dst_slot);
>> +	child_gen =3D btrfs_node_ptr_generation(dst_parent, dst_slot);
>> +	btrfs_node_key_to_cpu(dst_parent, &first_key, dst_slot);
>> +
>> +	dst_eb =3D read_tree_block(fs_info, child_bytenr, child_gen,
>> +			btrfs_header_level(dst_parent) - 1, &first_key);
>> +	if (IS_ERR(dst_eb)) {
>> +		ret =3D PTR_ERR(dst_eb);
>> +		goto out;
>> +	}
>> +
>> +	if (!extent_buffer_uptodate(src_eb) || !extent_buffer_uptodate(dst_e=
b)) {
>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	level =3D btrfs_header_level(dst_eb);
>> +	dst_path =3D btrfs_alloc_path();
>> +	if (!dst_path) {
>> +		ret =3D -ENOMEM;
>> +		goto out;
>> +	}
>> +	/* For dst_path */
>> +	extent_buffer_get(dst_eb);
>> +	dst_path->nodes[level] =3D dst_eb;
>> +	dst_path->slots[level] =3D 0;
>> +	dst_path->locks[level] =3D 0;
>> +
>> +	/* Do the generation aware breadth-first search */
>> +	ret =3D qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, lev=
el,
>> +					      level, last_snapshot);
>> +	if (ret < 0)
>> +		goto out;
>> +	ret =3D 0;
>> +
>> +out:
>> +	free_extent_buffer(src_eb);
>> +	free_extent_buffer(dst_eb);
>> +	btrfs_free_path(dst_path);
>> +	if (ret < 0)
>> +		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>> +	return ret;
>> +}
>> +
>>  int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
>>  			       struct extent_buffer *root_eb,
>>  			       u64 root_gen, int root_level)
>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>> index 54b8bb282c0e..9f9943dfd493 100644
>> --- a/fs/btrfs/qgroup.h
>> +++ b/fs/btrfs/qgroup.h
>> @@ -236,6 +236,16 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_tr=
ans_handle *trans,
>>  int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
>>  			       struct extent_buffer *root_eb,
>>  			       u64 root_gen, int root_level);
>> +
>> +/*
>> + * Inform qgroup to trace subtree swap used in balance.
>> + * Unlike btrfs_qgroup_trace_subtree(), this function will only trace=

>> + * new tree blocks whose generation is equal to (or larger than) @las=
t_snapshot.
>> + */
>> +int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,=

>> +				struct extent_buffer *src_parent, int src_slot,
>> +				struct extent_buffer *dst_parent, int dst_slot,
>> +				u64 last_snapshot);
>=20
> I've noticed that qgroup.h contains the function comments, but it's
> preferred to have them in the .c file, next to the code. Please move it=

> and feel free to send patch moving the rest.

A new code style learned.

Will update the patchset to reflect this comment.

Thanks,
Qu

>=20
>>  int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64=
 bytenr,
>>  				u64 num_bytes, struct ulist *old_roots,
>>  				struct ulist *new_roots);
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 8783a1776540..07ab61a740ae 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -1879,14 +1879,9 @@ int replace_path(struct btrfs_trans_handle *tra=
ns,
>>  		 *    and tree block numbers, if current trans doesn't free
>>  		 *    data reloc tree inode.
>>  		 */
>> -		ret =3D btrfs_qgroup_trace_subtree(trans, parent,
>> -				btrfs_header_generation(parent),
>> -				btrfs_header_level(parent));
>> -		if (ret < 0)
>> -			break;
>> -		ret =3D btrfs_qgroup_trace_subtree(trans, path->nodes[level],
>> -				btrfs_header_generation(path->nodes[level]),
>> -				btrfs_header_level(path->nodes[level]));
>> +		ret =3D btrfs_qgroup_trace_subtree_swap(trans, parent, slot,
>> +				path->nodes[level], path->slots[level],
>> +				last_snapshot);
>>  		if (ret < 0)
>>  			break;
>> =20
>> --=20
>> 2.18.0


--vbLD5DUCBfEqMkEJOtPyJmwxm2zbZBYx4--

--npxOq19gYNbWPeiXoPCRToImu9yg1tMXI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlurmx8ACgkQwj2R86El
/qjmjQf9HJoJ/6FjS3SFMCM+gdTwzqXPPirnRMFlScnFBuTLjtayZGCaTJ5v/0md
lSJGIoLVxT30/7Qzt/M0BdQIN5YZHXf+lqyD1iRZqEnM3CFxyHNfIs/BpkuFvHkS
oFn+mZrHxoOb72PC9k1X4zsaUV8061jlAdx5Enjq5FUcOlUoC5IyvFxRMgfa/ter
6GF9DVpwIUkCcdOo8thqiyF+kFdnBY6rRw0Ku8RfKqLHj41Tk9GdI2SJSSntv7Ta
1O+BD9bWLhKevXMSHFfLurmT04/OgbWtNBiwMiPdlhHmauUmxt/o80zeum7eD4fP
9EQsvutWPzVfKzlc1G/l7otUmGV4fQ==
=4WhJ
-----END PGP SIGNATURE-----

--npxOq19gYNbWPeiXoPCRToImu9yg1tMXI--
