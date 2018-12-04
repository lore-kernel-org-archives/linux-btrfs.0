Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41AFC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7202020878
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7202020878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbeLDKSm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:18:42 -0500
Received: from mout.gmx.net ([212.227.17.21]:53541 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbeLDKSm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 05:18:42 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LmrZY-1h8wm90ank-00h3Ph; Tue, 04
 Dec 2018 11:18:38 +0100
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
To:     Mike Javorski <mike.javorski@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
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
Message-ID: <35c0af18-35ea-fd2a-5388-c6ee4ce9f434@gmx.com>
Date:   Tue, 4 Dec 2018 18:18:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rMVRivf1tLpn7KquYSUS8FzXcaTIbdrAd"
X-Provags-ID: V03:K1:stmrHm1s9A4a4s156Ym0Bbo9qHaBQZsnFvtQzzfVppBfCR8yAxI
 wwnPU9HeVnzTQKPUAxv+VnQfwsEv7CqCBNz2o+W4XIkaHo3mJrdGaSbbiwKJbckoi1QeUNZ
 cUMT3cu/uv2XkXVtsOFncx8sh+ZrNy/LwkQx96GrgA9BPYme945uR5y6S5RXCF6o1umzDzb
 TaibIZzbVzroWUKvUVd2w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:j6jf4XpZo7k=:VnyCKPU2ojeeOzoFKktZFN
 K2bOo8svymetagUBnhECz6cMJPczIJPKh+SD4lSZ07+c5HhJ95gSrHE7nPF+7/LoVUJTNRtTY
 AsusRe8tcYFbArDKM4drsTJrCtFlnQEwzNV3jgPcnP6uRKOUhiNkoUCH5Ggkuob5XZTUC6MQ1
 9YbsFnSj4WfKvAlG2+pC5hF4k3VObhP3bumDWBO85lYJyRTxbgcX+Jrqh/wzJpft80XKt9ny3
 0EmbKtQ30NP68oRFu1Ey24028lFUN0DWKlMdeGDAi5GfbtFlrckWaRHgeQc8fQJb7JdwJsUuf
 fhximriw2h1L30H4x43PVdt9IQTN/n6ut8KoClnlNSoD9uzpAtL39K3rdsgiMB55Co5MA62wo
 lLdAMsirPeogQb/+ToAT/GwXhQNgerrCZfTPl+kV4d1mkfSa0n0LTUM9ZQVXlLVMYa6Qn8I5c
 MU01o0U/ZPNT5oBiksjVZRAaIxejMXyJTemZkZ5bE6TO1oJM+cfuk9QhupCORlWsCt0vdwS2Z
 EOEw/XUteIqKeC9i0Y6jDIyHYHSYL/RKge2tNTJ65rfnenGPaYJQkRe7haTQZd1aJ5LBSch2d
 I8Is4ikP0fGarnjvkZbuqn3+ofxnzpmzBwm1VvdoETnyDKm43fs43uWDygMMEmBUNbs3dn6hm
 h1GDfQOBa7pXnWvhm/Im9Ok/rILVHlq9OJ1eMFj8QZ6nJK3gJzVVFgInP8G5TzlsyEzeyItEt
 iXbm4baohPkRms8ctkgngf/6ah/pf4mu05cb14jYor9yp3Wr8aCywj47Z2EMI4Nig6XpqECjD
 oy6qKa6bNSaAii4fDmMouMP4aRmPD+FHGfL37XG0rqD5QXPI26SLonjM6wzqy1HbS1b2zczYe
 dTlrpCNyKySZP5VqF9T3cPBlS9J/xmjoqt/Dhc6rFkbfVNPpRUmrchodA0SphU
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rMVRivf1tLpn7KquYSUS8FzXcaTIbdrAd
Content-Type: multipart/mixed; boundary="2N8dXxl4nsO8bv1RCG0ap4vdrUFFbkr36";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mike Javorski <mike.javorski@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <35c0af18-35ea-fd2a-5388-c6ee4ce9f434@gmx.com>
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
In-Reply-To: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>

--2N8dXxl4nsO8bv1RCG0ap4vdrUFFbkr36
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/4 =E4=B8=8A=E5=8D=8811:32, Mike Javorski wrote:
> Need a bit of advice here ladies / gents. I am running into an issue
> which Qu Wenruo seems to have posted a patch for several weeks ago
> (see https://patchwork.kernel.org/patch/10694997/).
>=20
> Here is the relevant dmesg output which led me to Qu's patch.
> ----
> [   10.032475] BTRFS critical (device sdb): corrupt leaf: root=3D2
> block=3D24655027060736 slot=3D20 bg_start=3D13188988928 bg_len=3D108045=
27104,
> invalid block group size, have 10804527104 expect (0, 10737418240]
> [   10.032493] BTRFS error (device sdb): failed to read block groups: -=
5
> [   10.053365] BTRFS error (device sdb): open_ctree failed
> ----

Exactly the same symptom.

>=20
> This server has a 16 disk btrfs filesystem (RAID6) which I boot
> periodically to btrfs-send snapshots to. This machine is running
> ArchLinux and I had just updated  to their latest 4.19.4 kernel
> package (from 4.18.10 which was working fine). I've tried updating to
> the 4.19.6 kernel that is in testing, but that doesn't seem to resolve
> the issue. From what I can see on kernel.org, the patch above is not
> pushed to stable or to Linus' tree.
>=20
> At this point the question is what to do. Is my FS toast?

If there is no other problem at all, your fs is just fine.
It's my original patch too sensitive (the excuse for not checking chunk
allocator carefully enough).

But since you have the down time, it's never a bad idea to run a btrfs
check --readonly to see if your fs is really OK.

> Could I
> revert to the 4.18.10 kernel and boot safely?

If your btrfs check --readonly doesn't report any problem, then you're
completely fine to do so.
Although I still recommend to go RAID10 other than RAID5/6.

Thanks,
Qu

> I don't know if the 4.19
> boot process may have flipped some bits which would make reverting
> problematic.
>=20
> Thanks much,
>=20
> - mike
>=20


--2N8dXxl4nsO8bv1RCG0ap4vdrUFFbkr36--

--rMVRivf1tLpn7KquYSUS8FzXcaTIbdrAd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwGVHkACgkQwj2R86El
/qjAvwf+Jo6K/Unb0h7MoXGCehJDJLVIrWBwg5ypf6+NfvY+P5KLjeEks052aYGl
m0/Kx2/AG8Sy8FYtkeSgvMfWppRYB1GRpIjabtrA5pnGFWvwLsbGrjZ3aNvcpWXj
arDhC+6ZCU5UvtgC2mHTxB7Yt6myCZnJ1wwsLPrwyL4iKUwa66tWzUvFeWnELXeW
B7JPQV4OcvnHeWSmyf0gL+DBFYlsRp9qF24ksNJmUTvBqyFglznsJPyf0fmPtFqB
ot7SfPP3NKU8MX83bfWrc7mTXGpyqYwpJMZBv6NiHg2pf04sMzPTfzcRh3dBeABS
PFFeykWA2lAGnNNBD/08fb29wBLTzA==
=qfnS
-----END PGP SIGNATURE-----

--rMVRivf1tLpn7KquYSUS8FzXcaTIbdrAd--
