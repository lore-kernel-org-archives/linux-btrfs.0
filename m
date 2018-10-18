Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF65AECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 07:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B3002145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 07:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B3002145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbeJRPHz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 11:07:55 -0400
Received: from mout.gmx.net ([212.227.17.22]:54661 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbeJRPHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 11:07:55 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9eHT-1gLXfg374p-00D2aS; Thu, 18
 Oct 2018 09:08:12 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9eHT-1gLXfg374p-00D2aS; Thu, 18
 Oct 2018 09:08:12 +0200
Subject: Re: Conversion to btrfs raid1 profile on added ext device renders
 some systems unable to boot into converted rootfs
To:     Tony Prokott <tprokott@zoho.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
 <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
 <16685d14644.eefe20a081666.8834845236508091976@zoho.com>
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
Message-ID: <ca04659e-0103-6698-6971-2a34f7cd929d@gmx.com>
Date:   Thu, 18 Oct 2018 15:08:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <16685d14644.eefe20a081666.8834845236508091976@zoho.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Wv7OrSP9Um2mixfIQr2sMgRlxXPeubmSX"
X-Provags-ID: V03:K1:+gm5py29iywZ/I0l8Y3F2z7cuU7kDLxnZD7Mh8whDgXm4Inhckd
 sNaXlDSuSKSNC6fjw5kwZXIbtTm1beKC9wBeGDkWT37Inv9y2x/+pv+EZJba6F3uOda8VuL
 y3050gb/uJ89n0ca+7oLcr3ZsWwBa18ZMf02VyF4irtEvRnq2ZWzMp3mQWddOGaoQG+Iy39
 sRYSlyfQSOpegX79XAyNw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:zZ97AZos4Bw=:4TnTfCyD86D8AQoTR+SDlr
 gpWnoCmD0+t/L2xf5UmHNKQUH0o+DGS1xVcbCHMCU7nVh6qlOTGsJKqUKWho4l8OuSFuvCx1b
 jJ8neWlyFM9lWyLw+LAIQ5bOb1s0R3MhwOuC7esgHuBrvXzhVg9Di5/oGirwqgsbXs1o81vyl
 hzO2Cxe1rA2/l006jH5hx25VkqCEnV5KQxOTvASjXSB8/GYqmcYfzVOtJPYdFO9ya0kSUlkR4
 W5TZO2BXZ58un7fmUkSDTa/JchnsjNTyRGnkUa+t/v05cT3eghA2hFWpbthHBcTZcLFVKzScx
 paTPHAhW7MJ78mC+6vMPMtNDSeMvctYtJnIeqUJ3f4mZ+lTeyJVBL45U8TS0xAyN79vonACs4
 uc7XTbbmvG3By61B0a2SYu9PNgP6KOP6KSloZT0ZFhr1DbpwNUg3mX5NMk5oa3zRxpOFs+8M5
 e/vgQcKeUvXZUC6yYocf6UCZzIoYUPUZcWsHa6Z4Q/dmW1ELxQjf36u9w7dVWwRaSSD6TkCKs
 T1GIfaSxKBgeeIuCamY/XmiWB/9fPpfZwhU2Xs0QUMWaXac06O3xUSLnsPftHDQOwp7BDmKC3
 dh6dRGSWXJTfk1bsWvlRuWVHS4Vvty8skN3mDX90Sst7J/pWuUAGelFuOKIUjreIOG7ha1+0Q
 z9r1EF/riucmtJNnluIaFRtp2IYnsykOWdVMn2630n+w9eQxH/JfcKWhpUShFEVY1ydmzkrmY
 nRWFY0Gwd1cD/Rb91rmrcov5nF84qhPb09wi/tSYPmKkJ9PXVRGRkDqg8egnT4BWYm/xbrt5W
 mHCEKhivJIk2mAVZskoFg7Waq2I8A==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Wv7OrSP9Um2mixfIQr2sMgRlxXPeubmSX
Content-Type: multipart/mixed; boundary="FAp9JmNvo7kmYHXGKXftWdKvcGdOcN2xc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tony Prokott <tprokott@zoho.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <ca04659e-0103-6698-6971-2a34f7cd929d@gmx.com>
Subject: Re: Conversion to btrfs raid1 profile on added ext device renders
 some systems unable to boot into converted rootfs
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
 <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
 <16685d14644.eefe20a081666.8834845236508091976@zoho.com>
In-Reply-To: <16685d14644.eefe20a081666.8834845236508091976@zoho.com>

--FAp9JmNvo7kmYHXGKXftWdKvcGdOcN2xc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/18 =E4=B8=8B=E5=8D=882:16, Tony Prokott wrote:
>  ---- On Wed, 17 Oct 2018 17:57:25 -0700 Qu Wenruo <quwenruo.btrfs@gmx.=
com> wrote ----=20
> ...
>  > > But after chrooting to update-initramfs and cataloging resulting i=
mage content, usb_storage and uas were present under /lib/modules/xxx alr=
eady, and failing systems still just busybox without a real rootfs rather=
 than launch systemd; even tried kernel option "rootwait" which had no ef=
fect on access to ext storage; udev still seems not to have noticed the e=
xt drives once busybox had control.=20
>  > =20
>  > Still looks like a initramfs problem other than btrfs problem.=20
>  > =20
>  > In the busybox environment, have you tried listing /dev to see if th=
at=20
>  > external device is found?=20
>=20
> agreed that initramfs smells bad, but it hadn't been a problem until bt=
rfs mounts (external-raid) had to rely on the usb channel;

By default, btrfs must see *all* devices to mount RAID1/10/5/6/0.
Unless you're using "degraded" mount option.

You could argue it's a bad decision, but still you have the choice.

> in busybox, ext drives/partitions are all missing from /dev; can't tell=
 why so, ahci and usb modules are loaded afaict
>=20
>  > Since you have a busybox environment, have you checked if "btrfs" co=
mmand lives in the initramfs?=20
>=20
> yes btrfs command works from busybox
>=20
>  > IIRC at least you need the following things/abilities to boot:=20
>  > =20
>  > 1) usb and sata drivers=20
>  >    Means you could see both devices in the busybox environment under=
 /dev=20
