Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853A3C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 00:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A25920854
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 00:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfCHAmC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 19:42:02 -0500
Received: from mout.gmx.net ([212.227.17.22]:58209 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbfCHAmB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 19:42:01 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M8qOm-1hE7Lg0zgC-00C7Fb; Fri, 08
 Mar 2019 01:41:53 +0100
Subject: Re: [PATCH v2 0/3] btrfs: trace: Add trace events for extent_io_tree
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190301024800.17649-1-wqu@suse.com>
 <20190307163204.GK31119@twin.jikos.cz>
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
Message-ID: <0adb6db9-db67-05e2-207c-14ca6ea32c64@gmx.com>
Date:   Fri, 8 Mar 2019 08:41:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190307163204.GK31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vEWZsldA2ewVa9ma7GHGU6XpDHARhkQRD"
X-Provags-ID: V03:K1:EHwXajd+lYWdd1fkuMJCw0HIH6ggWDiOdHf9V/Nc6J/Q7x83DyQ
 o+7irmrR+Qk/aEHr1xqJVDva4FE6jsNu/vaIF4HXIQOswhsjopYjrBB8+tU0EdtUn97PGPp
 mr1KBZBhhZNEeIbzfRyxaV+AyqYb1/pdKq88mcinHOmYo0X4MeQRkXpG77F+4/64El8xqk5
 oDs69kMpo5LQ9Dwh4ZNGw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vIoyIZH3QKM=:7IpnZCD23rwQrc4CKo4cWd
 aXu2Rd8l+rCKXUDpnOZL4ykVx6kaOf0C4FdIJItYurgkuMRMPsrmGBT8uqRFSjtLeHOt9CYFn
 cu6ALoTffxkW5qBPQGSQ6hdXFgxCYTniv2yg8/QH/ZWA22hJZJIXBF/K6cpTnS7h1WmLTa7jY
 PQSMu4ZCtNz36NY+MtkCEHwiM4ot46LkQXTB4seDEK3dSpJCtgtGaHNF0qm+n/DI5gX8xqUio
 d1+g01tDqXNj41lF8gDeaiMtfx2z8RIx8JNIjM3jA9cKnFs86lKhEJ6xeBzd269kTrqGhzQzw
 CB0+uUr4Mq4vMtnBh8O0FtwVxtlbP+9lpxx13goWHj1rAIzEODcNe8yjFl1Qk+VhaWmbBljSZ
 nhOA/n8KAnpwA4YCS1+879kxuYfpDmky3hAAnQRSOu3HClh3xKyx4UEVge7yKLfFvWjAbYve5
 q6lAxoHHyXTw6e7vxrmHSe1DXhgfCYtd73NRq/8EjeVy2DbwJw0dEyko5MoeF+ud5iSMMI927
 HrzAtj4W1920INHfm+ngye/KFQBjkOjVG2CMRnFiKzMnwxXgK/2wGLr6toCzkfYacj0AApcSo
 ZXYZ3VsmZuAQkVmEi6sl7T9Ce0fAgAz8czInfMZUGHEWSVB0qRzddiXheZ68wh+6url8zmxiJ
 maDt8WDr7yu/8hvr11aA4UpBpKTyAG0ihExJErcqb/e5hfLIsh3IkwQWq2gbyEWj+ijKMiUKd
 MKit/BNJS2q9vshcbJYDKIWrgQ80UfGas/ySa3eJzgCfLc1DCDfHITOrtfmJwK3NNUCKDdSIb
 DcMz7mssHvnRCeaqZGuSNIe01+bhuO2BouJXmLeLoFiPPwt/frZsnViIgkMCxIT24SnBg34gR
 PWr8ZJ4K2vMs3NEOZXbCfnTnsAmmPZdsYvQlgbrydQ01jDDkbLmzsY5N8V7dm8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vEWZsldA2ewVa9ma7GHGU6XpDHARhkQRD
Content-Type: multipart/mixed; boundary="Q8zCi5E5PgIsKm8HM3v144ntpzW3ZklZy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <0adb6db9-db67-05e2-207c-14ca6ea32c64@gmx.com>
Subject: Re: [PATCH v2 0/3] btrfs: trace: Add trace events for extent_io_tree
References: <20190301024800.17649-1-wqu@suse.com>
 <20190307163204.GK31119@twin.jikos.cz>
In-Reply-To: <20190307163204.GK31119@twin.jikos.cz>

--Q8zCi5E5PgIsKm8HM3v144ntpzW3ZklZy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/8 =E4=B8=8A=E5=8D=8812:32, David Sterba wrote:
> On Fri, Mar 01, 2019 at 10:47:57AM +0800, Qu Wenruo wrote:
>> - Allow NULL fs_info for TP_fast_assign_fsid()
>>   There is extent bits operation in selftest which is too deep to pass=

>>   fs_info. And since it's in selftest, it shouldn't trigger trace
>>   events.
>>   But to be safe, we still need to check fs_indo in
>>   TP_fast_assign_fsid(), for NULL fs_info, just keep fsid filled with
>>   zero.
>=20
> Ok, better be safe here. I'd still like to remove the conditional, as
> the tests typically access only a single filesystem we could export the=

> fs_info globally, avoiding the need to pass it around.

In fact, it's purely to be safe here.

Since the selftest is only executed at module load time, it's pretty
hard to enable trace event at that small time windows.
And if btrfs is complied into kernel, it's definitely impossible.

>=20
>> There is one point which need extra attention:
>> 1) Those trace events are pretty heavy
>>    The following workload would generate over 400 trace events.
>=20
> I'm not sure if 400 is considered a lot, I'd say 400.000 would be a lot=

