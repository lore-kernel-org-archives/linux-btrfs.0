Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21783C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 05:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E18992081C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 05:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E18992081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbeLEFjL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 00:39:11 -0500
Received: from mout.gmx.net ([212.227.17.20]:60043 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbeLEFjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 00:39:11 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHbpA-1gVWMT2wwe-003R27; Wed, 05
 Dec 2018 06:39:02 +0100
Subject: Re: [PATCH 7/9] btrfs-progs: Fix Wmaybe-uninitialized warning
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-8-wqu@suse.com> <20181204121704.GL17773@twin.jikos.cz>
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
Message-ID: <2607d713-d0a6-d608-61cd-e72a8254301e@gmx.com>
Date:   Wed, 5 Dec 2018 13:38:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181204121704.GL17773@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nJMr9YlEIXJSlUVaKHN0MqfAqG3ysNIRA"
X-Provags-ID: V03:K1:7zGpjB9aeTc+QDeV8MS4WpU1jysar7d4cUrnlzeWhOygb28wlZ9
 bhQAfJN3OYL9sJD53HWZ3Ie+iPQgNqlKUFvFzbWK8a3P7HmFDw8062noueZZqoQGlpQtU+6
 vOxhgxJu6ShGe5e0wEHi9Ir34QeCVRKkj0CGtCHLX4tCs5jQ2jeOZHHmSqOq9WDBGMjfioP
 AAQzYcbJ/etV6usWlDskA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:J4Mb7YcIm40=:QX5KpTTYa/iy61XSWEpqjZ
 b0M9q7Tfq/UtqYkvcSiCNVkXZ55mZzBz71Ikn5vnJYil8/ikrEPseXKl9WXe35B15E/hPbBun
 slds3nkRsX1CXnFUT+FPjkSBawUpuo7SvKbHYvChI/olOmtePwbeyukkkzXGyJQtGXCXs18Zg
 vGvN4FHt+6GUtohJ6NJGYpUqxZv3nw45lR+tLX/14mB+KAO5TNck2yUEshWiX8DSQ3a9VQWpo
 p6xi/P7vQADWX9Y/lyHKXJkY2jMZewKCiArjIN9bUXz9L9ZW82wnbUgKXqm9aO+apl1JrdV6V
 dBwUA9kO5tWRTZM0l+9KpzX27A1J3R1Qo/oUqhJHtTHMoGuUVlkA3H9F8VZ3Q8iTRuJp4nIaz
 bKw5vcPN5ZMUunw/EpceHLWkmBZ/e0QLbyMMVcIws1hz8NhD/2rXpud5gsJ07H0A0Ei6oM2dz
 WYWhfl3vZ3XMvbbgwm47xXbNlC9yWHf5kAT/oynXPbdJcbviCdSWVHoywsT9erft2MGXBoQRW
 hGB24bm1J/bLDFVeQY00xjv5rnh7nBj7QnEQmg5P2oZ1dGRRqEr1BdYHJQPEwbIot34R6D6Ld
 iFUm47DzohMT3CJDxxdu8+pYoyZZVIODBE27N6ocropcQJSOZ6aeVUJIj+QRg3wTuaqEaK26z
 kgjmgFXO06XFCEagrQXEgkMX49CIjLdIYl8ZyjxbSvqQ/zn/HMFS0Fgb9i6mGZzr1D2IptsEN
 XxZ4xg1FbpdomWvDsBhizbbY5KDvpyEd2/viFLhhdx2XM5K+6hpR3yjdsYGMbzCEfSC29Hqlb
 ZxM4HxyX43jmwfk5H66I3PFHom437WGCTg4kehFUGv6i6nE847f0G10YVBCl4Rn2fo/44DLy8
 efYZeUhzC9Gcu9y8iATEl7YWTDrCcGW9Vz+bGVfiJ/5nKAd0uRnDnK2J5xTxQR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nJMr9YlEIXJSlUVaKHN0MqfAqG3ysNIRA
Content-Type: multipart/mixed; boundary="MY8575BzpHnpFBlEX6ZSPChXL6coTPlYD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <2607d713-d0a6-d608-61cd-e72a8254301e@gmx.com>
Subject: Re: [PATCH 7/9] btrfs-progs: Fix Wmaybe-uninitialized warning
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-8-wqu@suse.com> <20181204121704.GL17773@twin.jikos.cz>
In-Reply-To: <20181204121704.GL17773@twin.jikos.cz>

--MY8575BzpHnpFBlEX6ZSPChXL6coTPlYD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/4 =E4=B8=8B=E5=8D=888:17, David Sterba wrote:
> On Fri, Nov 16, 2018 at 03:54:24PM +0800, Qu Wenruo wrote:
>> The only location is the following code:
>>
>> 	int level =3D path->lowest_level + 1;
>>  	BUG_ON(path->lowest_level + 1 >=3D BTRFS_MAX_LEVEL);
>>  	while(level < BTRFS_MAX_LEVEL) {
>> 		slot =3D path->slots[level] + 1;
>> 		...
>> 	}
>> 	path->slots[level] =3D slot;
>>
>> Again, it's the stupid compiler needs some hint for the fact that
>> we will always enter the while loop for at least once, thus @slot shou=
ld
>> always be initialized.
>=20
> Harsh words for the compiler, and I say not deserved. The same code
> pasted to kernel a built with the same version does not report the
> warning, so it's apparently a missing annotation of BUG_ON in
> btrfs-progs that does not give the right hint.
>=20
Well, in fact after the recent gcc8 updates (god knows how many versions
gcc8 get updated in Arch after the patchset), it doesn't report this
error anymore.

But your idea on the BUG_ON() lacking noreturn attribute makes sense.

I'll just add some hint for kerncompact.

Thanks,
Qu


--MY8575BzpHnpFBlEX6ZSPChXL6coTPlYD--

--nJMr9YlEIXJSlUVaKHN0MqfAqG3ysNIRA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwHZGwACgkQwj2R86El
/qh6nwf9GJW95ysGkFatViLr5mMBH+Jq4MSW+OouNBlPTolpftfJ5zvWtOZBFNQH
tkVwxS4x+F7RnGvDAWmFfNBGu3FU4qTfBDYitxlMLk+E7V4oTAojAHfM+xj4CWCY
FmGReIfxLpWkVPnGzbjzhMKT9SQzEPv4k1lbWhAnFk30pi90ruBQ/y3hXkEOmrH4
1U3Ai16HFhGEmMoykaWi3jgmWIXbZWaOjIJShZ1GPg2cOrHoAs6CsrkU0Zil77XD
GG7r9qaLq0LJAE+8u3lN6V8cCE1mpSLcVgILV7Xy2Xn/vEGIrSSgFGenPSaekMBy
JeEGfQo81mfD/or9fKZK5YqcvQ5r4A==
=gawK
-----END PGP SIGNATURE-----

--nJMr9YlEIXJSlUVaKHN0MqfAqG3ysNIRA--
