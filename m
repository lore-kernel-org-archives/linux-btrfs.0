Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE9CC282D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 00:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B60320857
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 00:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfAaAqR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 19:46:17 -0500
Received: from mout.gmx.net ([212.227.15.15]:58619 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfAaAqQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 19:46:16 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LrvWY-1hIGVI3YhK-013few; Thu, 31
 Jan 2019 01:45:47 +0100
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com> <20190130151914.GU2900@twin.jikos.cz>
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
Message-ID: <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
Date:   Thu, 31 Jan 2019 08:45:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190130151914.GU2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6oo4ewj2dfFOeB04YLZwUGj59Sw06j8cO"
X-Provags-ID: V03:K1:YP1dTfJc7lFewVN4AlysUqq6d+jXsPpEkM3qXp/pVGRdsbve/i/
 JZMz9f10R502PvJ7S3hxZT9tVuKYKtskyhy/T/hgyv6rj8tCVQbsBTKhiCad77akhGc5qrI
 iKQsvyQ3M2cH0FdAfCEu4naV+we9i1LtdPdJ2w+3qOveEKBxGdnM2vBx4PNFNq5SS9eueFt
 IYOfrQ+f8ee1oCD5hxFqQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9P5DjA56WuA=:Dx+MOZcCsP1FLL45+sXGY8
 NhTaz9nz2DqJIWEsktYCm33uch2a/wM4+iAATFrwGrZMWHpHCiVVuUVM8P4PF/m6r03IYm5Xy
 YmNZMZlVvzYs0gZQmJRz4CcABzuWRmgHQcSbB5wPTNdfqZ649VPlvULdJfPJdviCFPliTWefR
 7tiVsOWoxkeC0AOOLrGD/wenI7vi/b9/bP+tu8Vz/srcII2y9ZbS6+9LBpvEBHmCGIK8s9Flh
 nRUSM+N3PxS6GiZhEK8Gu7v/0H40zIc8ZxLWxtNI2YHAr77MLdOe2RUWI1giJV8zZUQIWQKyL
 E+JwGgMNq/O1oV8XCBDc2jA9sRBQoexJIHyCquJ/P4/hR20YWoo0mVFCSl9sz6MBY8otDPl40
 FOy0ILyODk9lKTi1LXlNEqme3t/5f6j0aCPaaxeIBMJxYC0YgORNUO0+GTyONdL+FF2snvOpV
 HMM7YyQP9hPboZFtvd2UTNFPus7ZvOZzGCOowW/r6bYV71s3I2ZdIAKakShg2MdzCBs1lgj0z
 +D6MRkfiec7rO4JZdH90QP89+E9+2BeAQU1JhnxLKBIO8kceLb1YBveUzYq1iG19j4kSuORPP
 i5tmA19YENFYTpfALB0LIvjAJwZZrjdZURwZVYrVAT86zjOtq8MsB/geu1yoU8X7Pz3aYxtuW
 6C+1eDper7Yd1LiYckKuG0j+Wf3fKyetlRrccP4wjc0ienATBnnmHXlmb3z8DsdYTNs6SD66W
 JdS9XAyNBk3y3LjHlnUsjnHGy9VGI6YQhRTfnqZQo29imgLc7nX7u6DrspkRf796ahv20IA5n
 iUNxI9HczitYhdboSCv6aKWwWgA1x0v8v+596V3qLcio/VuFcddJUWKCZeiKErfU9ZhiK600C
 DtJAFIQu9aEm954pjpEJvqGd58pIMqvP3WZ6ySUeVC6iVPb0y1gsgexWJfPNWQ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6oo4ewj2dfFOeB04YLZwUGj59Sw06j8cO
Content-Type: multipart/mixed; boundary="9eLmOjusWYLXRR8teahvesbJG74s86t31";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com> <20190130151914.GU2900@twin.jikos.cz>
In-Reply-To: <20190130151914.GU2900@twin.jikos.cz>

--9eLmOjusWYLXRR8teahvesbJG74s86t31
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/30 =E4=B8=8B=E5=8D=8811:19, David Sterba wrote:
> On Fri, Jan 25, 2019 at 01:09:17PM +0800, Qu Wenruo wrote:
>> +static int __must_check flush_write_bio(struct extent_page_data *epd)=

>>  {
>> -	if (epd->bio) {
>> -		int ret;
>> +	int ret =3D 0;
>> =20
>> +	if (epd->bio) {
>>  		ret =3D submit_one_bio(epd->bio, 0, 0);
>> -		BUG_ON(ret < 0); /* -ENOMEM */
>>  		epd->bio =3D NULL;
>=20
> I'm not sure if resetting epd->bio to NULL is all that needs to be done=

> here. With the BUG_ON the error case never happens so if all goes fine
> it's also ok to set it to NULL and continue. But the callers might need=

> to send the flush again.

If flush_write_bio() get called again on the failed one, it will just
get skipped as  epd->bio is NULL, submit_one_bio() will not be triggered.=


Thanks,
Qu

>=20
> It's not easy to trace the bio here, it's set indirectly in
> submit_extent_page, submit_one_bio is another indirection, switching by=

> type and sometimes bio_endio is called in case of an error.
>=20


--9eLmOjusWYLXRR8teahvesbJG74s86t31--

--6oo4ewj2dfFOeB04YLZwUGj59Sw06j8cO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxSRTYACgkQwj2R86El
/qjerwf/Wp0CaDdzNO1p6ak2+Aq24wBl/N6PbgRsXko5q9sboc14jE7f4kstRjrV
XxCN43avbgxFAt5bgJUktp4kYupaEynjSpQrYh7MmYGWf6HUc6rmnHDr3IlsDePF
Uhw4VUD8ONhiRygl4Er7aaQpMSGQu//IMDp+yzPaJo5x/Z0fNTTPF/aDzGPN0IO8
M7g4lRow5gTkIKwIO7UalXLstnAADeHBD/ADQkcXqo4VaUu5WwHgOauWJnJhpkHS
XlyE0T6YMhgbeZTJ3mUhEjekKMB98eKqEmpe5Cpao0l4a1mz2zDc1AIXJ3MZY5LC
N3s6Kr7MW3YDkQ3IKnCVquBen+W8/Q==
=Lo6d
-----END PGP SIGNATURE-----

--6oo4ewj2dfFOeB04YLZwUGj59Sw06j8cO--
