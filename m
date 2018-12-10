Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC42AC5CFFE
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 11:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8437A2084E
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 11:23:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8437A2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbeLJLXw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:23:52 -0500
Received: from mout.gmx.net ([212.227.15.18]:50173 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbeLJLXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 06:23:51 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LqQzp-1hALN42VLF-00e61B; Mon, 10
 Dec 2018 12:23:40 +0100
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     fdmanana@gmail.com, Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181206193511.GF23615@twin.jikos.cz>
 <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
 <20181208004737.GH23615@twin.jikos.cz>
 <4cea2079-cef5-6833-884d-a3c8edc4c14a@suse.de>
 <CAL3q7H61QEEHAK4PSfmx8PzO_cWRDPJeHEKizJjS=tdUzT2KSQ@mail.gmail.com>
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
Message-ID: <932660f6-e810-c456-e8da-0a8d68a44cc2@gmx.com>
Date:   Mon, 10 Dec 2018 19:23:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAL3q7H61QEEHAK4PSfmx8PzO_cWRDPJeHEKizJjS=tdUzT2KSQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wkIIXe0hneQXIEq9rrXDTB4LMlrdWW0V7"
X-Provags-ID: V03:K1:P1sZ2wDAxKurzCDVZwt5543lRU3SyAG6mykZiTooM6cEDIRqPJN
 9E9y6Da61ZrhRX6tNAFxqv1fNlKIHy5HVXNbZWkumr496HJP6+5W9uY8A5nMMS01wDdBtjd
 uv05IgJe/KF5820p7Xs/2PtlMfLAD/+LTuWuyWBz97muuQrMeD7piOYMfAt9JDGlycxL0jq
 iB6yluFiOjGjmjP8+iiKw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:36Lbap+arQM=:+ox7OkLg3uF+1kUM2F+6DH
 2g4hUEfAXNoDvNjVjQp0nQRkNI+eqvv2UixedXyhBrEWuO9qK55yScBHIMVa3SjVIINPYVJeI
 8M8+DKtWE3lrmPuZMNs0F9pxKBCroja3bR221ZxWvaLqE7d4HIW7XoFMoW5lx/t4UpUYu4Dm0
 /z+NXB9AMJiMtk2uD9UW4NwktBE+ckA1p58wv1qH+yM63vHaCkf6zZ15lY11ugtxVFyKwJmoN
 FIIWiLGi5eUnTpsvc1iww5crANb+rSTpqVVW2ZbQRiS3PIgh65iJ/pjBg2dQlOCY7nHZ+y0m0
 sPw1vBesqLjMbDk3D/gNIiR49lZmjRM2+0BG+oa1u1F42/2TBxASFaJ6IgRGyCX6kL3AvB8V4
 afr5k8MsYSglF5eVudeK/a4/x6LwO0AcxErA+rsmWq3/jZvaTNyY2TjhL5oyrhlkZPuPWq2It
 cgm3LBvlg5Gz3sQT2V4Ey1oAd8Xu2rUjpwZFySWhIldYAUZg6FE027c8yq7IXYSSdBzqp/jkZ
 2x5KbIZ1Q27M6z5l7Hq155kktePgl7OUdx414vWo0DhhI+akVeVOjZbdwACSMl9Bsj8kHm5Ih
 rA1pMjN20hit0wUEY9w9HVY/jyeMpZDDx8SF2kFgvFd8WP5gtuWHZF3S51xe0xFYloHinA49d
 SMGaf1yDTQFkWrs1IYfOWcLVus7qD6D5hO8HT6HaQrHo4Ue7vOiyVgMcBR1jVATj5iBTISI6h
 7ZmF5n8a8wc0a+lqdPZkvh50RUwpVFnlBtLM/7VcZUv0Vt02zBIYeM3jtJaW3XfaaLYSwmhiS
 5friiMURpmNIVdPolz0jC2tP5O1p9SDC0W/rgfWQGUmSy0HQns+7DbwOd8exkCT5zEbpK+ndr
 5ohYyFU2ifRN0g9McbkvU+8XIy+1io1I0vEKkq+643Jv70i5eJvWcJmQNkNofq
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wkIIXe0hneQXIEq9rrXDTB4LMlrdWW0V7
Content-Type: multipart/mixed; boundary="1opmuGCQAW0ENPaFcIK5EXBBl83eRo0HE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.de>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <932660f6-e810-c456-e8da-0a8d68a44cc2@gmx.com>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181206193511.GF23615@twin.jikos.cz>
 <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
 <20181208004737.GH23615@twin.jikos.cz>
 <4cea2079-cef5-6833-884d-a3c8edc4c14a@suse.de>
 <CAL3q7H61QEEHAK4PSfmx8PzO_cWRDPJeHEKizJjS=tdUzT2KSQ@mail.gmail.com>
In-Reply-To: <CAL3q7H61QEEHAK4PSfmx8PzO_cWRDPJeHEKizJjS=tdUzT2KSQ@mail.gmail.com>

--1opmuGCQAW0ENPaFcIK5EXBBl83eRo0HE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/10 =E4=B8=8B=E5=8D=886:45, Filipe Manana wrote:
> On Sat, Dec 8, 2018 at 12:51 AM Qu Wenruo <wqu@suse.de> wrote:
>>
>>
>>
>> On 2018/12/8 =E4=B8=8A=E5=8D=888:47, David Sterba wrote:
>>> On Fri, Dec 07, 2018 at 06:51:21AM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018/12/7 =E4=B8=8A=E5=8D=883:35, David Sterba wrote:
>>>>> On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
>>>>>> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
>>>>>>> This patchset can be fetched from github:
>>>>>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_r=
ebased
>>>>>>>
>>>>>>> Which is based on v4.20-rc1.
>>>>>>
>>>>>> Thanks, I'll add it to for-next soon.
>>>>>
>>>>> The branch was there for some time but not for at least a week (my
>>>>> mistake I did not notice in time). I've rebased it on top of recent=

>>>>> misc-next, but without the delayed refs patchset from Josef.
>>>>>
>>>>> At the moment I'm considering it for merge to 4.21, there's still s=
ome
>>>>> time to pull it out in case it shows up to be too problematic. I'm
>>>>> mostly worried about the unknown interactions with the enospc updat=
es or
>>>>
>>>> For that part, I don't think it would have some obvious problem for
>>>> enospc updates.
>>>>
>>>> As the user-noticeable effect is the delay of reloc tree deletion.
>>>>
>>>> Despite that, it's mostly transparent to extent allocation.
>>>>
>>>>> generally because of lack of qgroup and reloc code reviews.
>>>>
>>>> That's the biggest problem.
>>>>
>>>> However most of the current qgroup + balance optimization is done in=
side
>>>> qgroup code (to skip certain qgroup record), if we're going to hit s=
ome
>>>> problem then this patchset would have the highest possibility to hit=

>>>> problem.
>>>>
>>>> Later patches will just keep tweaking qgroup to without affecting an=
y
>>>> other parts mostly.
>>>>
>>>> So I'm fine if you decide to pull it out for now.
>>>
>>> I've adapted a stress tests that unpacks a large tarball, snaphosts
>>> every 20 seconds, deletes a random snapshot every 50 seconds, deletes=

>>> file from the original subvolume, now enhanced with qgroups just for =
the
>>> new snapshots inherigin the toplevel subvolume. Lockup.
>>>
>>> It gets stuck in a snapshot call with the follwin stacktrace
>>>
>>> [<0>] btrfs_tree_read_lock+0xf3/0x150 [btrfs]
>>> [<0>] btrfs_qgroup_trace_subtree+0x280/0x7b0 [btrfs]
>>
>> This looks like the original subtree tracing has something wrong.
>>
>> Thanks for the report, I'll investigate it.
>=20
> Btw, there's another deadlock with qgroups. I don't recall if I ever
> reported it, but I still hit it with fstests (rarely happens) for at
> least 1 year iirc:
>=20
> [29845.732448] INFO: task kworker/u8:8:3898 blocked for more than 120 s=
econds.
> [29845.732852]       Not tainted 4.20.0-rc5-btrfs-next-40 #1
> [29845.733248] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [29845.733558] kworker/u8:8    D    0  3898      2 0x80000000
> [29845.733878] Workqueue: btrfs-endio-write btrfs_endio_write_helper [b=
trfs]
> [29845.734183] Call Trace:
> [29845.734499]  ? __schedule+0x3d4/0xbc0
> [29845.734818]  schedule+0x39/0x90
> [29845.735131]  btrfs_tree_read_lock+0xe7/0x140 [btrfs]
> [29845.735430]  ? remove_wait_queue+0x60/0x60
> [29845.735731]  find_parent_nodes+0x25e/0xe30 [btrfs]
> [29845.736037]  btrfs_find_all_roots_safe+0xc6/0x140 [btrfs]
> [29845.736342]  btrfs_find_all_roots+0x52/0x70 [btrfs]
> [29845.736710]  btrfs_qgroup_trace_extent_post+0x37/0x80 [btrfs]
> [29845.737046]  btrfs_add_delayed_data_ref+0x240/0x3d0 [btrfs]
> [29845.737362]  btrfs_inc_extent_ref+0xb7/0x140 [btrfs]
> [29845.737678]  __btrfs_mod_ref+0x174/0x250 [btrfs]
> [29845.737999]  ? add_pinned_bytes+0x60/0x60 [btrfs]
> [29845.738298]  update_ref_for_cow+0x26b/0x340 [btrfs]
> [29845.738592]  __btrfs_cow_block+0x221/0x5b0 [btrfs]
> [29845.738899]  btrfs_cow_block+0xf4/0x210 [btrfs]
> [29845.739200]  btrfs_search_slot+0x583/0xa40 [btrfs]
> [29845.739527]  ? init_object+0x6b/0x80
> [29845.739823]  btrfs_lookup_file_extent+0x4a/0x70 [btrfs]
> [29845.740119]  __btrfs_drop_extents+0x157/0xd70 [btrfs]
> [29845.740524]  insert_reserved_file_extent.constprop.66+0x97/0x2f0 [bt=
rfs]
> [29845.740853]  ? start_transaction+0xa2/0x490 [btrfs]
> [29845.741166]  btrfs_finish_ordered_io+0x344/0x810 [btrfs]
> [29845.741489]  normal_work_helper+0xea/0x530 [btrfs]
> [29845.741880]  process_one_work+0x22f/0x5d0
> [29845.742174]  worker_thread+0x4f/0x3b0
> [29845.742462]  ? rescuer_thread+0x360/0x360
> [29845.742759]  kthread+0x103/0x140
> [29845.743044]  ? kthread_create_worker_on_cpu+0x70/0x70
> [29845.743336]  ret_from_fork+0x3a/0x50
>=20
> It happened last friday again on 4.20-rcX. It's caused by a change
> from 2017 (commit fb235dc06fac9eaa4408ade9c8b20d45d63c89b7 btrfs:
> qgroup: Move half of the qgroup accounting time out of commit trans).

I have to admit, this commit doesn't really save much critical section
time, but causes a lot of problem for its ability to trigger backward
tree locking behavior.

Especially when its original objective is to reduce balance + qgroup
overhead, but did a poor job compared to recent optimization.

I'll revert it just as what we did in SLE kernels.

Thanks,
Qu

> The task is deadlocking with itself.
>=20
> thanks
>=20
>=20
>> Qu
>>
>>> [<0>] do_walk_down+0x681/0xb20 [btrfs]
>>> [<0>] walk_down_tree+0xf5/0x1c0 [btrfs]
>>> [<0>] btrfs_drop_snapshot+0x43b/0xb60 [btrfs]
>>> [<0>] btrfs_clean_one_deleted_snapshot+0xc1/0x120 [btrfs]
>>> [<0>] cleaner_kthread+0xf8/0x170 [btrfs]
>>> [<0>] kthread+0x121/0x140
>>> [<0>] ret_from_fork+0x27/0x50
>>>
>>> and that's like 10th snapshot and ~3rd deltion. This is qgroup show:
>>>
>>> qgroupid         rfer         excl parent
>>> --------         ----         ---- ------
>>> 0/5         865.27MiB      1.66MiB ---
>>> 0/257           0.00B        0.00B ---
>>> 0/259           0.00B        0.00B ---
>>> 0/260       806.58MiB    637.25MiB ---
>>> 0/262           0.00B        0.00B ---
>>> 0/263           0.00B        0.00B ---
>>> 0/264           0.00B        0.00B ---
>>> 0/265           0.00B        0.00B ---
>>> 0/266           0.00B        0.00B ---
>>> 0/267           0.00B        0.00B ---
>>> 0/268           0.00B        0.00B ---
>>> 0/269           0.00B        0.00B ---
>>> 0/270       989.04MiB      1.22MiB ---
>>> 0/271           0.00B        0.00B ---
>>> 0/272       922.25MiB    416.00KiB ---
>>> 0/273       931.02MiB      1.50MiB ---
>>> 0/274       910.94MiB      1.52MiB ---
>>> 1/1           1.64GiB      1.64GiB
>>> 0/5,0/257,0/259,0/260,0/262,0/263,0/264,0/265,0/266,0/267,0/268,0/269=
,0/270,0/271,0/272,0/273,0/274
>>>
>>> No IO or cpu activity at this point, the stacktrace and show output
>>> remains the same.
>>>
>>> So, considering this, I'm not going to add the patchset to 4.21 but w=
ill
>>> keep it in for-next for testing, any fixups or updates will be applie=
d.
>>>
>>
>=20
>=20


--1opmuGCQAW0ENPaFcIK5EXBBl83eRo0HE--

--wkIIXe0hneQXIEq9rrXDTB4LMlrdWW0V7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwOTLUACgkQwj2R86El
/qgo1gf/e7n/Hbn8BQCstjpVPLkGCm1yZxsKPyEtqyAjy9HOyBta6/puxWEkBoJF
leT3E0DEFRVOa41hhRZlPPoXzqdOK1SAyjvRY2pPWPU7EmELrs7g558fxw/Qh/xK
WKyCeSchd5NGGvlD6ka74iKX6PyAv2mNv/vjZaiSlNafAsNO8fg9FONlUPFBPnTO
IxJHgEqzmqQJskEllK+tOUWc3+WhLRNPaO1G4qehoGBDsl+1ULf2h1BMU0Bpx4FD
n1x48wTIqgvXvPv59RwVgZJFdopwyP2Ni1EnQq42wHaZgRwswS1R1jjvtGjaxsIb
eHzna8cHV/hlAUjlNkb8klu7ry5XQw==
=Moqz
-----END PGP SIGNATURE-----

--wkIIXe0hneQXIEq9rrXDTB4LMlrdWW0V7--
