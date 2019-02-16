Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B2EC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 00:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FE79222D0
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 00:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfBPAyE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 19:54:04 -0500
Received: from mout.gmx.net ([212.227.15.18]:36839 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfBPAyD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 19:54:03 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lxgt9-1h9STV1fI3-017Fr0; Sat, 16
 Feb 2019 01:53:59 +0100
Subject: Re: Btrfs corruption: Cannot mount partition
To:     =?UTF-8?Q?Martin_P=c3=b6hlmann?= <mpdeimos@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
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
Message-ID: <6a9c683a-bb47-109a-753d-010613ae595a@gmx.com>
Date:   Sat, 16 Feb 2019 08:53:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N1oftZvg5IfVjUtosOdsR0tx76BCULXZv"
X-Provags-ID: V03:K1:xeeE/AVLEnVksyvnQTPo6YbpFkOtaQhGhuVx2w0xas1Q3OaQrqO
 Qc/Cx6RYF5gfGswRM1aMos/o3jx+Z0eG4wHURsWNM7IVAaXOaCrKx3AaCr9uo/bYJ32XWI/
 YAa9UKyakXXj3vaS6MrOl12B65IltrGPvx70SoyfaYoLfNZnOqcaKtcGYy7C8JmZwPQEAPC
 AcintBrej7r46iWkYGF4g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DRzjvCrKK7o=:WyrErJZGoZK/VHImD/VCXm
 zcukKc5w5svvB7MHaPJJ7Iq4zwWLDPfvyXF5Dt+U5NukLOsrLSo95MyJ0e5zj4Od7tJoB4aN1
 +XGz+yXLOsL1O+zKt/z6ZECVd+7aizAh62Qu0Wb1bN2lLyVzoCZz0gUm/OmZ01CPqHxicPHCk
 quVhlYfWXbDKJllqgkAE8VO/7squDaf3oPM7gwmQzsS0OVCep4twxHc2sKDuUsMqjIqru5r6f
 qWvb0rqVVh4MI60pk+Ppp5BwYlInI3Wu6SXlaBN8pwBr5kEKhrpH8J9vqttx5id2mLqO6a7oj
 g0R3HjnKGs5p4EDDNKMYwiiwr3Yxdmb54oi8dyCXbGsFzpl41rt819UuFIf+Of+z4EFehuj04
 qy1oRCJ10tLutvu/DANO7431j/AW+XxH96/KMshgXbzlkR6onkJcetGTKUUvqEUmTLgTZgr02
 5HEl8HUSEpCTCeQYzEGkEchrsbkL62GbZNJZvph3iwfhS/ky5w05k5XahIdetMlKNoHqYWoZI
 SNsfF9peAjclzz7M5QY2gY+2LyZBNmw5LRDojMEj8jJX9DA2XETj9m6jW2XY53b/aZoaMZAXm
 0vq13vsqLEdnWHIzcOkTs/BIxnstc/uuj2hOdjn3dDVkm5lrycPdoCECnFA0pkPFYE74aKO7a
 i2BwfWqVscLirCoRb0orcNtBmwePa+8oCwvsnmwnZEgC50uF6zbGHaj4PsjJjUBizz0j3NRKT
 rr3/0KrsILqwE/fJ+whryTrCXjmkNQXW54MYv/MdCQAwgeKbfnSpwnRxgdVhVdA2nWk+3OZY3
 zAvEkF5Px0hMjG0fXyZf0y67jHgDoA1PHzlOdPTZsicbPaAUpqaUnYvSC7FkN88YqvO+6P0tJ
 KGkdvj9CskYnKVZIlR56LQRupSFjUXco2u3iIzvALRkbcDZ1PLZ71OjYFmokfT
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N1oftZvg5IfVjUtosOdsR0tx76BCULXZv
Content-Type: multipart/mixed; boundary="pSEJecwJm8viNy5tF7x3h2QOTVlTZ3icZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Martin_P=c3=b6hlmann?= <mpdeimos@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <6a9c683a-bb47-109a-753d-010613ae595a@gmx.com>
Subject: Re: Btrfs corruption: Cannot mount partition
References: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
In-Reply-To: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>

--pSEJecwJm8viNy5tF7x3h2QOTVlTZ3icZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/16 =E4=B8=8A=E5=8D=885:31, Martin P=C3=B6hlmann wrote:
> Hello,
>=20
> After a reboot I am lost with an unmountable BTRFS partition. Before
> reboot I had first compile problems with freezing IntelliJ. These
> persisted after a first reboot, after a second reboot I am faced with
> the following error after entering the dm-crypt password (also after
> manual mount with -o ro,recovery, see attached dmesg):

[Move check result here]
> # btrfs check --readonly /dev/mapper/cryptroot
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> root 258 inode 776 errors 200, dir isize wrong
> root 258 inode 1131031 errors 1, no inode item
>         unresolved ref dir 776 index 87215 namelen 17 name
> TransportSecurity filetype 1 errors 5, no dir item, no inode ref
> root 258 inode 2911226 errors 1, no inode item
>         unresolved ref dir 776 index 160611 namelen 17 name
> TransportSecurity filetype 1 errors 5, no dir item, no inode ref
> ERROR: errors found in fs roots
> Opening filesystem to check...
> Checking filesystem on /dev/mapper/cryptroot
> UUID: bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
> found 409699909636 bytes used, error(s) found
> total csum bytes: 390595732
> total tree bytes: 5061541888
> total fs tree bytes: 4224024576
> total extent tree bytes: 339312640
> btree space waste bytes: 892618468
> file data blocks allocated: 529336496128
>  referenced 490479570944
>
So there is just some minor problem in fs trees, not a big problem, and
your extent tree passes the check, so it's not on-disk data corruption.

>=20
> [ 6098.921985] BTRFS error (device dm-0): unable to find ref byte nr
> 390335463424 parent 0 root 2
> [ 6098.922473] BTRFS: error (device dm-0) in __btrfs_free_extent:6828:
> errno=3D-2 No such entry
> [ 6098.922526] BTRFS: error (device dm-0) in
> btrfs_run_delayed_refs:2978: errno=3D-2 No such entry
> [ 6098.922601] BTRFS: error (device dm-0) in btrfs_replay_log:2267:
> errno=3D-2 No such entry (Failed to recover log tree)
> [ 6098.972326] BTRFS error (device dm-0): open_ctree failed

It's log recovery causing problem.

You could just use "btrfs rescue zero-log" to recovery it.

Thanks,
Qu

>=20
> I've searched for a solution on the web, but most articles tell to do
> nothing, but write to this mailing list. So my hopes are that you can
> shed some light into what I can do.
>=20
> I've found a quite recent thread here
> (https://lore.kernel.org/linux-btrfs/5b0d2e94-6e4e-aecd-3eda-459c4a96bb=
13@mokrynskyi.com/)
> but this just mentions a fix for 'Fix missing reference aborts when
> resuming snapshot delete' and is not further specific.
>=20
> Setup of my SSD looks like:
>=20
> * efi
> * dm-crypt plain. Contains BTRFS (w/o lvm or similar). Several
> subvolumes (/, /home, ...)
> * swap
>=20
> I've already run btrfs restore on volid 258 (home) and gathered lots
> of data from the disk (>200GB). I also have a dd backup of the
> cryptroot after the failure happened (in case something goes wrong).
> Besides I did not do any fix attempts yet. If there is anything I can
> do to get the system working again, I'm happy to hear.
>=20
> Thanks!
>=20
> My Linux system is Arch Linux (up to date), logs below come from the
> Arch install medium .
>=20
> # uname -a
> Linux archiso 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:01
> UTC 2019 x86_64 GNU/Linux
>=20
> # btrfs --version
> btrfs-progs v4.19.1
>=20
> # btrfs fi show
> Label: 'root'  uuid: bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
>         Total devices 1 FS bytes used 381.56GiB
>         devid    1 size 460.39GiB used 393.01GiB path /dev/mapper/crypt=
root
>=20


--pSEJecwJm8viNy5tF7x3h2QOTVlTZ3icZ--

--N1oftZvg5IfVjUtosOdsR0tx76BCULXZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxnXxwACgkQwj2R86El
/qjOuAgAprd4htKqC9r5CQyqXUk17rsiz0oBNsTVRTeqGFfqIGWQUp0O11Kg1PVW
1kV175WbRuTCuZAsq1CnZhXpQrRkAaDSpmeN3/gLCV+dNtU3Z0cnMonyODCMd36H
CxfIBCgUzotm8GAXm2GIQKCbgsxUb20khJbFwM8qUSrMN0g0G0CTb36OPew+xMKY
+5IbyYaJaMay31mzaNr1EoLnlmzC2LEmRua02KwW/dnT17LOCCIo9fdmYjgZJ/kj
n0Yhmho8w0Do61Lxr3N1yhkLFeoYX1ENnQkNuFpcw0+OaJE1nhWfVeGLgu0++STl
BTUlIarbLDm8zgRQt/NKwbmy8PV+Ww==
=qY2E
-----END PGP SIGNATURE-----

--N1oftZvg5IfVjUtosOdsR0tx76BCULXZv--
