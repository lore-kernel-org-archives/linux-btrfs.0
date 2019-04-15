Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FD6C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 11:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90B30206BA
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 11:58:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="VX3KA+U0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfDOL6Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:58:16 -0400
Received: from mout.gmx.net ([212.227.17.20]:47657 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbfDOL6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 07:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555329492;
        bh=Ob35z/pAImjTfgc/oHpaYkH5nEY6qSaeoBS7O3Q+IFU=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=VX3KA+U0dYplM7MRVd0vMGGRmwec6HcbBsLZk/wibLXb/aBN7yTH9RAx5dyRamrIC
         pmXQgMedxW4ALF+syBFdpkaud8HBUAqSwv3peQZ0mwEDGF6tG/A/Diu1GKYuV1UoY9
         H45pk5LCTFp9MZAqCzwBeNd9x3s2B3Or871MefRQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MF9WR-1h5mqe2H07-00GHbd; Mon, 15
 Apr 2019 13:58:12 +0200
Subject: Re: Corrupted files support needed
To:     Daniel Brunner <daniel@brunner.ninja>, linux-btrfs@vger.kernel.org
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
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
Message-ID: <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
Date:   Mon, 15 Apr 2019 19:58:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mkijb6r4rA49rvwcmMfylOB7zQOKRbboP"
X-Provags-ID: V03:K1:ySmw/xQfELLYQNyj7Lxu5WJ6IHDWK2U+7gDHRu1q8JXMb/w0pMM
 NSr59Msx/jDKgWGUUeaxD/Mtb4GuC6k8CRgmR7d/Gtphg7zsteJnGeuw/TDZNQaAli1b24i
 TMDBYsCeQ5b2fyTCv5aKC/u0r8nA+rwGtE4lUGMz39FBvkOrmZD1pgCKgdDZaGIRQEjiQJ2
 vKA/LhtH825yfhmrDag9A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sefovNH3stA=:B7Ef3ryYHgVIle2XJ2Mwof
 jbKko0LfmSFTsU7zYBbPfgo7JAXQrvq6gwUIZdkNc8eUaKFcIlH3IhTohWRNUf/uUmdrhSt01
 S8VzRuB/H4rfUcKJ0zFW4vsftbQ3si6KjNaRy5KxATyGlbqo3cPjoo3SkNwVVo8zPbe1/qhoJ
 Ww2jOXFITfQIYcDUfVlKBMzYPFwtPX9rAVkBMNXl1OCpU5qmfXcnlrXsB+5w9M9Ke7UUipd7x
 dnHLETTzzZrbQ4SEbma6pb9bMbR9SDrOVVzfvbWYKix54yFQ+279dg4JC4aSoNuGOYomO/vDv
 +Fboc2hn6stjy++BPQuL5r3zTrzTCvrTO+7m65C6ThFqwNkV3au3UiVsLZ+1+14pCgjmCriii
 4AWKKIekQRReIOvXH+BDx9g3nuEZliMbqRH4hFQloE9RaeNVojUDYBBOPf2wM+TtrKoeaCwpZ
 69142uZTLJ/XOjqugkdBAVZzennyzISOrTvu202ue9e5zeql0mraiU2pdZjWbRSIfBppuDzvm
 geVTh1RHGmjH0X8Ds6PTnZ4994AZwIb5X3SUySflm6XRCEtuh2rBHqKV4iVLD0LgaUsFerU2I
 CTO4vmtqc6dzPKZ5Oj6jYwNghNpvlMyKYu8kS+KXq6CqS1NJu6dOxNWDY3W0LnTEpcoymO5Hj
 kHgkiiA31O3WEKBrqw2Er3y7fkK5u5DtmFFPlE1bRL4jZNfAiIlSyrUacxpoD8tg7a2tdQZIF
 vpb/c9H7Uu+MF6qnsJtBwUfwIrKsmU01G7VH4R7r/3aDJ/Id/Npe8G60kcLRDuQ3nUrh/fO2Q
 fjLlqG4xJ/nkh0Z39+bA4FK+ABcC71ZjrT9ErfIaxaXR7A8ZNo+DLMS9BE3qo3DITD4/WyLJu
 MJ0GrD6+kNWmL5zmx7sZUaaBia2rf5R/ONvmiKASwR15yKaQHJbc4qtilygY3E
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mkijb6r4rA49rvwcmMfylOB7zQOKRbboP
Content-Type: multipart/mixed; boundary="BGUAhBUEbWR8fE87wFsnWrHrXNnA0WkUh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Daniel Brunner <daniel@brunner.ninja>, linux-btrfs@vger.kernel.org
Message-ID: <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
Subject: Re: Corrupted files support needed
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
In-Reply-To: <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>

--BGUAhBUEbWR8fE87wFsnWrHrXNnA0WkUh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/15 =E4=B8=8B=E5=8D=887:44, Daniel Brunner wrote:
> Hi,
>=20
> after normal a reboot I noticed that many files fail to open / read
> (Input/Output error). I don't really have a backup of it (only
> snapshots which also seem to be corrupted too).
> The machine is remote, I can only ssh into it (at the moment). The
> raid consists of 8x 10TB drives.
>=20
> System & Metadata is RAID1
> Data is RAID6
>=20
> kernel is the most recent from arch linux repositories:
> 5.0.7-arch1-1-ARCH #1 SMP PREEMPT Mon Apr 8 10:37:08 UTC 2019 x86_64 GN=
U/Linux
>=20
> Disk layout & usage:
> https://0x0.st/zNBl.log
>=20
> Output of btrfs check:
> https://0x0.st/zNJs.log

