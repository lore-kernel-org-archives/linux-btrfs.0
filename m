Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC7AC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 044352133D
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbfB0Nli (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 08:41:38 -0500
Received: from mout.gmx.net ([212.227.15.18]:53203 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfB0Nlh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 08:41:37 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MCcvy-1gpfnz0U6s-009Ov9; Wed, 27
 Feb 2019 14:41:26 +0100
Subject: Re: [PATCH 1/5] btrfs: extent_io: Add comment about the return value
 of alloc_extent_buffer()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
 <20190222101645.4403-2-wqu@suse.com> <20190227133630.GJ24609@twin.jikos.cz>
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
Message-ID: <1471706f-ace7-b69c-4fd1-b1877128b813@gmx.com>
Date:   Wed, 27 Feb 2019 21:41:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190227133630.GJ24609@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6vwwYvivBPGciPFufoGwyPZjo5zjWuPYZ"
X-Provags-ID: V03:K1:Wt0IDKr32OE8BSvr+dMbhosFyA/vhhHB5zKC/KHMa1aQ3wnNZQT
 gRdc6VrpbRh3CcrfrapQmSGdRYt9zoD6QVxDJyCZ3HYwfrKG+0F/xtcgkm8bySNqCkxl664
 ax3s6HwrJd9H7mLqS18WVJ/RJUhXNr95Bb6hsCEuVaU4ZnNaAdOlbUYDv8i2kRoCEaPg15w
 WQsLxLKNTzFhr9gN7Ryfw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sxf8v4ky/mM=:1KCYlVe1a/9GdvJGuR6FRR
 2MrDeN6ymbGkow1NqSO8TjxdFmf4yrAslnrsFMxpSVAeRL+QgbdgsQFt9Rx3UVNJ+JLUDbZjV
 C7KrLqmCgHLpIUol41Mcvk8ZAA7MWNwSlqQvR1lPGlTdEI4Mt8Fvfvlgz5IFslP3N1ThmSrc3
 akzF1513iYSYNbiGa3lVcsjT5Hom7Rl0ixm5YwIhdBXyG/TvWor0k0K3vMJIE7EEZD0acw+Wd
 D539Pl0q/gpzLRclSJrB/2WZCKyMhX2d8VGMqRwZn5OSpcSazTctEJSDdsOb0wlGoUUpBT2aq
 UfwfsA2NcIjkxZDTmntIRcEZvZoQiY6hPWvfiKqW3U2HjtlAvgOdklY9jDBgHRFHgqIqfFe24
 kvMJVS6Z4BnuppQujDuNTqoAx+siKMN9kJuzZo4UdKGXduBiiQ36wujcQ515yFaayc/yEQpua
 nKxNHVNf65SfV2HBXr66JUYcBXMN7KLbsFOrLP3pSUHDxWwjNvxEY8DjyuG8s93i7LcWFiiMA
 1qcJqfTpmnuPtdKKl+mzvXrzKHg80o+uWlkzjSWXzCpsrZMdcHr1ICLMgs00vrU6Lv9K/tVwB
 zOgvzulLuBiS9hlGsobxlp9eb4GZXIMvkPAR9BvKI3zHfJ25mMbkmY4W3sRF5EyMzDbTiu5cP
 psY5acPxD7y30iZ5MQptpE9rhlBODh/ALiQZgs+kDHS0Hg4/MySbZhIjYyDj/95fm37gNlSlW
 Pd/4APtzdow/2uNSht+ZWYctuCfBikapOl2K4OKlQ/P2S5qLvpRRNWG9FDob27m5lg50tvwy0
 mIAKj9OwMlZmOJ9XBp82G0LCnQ+S06IvVdo3rYxcnXuE6cdXaflEGCMAWSrr4KQBsrIJ/7vm1
 nAekoaxsoOp78AVAQfvEcLq/sn1lwM70FR7mo1tG/YoAVCB8wqT2vlAeUNhIGr
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6vwwYvivBPGciPFufoGwyPZjo5zjWuPYZ
Content-Type: multipart/mixed; boundary="k6Rss1rPzZe88KaQAl4vsFU4o3NZKktz5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 dan.carpenter@oracle.com
Message-ID: <1471706f-ace7-b69c-4fd1-b1877128b813@gmx.com>
Subject: Re: [PATCH 1/5] btrfs: extent_io: Add comment about the return value
 of alloc_extent_buffer()
References: <20190222101645.4403-1-wqu@suse.com>
 <20190222101645.4403-2-wqu@suse.com> <20190227133630.GJ24609@twin.jikos.cz>
In-Reply-To: <20190227133630.GJ24609@twin.jikos.cz>

--k6Rss1rPzZe88KaQAl4vsFU4o3NZKktz5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/27 =E4=B8=8B=E5=8D=889:36, David Sterba wrote:
> On Fri, Feb 22, 2019 at 06:16:40PM +0800, Qu Wenruo wrote:
>> To inform later developers how to check the return value of it.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent_io.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 52abe4082680..b28a75546700 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4890,6 +4890,13 @@ struct extent_buffer *alloc_test_extent_buffer(=
struct btrfs_fs_info *fs_info,
>>  }
>>  #endif
>> =20
>> +/*
>> + * Allocate an extent buffer structure, with all its pages attached a=
nd locked.
>> + *
>> + * Return valid pointer if nothing goes wrong.
>> + * Return PTR_ERR() if failed.
>> + * Will never return NULL.
>=20
> I'd rather drop this as it depends on another function and the
> GFP_NOFAIL flag that will be removed eventually. The PTR_ERR covers
> ENOMEM and allocation failures.
>=20

I'm completely OK with the removal.

Do need to resend this patch?

Thanks,
Qu


--k6Rss1rPzZe88KaQAl4vsFU4o3NZKktz5--

--6vwwYvivBPGciPFufoGwyPZjo5zjWuPYZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx2k30ACgkQwj2R86El
/qj2hwf+NNBq5VyLJox0adGdOPy4VEFa+Yn/bPei/zE4nkrGcBEizYqEBNyJYCg+
14dmNeHWRjG5VzqbgaoGC2lhZuQa8auirD3aPoHxpPGqgdjQLquMWxAvZjYoSVls
CzTCSQq8EhKDyTsZFokDl+4mzzxc9Gy+p3xG/mniEFCA5t6L6oWQGekRRd6u7NbY
bwWKIi6WnILwfyg8A+Kf45CSD/VNcA3Qr3dYMxTP8hCzdbyEdJ/FX30lyAF0GiK8
qgwmALXcv3Sy/VRAdF+KAen9+2mZvdkqJQENfZl02oqMcpsVLmzrtrgGgRfMllHJ
1E+fy+d+8jzRy9+r2hF4AI6z9Vd47A==
=aEtW
-----END PGP SIGNATURE-----

--6vwwYvivBPGciPFufoGwyPZjo5zjWuPYZ--
