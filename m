Return-Path: <SRS0=cIUr=O6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FROM,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEE7C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Dec 2018 00:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 164AC218E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Dec 2018 00:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbeLUAAD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Dec 2018 19:00:03 -0500
Received: from mout.gmx.net ([212.227.17.21]:60051 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbeLUAAC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Dec 2018 19:00:02 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LxLcc-1hTrMo3oYE-016tKv; Fri, 21
 Dec 2018 00:59:53 +0100
Subject: Re: [PATCH] btrfs: qgroup: Don't trigger backref walk at delayed ref
 insert time
To:     Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181211050237.19016-1-wqu@suse.com>
 <a73aeace-e6c0-93e3-d9d5-a99c57f65d9d@suse.com>
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
Message-ID: <97b37024-8512-a1a5-00a3-a4a7c06cbbd2@gmx.com>
Date:   Fri, 21 Dec 2018 07:59:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <a73aeace-e6c0-93e3-d9d5-a99c57f65d9d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ByHAdEOjFYLQqaY1hqc8y7qHXAtOCwbEk"
X-Provags-ID: V03:K1:YakaurArjZjNKWbBoqIqbPnCz5PyTalZp+NGYf8p8ALuRr9TBXN
 bjPWepEYJBS0yhjvC9GmEkWdFLvAhfS5nI0HfmLTupukdgupTELTX2brSa61UK7+sv7R+mF
 h5pNgeNKJYUPTm+VVfNraMJkIv2FDCMRIVQKCxlZHXA3tvRMVkJZkswrMnMjhbV6mvyEgVW
 nrNqLroHvy4//pO15G7Xg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SJbX7nAd5sA=:0wmob3HCM2TBGKW0R5q4ty
 8W9Bu7iYWGBKSNvyeev74aQ9uVV6RN4dn0DFbykFttm2keflywDngIl3tyz12dAgM6TFRjkPP
 P6Etmr/xWa0biUo++AS5qaAJhut3lqVVsghMcLCTk+o+tdMjGfuaj2cPMKLjSzQvsqgHvOu0Y
 5p0rR6cBVcO9VOyw98FTtAwDpfPkIK6SG7ZIkXwF/q+ySk3Vy8fEhrfprnQq39/hET99NBWWL
 IMCr7Jpm5sano9cavYRLQNHr+juRSFUjVm7gkyX5DxExg0GMVUJyqYw1ZQWhUkqRHymlAaVd1
 uXFf/gwKwnhwAzR7yIAL4xeW7/Wy/MjGo5sCyHHEi3Oq7p8/zmAfhri+rDaTPugI41Dqjp28i
 znYIYLBEXqSbXj47KLZuiVeJumUB26D7/LvJD1QIjvLKgzIWmuBYckJzH7hJy1LivmpPuPI9F
 XTqH+ZGWYkwsYL9OJKFSs3YiyOJWKb/+ZEwgTkJSIf0fj0BkTDaVGVfGxVpTG+bcbi18qkE8+
 w6zKl7uBQuC0yNQoW8MTMpYnFeHbTmladfv+v89t/auoWNtEEsqxihgztaHPTmEhYOynFyAzo
 36Yht0gJkxl0XhmXRq4Qj1a42CGtFwAymtqwoMF9OMTDK8ANSbjeBcFjp7HTY/D4M3BEvKzKz
 oGQ44+GReYYbZBjUYXejBqnH+99TfzpPDuRxoEhcTSfh0HolIfFRMaBI3LrSC+x4wpb0mKoOD
 yoLFP1CSP6WfdvoiIHoc480hgt8BBQTPTXr7npCxCpI4equ2oCz6MVA/59+Nd716HelgZx6ne
 /xqHJQgOAMx5/YHZOmYe51B4RSr+jfaBetPexestUbHnUCK4MMcYPcPbxt70zwTxSVNSthaeb
 t3M/dG+omWtDZCpDV45C/CkU2b4ETecDWNgjBo7YeVOhIKMbNqQdIKjpiJaI8R
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ByHAdEOjFYLQqaY1hqc8y7qHXAtOCwbEk
Content-Type: multipart/mixed; boundary="PASRpfa3mgERj1dNfrGfYiISixk0rRT0V";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <97b37024-8512-a1a5-00a3-a4a7c06cbbd2@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Don't trigger backref walk at delayed ref
 insert time
References: <20181211050237.19016-1-wqu@suse.com>
 <a73aeace-e6c0-93e3-d9d5-a99c57f65d9d@suse.com>
In-Reply-To: <a73aeace-e6c0-93e3-d9d5-a99c57f65d9d@suse.com>

--PASRpfa3mgERj1dNfrGfYiISixk0rRT0V
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/21 =E4=B8=8A=E5=8D=8812:12, Jeff Mahoney wrote:
> On 12/11/18 12:02 AM, Qu Wenruo wrote:
>> [BUG]
>> Since fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting=

>> time out of commit trans"), kernel may lockup with quota enabled.
>>
>> There is one backref trace triggered by snapshot dropping along with
>> write operation in the source subvolume.
>> The example can be stably reproduced.
>>
>>   btrfs-cleaner   D    0  4062      2 0x80000000
>>   Call Trace:
>>    schedule+0x32/0x90
>>    btrfs_tree_read_lock+0x93/0x130 [btrfs]
>>    find_parent_nodes+0x29b/0x1170 [btrfs]
>>    btrfs_find_all_roots_safe+0xa8/0x120 [btrfs]
>>    btrfs_find_all_roots+0x57/0x70 [btrfs]
>>    btrfs_qgroup_trace_extent_post+0x37/0x70 [btrfs]
>>    btrfs_qgroup_trace_leaf_items+0x10b/0x140 [btrfs]
>>    btrfs_qgroup_trace_subtree+0xc8/0xe0 [btrfs]
>>    do_walk_down+0x541/0x5e3 [btrfs]
>>    walk_down_tree+0xab/0xe7 [btrfs]
>>    btrfs_drop_snapshot+0x356/0x71a [btrfs]
>>    btrfs_clean_one_deleted_snapshot+0xb8/0xf0 [btrfs]
>>    cleaner_kthread+0x12b/0x160 [btrfs]
>>    kthread+0x112/0x130
>>    ret_from_fork+0x27/0x50
>>
>> [CAUSE]
>> When dropping snapshots with qgroup enabled, we will trigger backref
>> walk.
>>
>> However such backref walk at that timing is pretty dangerous, as if on=
e
>> of the parent nodes get WRITE locked by other thread, we could cause a=

>> dead lock.
>>
>> For example:
>>
>>            FS 260     FS 261 (Dropped)
>>             node A        node B
>>            /      \      /      \
>>        node C      node D      node E
>>       /   \         /  \        /     \
>>   leaf F|leaf G|leaf H|leaf I|leaf J|leaf K
>>
>> The lock sequence would be:
>>
>>       Thread A (cleaner)             |       Thread B (other writer)
>> ----------------------------------------------------------------------=
-
>> write_lock(B)                        |
>> write_lock(D)                        |
>> ^^^ called by walk_down_tree()       |
>>                                      |       write_lock(A)
>>                                      |       write_lock(D) << Stall
>> read_lock(H) << for backref walk     |
>> read_lock(D) << lock owner is        |
>>                 the same thread A    |
>>                 so read lock is OK   |
>> read_lock(A) << Stall                |
>>
>> So thread A hold write lock D, and needs read lock A to unlock.
>> While thread B holds write lock A, while needs lock D to unlock.
>>
>> This will cause a dead lock.
>>
>> This is not only limited to snapshot dropping case.
>> As the backref walk, even only happens on commit trees, is breaking th=
e
>> normal top-down locking order, makes it deadlock prone.
>>
>> [FIX]
>> The solution is not to trigger backref walk with any write lock hold.
>> This means we can't do backref walk at delayed ref insert time.
>>
>> So this patch will mostly revert commit fb235dc06fac ("btrfs: qgroup:
>> Move half of the qgroup accounting time out of commit trans").
>>
>> Reported-by: David Sterba <dsterba@suse.cz>
>> Reported-by: Filipe Manana <fdmanana@suse.com>
>> Fixes: fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accountin=
g time out of commit trans")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.c |  6 ------
>>  fs/btrfs/qgroup.c      | 35 ++---------------------------------
>>  2 files changed, 2 insertions(+), 39 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 9301b3ad9217..7aaae8436986 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -788,9 +788,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_=
handle *trans,
>>  	if (ret > 0)
>>  		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
>> =20
>> -	if (qrecord_inserted)
>> -		btrfs_qgroup_trace_extent_post(fs_info, record);
>> -
>>  	return 0;
>>  }
>> =20
>> @@ -869,9 +866,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_=
handle *trans,
>>  	if (ret > 0)
>>  		kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
>> =20
>> -
>> -	if (qrecord_inserted)
>> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
>>  	return 0;
>>  }
>=20
>=20
> This looks good but is leaving some cruft behind.
>=20
> These were the only uses for qrecord_inserted so we don't need it in
> either function and we don't need to pass it to add_delayed_ref_head.

