Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9954DC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 12:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 536AF2086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 12:14:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 536AF2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbeKSWh4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 17:37:56 -0500
Received: from mout.gmx.net ([212.227.17.22]:55011 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbeKSWh4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 17:37:56 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M3MAG-1fXqqE107M-00qygu; Mon, 19
 Nov 2018 13:14:23 +0100
Subject: Re: [PATCH] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <f42a7622-0ebb-f431-c484-cb3c4013b7a7@gmx.com>
 <CAL3q7H6r-yLb+e84UxJ=tFLMa9MgP72MRoK9TYsyxfQ8x=DXEQ@mail.gmail.com>
 <89659371-3ab8-5305-746c-ab01295bac08@gmx.com>
 <CAL3q7H4FkWver_tO8vqcEdLCxgoXr1cxbiKP7AoU6a9kcipxyg@mail.gmail.com>
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
Message-ID: <f895eadd-34c9-6c9e-2f70-7c0ccd3185d6@gmx.com>
Date:   Mon, 19 Nov 2018 20:14:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4FkWver_tO8vqcEdLCxgoXr1cxbiKP7AoU6a9kcipxyg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SSgVn40pkGUkEZwEO2rjuok7Xpz4AoDso"
X-Provags-ID: V03:K1:2VGvT0QolTUOjIdxdiPDmelvVc7Dj+iL9N9DF1s+flhcn7rEYEC
 5nx4ndBhVV9my+ofUWSp53sgPSAT7v3gvQia6bXAfWdnSRjSbxBxArUHa6LqoBq7SiSB7Fv
 aYnHKhsfbomiIzRK44CmbXPyWT9RfVFhIVagWPopqrMBoiietLcHcE+nEKEYI3BgUZdbwWM
 BlDLuBqlJK9iQ3UStG3Yg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:B3V9y1JEHSU=:uDl2R0xEUvAmuu0lQ56WFV
 H63RpJBT+JnuYnmeC/mKpsErjyG05HU5rd3M6fJoRPeYDcgtaGWtRIFMoxp3Z4J153Rt2gduQ
 UggU8xCGja0Ifyta9VEprcQ6KJ7EjncgpUNPutEnv0Gw+qLUvDIp7xaTpAWAXOsL7m6TvrCJW
 /fK1EI38aRlIxsKZxpHQMzLldR6VtaNO+dElpB1L/pXgb3RnTkVxcc3SSbZRO0nrqH8+EkCnV
 futdg+pyRlfuYnICCNonaD1mLB36B44Lsd89MChLUEI5A3I5uzxQu9qqws/CTyImDggkKWpT6
 DadxUhnaBCRwsEMrL7S9T98dh0Ws+grOnHzdK2URfr4d2os9KKq8JlKGiO/368tQzqikn+std
 3Z8ZzxEOzVwbKfSDgc1Uxn3af+63cdixXbq+CEkwjPwsryWDl0nIgLNhamTcSeW6qNyvrozwz
 yrzj6S4CPN3dD45+9ADXnBLFNeOsyLJzi7V4CAaLWQaVN1CWsXlEeRRf+LbGAkdKeNR+f9Y6s
 Vmoh6krGmU1JIthHv2BSZdsdMb0kdTs6IChefxL0zfqNuvp6HtO3BSk7eAGIJFgk9JdgvrnSP
 dUlsgHLWBkOS3TbM9h+ufg14XsfdbRE3DKwBfoJIlOxi9XlKfGMNWBZkzEjYdGoqYxldm806W
 DvMvaAemLlXpW1ZswU9eudaoEe0SmJ8JSx8E7PDtcXgpBe1KYY5GOn4jTS2T/a+poyX9Uzs7Z
 Eg2PKffpwHLOlKViZJZxTK+OzaT906M+TmkClKZWk2mxMkKha1IYcRzV2hhuCTqTZUGDvaJIZ
 6n646wtaz0bVgFZ4J3XljbjpXVJ6v6636hxy6ozy27fa68G1guPR44FZS6uQMe51nhELjqmTz
 ONgHwUXkU2AiXO6iODKKBB+T3+QJdSMoDn/qhgF+scPcOApXaEyFGrtlIbrtsD
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SSgVn40pkGUkEZwEO2rjuok7Xpz4AoDso
Content-Type: multipart/mixed; boundary="dNkixuearsQFWOlYyi32QK3c7o7FH9m3P";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f895eadd-34c9-6c9e-2f70-7c0ccd3185d6@gmx.com>
Subject: Re: [PATCH] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <f42a7622-0ebb-f431-c484-cb3c4013b7a7@gmx.com>
 <CAL3q7H6r-yLb+e84UxJ=tFLMa9MgP72MRoK9TYsyxfQ8x=DXEQ@mail.gmail.com>
 <89659371-3ab8-5305-746c-ab01295bac08@gmx.com>
 <CAL3q7H4FkWver_tO8vqcEdLCxgoXr1cxbiKP7AoU6a9kcipxyg@mail.gmail.com>
In-Reply-To: <CAL3q7H4FkWver_tO8vqcEdLCxgoXr1cxbiKP7AoU6a9kcipxyg@mail.gmail.com>

--dNkixuearsQFWOlYyi32QK3c7o7FH9m3P
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8B=E5=8D=887:52, Filipe Manana wrote:
> On Mon, Nov 19, 2018 at 11:35 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>>
>> On 2018/11/19 =E4=B8=8B=E5=8D=887:13, Filipe Manana wrote:
>>> On Mon, Nov 19, 2018 at 11:09 AM Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>>
>>>> On 2018/11/19 =E4=B8=8B=E5=8D=885:48, fdmanana@kernel.org wrote:
>>>>> From: Filipe Manana <fdmanana@suse.com>
>>>>>
>>>>> If the quota enable and snapshot creation ioctls are called concurr=
ently
>>>>> we can get into a deadlock where the task enabling quotas will dead=
lock
>>>>> on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock=
 it
>>>>> twice. The following time diagram shows how this happens.
>>>>>
>>>>>            CPU 0                                    CPU 1
>>>>>
>>>>>  btrfs_ioctl()
>>>>>   btrfs_ioctl_quota_ctl()
>>>>>    btrfs_quota_enable()
>>>>>     mutex_lock(fs_info->qgroup_ioctl_lock)
>>>>>     btrfs_start_transaction()
>>>>>
>>>>>                                              btrfs_ioctl()
>>>>>                                               btrfs_ioctl_snap_crea=
te_v2
>>>>>                                                create_snapshot()
>>>>>                                                 --> adds snapshot t=
o the
>>>>>                                                     list pending_sn=
apshots
>>>>>                                                     of the current
>>>>>                                                     transaction
>>>>>
>>>>>     btrfs_commit_transaction()
>>>>>      create_pending_snapshots()
>>>>>        create_pending_snapshot()
>>>>>         qgroup_account_snapshot()
>>>>>          btrfs_qgroup_inherit()
>>>>>          mutex_lock(fs_info->qgroup_ioctl_lock)
>>>>>           --> deadlock, mutex already locked
>>>>>               by this task at
>>>>>               btrfs_quota_enable()
>>>>
>>>> The backtrace looks valid.
>>>>
>>>>>
>>>>> So fix this by adding a flag to the transaction handle that signals=
 if the
>>>>> transaction is being used for enabling quotas (only seen by the tas=
k doing
>>>>> it) and do not lock the mutex qgroup_ioctl_lock at btrfs_qgroup_inh=
erit()
>>>>> if the transaction handle corresponds to the one being used to enab=
le the
>>>>> quotas.
>>>>>
>>>>> Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when cre=
ating snapshot")
>>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>>> ---
>>>>>  fs/btrfs/qgroup.c      | 10 ++++++++--
>>>>>  fs/btrfs/transaction.h |  1 +
>>>>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>>> index d4917c0cddf5..3aec3bfa3d70 100644
>>>>> --- a/fs/btrfs/qgroup.c
>>>>> +++ b/fs/btrfs/qgroup.c
>>>>> @@ -908,6 +908,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs=
_info)
>>>>>               trans =3D NULL;
>>>>>               goto out;
>>>>>       }
>>>>> +     trans->enabling_quotas =3D true;
>>>>
>>>> Should we put enabling_quotas bit into btrfs_transaction instead of
>>>> btrfs_trans_handle?
>>>
>>> Why?
>>> Only the task which is enabling quotas needs to know about it.
>>
>> But it's the btrfs_qgroup_inherit() using the trans handler to avoid
>> dead lock.
>>
>> What makes sure btrfs_qgroup_inherit() get the exactly same trans
>> handler allocated here?
>=20
> If it's the other task (the one creating a snapshot) that starts the
> transaction commit,
> it will have to wait for the task enabling quotas to release the
> transaction - once that task
> also calls commit_transaction(), it will skip doing the commit itself
> and wait for the snapshot
> one to finish the commit, while holding the qgroup mutex (this part I
> missed before).
> So yes we'll have to use a bit in the transaction itself instead.
>=20
>>
>>>
>>>>
>>>> Isn't it possible to have different trans handle pointed to the same=

