Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1450C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97E2820866
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfAPBHi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:07:38 -0500
Received: from mout.gmx.net ([212.227.15.19]:59289 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbfAPBHi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:07:38 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MF5FT-1gTxQP0X75-00GLdj; Wed, 16
 Jan 2019 02:07:31 +0100
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     Qu Wenruo <wqu@suse.de>, Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
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
Message-ID: <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
Date:   Wed, 16 Jan 2019 09:07:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WKIQbpKRVreKJfruHu7as0PrXDDjs9VTN"
X-Provags-ID: V03:K1:I56IJToM8xoth0UandX0cFic+Tk59N0KsJhR5DbU3x1+nUw5baJ
 13jh1XfK6vXIMY+40fY0lBy0jweaa93CmLfGmWqXRqz6StmBxmjm3ELJoad3t+vNTnZ2cAn
 2Zn9t/OsTC4iR0Fa+qniI1sl0i/XESHDq91YvVvOtnRY0AqQ+UZjCycdD45BACJfxsif0ez
 UzyqlJWXObOGISe4RB3LQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mo905DPV410=:/sCdr/jQ/ZJD7eRdBccsqh
 8cYZNJwhJPtZjYNXDeJAywpELMz4gJvnSBeMikhke8vJdYASuANovqqJB38i+gIsWA9e+XCWo
 nxS8Di7yhDue4a7ywkQQxeRXvJw6Nv/DPVyky5q3S7uruX2k+yhnKd3V3Zym81Tvs5gRn9Ixf
 w+MxDbMLSgiyB104+NUCGoW8/19JaTwZ557gpq7Sq5i6dZ/7Ouwpf6bsEGSE3mrk22bYho/cb
 CLXQDXoy5s7bnAOJwyul0ycrlW3ST33lTnMKTv3siMLIeGzQxo9rQsvNhyw1SRqJ5/XAYmgoA
 Hy0h/5ZLkQp9DdsptxV4ATukSwHlDIfmk5hMyzUWj2vapPFNQ7u0JGRCDxHR8sadhq9En1cig
 LqzH2+OzqbNurV7UlG4G8P+j5TCl+73VI5+4pVT5rnFzU4EE9U3zqJKhhmwYhDDlBIj/CfsXx
 P/GEaNE3oyscj7HOYwbMBO4ZPMPf4by2kuR55PS3HMe6hiKT+JvZU/COw1syYuofoBmhAB4cO
 2kSSNRaB8pu2/BOura2oK7bBXkh4lCX9c7qScKGnhC3H78dN8ViAHNbkd98pExKjBVlv18OlW
 hZ5lhnkoyxNiQb11XpPF559LJBJBKTIzXrJ9tj5YV/CIx5fkMKwD3ibSxEcglF/A8Ei2YT4w0
 ctrKkxN5GYI3CvAUa1yvV7C7C8YcG65Jm7aYR83nukrOdOcNjowqAO6cSu7XcE8sZTjQW1yyS
 W53rqag3xUAmLqE3FBwErdmbTPFaQX/cSHJJ1kwBwbQM4qtcBswXO0lcUiJ6kzE5+hV1Kd+zo
 OtH+pyA8MMMIfHYq2zOkjAwLlVlSEy+OjKc6Pqw9S4V3hFC5Wf/X16RR5ij693gTH3ro5WnSV
 PppTDb4fiv8+hLUuP9VyepSxLUvtxQVpwmIhvwagdNKfsfOTNjUvKo7qC4FTIN
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WKIQbpKRVreKJfruHu7as0PrXDDjs9VTN
Content-Type: multipart/mixed; boundary="heRvYzHJAu4GEniaIev9PdhrSdDyEUTHX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.de>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
In-Reply-To: <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>

--heRvYzHJAu4GEniaIev9PdhrSdDyEUTHX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/16 =E4=B8=8A=E5=8D=888:31, Qu Wenruo wrote:
>=20
>=20
> On 2019/1/16 =E4=B8=8A=E5=8D=881:26, Josef Bacik wrote:
>> On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
>>> This patchset can be fetched from github:
>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
>>>
>>> Which is based on v5.0-rc1.
>>>
>>
>> I've been testing these patches hoping to get rid of the qgroup deadlo=
ck that
>> these patches are supposed to fix, but instead they make the box compl=
etely
>> unusable with 100% cpu usage for minutes at a time at every transactio=
n commit.
>=20
> I'm afraid it's related to the v5.0-rc1 base, not the patchset itself.
>=20
> Just try to balance metadata with 16 snapshots, you'll see btrfs bumpin=
g
> its generation like crazy, no matter if quota is enabled or not.
>=20
> And since btrfs is committing transaction like crazy, no wonder it will=

> do tons of qgroup accounting.
>=20
> My bisect leads to commit 64403612b73a94bc7b02cf8ca126e3b8ced6e921
> btrfs: rework btrfs_check_space_for_delayed_refs.

Furthermore, you could try this RFC test case to see the problem.
https://patchwork.kernel.org/patch/10761715/

It would only take around 100s for v4.20 but over 500 for v5.0-rc1 with
tons of unnecessary transaction committed for nothing, no quota enabled.

So I'm afraid that commit is blocking my qgroup patchset.

Thanks,
Qu


>=20
> Thanks,
> Qu
>=20
>> Thanks,
>>
>> Josef
>>
>=20


--heRvYzHJAu4GEniaIev9PdhrSdDyEUTHX--

--WKIQbpKRVreKJfruHu7as0PrXDDjs9VTN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw+g84ACgkQwj2R86El
/qh9Vwf+K9UfzhtdGag5D60MmFyBZgTEplBUdJ7Qd/HeLiasm9oUnIoLjWYTzWhW
kPvgbVa/vVw7OwuyfYBrZU0T2ZMXKT9ouLqcFywvI644UOkugLXHC9oOytYgfVRo
NHYNANCf4hvODByzwG1VaJKQk7VqvtmrE39KLO4kytYygaHuWhu1tQSiFm6k/H2d
gj9kRUTMyFf2tbqH1UDxTc4Xn7JPeWNCb1K7OK1NJ0ai51cHHhwiYNsahYwRLh/k
rOxcu2m1HvTrHSqg7CUEic1gHyv/ul+CNW7xOKUbd+lT8hGqyMHbxvKYEGb0Qsid
xPFFQoEQh9vYaBSxJcUZWyNKQ1b/3Q==
=mFS0
-----END PGP SIGNATURE-----

--WKIQbpKRVreKJfruHu7as0PrXDDjs9VTN--