This version is a little old, the latest one can be found titlted:
[PATCH v3 2/7] btrfs: qgroup: Don't trigger backref walk at delayed ref
insert time

Or at patchwork:
https://patchwork.kernel.org/patch/10725371/

Thanks,
Qu

>=20
> -Jeff
>=20
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 45868fd76209..7d485b1e0efb 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1553,33 +1553,6 @@ int btrfs_qgroup_trace_extent_nolock(struct btr=
fs_fs_info *fs_info,
>>  	return 0;
>>  }
>> =20
>> -int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
>> -				   struct btrfs_qgroup_extent_record *qrecord)
>> -{
>> -	struct ulist *old_root;
>> -	u64 bytenr =3D qrecord->bytenr;
>> -	int ret;
>> -
>> -	ret =3D btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, fa=
lse);
>> -	if (ret < 0) {
>> -		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>> -		btrfs_warn(fs_info,
>> -"error accounting new delayed refs extent (err code: %d), quota incon=
sistent",
>> -			ret);
>> -		return 0;
>> -	}
>> -
>> -	/*
>> -	 * Here we don't need to get the lock of
>> -	 * trans->transaction->delayed_refs, since inserted qrecord won't
>> -	 * be deleted, only qrecord->node may be modified (new qrecord inser=
t)
>> -	 *
>> -	 * So modifying qrecord->old_roots is safe here
>> -	 */
>> -	qrecord->old_roots =3D old_root;
>> -	return 0;
>> -}
>> -
>>  int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 b=
ytenr,
>>  			      u64 num_bytes, gfp_t gfp_flag)
>>  {
>> @@ -1607,7 +1580,7 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans=
_handle *trans, u64 bytenr,
>>  		kfree(record);
>>  		return 0;
>>  	}
>> -	return btrfs_qgroup_trace_extent_post(fs_info, record);
>> +	return 0;
>>  }
>> =20
>>  int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
>> @@ -2557,11 +2530,7 @@ int btrfs_qgroup_account_extents(struct btrfs_t=
rans_handle *trans)
>>  		trace_btrfs_qgroup_account_extents(fs_info, record);
>> =20
>>  		if (!ret) {
>> -			/*
>> -			 * Old roots should be searched when inserting qgroup
>> -			 * extent record
>> -			 */
>> -			if (WARN_ON(!record->old_roots)) {
>> +			if (!record->old_roots) {
>>  				/* Search commit root to find old_roots */
>>  				ret =3D btrfs_find_all_roots(NULL, fs_info,
>>  						record->bytenr, 0,
>>
>=20


--PASRpfa3mgERj1dNfrGfYiISixk0rRT0V--

--ByHAdEOjFYLQqaY1hqc8y7qHXAtOCwbEk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwcLPQACgkQwj2R86El
/qj4mAf/XF3ITtMYnGB8OBcB29zhBhb4YPlg5jionxIOvwpqN3S7q5Ol7pKFpoIv
kJUfeEO4BYLwQqSrQCZhwqsJq+nc7B68PoBYxyuVN61oaH3hYpFFizz42DQesFOg
d+fZf5qqC7NHlHIHq7IPmeecBcQ5OknJkYEMawGeAPlrfl/n6NYTKQWnrfjTsZ2Q
hBtVwrSMkEfFl39n01rPBe/Y4o7TZ4kfVV7O155vLs6bk3NqkMVti8Xzb/lRXRuv
4lgntRCdS8d1+SBW1kcL5i5sDAz4d7ojgZohw6prCcsmlmTLjfSI0gZkyKbW1KXk
DTDw3eXlFPq49YoAtJMz5mbnYH22Wg==
=0ALA
-----END PGP SIGNATURE-----

--ByHAdEOjFYLQqaY1hqc8y7qHXAtOCwbEk--
