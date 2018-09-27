Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23ABDC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 05:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6AE0206B6
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 05:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6AE0206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbeI0Lrr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 07:47:47 -0400
Received: from mout.gmx.net ([212.227.15.15]:56343 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbeI0Lrr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 07:47:47 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MUZKF-1gEv2C05cR-00RLIO; Thu, 27
 Sep 2018 07:31:11 +0200
Subject: Re: [PATCH v3 6/7] btrfs: delayed-ref: Introduce new parameter for
 btrfs_add_delayed_tree_ref() to reduce unnecessary qgroup tracing
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180911053818.10191-1-wqu@suse.com>
 <20180911053818.10191-7-wqu@suse.com> <20180926144018.GN3255@twin.jikos.cz>
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
Message-ID: <ccb5f13c-7b97-8f46-4466-8f81faacb713@gmx.com>
Date:   Thu, 27 Sep 2018 13:31:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180926144018.GN3255@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5qwz8cPWCJNxFPv35OFhkflYEEGQq3c6z"
X-Provags-ID: V03:K1:CmIZUY9pGaKxxjdNVSPCiguwm9UcNt5dAkyTEH+Oth2QIV/SNIV
 kHLaAXSegnRQjoU/VJVdF3zg3dxuQab6ebY3fl/oOgOUoXmlXLyIbNvC0fpwgV6pgIUHRG8
 OF+6KFyXWjvRtsnh1R/249AxvbWum3R/YZhXVMo+mVqRlRZ2yVnxG0jY8H6qWVeQ1U1fTFX
 oLSN5U5m1St+YQ4JLcccQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:LJsqVJnpMlI=:a4OlSpbz5E58/l+r+v8xI6
 uyry/lWFWeZGWr6CbkyH06c7ReJX2lIP1/FlNBm6qiOMs9y169EVpzFH8h+QdiP7Pu54Xq9a0
 JvUh8kBrtFglRhmLD8fXLYu4L9KPy6qVF375HQpvWnCQCD4ZsR4VrWTQotm+DNix/VPWBcbNy
 mXTglpZlC9nZmi8J2Z8jz3SydnVZ/YusmFeJ/RU9iOAJ6JUohfhm5cEMLN9sfqNoyfCFQ4nmb
 zDra9NlLV5f8L4WuM4XkEFcs1doSVKl7iUHVwnSMuqUfEHjhnpuTtW0VvDNGJYw51ndQL8pyj
 jR79noJbXai2b0/ESJ9ViARRxdSQxQv7OgWx+09mjgfLLIB4n4nX6OgM92+KSUB4KUuTQXP9I
 C4FIOCNpalTvzzSLVRwHRvDV5A+ZUHoToztbK3Kv5p0YnXvdTot4U4uWy9Fni3l7HdCpeURt/
 DZmORwZsSh7rhP14cfy/gs85d+LY7LPsMGmCHXMSWxGzYK8829f6NHmJt/7fLWzdUrCkntPJr
 f8IhSLUifqExO+S26GMLoVWB0TBI6Sz0Q4up+02gK9hZZWLvAoRbkFbLCkoI+DtAtNu0ay1Tj
 uGNgKl2M3c7NMpGUjOs6+O3yA1q4/MSg4pjw17upZ3WNHJ/RF2xyjwFI+sQmKStWd+Mfdgfth
 kcUjyA0/IKNj0L0UYGh3OMWgACluR6kvI8qpEcTnhgDjILtszMexKD+w/l78Qt8Hmiy40z5B9
 z3JYPbQpyfd/Une6phkHfc/rhk3d/x79YWXV2yuZzWtOWbOFMm2OV/I6AvDupjE1szsZIp1NM
 9LeX/OzQOlMHmsd2kXvxbQK+TgpxQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5qwz8cPWCJNxFPv35OFhkflYEEGQq3c6z
Content-Type: multipart/mixed; boundary="EC5hTEHHI8OwhEfNXDTSVdHmZvpX75NP8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ccb5f13c-7b97-8f46-4466-8f81faacb713@gmx.com>
Subject: Re: [PATCH v3 6/7] btrfs: delayed-ref: Introduce new parameter for
 btrfs_add_delayed_tree_ref() to reduce unnecessary qgroup tracing
References: <20180911053818.10191-1-wqu@suse.com>
 <20180911053818.10191-7-wqu@suse.com> <20180926144018.GN3255@twin.jikos.cz>
In-Reply-To: <20180926144018.GN3255@twin.jikos.cz>

--EC5hTEHHI8OwhEfNXDTSVdHmZvpX75NP8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/26 =E4=B8=8B=E5=8D=8810:40, David Sterba wrote:
> On Tue, Sep 11, 2018 at 01:38:17PM +0800, Qu Wenruo wrote:
>> For btrfs_add_delayed_tree_ref(), its ref_root parameter can be
>> different from its real root.
>> This is pretty common for reloc tree, in that case @ref_root is passed=

>> as the original tree owner (source file tree).
>>
>> However btrfs_add_delayed_tree_ref() uses @ref_root to determine wheth=
er
>> we should do heavy qgroup tracing for it, so for balance this could
>> cause a lot of unnecessary extent tracing.
>>
>> This patch will introduce a parameter, @root for qgroup code to
>> determine whether we really need to do the heavy-lifting tracing work.=

>>
>> This patch would reduce the qgroup dirty extent number from 'number of=

>> extents being relocated' to 0 for the transaction before real tree swa=
p.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.c |  5 +++--
>>  fs/btrfs/delayed-ref.h |  1 +
>>  fs/btrfs/extent-tree.c | 17 ++++++++++-------
>>  3 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 62ff545ba1f7..7f681dd36e7f 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -710,8 +710,9 @@ static void init_delayed_ref_common(struct btrfs_f=
s_info *fs_info,
>>   * transaction commits.
>>   */
>>  int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>> +			       struct btrfs_root *root,
>>  			       u64 bytenr, u64 num_bytes, u64 parent,
>> -			       u64 ref_root,  int level, int action,
>> +			       u64 ref_root, int level, int action,
>=20
> Unrelated change

Will avoid it in next update.

>=20
>>  			       struct btrfs_delayed_extent_op *extent_op,
>>  			       int *old_ref_mod, int *new_ref_mod)
>>  {
>> @@ -737,7 +738,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_=
handle *trans,
>>  	}
>> =20
>>  	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
>> -	    is_fstree(ref_root)) {
>> +	    is_fstree(root->root_key.objectid)) {
>>  		record =3D kmalloc(sizeof(*record), GFP_NOFS);
>>  		if (!record) {
>>  			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>> index d9f2a4ebd5db..a51560a3cb66 100644
>> --- a/fs/btrfs/delayed-ref.h
>> +++ b/fs/btrfs/delayed-ref.h
>> @@ -235,6 +235,7 @@ static inline void btrfs_put_delayed_ref_head(stru=
ct btrfs_delayed_ref_head *hea
>>  }
>> =20
>>  int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>> +			       struct btrfs_root *root,
>>  			       u64 bytenr, u64 num_bytes, u64 parent,
>>  			       u64 ref_root, int level, int action,
>>  			       struct btrfs_delayed_extent_op *extent_op,
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 4588153f414c..7a3c650b11f8 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2040,9 +2040,10 @@ int btrfs_inc_extent_ref(struct btrfs_trans_han=
dle *trans,
>>  			   owner, offset, BTRFS_ADD_DELAYED_REF);
>> =20
>>  	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>> -		ret =3D btrfs_add_delayed_tree_ref(trans, bytenr,
>> +		ret =3D btrfs_add_delayed_tree_ref(trans, root, bytenr,
>>  						 num_bytes, parent,
>> -						 root_objectid, (int)owner,
>> +						 root_objectid,
>> +						 (int)owner,
>=20
> Here as well and a few more below. The (int) typecast is actually a bug=

> as it trims the owner to just 32bits, so if you want to update the
> formatting, please send a separate patch.

Will avoid the unrelated change in next update.

But for the "bug" part, it's a mess.

Since owner is smaller than BTRFS_FIRST_FREE_OBJECTID, truncating to
32bits is in fact completely OK.

However the declaration of btrfs_add_delayed_tree_ref() says that
parameter is in fact @level.
On the other hand, ref->level is passed to __btrfs_inc_extent_ref() as
@onwer (and u64) again, so it's not causing problem (or we're already
screwed up badly).

The naming and forced convert is really a mess here though.

I'll just keep that mess as is and don't touch it for the patchset.

Thanks,
Qu

>=20
>>  						 BTRFS_ADD_DELAYED_REF, NULL,
>>  						 &old_ref_mod, &new_ref_mod);
>>  	} else {
>> @@ -6993,7 +6994,7 @@ void btrfs_free_tree_block(struct btrfs_trans_ha=
ndle *trans,
>>  				   root->root_key.objectid,
>>  				   btrfs_header_level(buf), 0,
>>  				   BTRFS_DROP_DELAYED_REF);
>> -		ret =3D btrfs_add_delayed_tree_ref(trans, buf->start,
>> +		ret =3D btrfs_add_delayed_tree_ref(trans, root, buf->start,
>>  						 buf->len, parent,
>>  						 root->root_key.objectid,
>>  						 btrfs_header_level(buf),
>> @@ -7072,9 +7073,10 @@ int btrfs_free_extent(struct btrfs_trans_handle=
 *trans,
>>  		old_ref_mod =3D new_ref_mod =3D 0;
>>  		ret =3D 0;
>>  	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>> -		ret =3D btrfs_add_delayed_tree_ref(trans, bytenr,
>> +		ret =3D btrfs_add_delayed_tree_ref(trans, root, bytenr,
>>  						 num_bytes, parent,
>> -						 root_objectid, (int)owner,
>> +						 root_objectid,
>> +						 (int)owner,
>>  						 BTRFS_DROP_DELAYED_REF, NULL,
>>  						 &old_ref_mod, &new_ref_mod);
>>  	} else {
>> @@ -8293,9 +8295,10 @@ struct extent_buffer *btrfs_alloc_tree_block(st=
ruct btrfs_trans_handle *trans,
>>  		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
>>  				   root_objectid, level, 0,
>>  				   BTRFS_ADD_DELAYED_EXTENT);
>> -		ret =3D btrfs_add_delayed_tree_ref(trans, ins.objectid,
>> +		ret =3D btrfs_add_delayed_tree_ref(trans, root, ins.objectid,
>>  						 ins.offset, parent,
>> -						 root_objectid, level,
>> +						 root_objectid,
>> +						 level,
>>  						 BTRFS_ADD_DELAYED_EXTENT,
>>  						 extent_op, NULL, NULL);
>>  		if (ret)
>> --=20
>> 2.18.0


--EC5hTEHHI8OwhEfNXDTSVdHmZvpX75NP8--

--5qwz8cPWCJNxFPv35OFhkflYEEGQq3c6z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlusaxoACgkQwj2R86El
/qinDAf+O35s1lUJZD5ZWeSItLdSSb5Cpzs4j4ByjAA5cPnM/cVspvCcaoG7oDVG
T9F68cfegHGCLMEKpFwNvOC6ziPQMxhA0TxLFsldvAQ9Rfbd3KvDCZcfZLzXm61c
tKfb09T8sPCPXw3b6HNCD08+tDXWy9DjEPIBfmrxx2fzoSh7QrQmR+WNOkzgkSUe
uBk1jgBKW+AMe0N30xlOZbK3NxBgYpicwUNu99EaFwocCDN+oIB3LWHB++xi+fvW
kzRqbvmTsfx0S9VOfP8CNs92VXFuCwphAMMdpMaSlhv1vrEy6UQ4+51eKapTjxGq
Re7XUaoAYFFlLP6bx5aZ4nWKjS2keg==
=WO92
-----END PGP SIGNATURE-----

--5qwz8cPWCJNxFPv35OFhkflYEEGQq3c6z--
