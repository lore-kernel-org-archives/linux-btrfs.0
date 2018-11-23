Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DBFC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 11:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97A9620659
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 11:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97A9620659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394361AbeKWWDY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:03:24 -0500
Received: from mout.gmx.net ([212.227.15.19]:39281 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729651AbeKWWDX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 17:03:23 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MGSgq-1gCw4O3sxc-00DDYb; Fri, 23
 Nov 2018 12:19:08 +0100
Subject: Re: [PATCH] btrfs: relocation: set trans to be NULL after free
To:     Pan Bian <bianpan2016@163.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1542967815-14547-1-git-send-email-bianpan2016@163.com>
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
Message-ID: <1202a51d-8e91-2a72-e12f-8bb6090bd714@gmx.com>
Date:   Fri, 23 Nov 2018 19:18:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1542967815-14547-1-git-send-email-bianpan2016@163.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SslFt6b7DEBOxt800EIuFb8ywlnG3ttnc"
X-Provags-ID: V03:K1:qEpRo6Z6ryKE8YGID8thNC5DbYWcAZYkTNKeRnrwVXVdkNJgFaK
 mL/+cx1lehtPjB3jTEEM/7B/Ufa9kGoEgMiGT83oEOy/wOUjD9TRWPqT9uj1Dx6O87sMHsf
 oL48Ypp+CCsCjy+9aaAw97vZaYOxJTxVMrlnA+3sMGSS4YgMqgaBnKZe09VthfF8FD3FT/Q
 nQTOnon0MP7pJ2GHq3Ojw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6n8BLC6acO8=:328p0lL0i5SN4b4TFbgw3s
 GwNIy+Vs47SI9UgbIpCYVhkphebHVUEjE6AxZummB69BCQ6p6CFsjr/D9RBe2GzG0d3gOMGcP
 PZZLgIk9Ns9OHIvT3vSzTytpf5U0IOkYAFAU8pxpyDx9s2YWk9oF6WhCn0qkNA14OU9rgk8e0
 JuUeKYXlhfI+k2EKjAkPkJdr9Jbl6r4JCMD6cADqQG6IyMWEDyk3xD1N0kK2XVAF99C1faIRE
 c0NcKFhKT0O7O2zIO52abnqfhWfwKf4bFQYiXo31AFdefOo5/+0YgrxVoBfgTszEbaasx891u
 N5VyVR7hkqeZALrW6a9KlKMaIkeMQ6rY7bnXZik1+mK3qHHgGPXGI96xgsj+4OWAlZ7WxOzm7
 E6h8noJfmxTkT0Fpjx7KdhvWZlgOaGeMZqs6/CUAYgP5QpmEWPO2G0KvB1vkPPvTh1UnHaQvS
 m9KAVUhGyLt8Rm9kAI8GsXJae9+jwO/rdj5o0Y7bsFBt3qHswwbj42iPZrVqVxWfgplEv7WUX
 ghKad5wz6iWLIRsw1MudIpH+bT7T83ybYaKtJ7mbqeimgfHIvdQx0f77krt6d02CLHrDaCXbn
 UlFC89s7ERt2ilVI2OjG0fwavjHVwaLWGIAATO/tj2NpyY+SZj0qip6UvDUbQgQVeyaTfSxup
 e/OVI7Se1ugjaEOi2pDXlAgQA1YNFUBcsv5rMivOVy1BniDV43Mv7Ggg0CYQuqFI/PQRa8Cc2
 w/4hHnrnpvcxdH20dAbjxdtq7WJ/u9FpaVre3O/ZuvTy7LJMIExNGhGkTXeAd9UipJOKLLkc5
 nZKzpNVk/KPtCXmJFqPqhB+A++Btncvv6tUjgI6AF/RxY5cn046sg/Nx4Z3fc1RlhJRkhSb+Y
 x/JiUSm32vvhPjbAUgiVQbiu/Rx72DbsSQoE6nDsQ=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SslFt6b7DEBOxt800EIuFb8ywlnG3ttnc
Content-Type: multipart/mixed; boundary="bh0aRPMomep1jyi7BjMyv9Ti48mfIsQeL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Pan Bian <bianpan2016@163.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <1202a51d-8e91-2a72-e12f-8bb6090bd714@gmx.com>
Subject: Re: [PATCH] btrfs: relocation: set trans to be NULL after free
References: <1542967815-14547-1-git-send-email-bianpan2016@163.com>
In-Reply-To: <1542967815-14547-1-git-send-email-bianpan2016@163.com>

--bh0aRPMomep1jyi7BjMyv9Ti48mfIsQeL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/23 =E4=B8=8B=E5=8D=886:10, Pan Bian wrote:
> The function relocate_block_group calls btrfs_end_transaction to releas=
e
> trans when update_backref_cache returns 1, and then continues the loop
> body. If btrfs_block_rsv_refill fails this time, it will jump out the
> loop and the freed trans will be accessed. This may result in a
> use-after-free bug. The patch assigns NULL to trans after trans is
> released so that it will not be accessed.
>=20
> Fixes: 0647bf564f1("Btrfs: improve forever loop when doing balance
> relocation")
>=20
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/relocation.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 924116f..a3f75b8 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3959,6 +3959,7 @@ static noinline_for_stack int relocate_block_grou=
p(struct reloc_control *rc)
>  restart:
>  		if (update_backref_cache(trans, &rc->backref_cache)) {
>  			btrfs_end_transaction(trans);
> +			trans =3D NULL;
>  			continue;
>  		}
> =20
>=20


--bh0aRPMomep1jyi7BjMyv9Ti48mfIsQeL--

--SslFt6b7DEBOxt800EIuFb8ywlnG3ttnc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv34hwACgkQwj2R86El
/qjO7Af7BmKcQsDx/E044iiHVXGvZomI3qEYa8rkUXvG4cpPTfOKUqHagy8Vvoyg
RtfEpihP7TTM3IzFMI0HlbI+tZDkILPJ5UM+wOmcyIOpHyaDqIoYetNf9Du2nMnc
dfrWAhIyAGkFyxtfOpefadv76cMGhGmi8qRxHn8T4l41gr5i8p9EPTPIzVhvISgY
8MCus1+8AzENUlzuVnTklPSf7IYxOmVVXx4w4+RxO7nCXwd1G9mbF1r/C7E/H0Du
thvEuj/zqVIHRuueeLRCe189mRVMgn/r18JIJ5pBAu+4CmrW9ubx05o22mviwWJS
aYItOfo1nRB84VOWYqC+h9GSQS5rFg==
=ZjX5
-----END PGP SIGNATURE-----

--SslFt6b7DEBOxt800EIuFb8ywlnG3ttnc--
