Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A383C67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 23:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B47320813
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 23:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B47320813
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbeJXIVD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 04:21:03 -0400
Received: from mout.gmx.net ([212.227.17.22]:50175 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727595AbeJXIVC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 04:21:02 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MFz0E-1gQbF73yUQ-00ErDA; Wed, 24
 Oct 2018 01:55:09 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MFz0E-1gQbF73yUQ-00ErDA; Wed, 24
 Oct 2018 01:55:09 +0200
Subject: Re: Conversion to btrfs raid1 profile on added ext device renders
 some systems unable to boot into converted rootfs
To:     Tony Prokott <tprokott@zoho.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        debian-user@lists.debian.org
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
 <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
 <16685d14644.eefe20a081666.8834845236508091976@zoho.com>
 <ca04659e-0103-6698-6971-2a34f7cd929d@gmx.com>
 <166a2601cc9.1251c8f6b159383.1587614760796128824@zoho.com>
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
Message-ID: <8383e038-9ce0-897e-2690-4726b19a88fb@gmx.com>
Date:   Wed, 24 Oct 2018 07:55:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <166a2601cc9.1251c8f6b159383.1587614760796128824@zoho.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="giRuEere10QSX9mgBVJ0DuRZyrcAbuId8"
X-Provags-ID: V03:K1:Ny/ReKuhdbOLeDN43RdPM98CiN5ZdbuHvYSJ1cK0slYAkvmHIK4
 EXXG1ENPDMmUjFbbBEpEJaLmrooduwpoRnbKaaWqjTlNG7dAWP5i1zusAOdg4wLypnKa+ss
 l4acpWI9WDIy2vqDtjEpxZh5ZXGM5KiKKtBGJ9nGn4PdB6a34iUwDd9L779QaXypCqUAPBW
 WajxyYVPWnIoEeD7KfrjQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:HQ3EyeaXjS8=:Mbm0D1wUyjfUeB2haYkYfY
 J3bU7zc/WWSe30kJXbII7CBFEN+si/ZFurnRFcY4G+HTOk9MV9OWRvjkXsWVGD/8jnAm0EYfg
 G0VD4IlL+T+o/gBKcam2E2DcmBkCM7IJSDdpYx2paRCWvvkZIbMROEJ3DpDMSrca9XkNdqtTo
 6kxKcHF0MCgxlO7yfc1JitLzUAjGuGmcadLnoQw3mEcRbvtUesnUpzFobfCzUCjQZCxK7QJ0r
 0EcaC+HLIzq8OzaSeVSNJvqNbIC+GJO9/2Zp0qbHaWFaz9+1CI2+2wMgdqJTH0fWvrFmjd/pg
 JOPh+5zTYIhcLNApBbDBodvOwI7WaqE7E3/LMZmbt/+4UGOqzafVyVJDqrplLRYIZ47xzaLim
 DGl3keBFw30mVMQf6l8JJmTYTAUhhxyfsOkQP3zWJSnyQ3ymFmTHpnssr6r3seZguiqP+cP4d
 RmzAuURXSGX9Vmo8DerLSU0fLdDrdwpHGedKOCjm51iHUeHvdr53zjkpBbsurq9zrC0rKwA0E
 yPeWwykeTLfWCqwUPHAMc+SK2q2OacNyYSoXdsC8YXnZyecF+/54FpkcMC8dFdTW2qTntKJ92
 wd0Sk5nz3rFaFigxLsXjiThi+qR8auQ7cUc0FaF4O1ciDnwroNS1S0UiZkPvRhDHpDSnX+Mva
 t5FGHrt5zlHaEc02XKz++QbOR4mfnD+835XzqkRyjgG27DlAV0Hdn098Eh9+65qAdvKGm6OuG
 o7qpSeKC4Cv+oZ2h3dr/mMJ0xqv0LbqAtKHerzrCTES33e9FPFKbM8WfELiYPRupE7ppog1En
 4JH8jU6wiIOTjL3sYW0KcijeL+bYw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--giRuEere10QSX9mgBVJ0DuRZyrcAbuId8
Content-Type: multipart/mixed; boundary="An3xxlrUEUkPfqXw5ztxoV7BO671ZmwXq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tony Prokott <tprokott@zoho.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>, debian-user@lists.debian.org
Message-ID: <8383e038-9ce0-897e-2690-4726b19a88fb@gmx.com>
Subject: Re: Conversion to btrfs raid1 profile on added ext device renders
 some systems unable to boot into converted rootfs
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
 <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
 <16685d14644.eefe20a081666.8834845236508091976@zoho.com>
 <ca04659e-0103-6698-6971-2a34f7cd929d@gmx.com>
 <166a2601cc9.1251c8f6b159383.1587614760796128824@zoho.com>
In-Reply-To: <166a2601cc9.1251c8f6b159383.1587614760796128824@zoho.com>

--An3xxlrUEUkPfqXw5ztxoV7BO671ZmwXq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Add Cc to debian user list.

On 2018/10/24 =E4=B8=8A=E5=8D=883:21, Tony Prokott wrote:
> The trouble is yet unresolved, symptoms are as they were, but I've diag=
nosed a step further. Maybe you can help me advance the diagnosis or bett=
er pose my question among debian experts, related to adjusting the buildi=
ng of initrd.
>=20
>  ---- On Thu, 18 Oct 2018 00:08:08 -0700 Qu Wenruo <quwenruo.btrfs@gmx.=
com> wrote ----=20
>  > >  > Still looks like a initramfs problem [rather] than btrfs proble=
m. =20
> Yes, but linux-btrfs list still knows better than I how best to proceed=
, mainly how to distill the trouble description using proper terms, also =
lending broader understanding of what named modules serve what device act=
ivate&cfg or storage-access purpose.

Personally speaking, distro guys are much better at such problem.

In fact I'm not even a debian guy, and for my distro, it's super easy to
setup initramfs to boot from USB device.

>=20
>  > >  > In the busybox environment, have you tried listing /dev to see =
if that external device is found? =20
> External usb attached drives are definitely not found by a newly launch=
ed kernel, and particulars of why are still not self evident. Boot loader=
 grub2 all along still has no trouble accessing -- presumably it's not ab=
le to leverage raid1 redundancy in btrfs but does have access to the ext =
mirror device and takes notice in passing of matching UUID's.

So missing drivers.
Without the driver, btrfs scan doesn't make sense at all.

It needs not only usb drivers but also some other drivers.
Normally distro should provide such tools to do runtime probe and
generate all needed drivers and their dependency, or manually setup
needed drivers.

BTW, have you tried something like fallback initramfs?
Generally speaking such fallback initramfs should have more modules thus
higher chance to detect external usb drivers.

>=20
>  > By default, btrfs must see *all* devices to mount RAID1/10/5/6/0. Un=
less you're using "degraded" mount option.=20
>  > You could argue it's a bad decision, but still you have the choice. =

> Yes did manage to mount it degraded, just to see that content demirrore=
d is also unclobbered, however can't finish the job by such means; hopefu=
lly in the process no metadata or other junk was written unintentionally =
(forgot to mount readonly - degraded)
>=20
> The task now seems to be finishing resolving which modules can bring in=
 the rest of the critical infrastructure to allow access to the drives th=
at had been no customized bother to bring online, prior to rootfs raid1 c=
onversion. A recently found item of great interest is module "autofs4" wh=
ich has userland friends such as systemd; it's present in cindy(LMDE3) wh=
ich boots fine in spite of deriving from stretch, and was absent in stret=
ch & buster which no longer boot.
>=20
>  > > When manually trying to mount in busybox, it gives a similar error=
 about missing the same external device, by its UUID_SUB=20
>  > Then it's still something wrong about the initramfs. From your descr=
iption, it looks pretty like the lack of external disk driver is the root=
 cause.=20
> Agreed *something* missing in initrd and-or module deployment is the ca=
use of failing access to ext usb3 drive enclosure devices, but am still t=
racking down which other missing blobs may be of concern; since busybox w=
on't allow "lsblk" "lshw" or "lsusb" -- only "blkid" or "ls /dev" work to=
 detect devices -- my confidence and expediency in tracking is reduced; h=
aven't yet happened upon the debian feature that lets more nonkernel prog=
rams and libraries--not just modules-- be built into initrd.

At least for my distro, it's pretty easy to inject external commands
into initramfs.
(Archlinux provides "add_binary" function in mkinitcpio, which will not
only add the binary but also its dependency)

So it's really dependent on the distro.

Thanks,
Qu

>=20
> As an aside probably not germane, the grub.cfg "linux" line to load the=
 kernel in some cases has "ro" readonly option and others not; what's the=
 difference signify? How to make informed choice whether to use ro? Why m=
ount a real disk rootfs without write access, before corruption's detecte=
d? Would that not potentially cripple some vital features such as logging=
?
>=20
> So far it's clear that uas, usb_storage, & autofs4 may be built into in=
itrd and then load ok, but they're not enough to restore normal systemd l=
aunch. Setting "MODULES=3Ddep" in /etc/initramfs-tools/conf.d/driver-poli=
cy seems not smart enough for building in all necessary objects. Ideas we=
lcome.
>=20
> regards-
> TP
>=20
>=20


--An3xxlrUEUkPfqXw5ztxoV7BO671ZmwXq--

--giRuEere10QSX9mgBVJ0DuRZyrcAbuId8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvPtNcACgkQwj2R86El
/qgQpwf/b5DNAsRXk3bWylE53C0t5KLI4LKH0kVD23suHZ3Hi2c8IsbBJ2HLbE+o
fVRr00Qz+ShEGlruIMFJ9F3Gj3sk5j6sCfXDYEvW9NytAeSciZM2Yxel0YZlsCum
/CrKOAs3M4OLvo3gDmwf7NSBliblcQjrLNPlzpq1AkYwTrEKrqT8HjzUBaVZVPvG
9YuOD/mO8I7NU3C8dziC2gQZFEKhjip2Rr02lu2RlMUCkL6yG83gnvaSpFM+ZauF
xypT6CHzXkD9PHd1drxPBUxq5EQNMdt+po3BvyXmchKosXiFpelPt9MIn1WR9KCF
A66UrYuD5NEbQAtdud0tLwTDnJZB9A==
=u8V6
-----END PGP SIGNATURE-----

--giRuEere10QSX9mgBVJ0DuRZyrcAbuId8--
