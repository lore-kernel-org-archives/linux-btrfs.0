Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EB2C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFCD32084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFCD32084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbeLEODt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:03:49 -0500
Received: from mout.gmx.net ([212.227.15.15]:36989 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbeLEODt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 09:03:49 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MhRI2-1gpu8p39og-00MZGJ; Wed, 05
 Dec 2018 15:03:38 +0100
Subject: Re: [PATCH v2 07/13] btrfs-progs: Fix Wmaybe-uninitialized warning
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181205064018.27755-1-wqu@suse.com>
 <20181205064018.27755-8-wqu@suse.com> <20181205134005.GB3905@twin.jikos.cz>
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
Message-ID: <926908c6-14c0-5c10-7ce2-de4b810e702b@gmx.com>
Date:   Wed, 5 Dec 2018 22:03:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181205134005.GB3905@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cgeltA27miE5VxTVsT2Adh3QmybuFdiP6"
X-Provags-ID: V03:K1:ucTOMf7piIZFQX2J9Og9xuDnFcCGduWFvbaP9+L9oy2Z8hhk2cT
 ucDYMUQMr9b3P1qqvAC79fBWfMDqGfxNwosBZNPtmkFllwSP/L7axsHZYz5elScJ5hE7nkm
 TrnvEe0DbxFqgb754V/Jht2jD5ufM7urhCrmvHgZWVApye1c8YJvLoaFmY/LgBnBekbqFB7
 hnMoMzlxH29sinP4Vsqew==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YY7Ixqgqm3U=:nwfFbeNO5JgVwlaz996Qrv
 NYxXy418zCm6fe8G2kXWGUij8+j9sorz5gENXflDPNt5St6Hs2yZYS+AoOkAkRDbT4jWtnL5Y
 nP0E0j17BHZbM5+f/TcSZEd+xEhEBsUkMWh4M6m5GxdgWk2Ale6c8gbzxumUR14fky5aeP0MA
 AER1gIV+KkMZrbsi47vHYgMtIB0P+PG41raxzccHI8O2tAIPxtMi8JTll9MXmeTFODKM27X6f
 SxwvDx2sH2JfZGaEdnYgT2zErWau5/QFbxxehvSl2JPqU8xOSNj1bzVOkhys1Hn+x33An2Vow
 992A/p6yOue5XlMUdIFCoGqlWuRAyBoe16i1aO/2kJTwAVINbmELzgOwH13wsxIPO0VS2Lhmy
 5f5RBbXvidazpEfSgBxXpCsSGxgVcf8STF1mf+HDmZK2bQLecCLUGvzpWwSZgqpVZyRTQEdRG
 SWDJSPGHvw0yUExUL8Ei4Nw0aRGsVxKbDtaizEVZkmdHQdQvUq/gnQ9ZmPm/DntrBdmdhKIfI
 IvGBTHnQulMU3PJeLtDzYmXgWW6GZhXgbQyMddHDbASDFDZ0AvW3ArUhR6Vdg538Ydo6e9/+G
 EZWhfoVoKk0BXUrFaun2URgYlqfNAgpZwTBy4Xa+0ZpRvC/8QzGr0eNICcGgYSH8Sa4Oofkh7
 rhxdcXaRFi7wrxtuDVWO3SJ9L+R+xhG0vB6e0ipKkYS9R45FHgpHo/3WTnAa6/KFfs6wtQdk1
 KOYrVP2P/Wyc5puk8RXQL/s2lEjsPwZSesdjM04w0tFI14T9dQXqe4pJtPsklHiSzz7cGSv3v
 +2djYA4oof7YfQMGO97gY7pD5p/CifAgVXrzFo2rXXtvJpozF6o3ocDUCo3Hah/0gjpDzFVA+
 o2IVly5vI1BU+kpRv5EA1EdkbS7gNHgrC2DUe85dT47mP6IJatMU+E/OeB23UV
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cgeltA27miE5VxTVsT2Adh3QmybuFdiP6
Content-Type: multipart/mixed; boundary="POUCqF7pVN2LKzHd6j8zyLrdxg7svQRnV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <926908c6-14c0-5c10-7ce2-de4b810e702b@gmx.com>
Subject: Re: [PATCH v2 07/13] btrfs-progs: Fix Wmaybe-uninitialized warning
References: <20181205064018.27755-1-wqu@suse.com>
 <20181205064018.27755-8-wqu@suse.com> <20181205134005.GB3905@twin.jikos.cz>
In-Reply-To: <20181205134005.GB3905@twin.jikos.cz>

--POUCqF7pVN2LKzHd6j8zyLrdxg7svQRnV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/5 =E4=B8=8B=E5=8D=889:40, David Sterba wrote:
> On Wed, Dec 05, 2018 at 02:40:12PM +0800, Qu Wenruo wrote:
>> GCC 8.2.1 will report the following warning with "make W=3D1":
>>
>>   ctree.c: In function 'btrfs_next_sibling_tree_block':
>>   ctree.c:2990:21: warning: 'slot' may be used uninitialized in this f=
unction [-Wmaybe-uninitialized]
>>     path->slots[level] =3D slot;
>>     ~~~~~~~~~~~~~~~~~~~^~~~~~
>>
>> The culprit is the following code:
>>
>> 	int slot;		<< Not initialized
>> 	int level =3D path->lowest_level + 1;
>>  	BUG_ON(path->lowest_level + 1 >=3D BTRFS_MAX_LEVEL);
>>  	while(level < BTRFS_MAX_LEVEL) {
>> 		slot =3D path->slots[level] + 1;
>> 		^^^^^^ but we initialize @slot here.
>> 		...
>> 	}
>> 	path->slots[level] =3D slot;
>>
>> It's possible that compiler doesn't get enough hint for BUG_ON() on
>> lowest_level + 1 >=3D BTRFS_MAX_LEVEL case.
>>
>> Fix it by using a do {} while() loop other than while() {} loop, to
>> ensure we will run the loop for at least once.
>=20
> I was hoping that we can actually add the hint to BUG_ON so the code
> does not continue if the condition is true.
>=20
I checked that method, but I'm not that confident about things like:

bugon_trace()
{
	if (!val)
		return;
	__bugon_trace();
}

__attribute__ ((noreturn))
static inline void __bugon_trace();

This is as simple as just one extra function call, but the original
problem is just one more function call before hitting abort().

So I just give up screwing up things I'm not comfort enough to tweaking.

The current do {} while() loop is the most direct solution, if gcc one
day still gives such warning then I could say some harsh word then.

Thanks,
Qu


--POUCqF7pVN2LKzHd6j8zyLrdxg7svQRnV--

--cgeltA27miE5VxTVsT2Adh3QmybuFdiP6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwH2rIACgkQwj2R86El
/qjfAwgApG130WyOTgjS8tmDAFzZwfqAwubkzPtNhXByHCT+A9NXScVBkUwzFw3r
2AmS/hfyxlAAhJfRCKPU3GSdf/UK3c0U+zl1Zpvo4mEgdx4qME+qG9DGfbS5XyUc
E89+CH1aRFUkUitpCvjR6w8G9o7sGN3HUiz1/re27/caIqfsimNmrnTwGZqOf98m
j53NHClideBQzPQ3WN6erYaKrm6OyF22tNYlbkFraDK9om1xvsII/1xZkmaCb3QM
3strWOxT9VgQNyg51REXvsbYSlmCZeYIzIKgR2RLClgWY0JdJzeSCjyEzX5uhs1n
JLQ3a4xNiphSvH4tmDxW1On0bEFOJQ==
=r+sW
-----END PGP SIGNATURE-----

--cgeltA27miE5VxTVsT2Adh3QmybuFdiP6--
