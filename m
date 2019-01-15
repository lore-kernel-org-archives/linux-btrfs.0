Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76650C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F4A20657
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfAOM14 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:27:56 -0500
Received: from mout.gmx.net ([212.227.15.18]:41515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728874AbfAOM1z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 07:27:55 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M54s2-1hSoyR1b9a-00zCSO; Tue, 15
 Jan 2019 13:27:51 +0100
Subject: Re: BTRFS critical corrupt leaf bad key order
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
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
Message-ID: <3a74079a-7e13-9368-93fb-0c25a10450e0@gmx.com>
Date:   Tue, 15 Jan 2019 20:27:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J4hnswFgFk7GxgCe8SmE6Hz5wmLTkV9na"
X-Provags-ID: V03:K1:MfdQmdg2XOJ+C0Eht2YHkGAbyTwF/kHVd2KE7/sbB+hOpid5ZYU
 C/v0j2ZfZ9wO9FC5jgyi1F69oU0TSmhMnRocVtsgyAD9u52WJj1XRCrzxlrukathM1d9GVs
 QgfKE5FeeQkMUTMa8YCnH1aTNxs8SrptDr5vPrwsezuta5woGKsrXxWLPEjfNDxNXwhZsPY
 yJEWKeYJWias6KDlZn47A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dak6OKNIeqw=:zNqX6FXIPsW/G9hWtdZqKo
 Zu0Sz6mm+fKwpNnyPtq70/8rX//3hv8CEKAI4iEgigQIjzV31+zb0Md3vuig89wE9ou9AvK1v
 WMZZGrjVvczOJoqoeIxkYuvXovfJpOtKwvGcufATOwLTRafjuSXPgvHrMSxHl2x1/iFQZFgDS
 QAnmv1MLzzNta8AymoRW31UQzOibCLLLuJuOh0Dn0yxURdxxWmk+oaWCUH9/WT9LPenuIMz9h
 oJ6xDlDiwfPlL/q3Sxdm2Arjyuyyijb5NRtGO5g+QQZmfwpCAbU+r35AM4DcNgQa+j3yj+JcF
 jsFltPuiRVGaWiHsl3oGNivUBmjc4ZDqnpxsTqSbzHTvYQzUDH70jstpVfMVx55I9lZ6bxkkL
 em0Lf+UAXvSOfUUWXbHP7lIVGLDA3iJJhGGVbjFMvkeWssVvlK5iLyH0uKT84fFxyOC2YqiNB
 zSfem8rpkH6d3lhrfefYFatwNf5Ee2rzWrxEnmP8iNorRENS1dOuSKdH6wQ3zSKT65e8Cahi6
 keMuYSV5R3XamW57Y4eUeOCqdwzafM7+fLTb1dn1cd1pTbQKCl5MTqrJKTFQehUJ1+W8wKYIi
 0BUEkLAQA+lMFuPTKqqb1glfrIYQ8G7GhWyOUK4lKmiCmEzUtNynJ5lyNS06Z19EV1rxjkTJ0
 mXVi7CyaiMXn0hyVM1EJVxb1LQgQZdUobUj7zx0Pam6rvimx4mvW7yVPVSif45PCkfDHtf2mF
 SFBJUQItngt3lLLe/gBoLfbT+gB5uyDrrljrNN4BEuuEtqd52W9u6V4HcsCngMPhZHj3xlfZ+
 RcUHh5rlgVAzkRFk8K14tow/3KO2Fc6kOApyaWFQSbzLV9VH+VBX/WnbRJ+1/Df4WImy4ttxT
 GuC9uw4+s6GRyIHgZw1MWXp+trIX3FmvuSX0RkHOQx0++wvfC4n0/tJ6i2SXWH
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J4hnswFgFk7GxgCe8SmE6Hz5wmLTkV9na
Content-Type: multipart/mixed; boundary="6y9m5bc8oGVv6AGhiUtSv2bSSNqscpAjc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
Message-ID: <3a74079a-7e13-9368-93fb-0c25a10450e0@gmx.com>
Subject: Re: BTRFS critical corrupt leaf bad key order
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
In-Reply-To: <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>

--6y9m5bc8oGVv6AGhiUtSv2bSSNqscpAjc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8B=E5=8D=887:48, Qu Wenruo wrote:
>=20
>=20
> On 2019/1/15 =E4=B8=8B=E5=8D=887:28, Leonard Lausen wrote:
>> Hi everyone,
>>
>> I just found my btrfs filesystem to be remounted read-only with the
>> following in my journalctl [1]:
>>
>>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS critical (device dm-2): =
corrupt leaf: root=3D2 block=3D1350630375424 slot=3D68, bad key order, pr=
ev (10510212874240 169 0) current (1714119868416 169 0)
>=20
> Tree-checker catches the corrupted tree block, again and again.
>=20
>>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS: error (device dm-2) in =
__btrfs_free_extent:6831: errno=3D-5 IO failure
>>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS info (device dm-2): forc=
ed readonly
>>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS: error (device dm-2) in =
btrfs_run_delayed_refs:2978: errno=3D-5 IO failure
>>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS info (device dm-2): dela=
yed_refs has NO entry
>>
>> Following Qu Wenruo's comment from 4th Sep 2018, I have generated the
>> following tree-dumps:
>>
>>   sudo btrfs inspect dump-tree -t root /dev/mapper/vg1-root > /tmp/btr=
fsdumproot
>>   sudo btrfs inspect dump-tree -b 1350630375424 /dev/mapper/vg1-root >=
 /tmp/btrfsdump1350630375424
>>
>> The root dump is at https://termbin.com/lz0l and the block dump at
>> https://termbin.com/oev5 . The number 1350630375424 does not occur in
>> the root dump. The root dump has 16715 lines, the block dump only 645.=

>=20
> Super nice move, it shows the corruption and the cause.
>=20
> 	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33
> 	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 42=

> 	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33
>=20
> See the key objectid of key 67 is way larger than item 66/68.
>=20
> And furthermore, it indeed looks like a bit rot:
> 0x18f19810000 (1714119835648)
> 0x98f19814000 (10510212874240)
> 0x18f19818000 (1714119868416)
>=20
> See one bit got flipped.
>=20
> I don't know it's corrupted in memory or on the SSD, although I tend to=

> believe it's caused by memory bit flip.
> But anyway, it can be fixed by patching the corrupted leaf manually.
>=20
> I'm working on the fix.
> Please make sure there is no write into the fs (just in case, since the=

> fs should be RO).

Here it is:
https://github.com/adam900710/btrfs-progs/tree/dirty_fix_for_leonard_laus=
en

You need to git checkout the branch, and then compile.
(No need to install)

Then inside the directory, execute:
# ./btrfs-corrupt-block -X <device>

It will try to locate the corrupted leaf using the dump-tree result.
If it doesn't find the corrupted leaf or the content isn't expected, it
will just exit without writing anything.

Thanks,
Qu

>=20
> And prepare a LiveUSB on which you could compile btrfs-progs (needs som=
e
> dependency).
>=20
> It shouldn't take me too long time crafting the fix.
>=20
> Thanks,
> Qu
>=20
>=20
>>
>> Would this imply that the corrupt tree block was not yet commited? Wha=
t
>> actions do you recommend to take next?
>>
>> My kernel version is 4.20.2. I am writing this email via ssh from the
>> affected system on some working server. Besides the error message abov=
e
>> and the fact that the filesystem is readonly, I have not yet found any=

>> issues on the affected system. Note that the error was occuring under
>> high system load while compiling a bunch of software on a tmpfs (and t=
he
>> compilation was successful, but installation failed in the end due to
>> trying to copy to the by then read-only btrfs root filessytem).
>>
>> Does this suggest a hardware issue?
>>
>> Thank you for your help and taking the time to read this.
>>
>> Best regards
>> Leonard
>>
>> [1]: For unknown reason, the dmesg output does not reach back to the
>> time of the error, but only contains log messages from after the
>> filesystem was mounted ro.
>>
>=20


--6y9m5bc8oGVv6AGhiUtSv2bSSNqscpAjc--

--J4hnswFgFk7GxgCe8SmE6Hz5wmLTkV9na
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw90b4ACgkQwj2R86El
/qhkSgf7BFJZ8xE8L9/efxiRPzHSIe0hDq/rqjUgEhg7qr0f/PHApAWZf6Hkqu0D
GJqUOKplgWBNW4Rm0HK1WW5OqWcRBvItKiVk74JgbB0lukLwkEvU+FItBiCc1q4Z
zs03B7z0IRu/QV2gDlCWQ1w1Bg3FjH+dAXpN1DkFBa+rfltJE0kcm+HS6164FIjh
yH8eremQNszrBHnte76HAEbcTZ1yWhbhCpULX2QGQdbE9kM89YdlD/idf2wSINHl
QnocerEqJdB027JEqGo+l/wi4wZ9+1ArFSxquhbRMh2z8nL3FyKPYTkeGiYrMP/r
MJOI4C6fkNCHIS19X23gOyGW3u7u0Q==
=3NER
-----END PGP SIGNATURE-----

--J4hnswFgFk7GxgCe8SmE6Hz5wmLTkV9na--
