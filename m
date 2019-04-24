Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7862BC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 08:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EAC9218D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 08:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="IOWtIN3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfDXIFA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 04:05:00 -0400
Received: from mout.gmx.net ([212.227.17.22]:60455 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbfDXIE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 04:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556093096;
        bh=eLqBcHPY+8VzFdOEs1mKah9WP7BeXZWkRUiMjK8lDn4=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=IOWtIN3fi44uq0MFGzmGVS/fs/V6mS6XPInsCA5Jcx8JHK5mddwBdO8xUi3SOyoNJ
         oJOXWAt9lA89E6PEI9uW0zJ9Uu0TJHBeY8jKXxJ8npIZCHJbPiU809Sjsag/6R01Fk
         f1Q2m88CGHV9ojClr3LvEZJJtjHQ4mpjsQ5XBVO8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lm7MT-1gkQFD1Wrp-00ZcgF; Wed, 24
 Apr 2019 10:04:56 +0200
Subject: Re: reading/writing btrfs volume regularly freezes system
To:     Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
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
Message-ID: <9338f259-47a7-11f7-8411-54f777a59487@gmx.com>
Date:   Wed, 24 Apr 2019 16:04:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0J72FThpnrvENI0gttMVqPCmVvJUqY7rx"
X-Provags-ID: V03:K1:MKwXPG6Q5Nz/Cio//FHkeXsTYnWtnGogjptz6IrWL+kWF3Ng+d6
 TNOiP83KQ5j9JKAUa/k2QoV/DPpSbhT0DqRgjdhYKtZSP38J4gfqCp1MFd6DslrwoJSNf6y
 eR3GqB4amDWcNKFrXsut15dGwMPAiBbdqPndWdRlpd7ohh+syoC+IkYyH0Mz8VmlOb/mW6w
 07VJ4XElJNYFNmWcj4/pA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jj7lza3Y38U=:L14+3y3WKTdDxtjLbkIOF5
 lyGNnvuSi7cz/JQf2ABjoq05cxqqQV/EtQrkzOpQ6x1Jvyl/vswpS4mSHkzS/xdM0iVkQv8Ta
 QCPGqQR4w8TGZ8FCyQxp/gC/jjVz8MqXZdku2+KyIUAEWKtxZdpBBx7ZtYRf7bKtcF3rB4DU7
 NND44MBQEjLmwwafLWmOTaKM+VhbZb6OsOvB5fesE+hwg6XzzyJJUpFtPHb5D5HeCyFRaE+3S
 Gk4PeucGgfJ+fx4+sxSCfhxpTwvaxX3Fem4DOwq5bgkQdaNxtEHpzNWZV1Qk0vr5xIrDcJCBS
 2ngkN3SiSEDMFL/PM4NLjSjJIjTXDeJiAWV4xEHIZbtRTDBZkdVoosrEJ3GqSFWaA+n2c+1oF
 WjVE2ki5nC78+reIp1Rd9fX5bumxRyOvdUbYtf90IcFY6mCaOFZVBzSMKJd9JUJO+V8zdz9e0
 ujZ6WPpnfQgALPbYXvN0/pYI6o5fccp7HY3uyFduROd2kg1Sqa5dTFl+yYeLjvOT8c1Wf3l+K
 XswhxPZ05ZQ1jYax+rQcnwzlrzLrBL6YJusHCXYK6VV9tgZkbyccOuI+93kmoBALQtLTvr47/
 VUzKLj3hnUhILCWW4o0wPVM7VUZZ25uYmiY4mZccn2gmx50arnjmqKlSGk8iNaHu3krCrLkRc
 GEwhhg+C6uizBtoDoKp/9ra3VPXcRbzjY6WPGQyr2jq/+M6TaUAlolJ1OaJ7EnHCGHlHp3408
 4Pfy/YOycG0fhSSJe9iLGS1kFJ8zM3qVXyJFeIqbBq7TpVYbHvv0SC4v6gE87youkD6J8HgvJ
 c/2qXuaGWVKzauDbJnrwytajELRhOU5ikZd77AmaOMp99oL3y/UFxuIM7h/rbo5Q6wF6r0eF6
 +iUBDzckh6xKG3JSS6X385uLj9OEqlyRfF2zojr51jaFgNuLH/H1UhJGZ6Qxc9
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0J72FThpnrvENI0gttMVqPCmVvJUqY7rx
Content-Type: multipart/mixed; boundary="MELrODi694Fv30cSPpOhfpvSldkvnBzwh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <9338f259-47a7-11f7-8411-54f777a59487@gmx.com>
Subject: Re: reading/writing btrfs volume regularly freezes system
References: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
In-Reply-To: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>

--MELrODi694Fv30cSPpOhfpvSldkvnBzwh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/23 =E4=B8=8A=E5=8D=884:37, Nathan Dehnel wrote:
> I have a raid10 volume that frequently locks up when I try to write to
> it or delete things. Any command that touches it will hang (and can't
> be killed) and I have to start a new ssh session to get into the
> computer again. Nothing fixes it besides a reboot, and the volume will
> fail to unmount while the computer is shutting down.
>=20
> [  302.360912] sysrq: SysRq : Show Blocked State
> [  302.360951]   task                        PC stack   pid father
> [  302.360987] btrfs-transacti D    0  2187      2 0x80000000
> [  302.360993] Call Trace:
> [  302.361007]  ? __schedule+0x59d/0x5f1
> [  302.361012]  schedule+0x6a/0x85
> [  302.361019]  btrfs_commit_transaction+0x219/0x7ac

Btrfs is waiting other transaction to be committed.

At that freeze, would you check which thread is taking CPU time?

Are you utilizing backgroup balance or qgroup?
If you have tons of snapshots, they may hugely slow down qgroup.
Or you just have a running balance with qgroup enabled, it will almost
hang your system.

It's going to be fixed in v5.2. While during 4.19 to v5.1 we have a lot
of optimizations to make balance + qgroup much faster.

Thanks,
Qu



> [  302.361027]  ? wait_woken+0x6d/0x6d
> [  302.361031]  transaction_kthread+0xc9/0x135
> [  302.361036]  ? btrfs_cleanup_transaction+0x4c7/0x4c7
> [  302.361041]  kthread+0x115/0x11d
> [  302.361046]  ? kthread_park+0x76/0x76
> [  302.361050]  ret_from_fork+0x35/0x40
> [  302.361064] nfsd            D    0  2292      2 0x80000000
> [  302.361067] Call Trace:
> [  302.361072]  ? __schedule+0x59d/0x5f1
> [  302.361077]  schedule+0x6a/0x85
> [  302.361120]  wait_current_trans+0x9b/0xd8
> [  302.361126]  ? wait_woken+0x6d/0x6d
> [  302.361131]  start_transaction+0x1ae/0x38e
> [  302.361135]  btrfs_create+0x59/0x1d0
> [  302.361142]  vfs_create+0xbf/0xef
> [  302.361160]  do_nfsd_create+0x2be/0x41d [nfsd]
> [  302.361214]  nfsd4_open+0x223/0x578 [nfsd]
> [  302.361229]  nfsd4_proc_compound+0x44a/0x562 [nfsd]
> [  302.361240]  nfsd_dispatch+0xb9/0x16e [nfsd]
> [  302.361258]  svc_process+0x524/0x6e2 [sunrpc]
> [  302.361270]  ? nfsd_destroy+0x5f/0x5f [nfsd]
> [  302.361278]  nfsd+0xf9/0x150 [nfsd]
> [  302.361284]  kthread+0x115/0x11d
> [  302.361289]  ? kthread_park+0x76/0x76
> [  302.361292]  ret_from_fork+0x35/0x40
> [  302.361297] nfsd            D    0  2293      2 0x80000000
> [  302.361300] Call Trace:
> [  302.361305]  ? __schedule+0x59d/0x5f1
> [  302.361309]  schedule+0x6a/0x85
> [  302.361314]  rwsem_down_write_failed+0x1af/0x210
> [  302.361325]  ? nfsd_permission+0xa3/0xe8 [nfsd]
> [  302.361330]  call_rwsem_down_write_failed+0x13/0x20
> [  302.361335]  down_write+0x20/0x2e
> [  302.361345]  nfsd_unlink+0xb1/0x16b [nfsd]
> [  302.361359]  nfsd4_remove+0x4e/0x10a [nfsd]
> [  302.361371]  nfsd4_proc_compound+0x44a/0x562 [nfsd]
> [  302.361381]  nfsd_dispatch+0xb9/0x16e [nfsd]
> [  302.361395]  svc_process+0x524/0x6e2 [sunrpc]
> [  302.361401]  ? __mutex_unlock_slowpath.isra.6+0x1e8/0x20a
> [  302.361410]  ? nfsd_destroy+0x5f/0x5f [nfsd]
> [  302.361419]  nfsd+0xf9/0x150 [nfsd]
> [  302.361424]  kthread+0x115/0x11d
> [  302.361428]  ? kthread_park+0x76/0x76
> [  302.361434]  ret_from_fork+0x35/0x40
> [  302.361441] rm              D    0  2388   2334 0x00000004
> [  302.361444] Call Trace:
> [  302.361449]  ? __schedule+0x59d/0x5f1
> [  302.361453]  schedule+0x6a/0x85
> [  302.361457]  wait_current_trans+0x9b/0xd8
> [  302.361462]  ? wait_woken+0x6d/0x6d
> [  302.361466]  start_transaction+0x1ae/0x38e
> [  302.361471]  btrfs_start_transaction_fallback_global_rsv+0x32/0x127
> [  302.361475]  btrfs_unlink+0x30/0xc0
> [  302.361478]  vfs_unlink+0xd2/0x147
> [  302.361482]  do_unlinkat+0x112/0x223
> [  302.361488]  do_syscall_64+0x7e/0x133
> [  302.361492]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  302.361496] RIP: 0033:0x7f681509b5d7
> [  302.361504] Code: Bad RIP value.
> [  302.361506] RSP: 002b:00007fffb1aed668 EFLAGS: 00000202 ORIG_RAX:
> 0000000000000107
> [  302.361510] RAX: ffffffffffffffda RBX: 000055672760c6c0 RCX: 00007f6=
81509b5d7
> [  302.361512] RDX: 0000000000000000 RSI: 000055672760b490 RDI: 0000000=
0ffffff9c
> [  302.361514] RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000=
000000000
> [  302.361516] R10: fffffffffffff12b R11: 0000000000000202 R12: 00007ff=
fb1aed848
> [  302.361518] R13: 000055672760b400 R14: 0000000000000002 R15: 0000000=
000000000
>=20


--MELrODi694Fv30cSPpOhfpvSldkvnBzwh--

--0J72FThpnrvENI0gttMVqPCmVvJUqY7rx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzAGJ8ACgkQwj2R86El
/qg+SAgArJurM5hSLzNQTzEViXZXzu4dwvcgrCK1zRhiO+qv5zPPwriZiKiWllve
N4J3m1iK34KwNSj8CZ3Bp5SklydcMPM2Ut9Q/xScy20YDTrcL+oJEtKisbr1gPN/
c2lpX9CgLYJ3E1xZTGORdgN703V3aOhzx93rHfQuerd7WdJkBTMwSTSTACI+gjGl
kfqRi4J9S9SXZO4aR/kS17+AuHEiqu6KA7utu3BfvCjiCETwOEVIcqPB0xlgnScs
DTKjhvXQw9eeGtP0qevRAv3u1fzoiGm3HD99UeDlPqwW85afM0wp6IX+uA42LqcJ
MhYrQ8KKkeVz5Tzbnhp/UAR20yF8dg==
=VR7+
-----END PGP SIGNATURE-----

--0J72FThpnrvENI0gttMVqPCmVvJUqY7rx--
