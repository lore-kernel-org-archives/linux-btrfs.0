Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C172CC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 11:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A6D720851
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 11:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A6D720851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbeKSV7D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 16:59:03 -0500
Received: from mout.gmx.net ([212.227.17.22]:39575 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728551AbeKSV7D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 16:59:03 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LhSfM-1fc9gc0ibA-00mcNi; Mon, 19
 Nov 2018 12:35:35 +0100
Subject: Re: [PATCH] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <f42a7622-0ebb-f431-c484-cb3c4013b7a7@gmx.com>
 <CAL3q7H6r-yLb+e84UxJ=tFLMa9MgP72MRoK9TYsyxfQ8x=DXEQ@mail.gmail.com>
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
Message-ID: <89659371-3ab8-5305-746c-ab01295bac08@gmx.com>
Date:   Mon, 19 Nov 2018 19:35:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6r-yLb+e84UxJ=tFLMa9MgP72MRoK9TYsyxfQ8x=DXEQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A2fOhMkUl1jOAFTtPHnbl10O1k7sgcPg5"
X-Provags-ID: V03:K1:wvTGIqtww4JWoHR7ZyqWq0hnnCV1cQKIvmHXj3g1kVkTxZGK0Ou
 J4V6CZPjHhkOgiY4uAQV2++YFO5HqTr+lNtwIwVAahnme7B9kcJJeiukrqo9mSHLdYQwrea
 29L/FpkXOEHhIvBZtIzwyODWzp2PjLDMEjtaiEPIH2UBqKDNvGO8Kp1DnPiLFTKM2em3t5r
 QYG9iyseY7vUnUgNU1vdA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Wf2Jiw2nSTE=:AOy+db2eqCqLkRg14rqPtR
 dIICoOqfHY/KVwqrK7qJg6ITZXnehc81wSacf9W8Ib2Q1GmOzzw17BJfDU8y5jFyLhmWsbisX
 OIxd3PVardZZzTM9kcCryjHC2qQO0HJHi5aL17ezyparxx6qXIAqUEY4baCIt+f4KwN35VTPR
 eD9sRon56mbQdesHSO2IH6yHeg0ZWxb972+52PLk/RF0ZXQEwGPFGfWwLJX3tHWWHPO5Qk7uq
 +UGAbK8xtxFhAcNw/WWUAT4nXbZaXUoM443CDOiqdzIApXiwSqmt0VAWAalX/y/2zmRUWfXJ8
 e3YIOenltSY10ed9GLDVU+wPMDp72gIikSPxTO7CL3QNH5cGRh6r1YZTPBJxDyXfhTtUrxZUb
 sdEBVtryCT/qYMTPtaOKruStdkYDrbzJKe8T6mZyZAwwtkNy+WrqcLJAZ3wLAnJvK+E2LUMI/
 uMGisy4eop0+aQBClOPP+m+1lFzEIUPMhDv/uGMZO7rUMoj6KY9xB3By0SxpHGoSvVp8Vat7D
 O87BDwZ8DNbAz3g7Hkuu252nSR8eiZnLZVn21fVWUEQpQ8noQZvTonf8XW6nUly1BEKsdaVdI
 bDy1bPlIaalr3rrnr3x3rEY+RZCWhMHwLnMRvc/Yffxfa0Sg1JID3f5YVq3C3nTDpjY4MNtMy
 d4XQ4D2HpIqC/gpG0IC03vir+MA0FDwMeKKflKJuglBgNlmZsq+Kuz4Yhg6+J8Pa9RQTB1vq2
 DRvSkOzvLzjE3XgR5vNUih9NygqonTeHghgOG6DrKPieyDqBTUhvr+8k2Z79cEn+qX1aWgvvN
 bjxP8gwoG8Ew0Ccqno1y4K6aSsOTzW9ecyEWDLBYNfOl/sJy023cAQV3zdrcZAgthaN+0aioW
 DszQI2+DcUpFgekRmEE7IFQY1HA6ekoctPaaPRylAklA0N+wOv4yHjM7rHejyX
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A2fOhMkUl1jOAFTtPHnbl10O1k7sgcPg5
Content-Type: multipart/mixed; boundary="6I6VkULlRWxAwEVeVUWB8tA9EBduBOotG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <89659371-3ab8-5305-746c-ab01295bac08@gmx.com>
Subject: Re: [PATCH] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <f42a7622-0ebb-f431-c484-cb3c4013b7a7@gmx.com>
 <CAL3q7H6r-yLb+e84UxJ=tFLMa9MgP72MRoK9TYsyxfQ8x=DXEQ@mail.gmail.com>
In-Reply-To: <CAL3q7H6r-yLb+e84UxJ=tFLMa9MgP72MRoK9TYsyxfQ8x=DXEQ@mail.gmail.com>

--6I6VkULlRWxAwEVeVUWB8tA9EBduBOotG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8B=E5=8D=887:13, Filipe Manana wrote:
> On Mon, Nov 19, 2018 at 11:09 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>>
>> On 2018/11/19 =E4=B8=8B=E5=8D=885:48, fdmanana@kernel.org wrote:
>>> From: Filipe Manana <fdmanana@suse.com>
>>>
>>> If the quota enable and snapshot creation ioctls are called concurren=
tly
>>> we can get into a deadlock where the task enabling quotas will deadlo=
ck
>>> on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock i=
t
>>> twice. The following time diagram shows how this happens.
>>>
>>>            CPU 0                                    CPU 1
>>>
>>>  btrfs_ioctl()
>>>   btrfs_ioctl_quota_ctl()
>>>    btrfs_quota_enable()
>>>     mutex_lock(fs_info->qgroup_ioctl_lock)
>>>     btrfs_start_transaction()
>>>
>>>                                              btrfs_ioctl()
>>>                                               btrfs_ioctl_snap_create=
_v2
>>>                                                create_snapshot()
>>>                                                 --> adds snapshot to =
the
>>>                                                     list pending_snap=
shots
>>>                                                     of the current
>>>                                                     transaction
>>>
>>>     btrfs_commit_transaction()
>>>      create_pending_snapshots()
>>>        create_pending_snapshot()
>>>         qgroup_account_snapshot()
>>>          btrfs_qgroup_inherit()
>>>          mutex_lock(fs_info->qgroup_ioctl_lock)
>>>           --> deadlock, mutex already locked
>>>               by this task at
>>>               btrfs_quota_enable()
>>
>> The backtrace looks valid.
>>
>>>
>>> So fix this by adding a flag to the transaction handle that signals i=
f the
>>> transaction is being used for enabling quotas (only seen by the task =
doing
>>> it) and do not lock the mutex qgroup_ioctl_lock at btrfs_qgroup_inher=
it()
>>> if the transaction handle corresponds to the one being used to enable=
 the
>>> quotas.
>>>
>>> Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creat=
ing snapshot")
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>  fs/btrfs/qgroup.c      | 10 ++++++++--
>>>  fs/btrfs/transaction.h |  1 +
>>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index d4917c0cddf5..3aec3bfa3d70 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -908,6 +908,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_i=
nfo)
>>>               trans =3D NULL;
>>>               goto out;
>>>       }
>>> +     trans->enabling_quotas =3D true;
>>
>> Should we put enabling_quotas bit into btrfs_transaction instead of
>> btrfs_trans_handle?
>=20
> Why?
> Only the task which is enabling quotas needs to know about it.

