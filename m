Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740F9C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 05:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EF0D2082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 05:51:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EF0D2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbeLJFvw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 00:51:52 -0500
Received: from mout.gmx.net ([212.227.17.21]:49071 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbeLJFvw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 00:51:52 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LbdiB-1hC7fC09lb-00lDdC; Mon, 10
 Dec 2018 06:51:42 +0100
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181206193511.GF23615@twin.jikos.cz>
 <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
 <20181208004737.GH23615@twin.jikos.cz>
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
Message-ID: <98cbb487-a1e1-42fa-7d20-a2bd92187641@gmx.com>
Date:   Mon, 10 Dec 2018 13:51:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181208004737.GH23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v966sYBfRJJ5DN3lYUy8W190LdoGkbqgh"
X-Provags-ID: V03:K1:6gTWGnd76YmYoK0gDBj0IjlusWaaYVHvhC1daV5euE1t5/WtniU
 9QA18VJrMi1MdeP+u15aJ0dbPQALqVqiX6C4bV9VwHyHufs3J20jA27p7Y3kBpC96uo0/x1
 1Wpq4qgOeXUZmKvTzDM598m8me2GS9HbfctcZgEWKgKN8kJdAZYRX5TfVbbyDqyKkr4td2w
 oXqhTnnjAJSf1WHLwng9w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DJcjaFxjr4k=:CGYCVRXVHtkbqhum4zf4OP
 rQCKMpy7MICcS3FxPWz8kAOVrMEWbXtLOlStS2tKbJTCjQwqjVJ6WYC3OyebqGn76unMGsYGS
 FPw10Axfg1ilo4H5/rigqYpeLsIopzY/nl+YGzJdcoZ2ci7WbHniV0idyOnxIzvh9SCEcBFIc
 Kq5i8v0AtyRyCeyGNaOKwrj9AJh+oCQPJqvM8wkYirEi1qasWUoqPqvovmaNuA3NrirvVKKSu
 4N+rf7+b4sVDJTkzTbbOlgRxmQN7KmG+rUpVOWnqhaL+FuiCaBfxuHG86+AgzskVT7BsyQqOE
 sHiK/27/d6L+JVOFH5PH6E9bv5UNKyYU/lsssT413NiT+mDAPP1K7KcQjyb3Y5TKvU47SGRQ8
 VKM8dw/oaZ2+msymW0MfdFUZg6ijMZAFq/KFse0dJSb11refdVpDKjCAN6DYNO5TkPPJRCPRv
 HoCUGNlxIvBBu8zuS5cPbJvj/7QR3rRW5wEd+oNEXJMbjoTKkCTW+Gk7wl1DK3o2c+XflWHVO
 jZiTiJ/J46zpUW8aD9I/+I5x88AWx3vEFzBTITnWyCQ03TpYi6e08pRVY4iWhsli+aAx3HNQm
 dACiR9U0EI48WmcVkP72QeoZTElwSF+A4ybotyRQoljt9ldgZbMh19DAECbPsJzqsYGBa+eLJ
 HZ+DAn2vdJfDXaadIQy9GO/vUooSWNkNaoyDQ/kW3fFFlFGST9RhtIP5WZ1FUGdVcg8X3gvOd
 nrR/d7P+7ruZK2I7JthgRy7Q3V52106Lr9ht0nWm40e+Yp1qWB2h36KdwEECycvkpu5Xw8F5n
 udxxPEcCBi40gOwUguJIiYBNHx8Gx3RoUGIX9K3Je0neNW97MPP+fc9Dg5suPzOYvLHlnOyTJ
 Ch0FLXOAd3yDKBxzdqJ/HfFr7e+vbxn6hyVmKWdg6rO0rMjqCALeHwL/q8Br40
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v966sYBfRJJ5DN3lYUy8W190LdoGkbqgh
Content-Type: multipart/mixed; boundary="H8rP9ys88cBWQncuzNZR7c0X7R235FdqT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <98cbb487-a1e1-42fa-7d20-a2bd92187641@gmx.com>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181206193511.GF23615@twin.jikos.cz>
 <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
 <20181208004737.GH23615@twin.jikos.cz>
In-Reply-To: <20181208004737.GH23615@twin.jikos.cz>

--H8rP9ys88cBWQncuzNZR7c0X7R235FdqT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/8 =E4=B8=8A=E5=8D=888:47, David Sterba wrote:
> On Fri, Dec 07, 2018 at 06:51:21AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018/12/7 =E4=B8=8A=E5=8D=883:35, David Sterba wrote:
>>> On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
>>>> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
>>>>> This patchset can be fetched from github:
>>>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_reb=
ased
>>>>>
>>>>> Which is based on v4.20-rc1.
>>>>
>>>> Thanks, I'll add it to for-next soon.
>>>
>>> The branch was there for some time but not for at least a week (my
>>> mistake I did not notice in time). I've rebased it on top of recent
>>> misc-next, but without the delayed refs patchset from Josef.
>>>
>>> At the moment I'm considering it for merge to 4.21, there's still som=
e
>>> time to pull it out in case it shows up to be too problematic. I'm
>>> mostly worried about the unknown interactions with the enospc updates=
 or
>>
>> For that part, I don't think it would have some obvious problem for
>> enospc updates.
>>
>> As the user-noticeable effect is the delay of reloc tree deletion.
>>
>> Despite that, it's mostly transparent to extent allocation.
>>
>>> generally because of lack of qgroup and reloc code reviews.
>>
>> That's the biggest problem.
>>
>> However most of the current qgroup + balance optimization is done insi=
de
>> qgroup code (to skip certain qgroup record), if we're going to hit som=
e
>> problem then this patchset would have the highest possibility to hit
>> problem.
>>
>> Later patches will just keep tweaking qgroup to without affecting any
>> other parts mostly.
>>
>> So I'm fine if you decide to pull it out for now.
>=20
> I've adapted a stress tests that unpacks a large tarball, snaphosts
> every 20 seconds, deletes a random snapshot every 50 seconds, deletes
> file from the original subvolume, now enhanced with qgroups just for th=
e
> new snapshots inherigin the toplevel subvolume. Lockup.

Could you please provide the test script?
As I can't reproduce it in my environment.

I crafted my own test with some simplification, namely no qgroup inherit.=

However I can't reproduce the problem even with more snapshots
creation/deletion and more data.

In my test script, I created around 35 snapshots, deleted 6 snapshots,
with around 1000 data regular extents and 1000 2K inline extents.

My test script can be found at:
https://gist.github.com/adam900710/4109fa23fc5ba8fc6b37a9c8e52353c1

Thanks,
Qu

>=20
> It gets stuck in a snapshot call with the follwin stacktrace
>=20
> [<0>] btrfs_tree_read_lock+0xf3/0x150 [btrfs]
> [<0>] btrfs_qgroup_trace_subtree+0x280/0x7b0 [btrfs]
> [<0>] do_walk_down+0x681/0xb20 [btrfs]
> [<0>] walk_down_tree+0xf5/0x1c0 [btrfs]
> [<0>] btrfs_drop_snapshot+0x43b/0xb60 [btrfs]
> [<0>] btrfs_clean_one_deleted_snapshot+0xc1/0x120 [btrfs]
> [<0>] cleaner_kthread+0xf8/0x170 [btrfs]
> [<0>] kthread+0x121/0x140
> [<0>] ret_from_fork+0x27/0x50
>=20
> and that's like 10th snapshot and ~3rd deltion. This is qgroup show:
>=20
> qgroupid         rfer         excl parent
> --------         ----         ---- ------
> 0/5         865.27MiB      1.66MiB ---
> 0/257           0.00B        0.00B ---
> 0/259           0.00B        0.00B ---
> 0/260       806.58MiB    637.25MiB ---
> 0/262           0.00B        0.00B ---
> 0/263           0.00B        0.00B ---
> 0/264           0.00B        0.00B ---
> 0/265           0.00B        0.00B ---
> 0/266           0.00B        0.00B ---
> 0/267           0.00B        0.00B ---
> 0/268           0.00B        0.00B ---
> 0/269           0.00B        0.00B ---
> 0/270       989.04MiB      1.22MiB ---
> 0/271           0.00B        0.00B ---
> 0/272       922.25MiB    416.00KiB ---
> 0/273       931.02MiB      1.50MiB ---
> 0/274       910.94MiB      1.52MiB ---
> 1/1           1.64GiB      1.64GiB
> 0/5,0/257,0/259,0/260,0/262,0/263,0/264,0/265,0/266,0/267,0/268,0/269,0=
/270,0/271,0/272,0/273,0/274
>=20
> No IO or cpu activity at this point, the stacktrace and show output
> remains the same.
>=20
> So, considering this, I'm not going to add the patchset to 4.21 but wil=
l
> keep it in for-next for testing, any fixups or updates will be applied.=

>=20


--H8rP9ys88cBWQncuzNZR7c0X7R235FdqT--

--v966sYBfRJJ5DN3lYUy8W190LdoGkbqgh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwN/ugACgkQwj2R86El
/qjGYQf/b940MS7hK+jB6f1kRh6J32wnvHDjN0n5SCJdoOcxFFp6T17KvAT5Fht0
WuaiwmqfnK3HPcYkNHjt39l4LBE1opGyLx4DhGDvNJaYThzGMpEWNYhIYhqRC8e5
ZsShYANNlsVmJ8O30imTHER8ayb3ULtz4WIdssqXe9mw3D9TcnaWl91xDlt20ds/
Bq4R8gtnYEYHlUDC5Km+c42JLgpv2sE6/2l0wAoaDD4b+8gChu2M+Q0tATMobdlX
J6+Rz1a2B1SvHlOhI2fvIRUIepSZfNtfszLES+mD+6WVjL9sSPw1ZDHSZokZBMoQ
BC2jra0l1by8XekyZ1yhqngl81loww==
=oJ+R
-----END PGP SIGNATURE-----

--v966sYBfRJJ5DN3lYUy8W190LdoGkbqgh--
