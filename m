Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0ABC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 23:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D452520645
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 23:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D452520645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbeJWHdf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 03:33:35 -0400
Received: from mout.gmx.net ([212.227.17.20]:50181 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeJWHdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 03:33:35 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MgYGJ-1g04ll4Bst-00O2Cy; Tue, 23
 Oct 2018 01:12:56 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MgYGJ-1g04ll4Bst-00O2Cy; Tue, 23
 Oct 2018 01:12:56 +0200
Subject: Re: Filesystem corruption?
To:     "Gervais, Francois" <FGervais@distech-controls.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>
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
Message-ID: <4b6ca03c-ed85-5719-1d0f-fc6957e8ad4c@gmx.com>
Date:   Tue, 23 Oct 2018 07:12:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mZ168aMzn6jX3LqLOY77gNEK1HhTRhNJs"
X-Provags-ID: V03:K1:qAIk+SPhfZMl4Xb7GL8TVOR8hlp4qcKF+xL5+CfvMpcymN8CSx4
 r29dH6gYFS4AIlgxxR/bAR8FeMX/OEF/QaNfHOwuXSHpVcR6nFnR5Gm906t+0mNwrVjAUIT
 T4WqYnlkt1WpCRfLuZOdvSUqx0UcrBe7m6dj2vYToHf+JzrTLoJ+0ptI+vVA65N0DB4lmoU
 GCAIxgWc2v/BBw3jaS1gg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:ZsKukg3rNb0=:WYR+6S+ZJEvULUNbdEZTRZ
 1gWpEJISLSD9fnesGQ6RpyICYpnUyM9HlBtSe9wlMSJ648OJd8KAXY1gYSLAe/fpvLJ48ntn3
 S5AvKgURTiYjiU+voNzh0E4REvWX8nb8rS7If/9Qi70yFTDjhAZcBmUbkVTVsBu5yspE8XLxN
 zQdJDD35UOlQl1D0mJJgtCjkpjv2tlQG3xwJLeY78bbjr4lE1XQUZ1P16wLdAGT0P94c67V/p
 AeXTKC54Hfh6UlapHU3COrqCUxTwSiY8fK8Of9BnE42PNUJEyM4tBmWHLj23FusWsjBPMN1g7
 cbNz2OR1DErGvC7fuqoGU16FrEeN0Kv2BvCMbrlGnuP5ASWzetLpVZzAh0pDweJtYSQyN7uWW
 QkhBjin9pcPQdKZZLqu/SyB3E+nNCi4lyJeP7YLKzJElw4mTEbexGKApAyJeAG6g2zFf7KN0n
 0lpD+PdgWTtajw4bTFVVqVWwFB3eYpxtgXsxt8NJrgPhqI9+QZ6y6r1WA7VoBDibc2HLImxqE
 W4YtGwu0j3Kpna+WKCeBZW67XupKx1aolBPnnu/URblB42ixBcRAsEmztToGL/5pGcLSc7SKg
 tlLdFaWiWsb1sMHKTv55/VdtCUnj/ur6Bs0ojMRMPAJeUTtAWfNR95++4l1zYF4vL9hRuEjZP
 VB6V6rV91NUtK29PxHB8DGyhWDyLbboMcdIYLUuWgQitqtWKuke+4gWpDOMy8Rkv6LDHgILB9
 ztrwwxoVsijICs158ruLdlkEDI/2Gd4jdpDg09YLLw6k4NvcMPbN27XceBm6mbunFLHyotI1p
 9WYsrdPO0c5dqTbo5fhZnK455abdw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mZ168aMzn6jX3LqLOY77gNEK1HhTRhNJs
Content-Type: multipart/mixed; boundary="FemfPe40HXhWBfQ7v83YXGBNElhHQITot";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Gervais, Francois" <FGervais@distech-controls.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <4b6ca03c-ed85-5719-1d0f-fc6957e8ad4c@gmx.com>
Subject: Re: Filesystem corruption?
References: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>
In-Reply-To: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>

--FemfPe40HXhWBfQ7v83YXGBNElhHQITot
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/23 =E4=B8=8A=E5=8D=884:02, Gervais, Francois wrote:
> Hi,
>=20
> I think I lost power on my btrfs disk and it looks like it is now in an=
 unfunctional state.

What does the word "unfunctional" mean?

Unable to mount? Or what else?

>=20
> Any idea how I could debug that issue?
>=20
> Here is what I have:
>=20
> kernel 4.4.0-119-generic

The kernel is somewhat old now.

> btrfs-progs v4.4

The progs is definitely too old.

It's highly recommended to use the latest btrfs-progs for its better
"btrfs check" code.

>=20
>=20
>=20
> sudo btrfs check /dev/sdd
> Checking filesystem on /dev/sdd
> UUID: 9a14b7a1-672c-44da-b49a-1f6566db3e44
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs

So no error reported from all these essential trees.
Unless there is some bug in btrfs-progs 4.4, your fs should be mostly OK.=


> checking quota groups
> Ignoring qgroup relation key 310
[snip]
> Ignoring qgroup relation key 71776119061217590

Just a lot of qgroup relation key problems.
Not a big problem, especially considering you're using older kernel
without proper qgroup fixes.

Just in case, please run "btrfs check" with latest btrfs-progs (v4.17.1)
to see if it reports extra error.

Despite that, if the fs can be mounted RW, mount it then execute "btrfs
quota disable <mnt>" should disable quota and solves the problem.

Thanks,
Qu

> found 29301522460 bytes used err is 0
> total csum bytes: 27525424
> total tree bytes: 541573120
> total fs tree bytes: 494223360
> total extent tree bytes: 16908288
> btree space waste bytes: 85047903
> file data blocks allocated: 273892241408
>  referenced 44667650048
> extent buffer leak: start 29360128 len 16384
> extent buffer leak: start 740524032 len 16384
> extent buffer leak: start 446840832 len 16384
> extent buffer leak: start 142819328 len 16384
> extent buffer leak: start 143179776 len 16384
> extent buffer leak: start 184107008 len 16384
> extent buffer leak: start 190513152 len 16384
> extent buffer leak: start 190939136 len 16384
> extent buffer leak: start 239943680 len 16384
> extent buffer leak: start 29392896 len 16384
> extent buffer leak: start 295223296 len 16384
> extent buffer leak: start 30556160 len 16384
> extent buffer leak: start 29376512 len 16384
> extent buffer leak: start 29409280 len 16384
> extent buffer leak: start 29491200 len 16384
> extent buffer leak: start 29556736 len 16384
> extent buffer leak: start 29720576 len 16384
> extent buffer leak: start 29884416 len 16384
> extent buffer leak: start 30097408 len 16384
> extent buffer leak: start 30179328 len 16384
> extent buffer leak: start 30228480 len 16384
> extent buffer leak: start 30277632 len 16384
> extent buffer leak: start 30343168 len 16384
> extent buffer leak: start 30392320 len 16384
> extent buffer leak: start 30457856 len 16384
> extent buffer leak: start 30507008 len 16384
> extent buffer leak: start 30572544 len 16384
> extent buffer leak: start 30621696 len 16384
> extent buffer leak: start 30670848 len 16384
> extent buffer leak: start 30720000 len 16384
> extent buffer leak: start 30769152 len 16384
> extent buffer leak: start 30801920 len 16384
> extent buffer leak: start 30867456 len 16384
> extent buffer leak: start 30916608 len 16384
> extent buffer leak: start 102498304 len 16384
> extent buffer leak: start 204488704 len 16384
> extent buffer leak: start 237912064 len 16384
> extent buffer leak: start 328499200 len 16384
> extent buffer leak: start 684539904 len 16384
> extent buffer leak: start 849362944 len 16384
>=20


--FemfPe40HXhWBfQ7v83YXGBNElhHQITot--

--mZ168aMzn6jX3LqLOY77gNEK1HhTRhNJs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvOWXIACgkQwj2R86El
/qgoeQf/TI8+Z0+lma/rUchDEAkhgcoGqLHcwz/fw2tUe5AWP+zErWu+/0pzAYiS
3me0FlH/Q47xDvuLJdiOtSkyCUk52/PwfeEDKvsezXccUF7/4bpPlNTerrcQ1iMD
QbrxT0N+58FiquIlhawUvi4ntRsvmApFMaubEUWOEoruteHWdNUTaA0Tj+tgVYU5
TabOReI+GkPX6YKxOlJ2gR6P/uuDb4DDgK2nXpT3mwWQW62rslTskXZVfgXziXUr
kXBiUxGGQoJPNa9DM+rnz1vmXQmSwEZZrxpBho07wkg7l0QvUcsdw+axRcdTKwNA
PlXpBFlb2tDaPG/RFHi49WETxkLqsA==
=3AM3
-----END PGP SIGNATURE-----

--mZ168aMzn6jX3LqLOY77gNEK1HhTRhNJs--
