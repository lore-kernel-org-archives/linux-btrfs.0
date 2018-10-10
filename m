Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB88C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 505F12086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:50:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 505F12086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbeJKHO5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 03:14:57 -0400
Received: from mout.gmx.net ([212.227.17.20]:55665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbeJKHO5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 03:14:57 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M3vCA-1fsAuB3yza-00rXZQ; Thu, 11
 Oct 2018 01:50:26 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M3vCA-1fsAuB3yza-00rXZQ; Thu, 11
 Oct 2018 01:50:26 +0200
Subject: Re: Recovery options for damaged beginning of the filesystem
To:     Shapranov Vladimir <equidamoid@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1a39748c-19de-5fdc-f8ee-efdced880df4@gmail.com>
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
Message-ID: <dc91dec5-a7fe-5aef-99de-91e48c83c837@gmx.com>
Date:   Thu, 11 Oct 2018 07:50:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1a39748c-19de-5fdc-f8ee-efdced880df4@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DT9JvSNfO3c79rvnoqHkpYLtG2ywYtGc8"
X-Provags-ID: V03:K1:mvYn6ccTAbAlUPPLJPA3bIfTTbSGikhNDcxA2fGzMvZv41r0ZIY
 qkusUPckfjhxgj58z0We+mKmA8jOHv/w8f1jP+e3GAHaqvgvGJPnvjfCC8NtpxQ7H3S91d8
 E5Jc5QB8QluKwQWxWjWJh+davt8M0yFQsfZlbUQP/VShCG5l0/SmgAHxBMNLrm+sAiYk9RN
 +0XX9TEAvzqC0Mb2uIsvw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:X6YYjMK2cgs=:JUQJI4DFyLJCnMiFti7kRn
 o/+HtGHjy7PjfKnyrpM8wg/lH0dH6jfGIVz9OwzHOaIA9NrOlDcMEbPxwyOudqoNaaI/vcfOe
 m8V4fWBFZYLOfAIJCXf0f1uSS6/xZ418T9qM8Vb2KL4SCyY06Nb83sSg1zB7IvSOpjLvVwqnm
 zWr94Q18r7xvCuCeX601BD3+hR65Sb4/vStmMUFGD2jMEtNbnpPHPvRfENG9Tj+pz8u5Elk/U
 x9rxmuaKQVzwNy8AHicFJRtoXekXt5P+F7Asm9qK4yUUM/CiDHL6ohbGiDRJKIPzF2wbNl4aL
 0M+Otvlvp2zp8dXghI6dhjxabZQdPxoYtYaaUDV/bqZr2zOJJUx6liT7rRS9zQsAJoH9mOJGp
 YFSz28kZyXS/T/BpCP0HPsBKCmxVN0r3OYezzT35fTgYqWKy4ZCtS3aCj54qSQuVsA2c979QV
 2ZDyvdejWLHDmGxQgoi9uh5etN683So6HPjrnZE8KDkS2BYKvpeX66wBXdcyu7Q2KodRbPRC3
 5vddPnKizXQYWwBd1536i6CIZMxcdhSKxU9y3lgK+KeYmZjRRBl7xYXLX+GIB4a64JqMNSxoR
 FGpf8jpNWT+6JCyjtJglza/7daRCIcQ88pH4v2D9TnbKPEkVBTDDSPof1km980AvzrrjcNceu
 6PY82NlWuwObXMhz+hb7sLdQtQXKj57EoZwrr5iowj3G0QvoRw9tBi6MR7/k+5GSyZ/1aaQxz
 IiHGfb9HbEDuS/Ji/nAwEi6KxsZXmJVCzhrKmHnVVmVci49fP2s4Q7+tivZitFa5Xg+SZq0Yp
 saxrj5A36vOCf/52787NwjTAPiwWg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DT9JvSNfO3c79rvnoqHkpYLtG2ywYtGc8
Content-Type: multipart/mixed; boundary="7BSmTZZZydrJPsMgh1wwRnqJ9KmURsjXg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Shapranov Vladimir <equidamoid@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <dc91dec5-a7fe-5aef-99de-91e48c83c837@gmx.com>
Subject: Re: Recovery options for damaged beginning of the filesystem
References: <1a39748c-19de-5fdc-f8ee-efdced880df4@gmail.com>
In-Reply-To: <1a39748c-19de-5fdc-f8ee-efdced880df4@gmail.com>

--7BSmTZZZydrJPsMgh1wwRnqJ9KmURsjXg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/10 =E4=B8=8B=E5=8D=8812:47, Shapranov Vladimir wrote:
> Hi,
>=20
> I've got a filesystem with first ~50Mb accidentally dd'ed.

So about 49M meta/data loss.

It depends on the chunk layout. If it got one metadata chunk wiped out,
it's pretty hard to repair.
If it only wiped several data chunks, it should be mostly OK.


>=20
> "btrfs check" fails with a following error (regardless of "-s"):
> checksum verify failed on 21037056 found FC8A6557 wanted 2F51D090
> checksum verify failed on 21037056 found FC8A6557 wanted 2F51D090
> checksum verify failed on 21037056 found 1EDD5E47 wanted 222F7E7F
> checksum verify failed on 21037056 found 1EDD5E47 wanted 222F7E7F
> bytenr mismatch, want=3D21037056, have=3D13515002166904211737
> ERROR: cannot read chunk root
> ERROR: cannot open file system
>=20
> "mount -o ro /dev/sdf1 /mnt/tmp" fails, while "mount -o ro,subvol=3DX /=
mnt/tmp" succeeds for "/" and couple subvolumes.

That's very strange.

If chunk root is corrupted, it should fail for all subvolumes.

>=20
> I can even ls the root directory, but at some point something can't be =
read anymore and following errors appear in dmesg:
> [385647.999981] btrfs_dev_stat_print_on_error: 158686 callbacks suppres=
sed
> [385648.079187] BTRFS error (device sdd1): bdev /dev/sdf1 errs: wr 0, r=
d 22094847, flush 0, corrupt 0, gen 0
> [385648.193733] BTRFS error (device sdd1): bdev /dev/sdf1 errs: wr 0, r=
d 22094848, flush 0, corrupt 0, gen 0
>=20
> Also it is worth mentioning that after corruption one of the subvolumes=
 was mounted read-write and possibly some files were written.
>=20
> Is there any chance to recover the FS?

You could try btrfs rescue chunk-recovery to recover the chunk root, and
then all depends on your luck to see if it works.

Thanks,
Qu

>=20
>=20
>=20


--7BSmTZZZydrJPsMgh1wwRnqJ9KmURsjXg--

--DT9JvSNfO3c79rvnoqHkpYLtG2ywYtGc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu+kD8ACgkQwj2R86El
/qgnjQf9GTaR3u6dJcncPCrH/nzPzp7BKt8ClP1L2qmZ8JhbdEpS8dbqqQ4ZfZBh
++2eiSAMhjLUHPeOfg7NMbGfiOnsgTWeda37LAKTm9/KOuLudSsgVnWe4CASK36C
oGchXBGfwLPOd5b9H73ItsrhM3T1YTiTCG1/jORKDHeb456KF3aYAK9uHvZfvuDv
bPiOkRY4V6I3N6Tf2YrMqpBHhxB9b+Lmhlq0rMbKCtoYOKabA+QFTAXU1i8HerQS
72Rwal1dd7X59fX68+PG3vU1Azipy+scbgTkiUZ30eXGKUJh7cLKVyoDiveOgI/q
hwWIIreZsOyUgFJEgPIkeAb1BTLwmQ==
=KSR5
-----END PGP SIGNATURE-----

--DT9JvSNfO3c79rvnoqHkpYLtG2ywYtGc8--
