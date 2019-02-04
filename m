Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3B7C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 11:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C7882087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 11:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfBDL7f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 06:59:35 -0500
Received: from mout.gmx.net ([212.227.17.20]:45451 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbfBDL7e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Feb 2019 06:59:34 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MQNFY-1ggl1a1qJA-00ThXT; Mon, 04
 Feb 2019 12:59:31 +0100
Subject: Re: Help needed, server is unresponsive after btrfs balance
To:     Moritz M <mailinglist@moritzmueller.ee>,
        linux-btrfs@vger.kernel.org
References: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
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
Message-ID: <4ecaf7ef-49cb-d7f6-3535-941e44e2f469@gmx.com>
Date:   Mon, 4 Feb 2019 19:59:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NWU6y3iewh9FFMh63XU01VOW1SEsAU9qL"
X-Provags-ID: V03:K1:XtpVYtLCLVn6Z0QsiYukolfiTWMXX/ASEdgQQIVI9jpy27XB9f5
 QI3mHwjmPSmxvQiRZmAsyQerT0eK5HBwk3ASM8bhx6YSrTujTeczVjyyOJhXyDyiZvFuONS
 AQ2UgLh/1F5VmK6j0Ap6nFXk4QF2qIdR5LJsanHHNzPJ0Ga+LNSTi+9VssKRP4/hXlX/wy5
 tVKym7UgcIc1e/xN8UWZQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:FGOospzguf4=:2HeVlQhMTMoV20Yp5NuB8N
 W/gMfCDctfJ/28cfKqyDcBZgayMNSrq7upm0lcp3gR+aFTISz1GGttQQjnDL/9xCd+V0XC+34
 7RBfsnyLoAjrgOhlbUntf+HfFOgwGjqkhcUCUoSkGDZgg2Ds4yPv7vW4Mnv6Kuo85xMDmb4F2
 PW1XVGT+mjmlXxHbXJA5B02EH5eovf+2ceya5/rHgRftxTquBqVG4pSoZMBLBqi3IP3PfOQQd
 nVjFUsg2HOLhHAXCSdZHgO8MmpKpqbO3YBLASTKlwT5npKQkWzJikZAOoLQ/3Z/o9jWww5kSt
 2ggRlLEHrzhVoZWYbyJnPiRGTMtkdsemVREOqbod6Wsr7ENHTe2KgatlS9909KQze+w9OOZQu
 w2/rdDn2WTp7eksWt3gEkdsNkhiFzSVlKkR0VodvZFR5aE2LbHhw+kCAoCT5lNAsByC3pw+5d
 Hz3aCGQTXLrveK5FeyujB7DSyziChGe0sOeQikBfMA1eebz1ZpuCZxQUEzKXP/SaezuWhKc8j
 ArRq8ZUeMBtKBPxAfriiWLjPI3ChzRexIFHpORIjyw/w7aBy3Y9ME3Er4LKal8lCHZ1iBYZ9+
 jIN+3qbshj4KZpkcNHb7yNNVrF3C269itT3xHr08EMMNTzzWKnq/f+ewsLB4PFcDDVu6YWBaW
 Lb7G+UJy18Wb+ZP5F1C/1rbGvimNTNWXdxyjLwGKfBYzQvtDAxlmfaKqWimhIZGH9UUdcju8E
 i7a7P2oYpMXPkETXlLHt8J48UQQVHj4KImMrs5RhQhoMtf0cCUj14uKYNxo6+OHDpXSDcvPJu
 DQLXNaTwoVjdo56OtinWOyU3M073OWNFmfbuSUkZi7Wcwzqs/0ACseqv5G9Mkoes5EnW3xyEc
 dzGAM41arZxpw2jX3eFOLWd2NJtL2sFK7IOMqo6lndOCTnmCjYaPdQP2hbD9M7
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NWU6y3iewh9FFMh63XU01VOW1SEsAU9qL
Content-Type: multipart/mixed; boundary="LowE4RiRXyI3B6lJPnuwsNhX57I6dPTTv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Moritz M <mailinglist@moritzmueller.ee>, linux-btrfs@vger.kernel.org
Message-ID: <4ecaf7ef-49cb-d7f6-3535-941e44e2f469@gmx.com>
Subject: Re: Help needed, server is unresponsive after btrfs balance
References: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
In-Reply-To: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>

--LowE4RiRXyI3B6lJPnuwsNhX57I6dPTTv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/4 =E4=B8=8B=E5=8D=887:47, Moritz M wrote:
> Hi,
>=20
> I'm running a Ubuntu server with a btrfs RAID1 consisting of three HDDs=
=2E
>=20
> I do balancing daily via
>=20
>> btrfs balance start -dusage=3D50 -dlimit=3D2 -musage=3D50 -mlimit=3D4 =
/
>=20
> It usually takes between 1 - 10 minutes.
>=20
> But today the server was unresponsive (no ssh connect possible, no
> direct login via keyboard possible)=C2=A0 even after 7 hours.
>=20
> I had a similar situation two weeks ago. I did not find anything and
> finally checked and repaired the filesystem with
>=20
>> btrfs check --repair /dev/sda3
>=20
> Which found some qgroup related problems:
>=20
>> enabling repair mode
>> Checking filesystem on /dev/sda3
>> UUID: cf8c4bb2-6a75-4e1d-983c-19583a93a546
>> No device size related problem found
>> cache and super generation don't match, space cache will be invalidate=
d
>> Counts for qgroup id: 0/257 are different
>> our:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 referenced 127300112384=
 referenced compressed 127300112384
>> disk:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 referenced 18446743939=
800129536 referenced compressed
>> 18446743939800129536
>> diff:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 referenced 26120953446=
4 referenced compressed 261209534464
>> our:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exclusive 56360521728 e=
xclusive compressed 56360521728
>> disk:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exclusive 56360521728 =
exclusive compressed 56360521728
> =E2=80=A6
>> Repair qgroup 0/257

You're using qgroups, it's known to cause huge performance overhead for
balance.

We have upcoming patches to solve it, but it not going to mainline
before v5.1 kernel.

So please disable qgroups if you're not using it actively.

Thanks,
Qu

>=20
> Today I had to boot a Live system, mount the btrfs filessystem with
> -o skip_balance and cancel the balancing there.
>=20
> Mounting took ~30 mins and in journalctl of the Live system I found thi=
s
>=20
>> Feb 04 09:42:28 ubuntu kernel: INFO: task btrfs-transacti:7527 blocked=

>> for
>> more than 120 seconds.
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not=
 tainted
>> 4.15.0-29-generic #31-Ubuntu
>> Feb 04 09:42:28 ubuntu kernel: "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Feb 04 09:42:28 ubuntu kernel: btrfs-transacti D=C2=A0=C2=A0=C2=A0 0=C2=
=A0 7527=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2
>> 0x80000000
>> Feb 04 09:42:28 ubuntu kernel: Call Trace:
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 __schedule+0x291/0x8a0
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 schedule+0x2c/0x80
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 btrfs_commit_transaction+0x81d/0x=
8f0
>> [btrfs]
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 ? wait_woken+0x80/0x80
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 transaction_kthread+0x18d/0x1b0 [=
btrfs]
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 kthread+0x121/0x140
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 ? btrfs_cleanup_transaction+0x560=
/0x560
>> [btrfs] Feb 04 09:42:28 ubuntu kernel:=C2=A0 ?
>> kthread_create_worker_on_cpu+0x70/0x70 Feb 04 09:42:28 ubuntu kernel:=C2=
=A0 ?
>> do_syscall_64+0x73/0x130
>> Feb 04 09:42:28 ubuntu kernel:=C2=A0 ? SyS_exit_group+0x14/0x20
>=20
> After rebooting the server acted normal. The only thing I could find in=

> the journalctl was:
>=20
>> Feb 04 02:00:02 server kernel: BTRFS info (device sda3): relocating bl=
ock
>> group 7246746484736 flags data|raid1
>>
>> Feb 04 02:05:23 server kernel: BTRFS info (device sda3): found 3 exten=
ts
>> Feb 04 02:06:12 server kernel: BTRFS info (device sda3): found 3 exten=
ts
>> Feb 04 02:07:01 server kernel: BTRFS info (device sda3): relocating bl=
ock
>> group 7059915407360 flags metadata|raid1
>=20
> Btrfs balancing starts at 02:00.
>=20
> Can anybody give me a hint what causes this?
>=20
> I suspect some kind of hardware failure but can't find anything. Any
> idea where to look?
>=20
> My setup:
>> Linux server 4.15.0-45-generic #48-Ubuntu SMP Tue Jan 29 16:28:13 UTC
>> 2019
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>> btrfs-progs v4.15.1
>>
>> Label: 'rootfs'=C2=A0 uuid: cf8c4bb2-6a75-4e1d-983c-19583a93a546
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 3 FS bytes us=
ed 620.55GiB
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 s=
ize 923.13GiB used 446.03GiB path /dev/sdc3
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 s=
ize 923.13GiB used 449.00GiB path /dev/sda3
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 3 s=
ize 923.13GiB used 447.03GiB path /dev/sdb3
>>
>> Data, RAID1: total=3D667.00GiB, used=3D617.65GiB
>> System, RAID1: total=3D32.00MiB, used=3D176.00KiB
>> Metadata, RAID1: total=3D4.00GiB, used=3D2.90GiB
>> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> Dmesg output is not provided there was nothing after reboot.
>=20
> Thanks
>=20
> Moritz


--LowE4RiRXyI3B6lJPnuwsNhX57I6dPTTv--

--NWU6y3iewh9FFMh63XU01VOW1SEsAU9qL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxYKRoACgkQwj2R86El
/qiwFQf/ZhL/rpRvDG5+RvtopUPPHUz70h50J5/2/xhsfg2St5d0pdIMZi5+70Yr
DTbzas5OT7beIv5+QYj44JzrjJ/lWgK0BR2SOMk7n4MzYOBlez8Q72g1GSvLRxBT
RwV4FUJoGNRhWlLngxcU7vk1kxV6xDphysIf3dU2U7AzrfgzjEwor3FqwRfTvfuO
oDPwhACmesV2lGBGS0jAED+/xo+PKE+AfqATvPG8flkVpuoi8zHYHgtlxlCtQa7m
u5WCwG7uolzgiPMEqcA+3lMcUp/7clSdYLcD1GCTVG/tAcnCdVGs2nvrrrYturBO
PWsZFW+worh9Wxpr3/AzAq9NWY2ENQ==
=qYfd
-----END PGP SIGNATURE-----

--NWU6y3iewh9FFMh63XU01VOW1SEsAU9qL--
