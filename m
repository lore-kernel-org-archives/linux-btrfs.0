Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_MIXED_ES autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E6CC07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 07:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC47720838
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 07:22:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC47720838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbeLGHWb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 02:22:31 -0500
Received: from mout.gmx.net ([212.227.17.21]:48987 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbeLGHWb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Dec 2018 02:22:31 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MgKoE-1grlHp3CHW-00Nitu; Fri, 07
 Dec 2018 08:22:28 +0100
Subject: Re: System unable to mount partition after a power loss
To:     Doni Crosby <doni.crosby1995@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
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
Message-ID: <1a8e4805-10a5-8203-5f62-7cd572ca578e@gmx.com>
Date:   Fri, 7 Dec 2018 15:22:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kH93iacRCz1BlmoIkMq2zqsWO06BQKwjl"
X-Provags-ID: V03:K1:zUfVSMRCp3vX/ksdVz+F9N4CTkJWWYStg9cuEM+k8DPSfXiNvvH
 mQf+GfJPeQYr125j0VVJqoTx/P4thjm7k0fnLT1Aru1m3dIo9yHcF8RWt1mFdOzpSFLN3Gj
 ryHHTWDZ6Cj/AiVli/5d8X5FQDjVDup98I5pZvB7CrsoAzvAFlAvTcqY2wCwEK0DOqf4lZ/
 bQXyYnCJbqtgIH4nrlpMw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OBSmLn466lA=:9C+MqeSmOO1zaK/YQVkQzr
 YnrgksKPRcci2tLPbQJ1G1FvrNw9WIUfiF7vWQ+9snPjKOCQB/YYHuWL4jynzIdLQZFoZKEd5
 snTv5nTyddIycjWxFip/1KZTcgVvBTOvlkKoE2VMgvc2bhj6lceCiiAWTQdbuiDPDIK8PyTFQ
 6syU4j6I/31eT6N5LpjZt9ydg2ApR++twW7k9YWlsQQKsZoYL+OtdKC5h1Zjs/lYZdHn8gT3u
 v/kEJzRc+MmyzEwFTEvSVlTymCar8XZluNjL0CIo3hc9GM/QT1q+80r0ohnK5KHJnBOEl1m0O
 Nt/0uExq6bqTEI1yW7/lbuSEIp4xhhVI4yTIP0YPeZS/ARphkQJXHHJyGkG7FlOAJxr26su/l
 VDJehN6ZF8Zy7Y0PJrAeLjU9zkWuwvgMC8vHvpCQxa2Py+o789/fMY3gDX1sagfVE7cVVq3uz
 H2izvvWg2ou91HJ4hkYAzr5Ti4OuqyOonKYctGblX7us2U8LpHbz/b6TFZpeFixGAsBeeQquT
 enwGbMiYbpOT4vwNGRdONZLqTWfuzJUwUQnd901/5rt+VMCJTBp+as80/hWVPpNYs6a6P4AXi
 Z9QrthcYLCpX9qdIrnATTkcAH2WI5vlGREzQx4YZ8ZYWe7/cyU1tLzbANBGTQBWHaYGMxcEHH
 sezmICVb2yp0VxpGrIshXWM+66x9z8H/+cERWgPSch5gI4uD0/+nm5lv+xRn651EuXXGM1kuF
 bqw1Rae836+H+p5b/EvQLxLjG6nd2KsZOh0pH/xLHM6q5EScQj+6o3E6ILPmpbO0b43l9qjqc
 Ujs4JyhvhNg8hiDgyapGVa+92+DcNKBvbeonK2MzNIP+5bBcDZCMcgXuC6Tpv18j78lQf/dCQ
 PtdH7xDXSpULSVNojURgMAHOGLRv4AnsTR9gjTZRVm85oG4XVvwxN0TRn2+U4G
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kH93iacRCz1BlmoIkMq2zqsWO06BQKwjl
Content-Type: multipart/mixed; boundary="Wtdl9i0lmIeNskS3EZ9ywm2sDwWSgxYzW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Doni Crosby <doni.crosby1995@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <1a8e4805-10a5-8203-5f62-7cd572ca578e@gmx.com>
Subject: Re: System unable to mount partition after a power loss
References: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
In-Reply-To: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>

--Wtdl9i0lmIeNskS3EZ9ywm2sDwWSgxYzW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/7 =E4=B8=8B=E5=8D=881:24, Doni Crosby wrote:
> All,
>=20
> I'm coming to you to see if there is a way to fix or at least recover
> most of the data I have from a btrfs filesystem. The system went down
> after both a breaker and the battery backup failed. I cannot currently
> mount the system, with the following error from dmesg:
>=20
> Note: The vda1 is just the entire disk being passed from the VM host
> to the VM it's not an actual true virtual block device
>=20
> [ 499.704398] BTRFS info (device vda1): disk space caching is enabled
> [  499.704401] BTRFS info (device vda1): has skinny extents
> [  499.739522] BTRFS error (device vda1): parent transid verify failed
> on 3563231428608 wanted 5184691 found 5183327

Transid mismatch normally means the fs is screwed up more or less.

And according to your mount failure, it looks the fs get screwed up badly=
=2E

What's the kernel version used in the VM?
I don't really think the VM is always using the latest kernel.

> [  499.740257] BTRFS error (device vda1): parent transid verify failed
> on 3563231428608 wanted 5184691 found 5183327
> [  499.770847] BTRFS error (device vda1): open_ctree failed
>=20
> I have tried running btrfsck:
> parent transid verify failed on 3563224121344 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563224121344 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563224121344 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563224121344 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563224121344 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563224121344 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563221630976 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563221630976 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563223138304 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563223138304 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563223138304 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563223138304 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563224072192 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563224072192 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563225268224 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563225268224 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563227398144 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563227398144 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563229593600 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563229593600 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563229593600 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563229593600 wanted 5184691 found 5184=
689

According to your later dump-super output, it looks pretty possible that
the corrupted extents are all belonging to extent tree.

So it's still possible that your fs tree and other essential trees are OK=
=2E

Please dump the following output (with its stderr) to further confirm
the damage.
# btrfs ins dump-tree -b 31801344 --follow /dev/vda1

If your objective is only to recover data, then you could start to try
btrfs-restore.
It's pretty hard to fix the heavily damaged extent tree.

Thanks,
Qu
> Ignoring transid failure
> Checking filesystem on /dev/vda1
> UUID: 7c76bb05-b3dc-4804-bf56-88d010a214c6
> checking extents
> parent transid verify failed on 3563224842240 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563224842240 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563222974464 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563222974464 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563223121920 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563223121920 wanted 5184691 found 5184=
688
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184=
689
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184=
689
> Ignoring transid failure
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183=
327
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183=
327
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183=
327
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183=
327
> Ignoring transid failure
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183=
325
> Ignoring transid failure
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183=
325
> Ignoring transid failure
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183=
325
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183=
325
> Ignoring transid failure
> Segmentation fault
>=20
> btrfs check --recover also ends in a segmentation fault
>=20
> I am aware of chunk-recover and have tried to run it but got weary
> when I saw dev0 not vda1.
>=20
> Any help would be appreciated,
> Doni
>=20
> uname -a:
> Linux Homophone 4.18.0-0.bpo.1-amd64 #1 SMP Debian 4.18.6-1~bpo9+1
> (2018-09-13) x86_64 GNU/Linux
>=20
> btrfs --version:
> btrfs-progs v4.7.3
>=20
> btrfs fi show:
> Label: 'Array'  uuid: 7c76bb05-b3dc-4804-bf56-88d010a214c6
>         Total devices 1 FS bytes used 6.05TiB
>         devid    1 size 29.11TiB used 6.13TiB path /dev/vda1
>=20


--Wtdl9i0lmIeNskS3EZ9ywm2sDwWSgxYzW--

--kH93iacRCz1BlmoIkMq2zqsWO06BQKwjl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwKH7AACgkQwj2R86El
/qgU2Af/bd3WOFpaIfUe4Mf2jxWE28N8LWxwn+nXTyCwrIOELVCbG0skXVTzeAu6
n0YXVitt1pZs3T3iM4Kdq6fqZ1roNKZKpCJWCWnOx7+FMfIDyrmG+fJK9vlvWVGi
ll6a2uGLk06mJTnHKkDpsalx49V5KvBcuSky55TlN1zI5Cw0v7AM72w5LgqrGIah
/CfK0p5DO+cSGcJhNQ8hMGlYco+0rdzeb5VkP8ZDMT6Jq4BBHE50D0Sf6aNvNJYm
C/ROoXpmskXLwDgC1mURQOsMQtAncoBV0TOxqSn+SkCs2reWAEU3LPbR4eh6uUrm
yX251g/nKa5aK6RCcZwUOU63PTOo0Q==
=MTHB
-----END PGP SIGNATURE-----

--kH93iacRCz1BlmoIkMq2zqsWO06BQKwjl--