> for the steps below.

Considering other btrfs events are hardly to hit 40 for that small
workload, among btrfs specific events, it looks a little heavy.

>=20
>> 	mkfs.btrfs -f $dev
>> 	start_trace
>> 	mount $dev $mnt -o enospc_debug
>> 	sync
>> 	touch $mnt/file1
>> 	touch $mnt/file2
>> 	touch $mnt/file3
>> 	xfs_io -f -c "pwrite 0 16k" $mnt/file4
>> 	umount $mnt
>> 	end_trace
>>    It's not recommended to use them in real world environment.
>>
>> Changelog:
>> v2:
>> - Introduce fs_info to distinguish different btrfs filesystems
>> - Code style change to make trace code more elegant
>> - Minor IO_TREE_* naming change.
>> - Use btrfs_ino() to replace raw inode number.
>> - Change extent_io_tree::owner declaration to avoid affecting spinlock=
=2E
>=20
> v2 looks good to me, thanks. I'll add it to the 5.2 queue.
>=20
Thanks for merging and update it for the renaming.

Thanks,
Qu


--Q8zCi5E5PgIsKm8HM3v144ntpzW3ZklZy--

--vEWZsldA2ewVa9ma7GHGU6XpDHARhkQRD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyBukwACgkQwj2R86El
/qh9fAf8D9kOzISFkYmjZi/DRLHqeaN1AhGLP9t1KL0vNhb2OKB9APJrcm7aXt0K
5B0+1iCuq9D+cG+Xt4YerF5M3dBeXG7iCNfzABUFv+3q7i/3+Ha2VQlZC5JOcQ4W
NFAfJL5I3mgeiOETU/xQkBtYG1DQcwrxpyicML1K8o2G/wmwyohWeG06PC4Dj6GR
W926BrZ7QL/h9Bag78fH/VEoT3u9Sf1U9UvB6JdFL3cAgOvdj7XWFxLWcoI9VGsX
vDcpxEQUQkycxrab0KWUdfMFQAB0Tsg/aralD5tuDV619pnXsngG3MffOpBvEfBe
t5yU3jNNOWf9966QCQTI4BgWbWi+zw==
=HjR/
-----END PGP SIGNATURE-----

--vEWZsldA2ewVa9ma7GHGU6XpDHARhkQRD--