>>>> transaction?
>>>
>>> Yes.
>>>
>>>>
>>>> And I'm not really sure about the naming "enabling_quotas".
>>>> What about "quota_ioctl_mutex_hold"? (Well, this also sounds awful)
>>>
>>> Too long.
>>
>> Anyway, current naming doesn't really show why we could skip mutex
>> locking. Just hope to get some name better.
>=20
> No name will ever show you that.
> You'll always have to see where  and how it's used, unless you want a
> name like "dont_lock_mutex_because_we_locked_it_at_btrfs...".

(Personally speaking I indeed prefer this one naming as it doesn't
exceed 80 chars yet)

Your statement makes sense, just keep current naming.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>       fs_info->qgroup_ulist =3D ulist_alloc(GFP_KERNEL);
>>>>>       if (!fs_info->qgroup_ulist) {
>>>>> @@ -2250,7 +2251,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_=
handle *trans, u64 srcid,
>>>>>       u32 level_size =3D 0;
>>>>>       u64 nums;
>>>>>
>>>>> -     mutex_lock(&fs_info->qgroup_ioctl_lock);
>>>>> +     if (trans->enabling_quotas)
>>>>> +             lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
>>>>> +     else
>>>>> +             mutex_lock(&fs_info->qgroup_ioctl_lock);
>>>>> +
>>>>>       if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
>>>>>               goto out;
>>>>>
>>>>> @@ -2413,7 +2418,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_h=
andle *trans, u64 srcid,
>>>>>  unlock:
>>>>>       spin_unlock(&fs_info->qgroup_lock);
>>>>>  out:
>>>>> -     mutex_unlock(&fs_info->qgroup_ioctl_lock);
>>>>> +     if (!trans->enabling_quotas)
>>>>> +             mutex_unlock(&fs_info->qgroup_ioctl_lock);
>>>>>       return ret;
>>>>>  }
>>>>>
>>>>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
>>>>> index 703d5116a2fc..a5553a1dee30 100644
>>>>> --- a/fs/btrfs/transaction.h
>>>>> +++ b/fs/btrfs/transaction.h
>>>>> @@ -122,6 +122,7 @@ struct btrfs_trans_handle {
>>>>>       bool reloc_reserved;
>>>>>       bool sync;
>>>>>       bool dirty;
>>>>> +     bool enabling_quotas;
>>>>>       struct btrfs_root *root;
>>>>>       struct btrfs_fs_info *fs_info;
>>>>>       struct list_head new_bgs;
>>>>>
>>>>
>>


--dNkixuearsQFWOlYyi32QK3c7o7FH9m3P--

--SSgVn40pkGUkEZwEO2rjuok7Xpz4AoDso
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvyqRoACgkQwj2R86El
/qjdDQf9FHVS3yBYrPxCm5G6lTzHNpSruuMcoeKf6lhZ4lHFyjxUugpbYaBpMLvz
oNk63ukyPYNG0xnve4CTjmHpwbaI+2TPZo6HzSMDVK7YQYzZ3SDQ36Oa5t20tQvQ
d1sDwxMFZgweOR7xiprzL+2+YyKFUR7fK+vTiziZXKk5qPlk6//RaTEZBsI/1FSZ
yhLTL1hx0VbvduaUZGVXr33c2mBFWYhnwcKwxSmORuFBjlTWHNYfbZXtdQEMowrG
mcm+B6np2KR34BCzP2IENQirSKZIpFTKHr06Jnt6YzNq3FRivKyv6BY4LSaPWOLB
Y0txx94sOyqqSULgZHt0IxLAPWNv3g==
=LapP
-----END PGP SIGNATURE-----

--SSgVn40pkGUkEZwEO2rjuok7Xpz4AoDso--