>  > =20
>  > 2) "Btrfs" command=20
>  >    Mostly for scan=20
>  > Then you could try the following commands under busybox environment:=
=20
>  > # btrfs device scan=20
>  > # mount <device> <some temporary mount point>=20
>=20
> "btrfs dev scan" runs but doesn't indicate recognizing any; since raid1=
 conversion, ext drives are required for any btrfs mounts to be seen whol=
e.
> When manually trying to mount in busybox, it gives a similar error abou=
t missing external device by UUID_SUB

Then it's still something wrong about the initramfs.

=46rom your description, it looks pretty like the lack of external disk
driver is the root cause.

Could you try "btrfs fi show" to see which devices is missing?
I strongly suspect it's the external device, if so, then it is the
mkinitramfs driver causing the problem.

>=20
>  > If it works, it may mean you're missing "btrfs device scan" during b=
oot=20
>  > so kernel can't see all RAID1 disks for btrfs and failed to boot.=20
>  > =20
>  > Please refer to your distribution initramfs creation tool to see how=
 to=20
>  > add that scan. (Some distro has special hook for btrfs to handle suc=
h case).=20
>=20
> may have to tweak the /etc/initramfs-tools/initramfs.conf or modules li=
st; MODULES=3Ddep setting might act better than MODULES=3Dmost
> will look into this further to see about contrasting block device modul=
es between cindy and the others

Sorry I can't help much in this case, as I'm not debian user.

But in Archlinux, it's pretty easy by just adding a 'block' hook.
And in that case, Archlinux will install all kernel modules under
'drivers/usb/storage' directory.

For details, you could refer to this file:
https://git.archlinux.org/mkinitcpio.git/tree/install/block

Thanks,
Qu

>=20
> appreciate the timely response-
> TP
>=20


--FAp9JmNvo7kmYHXGKXftWdKvcGdOcN2xc--

--Wv7OrSP9Um2mixfIQr2sMgRlxXPeubmSX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvIMVgACgkQwj2R86El
/qiIBQgAjBVjKzDu7yHAiduunofMqa49PF2LwzgYKOdBp9fc+UGgo9yz6XPyYvs/
op4Te6CrlaUrsO5/N7stzG7Q0FLqRISvUFeG1tB8SXFye9S0INaQHdEhNEMHlBXG
NHK+Y37jYCkKbdSs2xQcCEhjuIm7t3ynhFek49ALESveuEiW3p68zpKIqjrxgFjL
QI4kakByG+nVHvDURT70rWGM+q3bjtR4buzVG2AFSw+ZORupL0aheSe+qSFRcx0r
SDlIFatc2we83S/JRltVxpNHdsUrzZSrZR5ahe5BdplM4E1ZRMU7+z+VOszcYpZO
3EYLadljUxuAj/dZNUl+L7L5JsODwQ==
=ZYLO
-----END PGP SIGNATURE-----

--Wv7OrSP9Um2mixfIQr2sMgRlxXPeubmSX--