Strange, btrfs check reports no error at all.

Would you please try btrfs check unmounted just in case.

>=20
> Kernel messages:
> http://cwillu.com:8080/84.115.44.105/2

According to the dmesg, it looks like one device is bad, affecting both
data and metadata.

And thanks to recent RAID6 enhancement to try all possible mirror
combination, it doesn't cause too many problem to metadata at least.

Although data csum is not that good.
Quite a lot of combination doesn't match checksum, and even more, some
check doesn't exist in csum tree.

An unmounted btrfs check is recommended.
# btrfs check --check-data-csum --readonly

This would be better than scrub.

And please check the SMART info, some devices look suspicious.

Also, please remount the fs read only at least to prevent further
corruption.

Thanks,
Qu

>=20
> btrfs scrub is running but it seems like it will take weeks to finish..=
=2E
>=20
> Do you think my data is gone or is there anything I can try? An rsync
> is already running, but every 5th file fails to read.
>=20
> Best regards,
> Daniel
>=20


--BGUAhBUEbWR8fE87wFsnWrHrXNnA0WkUh--

--mkijb6r4rA49rvwcmMfylOB7zQOKRbboP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly0cc8ACgkQwj2R86El
/qjumwf/Y4Po9rSlBvs+W79/pJ5RCAB4B8ndX0Do6KI/dshb5CoEmSY0hoj8CICC
lQSciVC6LLSK6c1JehTbPEWxDMPSUS1u4l1J63xIRWfsXOWFfXVhDXGJuPNXmCGx
pj0a7cKteLtVLLrL+WMAwAz/e/rfcr8Jx3F+JZN5srETsojJ/29k00Nf7BOJpdD4
5FdHeX7faxUlSKyXzlbnxdoEG+PpKVtZ9ox51EO8qFmVqMNL4EPx3z/pMjsfffLh
Mkv20m6QOSXspyE1QJePJHa5C+TkXxoTtBh8wsrAwc35KfU/+reqcQ7PzKoxF+Oe
qXWdHKalyQy9KY9tSaGcbJKkGNXdyw==
=nbJr
-----END PGP SIGNATURE-----

--mkijb6r4rA49rvwcmMfylOB7zQOKRbboP--
