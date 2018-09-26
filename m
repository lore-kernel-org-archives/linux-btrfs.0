Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B816BC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 00:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CE0320684
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 00:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CE0320684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbeIZGaH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 02:30:07 -0400
Received: from mout.gmx.net ([212.227.17.22]:55909 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbeIZGaH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 02:30:07 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LjN0F-1fUGUZ0se7-00dTNC; Wed, 26
 Sep 2018 02:19:53 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LjN0F-1fUGUZ0se7-00dTNC; Wed, 26
 Sep 2018 02:19:53 +0200
Subject: Re: [PATCH 2/2] btrfs: tree-checker: Avoid using max() for stack
 array allocation
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180925000626.15474-1-wqu@suse.com>
 <20180925000626.15474-2-wqu@suse.com> <20180925153428.GF3255@twin.jikos.cz>
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
Message-ID: <848c89dd-2165-fcc8-9da7-0876a4e5a19c@gmx.com>
Date:   Wed, 26 Sep 2018 08:19:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180925153428.GF3255@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LuUv11ubse82NHs1usn32pr6Ia85p0XNb"
X-Provags-ID: V03:K1:ta86lb+rjJLs17W+CPcqRZd15z9cbO0hOvCkEbFhZDMXbDmusQr
 NMLz4GZQmcwuhoKZEvCxQaRZV8rUQQn5R4FkzFbM+/Gmwjwy8tUi/6b52jdhOLuOUTehpoM
 GYPXmAuLTnMTaTbxPqhM1alpktVyrMxSspetmuCxbfUXOdr8A1AIAdJ1cpDVtfy4d2KKn2M
 RAvH1mvh8xcrw7P4MeDAg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:EFEINTMUPPU=:GSAchcXXyg/HStgoL92cZF
 Og1JPxKyzSPCJxAQdXzq7jcRnUhgPS3LWzYLqFJHKBjX2vmlel/Xufd8vE0GuCSiJHBRQay1W
 /MKcZG8QEoexF6fQUdzeud0Ke5H/tOI+QrhKkdFRRUezzPd9oVfDIzq0HKCaybrfvnkagRCih
 hXPiunoyAsZApX/NQuw+vIWkaZr3399d/fu/grCaCpOyrqEcXVf+raTaSOEum0l+T0yI8quwx
 58+JOQJHbMT75huyDbU3znsVXEV9aOEiJwRTXUSmmJrOf9WMhbOP7BobHimcmSfAHRbfZVE8y
 svhcs9AwuSMjyd/7AyyJ2WGp2o3lmXBcsH+cL+loH0P5qbUOfTaW2W7V4o5CA322YkFARci7Q
 G+riXvl9EyDHFAk23SkMbvCxpuPuP6Bfyi0UYgJvibCp0GrDd/LtJp6JEvwrj22z4gwmeX6uA
 7zcXcIUDliLtIUqwYoX9eBbSShJXaY8ts1Y8i6g8X1qgNGfpqJAeLWj9sy3dvPEIhvDWFGiyF
 5rg8EAaurc5MPh70T9/tGWoJpX6zo2m9gGhccLKvLCKyEHAMyQV7NIZFl6ZjELjThULYBVJNy
 +meM1H5M9zo/8oKDR5nQIaDVnE1QFm6mUbAcPPyBsNak212IxcQ81qkcRiRD2FGkCPr/0lGR4
 wJaaEir6IvbkhlLzFmLaX661s0/ay5B7+G0cOq5GryFoakfzHY5/KkmhTv1gb5fqr5Pm6Klge
 dq2G8EuJrm983nJFbpsLctKE7HNQINpN8kJgQ4PRpDUUF6JWVzg8mxh+UBlEKvVS4y7LbhP4c
 rKbbZ1oYpK3GOdGKfg1UOywDStJ1w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LuUv11ubse82NHs1usn32pr6Ia85p0XNb
Content-Type: multipart/mixed; boundary="KB7q3nwsP6IETo8CwaZTDzOrUy4VlybI1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <848c89dd-2165-fcc8-9da7-0876a4e5a19c@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: tree-checker: Avoid using max() for stack
 array allocation
References: <20180925000626.15474-1-wqu@suse.com>
 <20180925000626.15474-2-wqu@suse.com> <20180925153428.GF3255@twin.jikos.cz>
In-Reply-To: <20180925153428.GF3255@twin.jikos.cz>

--KB7q3nwsP6IETo8CwaZTDzOrUy4VlybI1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/25 =E4=B8=8B=E5=8D=8811:34, David Sterba wrote:
> On Tue, Sep 25, 2018 at 08:06:26AM +0800, Qu Wenruo wrote:
>> Although BTRFS_NAME_LEN and XATTR_NAME_MAX is the same value (255),
>> max(BTRFS_NAME_LEN, XATTR_NAME_MAX) should be optimized as const at
>> runtime.
>>
>> However S390x' arch dependent option "-mwarn-dynamicstack" could still=

>> report it as dyanamic stack allocation.
>>
>> Just use BTRFS_NAME_LEN directly to avoid such false alert.
>=20
> Same reasoning as for the NAME_MAX, these are different things.
>=20
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/tree-checker.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index db835635372f..4c045609909b 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -336,7 +336,7 @@ static int check_dir_item(struct btrfs_fs_info *fs=
_info,
>>  		 */
>>  		if (key->type =3D=3D BTRFS_DIR_ITEM_KEY ||
>>  		    key->type =3D=3D BTRFS_XATTR_ITEM_KEY) {
>> -			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
>> +			char namebuf[BTRFS_NAME_LEN];
>=20
> The updated implementation of max() can now handle the expression
> without a warning, with sufficiently new compiler so I don't think we
> need to fix that.

Yes, it's mostly a workaround to make S390 happy.

And if it can be fixed by kernel config/compiler, it doesn't make much
sense to fix it here.

So please discard these 2 patches.

Thanks,
Qu

>=20
> Alternatively, you could use BTRFS_NAME_LEN and add a
> BUILD_BUG_ON(BTRFS_NAME_LEN < XATTR_NAME_MAX) with a comment why.
>=20
>> =20
>>  			read_extent_buffer(leaf, namebuf,
>>  					(unsigned long)(di + 1), name_len);
>> --=20
>> 2.19.0


--KB7q3nwsP6IETo8CwaZTDzOrUy4VlybI1--

--LuUv11ubse82NHs1usn32pr6Ia85p0XNb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluq0KIACgkQwj2R86El
/qgk9wf/cKIN8q2RQbQXZPLuy4KIW8YdP75P1YQkZv1KIN5KsJAUIkG+2paF2hME
GEEpr4jSrDTwq5p9AEwlMONC1EJuVYYXPW0sfacsO4rECZmitQEB16F4uXwBei/P
3LyDPVeyHpGj2D8KS21OQungJvKT+afhYO02V3AdoVAgPCdA846PhmyUN7DwXP7M
oPU7WmLqPKewmZ4QgShC+1r0fjQwEnAdwxjQaICQjY4LvbsXmRZx5TVUkmuCopBE
Y41QMgS2leTe7U767kXR+BB1hwrtRhR7/9bF/OUoXI9heXDkwSXmXYrbowM/Md3C
ey8w4GkoSIvJRMFFEHz/gLmjTFsWKg==
=QnKS
-----END PGP SIGNATURE-----

--LuUv11ubse82NHs1usn32pr6Ia85p0XNb--
