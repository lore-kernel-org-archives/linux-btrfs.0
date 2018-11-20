Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB96C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85F922089F
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:32:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85F922089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732456AbeKTK7L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 05:59:11 -0500
Received: from mout.gmx.net ([212.227.17.21]:41619 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbeKTK7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 05:59:11 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M09Ee-1fbTk20dHI-00uH0L; Tue, 20
 Nov 2018 01:32:47 +0100
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
 <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
 <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
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
Message-ID: <3b5c8646-42f7-e51d-e1f8-c28541558192@gmx.com>
Date:   Tue, 20 Nov 2018 08:32:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="euS6pWrB4lmuOSgwtL7X7DiE8TxtlABho"
X-Provags-ID: V03:K1:Hbuq45jE4JfN0cCNhNswYItTX1GVXwuEoXgHUpgX6rc2chA4xe2
 V7F2xYFr33t2OYC9OrBP3HvX+De0BpX8sHjFkFhQGMV8J1dnrAb9Y4YFYoGbLvEFpUG8rqW
 Utp0jZkuQdW7Prwk37qWVPzAwqnTZvfGJ+tnlRj0FOw8IjZQ1EC7+GIsW66KQHhc0JeMThY
 6CVzSDakpIPvttGjhRBYA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:pFCf9mqtzCE=:G5cyksL1wrEnNoE/FEciBo
 PTneMYCZJxz4vGQ8ixZnP3fV6QVtiSkeL74oxJb+tkXtSTZ9Z0oBvLgkN5DQGgtdOJCfAfqLs
 96/3ZzpRzijgwS6r6zkTvBOkhOzalZbj68JCyu/2jczYNhybxZSOceKtXlmbqiH60JzylOR+S
 Bnu15Cy9A0OWN+04uunzGET7Ytzeuw1PCxtkqsu1GztxqmgIBLhhNgO+cL+H5B5q0ESaYAkvP
 th9FfHHTFRdLhijNFQ3LXRWLDj9zmAMGW5gYWOElpDgJzH0OAupiRcAsYske5fov82PDBYNPP
 rfuDLAJKJZZtzoroWCsuB7/gb3DipJ5nW2cmS7o3qnjo3CiNt6OVqb2/1Q4u2q5HKlzYjZjrK
 gqSqgTYFWIVMHaaHWTCPF8ZDm6NfSomJMnyIEXZAyCFTxJZHPf6amjIpDYqHolgIpZRRkXijT
 BlQoYlbCtuG1oXHHuxjTAz9a2suUnaj1kXT95vaiyrFjMySr42yF2dcBE5SubN0s9ENQbjyoa
 qGJ2DGh0t5rJjvmv6ijbOTo67ZStaGpHNyoTWDkhIEnIeCq3uwSzEpBmuwojmJyboz5YnMUj7
 fMadiQGvyFU/uyRaN6ViOSoWHXOZp+F3sE0DY5VAhX9dW3FQAJLCNSuYuyOM6NwAHCS2ZCs5k
 0fkMQwme+O+ZoUAkm+1g71wjimPutvMb0oAeyhbMNihrjSptUj75DNMIeLU0CN/x7VNRDkQ5l
 7rePlatDKhBQWOt4B++94dejZmrgRv90QJdZ6MzhfRi3Bic8dCLrjrLRgL318ox/O7WevDY2F
 RK/ZUcMj5ZuJUkTqbMnXa+2nYn3H7XgGQC+vfodW7zaljIYV0Z8L0ZOz8DgR/A+TA5uTQRcSc
 PnyknFhh7b/LOvtB7iNagozA+fV7tRtPr7sBsu5/CRdVh/+mfguUfXl+BaEead
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--euS6pWrB4lmuOSgwtL7X7DiE8TxtlABho
Content-Type: multipart/mixed; boundary="f4q7enDNsppqyDiLU5LusMp1Y4wEPgivi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <3b5c8646-42f7-e51d-e1f8-c28541558192@gmx.com>
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
 <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
 <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
In-Reply-To: <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>

--f4q7enDNsppqyDiLU5LusMp1Y4wEPgivi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8B=E5=8D=8811:24, Filipe Manana wrote:
> On Mon, Nov 19, 2018 at 2:48 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>
>>
>>
>> On 2018/11/19 =E4=B8=8B=E5=8D=8810:15, fdmanana@kernel.org wrote:
>>> From: Filipe Manana <fdmanana@suse.com>
>>>
>>> If the quota enable and snapshot creation ioctls are called concurren=
tly
>>> we can get into a deadlock where the task enabling quotas will deadlo=
ck
>>> on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock i=
t
>>> twice, or the task creating a snapshot tries to commit the transactio=
n
>>> while the task enabling quota waits for the former task to commit the=

>>> transaction while holding the mutex. The following time diagrams show=
 how
>>> both cases happen.
>>>
>>> First scenario:
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
>>>
>>> Second scenario:
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
>>>                                                 btrfs_commit_transact=
ion()
>>>                                                  --> waits for task a=
t
>>>                                                      CPU 0 to release=

>>>                                                      its transaction
>>>                                                      handle
>>>
>>>     btrfs_commit_transaction()
>>>      --> sees another task started
>>>          the transaction commit first
>>>      --> releases its transaction
>>>          handle
>>>      --> waits for the transaction
>>>          commit to be completed by
>>>          the task at CPU 1
>>>
>>>                                                  create_pending_snaps=
hot()
>>>                                                   qgroup_account_snap=
shot()
>>>                                                    btrfs_qgroup_inher=
it()
>>>                                                     mutex_lock(fs_inf=
o->qgroup_ioctl_lock)
>>>                                                      --> deadlock, ta=
sk at CPU 0
>>>                                                          has the mute=
x locked but
>>>                                                          it is waitin=
g for us to
>>>                                                          finish the t=
ransaction
>>>                                                          commit
>>>
>>> So fix this by setting the quota enabled flag in fs_info after commit=
ting
>>> the transaction at btrfs_quota_enable(). This ends up serializing quo=
ta
>>> enable and snapshot creation as if the snapshot creation happened jus=
t
>>> before the quota enable request. The quota rescan task, scheduled aft=
er
>>> committing the transaction in btrfs_quote_enable(), will do the accou=
nting.
>>>
>>> Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creat=
ing snapshot")
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>
>>> V2: Added second deadlock example to changelog and changed the fix to=
 deal
>>>     with that case as well.
>>>
>>>  fs/btrfs/qgroup.c | 14 ++++++++++----
>>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index d4917c0cddf5..ae1358253b7b 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -1013,16 +1013,22 @@ int btrfs_quota_enable(struct btrfs_fs_info *=
fs_info)
>>>               btrfs_abort_transaction(trans, ret);
>>>               goto out_free_path;
>>>       }
>>> -     spin_lock(&fs_info->qgroup_lock);
>>> -     fs_info->quota_root =3D quota_root;
>>> -     set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>>> -     spin_unlock(&fs_info->qgroup_lock);
>>>
>>>       ret =3D btrfs_commit_transaction(trans);
>>>       trans =3D NULL;
>>>       if (ret)
>>>               goto out_free_path;
>>
>> The main concern here is, if we don't set qgroup enabled bit before we=

