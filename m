Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F31C28CF8
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 08:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 826A820652
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 08:30:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 826A820652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbeJOQOp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 12:14:45 -0400
Received: from mout.gmx.net ([212.227.15.18]:44091 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbeJOQOp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 12:14:45 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LvV1X-1fUuDw1ThD-010eZH; Mon, 15
 Oct 2018 10:30:28 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LvV1X-1fUuDw1ThD-010eZH; Mon, 15
 Oct 2018 10:30:28 +0200
Subject: Re: How to recover from btrfs scrub errors? (uncorrectable errors,
 checksum error at logical)
To:     =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>,
        linux-btrfs@vger.kernel.org
References: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
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
Message-ID: <eba5de6f-535a-0f5d-e415-9cd622d71b36@gmx.com>
Date:   Mon, 15 Oct 2018 16:30:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Pb5hQ9o8s1irQc8DhXEBdR2Ab6zXb5QcO"
X-Provags-ID: V03:K1:fxHJ5N+fg0AFAyHQlJFXZPCS9/+qluwngv/BxHmEblpfB9ViocX
 lUDuAvPWcnzwv7B5Xk2nVrWt5uunpDREv6dzmErDZ2M7cv8S5Sec3y+qicMBW0nSpS08Xfo
 EHjtpbGu3Fo08f0Vt2aOql+4/5Z1vY2hwMao6SRM2tIUJqCyfjCsSIbBLJWlnTrAsYCLH7N
 O2O5ZNiNv7b0IDU0tbNBQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:mQJCG3J4dEY=:c2SMoa+akCXCBaoiutDDdV
 FQTycPwlwJa+bCpUuw3SeaAz1EeBrKhkXQlMtdB8khVTv8zwhskOTxJo0zw6PZjIuKmMuR7hu
 QBlMDA8dCvwemoUYGT61iPa9XOfjN8MaQLM7IGldplg/YGdZakf0OuatFSQ54oGbJt3ZEfMIN
 Pj0OERIrOUvBNPWLpiaYc+D2+K4GgyEGJNxKkBDyv0D6NA3QSCtbaWRUlL5+p5Gv2VJrm7Kqz
 ipcBG9f5bx5g5VfRzPW/Yrc72fiS8yWit/Pf3l2LVVPqCbf/k8BQyYJTrOGLyzvLS+KleGWu/
 9V91dqUYETlim+D1EKb4rojOawMgNv4nKZLg/yX0RclFIyUD2ybGIFLnXYQjoH2F5JJCEeLMH
 XD15/sRW1A54bWvTNBIH3MFxkWhPVVUDXY7f85iz1cHZLpygJDb+viD+kUHarDK9xPIEhFSo7
 /Ka7YfTVF+zgOj8HbDM7qmRvEC6/xHzXhzzb8NXirIOdsObCkGFhOPr1oySP/C9uUCVdI/HER
 5V6vQheSpXdfSZqCdccKoyjPapMEXt1QnzpYeZmAnBJZw2E1y97S5MJKnY66XusjG0limGV+D
 HbJlihNxhBbiHt4y5gzrpJ5sU0t2yK3ApenkNGOkpbaKNwi+FhDd7CT50la0/XJbDOxmTuEWH
 OJ2/Q0Y27IvKYUMA02IoC36D/Q7WmaN/bIXCAMh5cH6LqYFMgmn5MBOxiRUvs5KxfDeFpuaBI
 XUsarDEjgZMbmIaZaSqEseVe36pabYZQ4CsY5XOH04EMngdEB/ITZGksaEY1BfZuLEcZ1YRLR
 ZYMZvNcxLbTm7e4jtI1DND8/tFRFg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pb5hQ9o8s1irQc8DhXEBdR2Ab6zXb5QcO
Content-Type: multipart/mixed; boundary="QZlq9p4SMBSaaWnDrwD0Ze3yaUnNViaEY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>,
 linux-btrfs@vger.kernel.org
Message-ID: <eba5de6f-535a-0f5d-e415-9cd622d71b36@gmx.com>
Subject: Re: How to recover from btrfs scrub errors? (uncorrectable errors,
 checksum error at logical)
References: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
In-Reply-To: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>

--QZlq9p4SMBSaaWnDrwD0Ze3yaUnNViaEY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/15 =E4=B8=8B=E5=8D=883:50, Otto Kek=C3=A4l=C3=A4inen wrote:
> Hello!
>=20
> I am trying to figure out how to recover from errors detected by btrfs =
scrub.
>=20
> Scrub status reports:
>=20
> scrub status for 4f4479d5-648a-45b9-bcbf-978c766aeb41
>         scrub started at Mon Oct 15 10:02:28 2018, running for 00:35:39=

>         total bytes scrubbed: 791.15GiB with 18 errors
>         error details: csum=3D18
>         corrected errors: 0, uncorrectable errors: 18, unverified error=
s: 0
>=20
> Kernel log contains lines like
>=20
>   BTRFS warning (device dm-8): checksum error at logical 7351706472448 =
on dev
>   /dev/mapper/disk6tb, sector 61412648, root 12725, inode 152358265,
> offset 483328:
>   path resolving failed with ret=3D-2
>=20
> I've tried so far:
> - deleting the files (when path is visible)

Please ensure there are no other subvolumes/snapshots containing the
same file or reflink to it.

If path is not visible, please use the root and inode number to locate
the culprit file.
"find" command support to search using inode number.
And "btrfs subvolume list" command will show the subvolume number.

Also it's recommended to sync the fs before scrub, in case culprit inode
only get orphaned but not deleted from disk.

> - overwriting the files with new data

If you're only overwriting the culprit sector, it could get CoWed and
the original data extent is still there.

You need to ensure the old data is not referred by any other root/inode.
Please ensure there is no reflink/snapshot first.

Then delete the file or overwrite the whole culprit file.

Thanks,
Qu

> - changed disk (with btrfs replace)
>=20
> The checksum errors however persist.
> How do I get rid of them?
>=20
>=20
> The files are logs and other non-vital information. I am fine by
> deleting the corrupted files. It is OK to recover so that I loose a
> few gigabytes of data, but not the entire filesystem.
>=20
> Setup is a multi-disk btrfs filesystem, data single, metadata RAID-1
> Mounted with:
>=20
> /dev/mapper/wdc3td on /data type btrfs
> (rw,noatime,compress=3Dlzo,space_cache,subvolid=3D5,subvol=3D/)
>=20
> I've read lots of online sources on the topic but none of these help
> me on how to recover from the current state:
>=20
> https://btrfs.wiki.kernel.org/index.php/Btrfsck
> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-S=
crub-and-Btrfs-Filesystem-Repair.html
> https://wiki.archlinux.org/index.php/Identify_damaged_files#Find_damage=
d_files
>=20


--QZlq9p4SMBSaaWnDrwD0Ze3yaUnNViaEY--

--Pb5hQ9o8s1irQc8DhXEBdR2Ab6zXb5QcO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvEUCAACgkQwj2R86El
/qiZLwf5Aal7mesevR7hmMeNU5YL1kbuzIzicn8w0C+Uk3tP4SKUeHPTAJ7dIln2
2etj3xaEyRvtfBw7Ta1BmWLvYhRK8TJ8P2n86NBCEzedVtcW4ALrlbSOQy/IDfTT
Zy9o7KtrxyOFbi3P3qR8LccdkiW36YvwuBT8YwS+Nmjx+KUN9bGlFFVwLOusPkiy
zIpL7ApkXFaG6df+RJ6S8Ajm0Qa/9wnCtcBKOhbwfRWw43sbHjn1nnYqkzkerOBU
QDZm/zlWdc5EgU9Lhh3iN0uT5FTYtsEDOCmcWYQ/1e1mEc/MHZ+nykw5hounqGCq
6xZP0DdXUR705bvjRnlucK9agO+4mQ==
=jB59
-----END PGP SIGNATURE-----

--Pb5hQ9o8s1irQc8DhXEBdR2Ab6zXb5QcO--
