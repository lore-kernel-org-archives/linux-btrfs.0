Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E841BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 05:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB98D20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 05:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfCKE65 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 00:58:57 -0400
Received: from mout.gmx.net ([212.227.15.18]:48587 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbfCKE65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 00:58:57 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MVvi4-1ha73l3BxQ-00X5lG; Mon, 11
 Mar 2019 05:58:54 +0100
Subject: Re: confusing behavior when supers mismatch
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
 <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com>
 <CAJCQCtRVT9Fpy0Knj44m0BN80d-PidUfHPJ0d9VJkag7B-KXTQ@mail.gmail.com>
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
Message-ID: <2621cc31-0d74-f514-fae4-fea35e34fae3@gmx.com>
Date:   Mon, 11 Mar 2019 12:58:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRVT9Fpy0Knj44m0BN80d-PidUfHPJ0d9VJkag7B-KXTQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jFQg6thogTcNErSRpYNboS88Iutj2BdZV"
X-Provags-ID: V03:K1:pbkw5mzJ5JJ5iAaKNx71BFB3yigzMFAZYIVQU7mLniDO4SZeykB
 g87Gyx+KTOTEuDTzgbaAjjAWIt+4SmvFQTiPT5yDmHLYFlVpN46cYU81MDwDcarU3BnMHj/
 0+UPujLN6KxZ139rXpV3gOZbmeU5hi9hlR5XlP/8uwi7alXjfTW2dNyOCeGtBPoXkxv8KZ+
 DJWLj6ar4wsoyaEt87JwA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2m1cVaztZk8=:sAZ1g+UDKAZ6nDDvXQ8shJ
 AI2bOkZflf+14PEOY2XzvKqDlA4PmVQR/4oqs6Ng+5YWDd1LRRtH/4oZwy3Z3383fTrrZJIbH
 r+Qb7qn70DgMyUaA+68zbR2g/mCN8SOCHyU8l+LTFM70X0PtfhhzwnKL7PIczlpmKlDjqKZC6
 j+7OhSJLqg69q25lePq2rKuqkWnyX/QTtO4RG9LZK+Ief1a/gRz2eYciBXu6+rheWomvmEa3G
 BFI7xlai9AwXjvf2xGssbVGPqJh9XiXr9UNaJv516J5P0o3JA6EpIrR9nnhT2O31gJqkimJaF
 WUqfdQMj3iDiT575o+KOZT95lVcfiDou4Zc1qiRv7TOguR/YlK6Hqn5VBIT4jUMEpIumqQFz4
 6mewuKyVKzmPYdekjAIl05HM+9NuD/andge72KeRRkv5MvKX9AtjDVHrvCY+CrGqa/FI0BPSV
 PXMGaz/Om2DZW9gTogo5Ai37mq1t9QJRPhaxSAv5fUHWuV+CgJ6X9R9AoSJJuVJyG7NYHSRjR
 P6ZcXdalVm7djvzMoeus+itRvpwX3X7CwaM14YSXbvE8nfZksnG4OexBWs8Sjn6H96vPdoRzi
 4Jd6Ou0OW4FZqDZ3WBhyueOsAnKmMLdmRaw7WR8JiYbjuWUi/HwE4LvDG7WMdN5aVloIsccbs
 oo1Q2dKos0CKo1+VenGvgc1K4u5wPCUBg2KDmpR2CprGhLNdqGD696lJkH/X/n26dPuiekbuz
 wtykxrX5vgbPCV0smj7xZfXqgc0MVGnJYetRyncDfag3mw/3es+hrYIcblWoijSj+CVBpppLu
 5dTWQzkTR3gaHUoBx4mB8jY0BCXEex2trku5cIe+UQXc/TFFj1pZuy+dTb34+B9/hEp/A1zhP
 RLb8lgA5U74Lz9jLhYRs2DiqaxquD7mZdiZ5aFebY8V8v3Xi4Q2XWg1qS82cw3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jFQg6thogTcNErSRpYNboS88Iutj2BdZV
Content-Type: multipart/mixed; boundary="P18p11TNVC5229aL1ffQGxQkaYAPGfmzz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <2621cc31-0d74-f514-fae4-fea35e34fae3@gmx.com>
Subject: Re: confusing behavior when supers mismatch
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
 <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com>
 <CAJCQCtRVT9Fpy0Knj44m0BN80d-PidUfHPJ0d9VJkag7B-KXTQ@mail.gmail.com>
In-Reply-To: <CAJCQCtRVT9Fpy0Knj44m0BN80d-PidUfHPJ0d9VJkag7B-KXTQ@mail.gmail.com>

--P18p11TNVC5229aL1ffQGxQkaYAPGfmzz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/11 =E4=B8=8A=E5=8D=8811:20, Chris Murphy wrote:
> On Sun, Mar 10, 2019 at 7:18 PM Qu Wenruo <quwenruo.btrfs@gmx.com>
> wrote:
>>=20
>>=20
>>=20
>> On 2019/3/11 =E4=B8=8A=E5=8D=887:09, Chris Murphy wrote:
>>> In the case where superblock 0 at 65536 is valid but stale (older
>>> than the others):
>>=20
>> Then this means either the fs is fuzzed, or the FUA implementation
>> of the disk is completely screwed up.
>=20
> Fuzzed in this case by me.
>=20
> (Backstory: On linux-raid@ list, user accidentally zero'd first 1MiB=20
> of an mdadm array which contains Btrfs, but has a backup of this
> 1MiB. So I was testing in advance the behavior of restoring this
> 1MiB backup; but I'm guessing upon zero the working file system may
> have changed as it's not unmount, and in fact probably very soon
> after zeroing, wrote a good super replacement anyway. It seems the
> only missing thing we need is LVM metadata, maybe.)
>=20
>=20
>> So IMHO always use the primary superblock is the designed
>> behavior.
>=20
> OK interesting. So in what case are the backup supers used? Only by=20
> `btrfs rescue super` or by explicit request, e.g. I notice even with=20
> an erased primary super signature, a `btrfs check -S1 --repair` does=20
> not cause the S0 super to be fixed up;

This is because there is no thing to repair thus no need to commit
transaction.
If --repair modified anything, then it should fix all supers.

But indeed, this behavior is a problem.

> and `btrfs rescue super` lacks an -S flag, so fixing accidentally
> wiped Btrfs super requires manual intervention.

Normally 'btrfs rescue super' should be enough for accidentally wiped btr=
fs.

If not, then we should fix it of course.

Thanks,
Qu

>=20
>=20


--P18p11TNVC5229aL1ffQGxQkaYAPGfmzz--

--jFQg6thogTcNErSRpYNboS88Iutj2BdZV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyF6woACgkQwj2R86El
/qibwAf+MV8JN2o2aozHVr5jLxvPEi4qERpZFRicVGn+cgDvxdVK9G0Kpu6gR45N
ObbhDYO0qkvHPBMRLxwQA+WNS22vtadvwmgRO8gX3JXPGzddqCCZphoJs/Gi4Co4
ufyeg1ZXoYrUxI9Sx9VY1mnt9nWJH+D1aX056S74Op7bSK4ay1kLfpquw/Yh8SKp
h6aPy5YliloesehLTbca4LyTHelLaM612goAilrYLsgNHytBNr7ENJZLbcRUzUTA
Immqymh9xk0Fo75VvCBw1rDoeUwzc5AiKFtZ68CHvipYhvvU0otWdg1iGcJDytHa
ixwef+vMX6dzIoKIwsBblskeKg99nw==
=Vf+C
-----END PGP SIGNATURE-----

--jFQg6thogTcNErSRpYNboS88Iutj2BdZV--
