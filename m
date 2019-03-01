Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7A9C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 01:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BDCD20643
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 01:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfCABXe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 20:23:34 -0500
Received: from mout.gmx.net ([212.227.17.21]:43833 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfCABXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 20:23:33 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M7H2Y-1hEKkH26Jq-00x2LC; Fri, 01
 Mar 2019 02:23:00 +0100
Subject: Re: [PATCH] btrfs: Fix possible NULL pointer dereference in btrfs
 selftest
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190222005350.7535-1-wqu@suse.com>
 <20190228160253.GK31119@twin.jikos.cz>
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
Message-ID: <141399ee-667d-6adb-b0af-250fe1263f31@gmx.com>
Date:   Fri, 1 Mar 2019 09:22:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190228160253.GK31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cij0cnLLl0Uorewjg7vdhZm0eX72oN88d"
X-Provags-ID: V03:K1:FK8Elms5X00UH4v9gf2u4PMX19f8/tnFxsc52Wmg+T5cHHxRZqO
 8uCV6JBxQevehHE/A+jiaP8yfVk4fXmEoe1yZPvQEpbgGN/UkZ7Rf9jp/M9zxK5NET6Y5sE
 4UF0sbljsPTPNqOMFGFAWX4M38najGokw4kBmocNmASnwGSEEighb/0lYbCNQ3WArrYoNZ9
 9wx5LMCnjyFujxM6EBrQw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:J+q889svOCM=:kiBsPVdRkamd4eDCWadw5N
 G0QXFyfco/5gdTM5vzFe4n0NDfN042Lm5iGIU0aGFlXp2c+bgAOymtZ3KOL+wi9OVU9p/IKpw
 d1LOWmXIpUvt48qnF1F0qlYUheVapTqBUYV3qmTIWDTG9ZWPZiFwDfzty5TzKLZY5seNDc1xM
 4TKkGio0b7XOyztov3CgpDn+H4LsUieloGiC7VbG0R9DBuJN5wBgoLjrmEYiqHhKQZxgqTrv9
 W3FcXkg10mXmDt8lzkvJeLp3OnlOBwXNSuLPcnxhVSg2KtnhcrhlpDlMAzoHoOvt2yS1MHUTu
 UM02YlK/fZervp/Gxm6b+3m5lbi4ZYz3ZIrGVvMcKo6xLLcXbqmHDk+rds71mrw3SaKv5ux/o
 wkbu5dZCNPgTF2hnBlyusWxywWwtazcfsJpMxldC9kJqx/56hQBpR9Fd+YOzcQU/KpGnXvuLS
 Y0fhaVy7YwRt9e8hWEEXyMFtMvuyX57Ale1Nx1XYoCQsB2K/CnQMECYaYw6n+/ZAiXHVV8O+x
 a+qHPEDXgmoKSAoIb2TL9E0sxWpgZD/wfvpQc1egoURQeUnDouWRlwViwOWIR5sIRhAi8IeGg
 pKUCxBwxniYsHfNmhHNJEK6L0yk3QWM0DZydCugNVyKu16XcQqm/DdTRqCqekvfDJnk5YFJCw
 UfOFtjVg4BZu0H/RWLFY3EklQyvyRc8sALnSqTu6ed55WUuV1xYRXsC7wtJh/mm1/alkoUHtU
 l16q7HnNlzhzu+K0djF8pSvbH84mq+JuQlKTb1tMgxXgFR5yDN84DE5SB6SyaMb0GzhczVbIA
 f+vYQcB/0xU0alutlMq/PRiHq5nBsTIiKuuS6BPLtgamCpxgRhnDhBDKPmOm9qvhQlTjsFlkt
 kryTDxiz6glzbIvdED0zhWYGc/GTBbzB7oPVkmTVGhbHFRdDoXmbZ0YFcUHhOG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cij0cnLLl0Uorewjg7vdhZm0eX72oN88d
Content-Type: multipart/mixed; boundary="NuwSqD670dx9GDgAz7VxaZEUfxzIyhnOu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <141399ee-667d-6adb-b0af-250fe1263f31@gmx.com>
Subject: Re: [PATCH] btrfs: Fix possible NULL pointer dereference in btrfs
 selftest
References: <20190222005350.7535-1-wqu@suse.com>
 <20190228160253.GK31119@twin.jikos.cz>
In-Reply-To: <20190228160253.GK31119@twin.jikos.cz>

--NuwSqD670dx9GDgAz7VxaZEUfxzIyhnOu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/1 =E4=B8=8A=E5=8D=8812:02, David Sterba wrote:
> On Fri, Feb 22, 2019 at 08:53:50AM +0800, Qu Wenruo wrote:
>> When CONFIG_BTRFS_FS_RUN_SANITY_TESTS is enabled, btrfs will run
>> selftest at module load time.
>>
>> During selftest, we allocate extent buffer using
>> alloc_test_extent_buffer(), instead of alloc_test_extent_buffer().
>>
>> The problem is, unlike alloc_extent_buffer(),
>> alloc_test_extent_buffer() can return NULL pointer instead of error
>> pointer, and callers all expect error pointer other than NULL pointer.=

>>
>> So this could lead to NULL pointer dereference during selftest.
>>
>> Fix it by returning error pointer in alloc_test_extent_buffer().
>>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> This patch is obsoleted by https://patchwork.kernel.org/patch/10828221/=

> "btrfs: extent_io: Always return error pointer for extent buffer
> allocation failure", right?

Yup.

Thanks,
Qu


--NuwSqD670dx9GDgAz7VxaZEUfxzIyhnOu--

--cij0cnLLl0Uorewjg7vdhZm0eX72oN88d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx4iWkACgkQwj2R86El
/qiDSAf/Y27xvygyBflHkNBOsMhpgIwASX0GNaS9JzbsZUxeJsTnSc0Bm5FOGISQ
L1znMs7JwAEdYDqwAHEugrz96gOjRfx0zlLt2GYK/HyjTe5dvIFnsnCpCTvYhUGX
UOLr8QG5cG9bnfRY/1rqwAnJsp2SrijatkUcHseqwVw0i8O7h5OUWIusd7AouCmI
Wqk3RRL3po0VWIR9vt8asqqPq3ztC6wSFiDDIWNb/wHrxDi1G2y4f7/JdNuzg//Z
mWk9XXVbZOc9F2M4fb47EnaZHzmJUt8VPARBE0NMy+uOQjHyXw3ZT2DyHkakCZ+T
3uhvFZmEnxMvTLIzOhDnjerQEL41kg==
=gQ2i
-----END PGP SIGNATURE-----

--cij0cnLLl0Uorewjg7vdhZm0eX72oN88d--
