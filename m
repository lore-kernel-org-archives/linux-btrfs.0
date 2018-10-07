Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D46C46475
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 00:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C40882087D
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 00:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C40882087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbeJGHrM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 03:47:12 -0400
Received: from mout.gmx.net ([212.227.15.15]:59885 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbeJGHrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Oct 2018 03:47:12 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M3zT0-1fryFo2Xkg-00rWfv; Sun, 07
 Oct 2018 02:41:51 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M3zT0-1fryFo2Xkg-00rWfv; Sun, 07
 Oct 2018 02:41:51 +0200
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
To:     evan d <forumscollective@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
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
Message-ID: <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
Date:   Sun, 7 Oct 2018 08:41:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Mj5d5nWECBSeK3YwcnUxzepqhHMqpVOgN"
X-Provags-ID: V03:K1:uIr4/70Zend68vJxzyusbpU9RSnAtfy9glhf8MwUVgtGSoxeCda
 NY8sAqUv1WVwgHrupe9GNfk1sRtJCFCYSp3X11K1VGsfRJtGxfoghN8OTUE6zw1QoNklMq7
 OGNKnvMIFkBaUEsRAGXbygJInEJ9J+Pd/RGR0QafyuCm6FykHfPNrnSFQuVZC3Q/87Fohan
 s9s++sk3vxX0VnrSgJirQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Z9v1F6RAeU8=:AtpLN0AcBITnsyTClgaEI6
 hPcNvOxa1lwGnTVD1E0uUlLqzmpmdoi4+5M0tw9P5CVIJkQBK0gfrz3TgabTxabzJuTF7UR06
 1RAxNQKcEo9Z77V0Fb6l5IAq+p4zwXKDJbBVFFXnY+Iykf74b9hxYo5lfuG23cO5voA6UhObk
 ercarHYZ6pYtmxILI4AW//kVfYkGfDtHdStBEm7WlIOFAoSx7cGf2GOmMjMwyNWvxQVluhCGo
 1ZmKEobXVwmMbzzZlPMBJy4mq53CVCBcUUiain5/2SimxQb63YvdtMpKB34zRhe1lHcxXVlRh
 /w3mXCX/LHCC4XhRPsk81e7ooDGphKPX6s0ahi+G+T2qAfgUhAPafcAUO6/DAN7Dco+gzF60n
 d7/gLu2ppv3RCLkUWNQ/IAIBOJqwOYq/RkGWyQVLpWf8QckxEhAwmlPbpvwHlQw61XtGKcaeY
 FGDB0cPsGQpkQXgEOPHvhV3bIw/eaZrUlvYLZtuNBciqKbkJ1gqzs3ubd4yzyGv69ClJvLjMK
 gjqJ4VFZmykKFqx1AhO6xiBbIrrh54DG0nJPlsvZtsgYybzn1MRGJJWg/3hvrjyA0CF0leHHA
 qY1AHuAvPHn/l0mBMnTTNUgpEWMwtCJoX9cGdIsUnvbb7A28Bit8DmUr9IhZSQp1IZzHL0W+D
 iv35EWSVajK4rbmQpFEFHG3VDEyp/8Qr4lVgnOIEZ7clG7jX3Ij27dH0GoW6nPWV/yKL46N+p
 6o+3prNfOQDKFx3oxYxINGA2UBG0ov+pJS2MT0A7OqhikDR5MrrQFoxU4r30MRseXMqDMV4Xx
 DC+RKIRYkLSdRdseoSiE8RirBgl5g==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Mj5d5nWECBSeK3YwcnUxzepqhHMqpVOgN
Content-Type: multipart/mixed; boundary="MOEo065NpV96JmgpAv8v2Exf7Tl35prY2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: evan d <forumscollective@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
In-Reply-To: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>

--MOEo065NpV96JmgpAv8v2Exf7Tl35prY2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/7 =E4=B8=8A=E5=8D=887:23, evan d wrote:
> I have two hard drives that were never partitioned, but set up as two
> independent BRTFS filesystems.  Both drives were used in the same
> machine running Arch Linux and the drives contain(ed) largely static
> data.
>=20
> I decommissioned the machine they were originally used in and on
> installing in a newer Arch build found that BRTFS reported no
> filesystem on either of the drives.

Please try "btrfs ins dump-super -fFa" on these two disks.

If it's only the primary superblock corrupted, the backup should be good.=


If backup is also corrupted, either it has some offset or the whole data
is corrupted.

Thanks,
Qu

>=20
> uname -a:
> Linux z87i-pro 4.18.9-arch1-1-ARCH #1 SMP PREEMPT Wed Sep 19 21:19:17
> UTC 2018 x86_64 GNU/Linux
>=20
> btrfs --version: btrfs-progs v4.17.1
> btrfs fi show: returns no data
>=20
> parted -l:
> Error: /dev/sdb: unrecognised disk label
> Model: ATA WDC WD60EFRX-68M (scsi)
> Disk /dev/sdb: 6001GB
> Sector size (logical/physical): 512B/4096B
> Partition Table: unknown
> Disk Flags:
>=20
> gdisk /dev/sdb - l:
> Error: /dev/sdc: unrecognised disk label
> Model: ATA WDC WD60EFRX-68M (scsi)
> Disk /dev/sdc: 6001GB
> Sector size (logical/physical): 512B/4096B
> Partition Table: unknown
> Disk Flags:
>=20
> gdisk /dev/sdb -l
> GPT fdisk (gdisk) version 1.0.4
>=20
> Caution: invalid main GPT header, but valid backup; regenerating main h=
eader
> from backup!
>=20
> Caution! After loading partitions, the CRC doesn't check out!
> Warning: Invalid CRC on main header data; loaded backup partition table=
=2E
> Warning! Main and backup partition tables differ! Use the 'c' and 'e' o=
ptions
> on the recovery & transformation menu to examine the two tables.
>=20
> Warning! One or more CRCs don't match. You should repair the disk!
> Main header: ERROR
> Backup header: OK
> Main partition table: ERROR
> Backup partition table: ERROR
>=20
> Partition table scan:
>   MBR: protective
>   BSD: not present
>   APM: not present
>   GPT: damaged
>=20
> ***********************************************************************=
*****
> Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but=
 disk
> verification and recovery are STRONGLY recommended.
> ***********************************************************************=
*****
> Warning! Main partition table overlaps the first partition by 33 blocks=
!
> You will need to delete this partition or resize it in another utility.=

> Disk /dev/sdb: 11721045168 sectors, 5.5 TiB
> Model: WDC WD60EFRX-68M
> Sector size (logical/physical): 512/4096 bytes
> Disk identifier (GUID): FB26D91F-0709-11E7-B298-3464A99AF244
> Partition table holds up to 128 entries
> Main partition table begins at sector 2 and ends at sector 33
> First usable sector is 34, last usable sector is 11721045134
> Partitions will be aligned on 8-sector boundaries
> Total free space is 11721045101 sectors (5.5 TiB)
>=20
> Number  Start (sector)    End (sector)  Size       Code  Name
>   69               1               6   3.0 KiB     FFFF  =E7=8A=80=EC=9D=
=AD=ED=87=B8=E4=B5=A7=E7=BE=92=E2=8C=A6=E7=9B=A4=E4=A7=94=E1=BA=90=E5=9D=94=

>=20
> gdisk /dev/sdc -l:
> GPT fdisk (gdisk) version 1.0.4
>=20
> Caution: invalid main GPT header, but valid backup; regenerating main h=
eader
> from backup!
>=20
> Caution! After loading partitions, the CRC doesn't check out!
> Warning: Invalid CRC on main header data; loaded backup partition table=
=2E
> Warning! Main and backup partition tables differ! Use the 'c' and 'e' o=
ptions
> on the recovery & transformation menu to examine the two tables.
>=20
> Warning! One or more CRCs don't match. You should repair the disk!
> Main header: ERROR
> Backup header: OK
> Main partition table: ERROR
> Backup partition table: ERROR
>=20
> Partition table scan:
>   MBR: protective
>   BSD: not present
>   APM: not present
>   GPT: damaged
>=20
> ***********************************************************************=
*****
> Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but=
 disk
> verification and recovery are STRONGLY recommended.
> ***********************************************************************=
*****
> Warning! Main partition table overlaps the first partition by 33 blocks=
!
> You will need to delete this partition or resize it in another utility.=

> Disk /dev/sdc: 11721045168 sectors, 5.5 TiB
> Model: WDC WD60EFRX-68M
> Sector size (logical/physical): 512/4096 bytes
> Disk identifier (GUID): FC86A481-0709-11E7-B298-3464A99AF244
> Partition table holds up to 128 entries
> Main partition table begins at sector 2 and ends at sector 33
> First usable sector is 34, last usable sector is 11721045134
> Partitions will be aligned on 8-sector boundaries
> Total free space is 11721045101 sectors (5.5 TiB)
>=20
> Number  Start (sector)    End (sector)  Size       Code  Name
>   69               1               6   3.0 KiB     FFFF  =EC=9C=9C=E3=BA=
=97=E1=A3=B2=E4=8C=9F=E7=8A=94=E7=86=B5=E4=95=AD=E3=B6=96=E1=BA=90=E5=9D=94=

>=20
>=20
> Any ideas what's happened here seeing as both drives appear to suffer
> the same symptoms and what I can do to attempt a recovery?
>=20


--MOEo065NpV96JmgpAv8v2Exf7Tl35prY2--

--Mj5d5nWECBSeK3YwcnUxzepqhHMqpVOgN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu5VkoACgkQwj2R86El
/qh37wf/WCAFEaf9RI+QxDnzga69G4JOH2Q6gknzKOtsepuo19TIrmKGb2JXro+7
4/qlmHd6jiYtVH51QHs2VZ+dW+NW1Iqwf/ugMyFwnr5IZvQsUjppP8ha+Pp/8kEg
ZdnlPz8jE1Nl3Txu2JfQ7+0L//Kn5huXC+FZSDJR87bkUqTFB7O18elEJuHoDH5r
qhguDi0S4Kk+9vCKA746F32TjfYsZX71Taaj7XU1Z6XIJHlZ8X7mn10ML1HJk12b
8i8iU1M1np5Nw/bNzoHJ42CdalKiKgyzKPTFTyr21xfttnrm9hOVypJI9Y1lBp8C
Vj9OFPY1q3jho6wGXDJ5G8fAEqEHMw==
=+A1Z
-----END PGP SIGNATURE-----

--Mj5d5nWECBSeK3YwcnUxzepqhHMqpVOgN--