>> commit transaction, there will be a window where new tree modification=

>> could happen before QGROUP_ENABLED bit set.
>=20
> That doesn't seem to make much sense to me, if I understood correctly.
> Essentially you're saying stuff done to any tree in the the
> transaction we use to
> enable quotas must be accounted for. In that case the quota enabled bit=
 should
> be done as soon as the transaction is started, because before we set
> it and after
> we started (or joined) a transaction, a lot could of modifications may
> have happened.
> Nevertheless I don't think it's unexpected for anyone to have the
> accounting happening
> only after the quota enable ioctl returns success.

The problem is not accounting, the qgroup number won't cause problem.

It's the reserved space. Like some dirty pages are dirtied before quota
enabled, but at run_dealloc() time quota is enabled.

For such case we have io_tree based method to avoid underflow so it
should be OK.

So v2 patch looks OK.

Thanks,
Qu

>=20
>>
>> There may be some qgroup reserved space related problem in such case,
>> but I'm not 100% sure to foresee such problem.
>>
>>
>> The best way to do this is, commit trans first, and before any other o=
ne
>> trying to start transaction, we set the bit.
>> However I can't find such infrastructure now (I still remember we used=

>> to have a pending bit to change quota enabled flag, but removed later)=

>>
>> Thanks,
>> Qu
>>
>>>
>>> +     /*
>>> +      * Set quota enabled flag after committing the transaction, to =
avoid
>>> +      * deadlocks on fs_info->qgroup_ioctl_lock with concurrent snap=
shot
>>> +      * creation.
>>> +      */
>>> +     spin_lock(&fs_info->qgroup_lock);
>>> +     fs_info->quota_root =3D quota_root;
>>> +     set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>>> +     spin_unlock(&fs_info->qgroup_lock);
>>> +
>>>       ret =3D qgroup_rescan_init(fs_info, 0, 1);
>>>       if (!ret) {
>>>               qgroup_rescan_zero_tracking(fs_info);
>>>
>>


--f4q7enDNsppqyDiLU5LusMp1Y4wEPgivi--

--euS6pWrB4lmuOSgwtL7X7DiE8TxtlABho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvzVioACgkQwj2R86El
/qiQIQf+Jk8HfnoicFov54ZaQQsQpJLApjRU3bdBzHMnWgwQjwtdgSGbM1xT+bCx
AfZMIjrkOm/Qx7QfCl1m9y62r+CWVfsv0sbvqv+qI5j7q90zhClEbkFLbeieyOjM
iZRkCaE7BO1J7U7aWda5WCoXcscc19QOpPW/84D4avTkFx6Fw3kA+sVMKhBkfzH3
IZVj/wvVCcLXJ1jezbqWPEp7ppOlW7DTmLWu2ZspHbGeegNCRKKtK58GFQ1wmysO
apsKqt0Ob+Gu3pReZXYKXFWuyjWDTuMFxgWvXM1V/QcBauujDHR6znfysL9S5EJ8
mZYJGolUBnxS9cUnYolnUcs3FgKQ6w==
=vRto
-----END PGP SIGNATURE-----

--euS6pWrB4lmuOSgwtL7X7DiE8TxtlABho--