But it's the btrfs_qgroup_inherit() using the trans handler to avoid
dead lock.

What makes sure btrfs_qgroup_inherit() get the exactly same trans
handler allocated here?

>=20
>>
>> Isn't it possible to have different trans handle pointed to the same
>> transaction?
>=20
> Yes.
>=20
>>
>> And I'm not really sure about the naming "enabling_quotas".
>> What about "quota_ioctl_mutex_hold"? (Well, this also sounds awful)
>=20
> Too long.

Anyway, current naming doesn't really show why we could skip mutex
locking. Just hope to get some name better.

Thanks,
Qu

>=20
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>       fs_info->qgroup_ulist =3D ulist_alloc(GFP_KERNEL);
>>>       if (!fs_info->qgroup_ulist) {
>>> @@ -2250,7 +2251,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_ha=
ndle *trans, u64 srcid,
>>>       u32 level_size =3D 0;
>>>       u64 nums;
>>>
>>> -     mutex_lock(&fs_info->qgroup_ioctl_lock);
>>> +     if (trans->enabling_quotas)
>>> +             lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
>>> +     else
>>> +             mutex_lock(&fs_info->qgroup_ioctl_lock);
>>> +
>>>       if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
>>>               goto out;
>>>
>>> @@ -2413,7 +2418,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_han=
dle *trans, u64 srcid,
>>>  unlock:
>>>       spin_unlock(&fs_info->qgroup_lock);
>>>  out:
>>> -     mutex_unlock(&fs_info->qgroup_ioctl_lock);
>>> +     if (!trans->enabling_quotas)
>>> +             mutex_unlock(&fs_info->qgroup_ioctl_lock);
>>>       return ret;
>>>  }
>>>
>>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
>>> index 703d5116a2fc..a5553a1dee30 100644
>>> --- a/fs/btrfs/transaction.h
>>> +++ b/fs/btrfs/transaction.h
>>> @@ -122,6 +122,7 @@ struct btrfs_trans_handle {
>>>       bool reloc_reserved;
>>>       bool sync;
>>>       bool dirty;
>>> +     bool enabling_quotas;
>>>       struct btrfs_root *root;
>>>       struct btrfs_fs_info *fs_info;
>>>       struct list_head new_bgs;
>>>
>>


--6I6VkULlRWxAwEVeVUWB8tA9EBduBOotG--

--A2fOhMkUl1jOAFTtPHnbl10O1k7sgcPg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvyoAIACgkQwj2R86El
/qi4dQf9HlJ9S3OAT7v83fnq7LW9qa07ZTKIqopfg6yT5gpFpfkgDnclUNkEL/nx
Ghb+AH2rCI7jq5mRyRo4UXTi/iyRARVgbeDTPrAn/q2d6Smx1mqq9XluyVyN0cTC
7McTk1CeLSKAHMH+oAd57xGQpAmFUeUVY+USKYSV8Pl3E7f23pLNQLD2bKxaBsrM
oq/G1U9fH0tzFO6etvyDhljF9XQZw16s+x7fLILPb6V7iV0Q3bBhW+yTW0tSr9q9
V3bdEBNr+qY9SZLsjmjB9eslD/OTQ2V31HyBt2LH89TLn9Bec5ICSO7cAGgdXS2q
OhaEHRChfDJZbCzaY3xwq4eoae7HkA==
=Ya8p
-----END PGP SIGNATURE-----

--A2fOhMkUl1jOAFTtPHnbl10O1k7sgcPg5--
