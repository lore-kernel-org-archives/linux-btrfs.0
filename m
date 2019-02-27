Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2E2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 11:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B367F2087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 11:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfB0L3c (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:29:32 -0500
Received: from mout.gmx.net ([212.227.15.15]:55407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbfB0L3c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 06:29:32 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lq9oW-1hTsId0pma-00dmri; Wed, 27
 Feb 2019 12:29:24 +0100
Subject: Re: [PATCH] btrfs-progs: gitignore: Ignore hidden files
To:     Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190227051602.28987-1-wqu@suse.com>
 <CAMU1PDi9GD9TC6B8kN4iGbeddOxkPH7B+UxeiVbC_KOwJvxnzQ@mail.gmail.com>
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
Message-ID: <62c5272f-6e30-4ea2-dff0-853bad22fb14@gmx.com>
Date:   Wed, 27 Feb 2019 19:29:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAMU1PDi9GD9TC6B8kN4iGbeddOxkPH7B+UxeiVbC_KOwJvxnzQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yntKIr4DyvUPU1Nhla0JCktRAJbAl8L32"
X-Provags-ID: V03:K1:fzRoUNDd5tt9v0ylUK7kxu0WgyGc8I/E/PPVp/OyjekiRIpSUFK
 0cAX+1ECHJPwpDJvAJE9yBfMVV5TQLiIAVULcHsyzDfpKJ/rPdanhKdu0YnsWNSmAuW8kJR
 pxsOEBokHBuI49X97aHCh1NW3/KiVGzgHyuxtY0OQ+AEVih4vhBsIb3OD2EsTwxzGXGUYae
 dvJpUelGzgdqpsEEICkuQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Eu8z++D4ifE=:RIItRn6BIR7ZgYyIg+hgqY
 k4BSL15TLesfXGINzFF58zx5aW/MA8XLnmmMHI/onH1OcBf8jWYIR0GH3QlqUMN1UqMH0MAxa
 W4Ht5DEwDmZKX7kOVeVCxdOukCmrTQpRkI2Gy0CisoYUlqEENI6NIexsHqyEQ3oKysURkPrvR
 xqdE1ngmGK5S5KW0iacMCZr2p1w/AZn13p9F4FKrfEfb4RVQS2uZD4hNx4Q6BaFmbIzBEyWif
 iatS/tVKHVdXyFZwYhO7FFXlwiP3XAUyEWbBDgerAOYiAcnSCLUBDiytfvW1kDELjw75BCrNm
 HE0Xjgw+S9zzgnMjUGkk1n351FEaINWewZoZuIA/ARXTB/Mty5EP8Uerk2kSii4g4ERiNzFQH
 QHhFJFBmiV2mdW3zV3OKF5NL711aWJkzknGy9w7+RASn5OGrXo/vhgn0lCX5ie6Nmzg3G5Wc8
 G+LZRaZx2Uore4oMdfrsLbnnKVXEoBnB+K6LrJQPiuiJ+NaG3+pqwaU/TgCQS2vTx7jdG5cmm
 y4tokU+mpV95sdx3RbyNWcxTQBlWQ8N2L2wGh+i7zIU/WnZtsSYry1eaYmjWCwj1Q0DJtfGBN
 xgD6eoKYfFWBadOk+SS21GoS1lMOKgWbhm6qPCe4Hwj9tNpo1YYx0BbetiXYKn83PbKfo2CJe
 iBIRpf+9/V4mz84g4CdM9SV+aDPYUkoznerzjzsGdYoLpeDOF5Nj2v+G+DZwwPEFgLdbw46fv
 U+0OZFL/f/HOxtSC0JFQ0uQigBteLULRggRPsmPq6PCeE0leyZ8IPH6QErqEwFEo8GslIQkVD
 vkwfJNZIRxMlXIS8ELtkwcb7b8ETuU2daaWAQEyjwjAeUZqq2XTvOSRB/XRlMEKrGZMw9bhtx
 vK1+pu8kfK3XWY6/0nfpemSMqXlkEFzSCJt+ekxVzdyZbYL3XwYHsKXruSftKG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yntKIr4DyvUPU1Nhla0JCktRAJbAl8L32
Content-Type: multipart/mixed; boundary="vx52d2c2ukOAzBNDgeXqxKTVyTk3b2w0f";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <62c5272f-6e30-4ea2-dff0-853bad22fb14@gmx.com>
Subject: Re: [PATCH] btrfs-progs: gitignore: Ignore hidden files
References: <20190227051602.28987-1-wqu@suse.com>
 <CAMU1PDi9GD9TC6B8kN4iGbeddOxkPH7B+UxeiVbC_KOwJvxnzQ@mail.gmail.com>
In-Reply-To: <CAMU1PDi9GD9TC6B8kN4iGbeddOxkPH7B+UxeiVbC_KOwJvxnzQ@mail.gmail.com>

--vx52d2c2ukOAzBNDgeXqxKTVyTk3b2w0f
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/27 =E4=B8=8B=E5=8D=887:22, Mike Fleetwood wrote:
> On Wed, 27 Feb 2019 at 05:16, Qu Wenruo <wqu@suse.com> wrote:
>>
>> A lot of editor/IDE related config files are hidden files, like .vimrc=

>> or .clang_complete.
>>
>> Instead of adding gitignore entry for each editor/IDE, just ignore all=

>> hidden files like what kernel does.
> I think you mean:
> files starting with ".", like ls does by default without the -a flag.

When I punched the words "linux hidden file" into google, I got quite a
lot of pages showing 'In the Linux operating system, a hidden file is
any file that begins with a "."'

So I think the words "hidden files" should be more or less OK?

Thanks,
Qu
>=20
> Mike
>=20
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  .gitignore | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/.gitignore b/.gitignore
>> index d9f022c48c7d..aadf9ae77d41 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -64,7 +64,7 @@
>>  /cscope.files
>>  /cscope.in.out
>>  /cscope.po.out
>> -.clang_complete
>> +.*
>>
>>  /Documentation/Makefile
>>  /Documentation/*.html
>> --
>> 2.21.0
>>


--vx52d2c2ukOAzBNDgeXqxKTVyTk3b2w0f--

--yntKIr4DyvUPU1Nhla0JCktRAJbAl8L32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx2dIkACgkQwj2R86El
/qid2Af/WwJZ3sYjAsZ5fRNzdGE1g6xXBmqarAWcLIBvb6MC51M7cNlygtCBwilH
nTSqiaJoYKJ4H9yzdBRXjvHLO7PiOdmuzqrpXmwT6B9SBHXHCuDUefkr/DuARnXL
Lpr5O3upbyuXDycCmJ927GqGnpFXg5tl7bv5Z4KZedeHAu1vwNcofRUDIopFPssr
Et5+pQqjJ3iezThIheJC50bCvfFq/AFebpzZkBXUZZoucXWcaWvCMkLpdKOh5i/C
hA2d79PD8TJ5Yx+2wJqFFE9EG5/L+g1+OcAeRPrJZiqtPCuCarVLcTePMvq/ZKnF
pr5UC0Yscgq9GpMUwC9JMTamAQB2rg==
=MX/+
-----END PGP SIGNATURE-----

--yntKIr4DyvUPU1Nhla0JCktRAJbAl8L32--
