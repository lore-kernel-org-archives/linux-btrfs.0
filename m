Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70DDC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8701E2086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfAPB3j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:29:39 -0500
Received: from mout.gmx.net ([212.227.15.15]:58191 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbfAPB3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:29:38 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MLOMM-1gj23b1uk6-000cC3; Wed, 16
 Jan 2019 02:29:34 +0100
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Qu Wenruo <wqu@suse.de>, linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
 <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
 <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>
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
Message-ID: <3f0a8149-2e07-73a8-0cdd-46528f03915a@gmx.com>
Date:   Wed, 16 Jan 2019 09:29:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HldbEDmcmJfZfBzzUs4bUU8VAZnLtiLbV"
X-Provags-ID: V03:K1:SUU9hehPJCTxfNO0LZn//snhpkFO141cj7rFR4IKJgC1nFCADpZ
 kmkoucBvJ3zXB5hOsxb6OTqlwdmAkQ5IVusrdpYQ1hnFdqv4yQW2ClcdKBcD6fQRStJFHvM
 XpVNLdqJzz457zkEwdyS0KV0GMPPi5pl99ps0/28lUFwSrLQCsL5HczkMhTQ38PYM9CGRDX
 ATVTAhrC6PX71yBIj+Opw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LtXCcFpauPo=:/2fUElit6cT0imzDjpoyn6
 OEx5pj6N/qDicji3xIBkqzISWZ6114slOqBxvYH8Fhn869I1jv7nITkiAue1mgPH5YRu6V78A
 Q/b6YQqaQJiHdtTSBogq7V3ZgNfKhKD0fxG9Dy167HePWvyoww3LeDBRVc6Arb9ZH6jamATDT
 HxqrKBGIrRiWMpf2qQJbmOmrw48aVaQ3gIeo5pXk140VHsdbm3zaEJHrZ6h2zl4KQRLiPl/jq
 dTnTykC76N0JPmPZNcd/MkSIBZ1rteEyvuMGslFy/uTPkq7dMSVUzxIwIGm8NDTf304Jqt+nu
 Pswe6O0lAmH50xrJ6dwjYH5zPK4CZtiGnjQPQWgyJTM8c2RyiFMNqYZCVGh6S3xDWw5GumJ+u
 e842wOA4Rxb5gumZvhkv85Fvc82x+xQupOESERB2VUq1Cc5Fq3VS7hJiahdy28HDBf3bo/QNS
 P3EbL3bBAGr9ZSpqLWMSbPSzJTcSaa4PwIcph/z/m8gEZqB0YmLPFyz8QN1QaaKbLx/XZZgHP
 c60COiBjbOwqn2tPqZhBs+lAn+NTe6f87+Z1ILdLPJ77ISTp2rsZwTAcjnwK0cjxuTakxv0T0
 XuulAc3P2FLjza5YCOxBmDtbR4BYWiZ7qojhTYhhqqT6lSeTqMkE6fiW++quOSvSa78aB9oeI
 uigCr9acyTu/2W0vazKMibsmu+k8E63EAFUiA2kmyxkwIhaG6M8FvhdUjeYRTgolmY6pXdrwc
 akWkThHAYmks6tWwOthH8ICKeMM6AUIdrxIxbuXfMzEsvPy374iOmwg5BpUO3MgRXiHEF1fDc
 GPsleap42v+oBffJuvhCAcBsKik9z3RfacoAxnO7cSwqnAvz6Bty6QjLMmFpfHadHHp6k9WT8
 C63YZjCU6aRQSmja8iNbHABhxzKLY0YFlIJMLaclVFY2ilA58bSMhlp+VNEsol
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HldbEDmcmJfZfBzzUs4bUU8VAZnLtiLbV
Content-Type: multipart/mixed; boundary="TbpS1K2sKzF4gmZ1uATvmDTKUTzf2FElg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Qu Wenruo <wqu@suse.de>, linux-btrfs@vger.kernel.org
Message-ID: <3f0a8149-2e07-73a8-0cdd-46528f03915a@gmx.com>
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
 <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
 <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>

--TbpS1K2sKzF4gmZ1uATvmDTKUTzf2FElg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/16 =E4=B8=8A=E5=8D=889:15, Josef Bacik wrote:
> On Wed, Jan 16, 2019 at 09:07:26AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/1/16 =E4=B8=8A=E5=8D=888:31, Qu Wenruo wrote:
>>>
>>>
>>> On 2019/1/16 =E4=B8=8A=E5=8D=881:26, Josef Bacik wrote:
>>>> On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
>>>>> This patchset can be fetched from github:
>>>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
>>>>>
>>>>> Which is based on v5.0-rc1.
>>>>>
>>>>
>>>> I've been testing these patches hoping to get rid of the qgroup dead=
lock that
>>>> these patches are supposed to fix, but instead they make the box com=
pletely
>>>> unusable with 100% cpu usage for minutes at a time at every transact=
ion commit.
>>>
>>> I'm afraid it's related to the v5.0-rc1 base, not the patchset itself=
=2E
>>>
>>> Just try to balance metadata with 16 snapshots, you'll see btrfs bump=
ing
>>> its generation like crazy, no matter if quota is enabled or not.
>>>
>>> And since btrfs is committing transaction like crazy, no wonder it wi=
ll
>>> do tons of qgroup accounting.
>>>
>>> My bisect leads to commit 64403612b73a94bc7b02cf8ca126e3b8ced6e921
>>> btrfs: rework btrfs_check_space_for_delayed_refs.
>>
>> Furthermore, you could try this RFC test case to see the problem.
>> https://patchwork.kernel.org/patch/10761715/
>>
>> It would only take around 100s for v4.20 but over 500 for v5.0-rc1 wit=
h
>> tons of unnecessary transaction committed for nothing, no quota enable=
d.
>>
>> So I'm afraid that commit is blocking my qgroup patchset.
>>
>=20
> I've fixed the balance problem, it took 2 seconds to figure out, I'm ju=
st
> waiting on xfstests to finish running.
>=20
> And your patch making things worse has nothing to do with that problem.=
  Our
> test doesn't run balance, so the issue you reported has nothing to do w=
ith the
> fact that your patch makes our boxes unusable with qgroups on.
>=20
> The problem is with your deadlock avoidence patch we're now making a lo=
t more
> dirty extents to run in the critical section of the transaction commit.=
  Also
> because we're no longer pre-fetching the old roots, we're doing the old=
 roots
> and new roots lookup inside the critical section, so now each dirty ext=
ent takes
> 2x as long.  With my basic test it was taking 5 minutes to do the qgrou=
p
> accounting, which keeps the box from booting essentially.
>=20
> Without your patch it's still awful because btrfs-cleaner just sits the=
re at
> 100% while deleting snapshots, but at least it's not making the whole s=
ystem
> stop running while it does all that work in the transaction commit.
>=20
> And if you had done the proper root cause analysis you would have notic=
ed that
> we're taking tree locks in the find_parent_nodes() case when we're sear=
ching the
> commit root, something we shouldn't be doing.  So all that really needs=
 to be
> done is to check if (!path->skip_locking) btrfs_tree_read_lock(eb); in =
those
> cases and the deadlock goes away.  Because no matter what we shouldn't =
be taking
> locks when we're not given a trans in the backref lookup code.

That indeed looks much better than my current solution.

Although I'm not 100% sure for cases like tree blocks shared between
commit and current root (tree block not modified yet).

I'll definitely invest more time to try to fix this bug.

Thanks,
Qu

>  So the fact that
> we were doing just that and thus deadlocking should have been a red fla=
g.
>=20
> I will be sending these patches in the morning, once all of the various=
 testing
> that should take place on patches is complete.  The balance patches you=
 have for
> qgroups don't appear to be a problem, but that deadlock one is bogus an=
d needs
> to be dropped.  Thanks,
>=20
> Josef
>=20


--TbpS1K2sKzF4gmZ1uATvmDTKUTzf2FElg--

--HldbEDmcmJfZfBzzUs4bUU8VAZnLtiLbV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw+iPkACgkQwj2R86El
/qgtLgf+MKuCyhhAIQVHZqNUVbcv98M7eQVQd2lyMR79AD6oVfUYyUyf0pXzSqiN
MfuyVmOFu8LuKwduCZiikwWE9gfSUjRz/Uqkq+tH4CqjPv2VjxS6QaCdZbyCb61T
mQ0vWaDO43+D1fOmk9F6WUULtUUvymLezbF2f5/pOLlFpbNGTadFdEVi28muvb+X
9nXB0RbEc1rL1wRymSPdggVx5RjZyZFcy6I859PgkLOtVNDvzKwPs99qwbmz7aII
M7q9fab2NTI0b0zzF9as6S2miBLA+M683wiQwwhgNBTxIyF8zXA9L7I3aqoM8BOY
lz6V9GyMioQxAhvH19IuU5Lub56euA==
=/fhT
-----END PGP SIGNATURE-----

--HldbEDmcmJfZfBzzUs4bUU8VAZnLtiLbV--
