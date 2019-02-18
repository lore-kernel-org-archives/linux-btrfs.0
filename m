Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89DAC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 01:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97CC0218D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 01:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfBRBvv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Feb 2019 20:51:51 -0500
Received: from mout.gmx.net ([212.227.15.18]:54581 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbfBRBvv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Feb 2019 20:51:51 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MGjfl-1grTTm2kZF-00DVcs; Mon, 18
 Feb 2019 02:51:48 +0100
Subject: Re: Errors after kernel panic not addressed during scrub or fsck.
To:     nstgc379@gmail.com, linux-btrfs@vger.kernel.org
References: <CAMOGTQm-xnYjetpQ6jzDL6Do4PZQwpHL0W_fGTzcWmW+4Npadg@mail.gmail.com>
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
Message-ID: <02144936-a3f7-3d1a-cdd5-601337c50884@gmx.com>
Date:   Mon, 18 Feb 2019 09:51:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAMOGTQm-xnYjetpQ6jzDL6Do4PZQwpHL0W_fGTzcWmW+4Npadg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gtCbdb0RN3nDir7lNmOnbGN595BvnDcHQ"
X-Provags-ID: V03:K1:RDpp5fsZ86M1UCzzQH6rJO7pkF3nEvRbTSTaPTTLrp1BwXhNlpE
 BFvSu1LWEJCms6MjD+flaAfj6IhOmFbAbsGrHHYnQIaxs5E9SeNSIUB1DGwo9yvGnziX/t5
 XXOjkZlKcM/bf1xfVQgPtXBGcLrDnqCaQzqDMdrSLIuO+vtn2eeqH1PdhPq1OvwfK4Phf7B
 GbE+8y/SvK6YTAbqiMj8g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:efKFSMJiSk0=:WmN0xHxeq72pa204pYlfxf
 g3w0QJX6pmYstSQS+hOSzMB4+aQjVo1LtahFeLwML2T6oKtEWfWDkMb0GK/6yZR9L1cpY8X6h
 MMuZoiCHJAsggvzI38jFATGrNVO0z5OrgOaL0Pm9uo5uzWzikES/HIgqin8fgfMwuO6Zpr90N
 wfk+DKDOfMWvojZLmJmhSOHJd6fLB99LviUJEdtbkA30SLCrUnBDz73yKWjwn5SCtMV5FLVFG
 U+DXwYBIniViPTGG8kJau9/dR/LVSrdRMWwxcvEuR0ieXN4p0dOmKgQj6S/t1C/dF0H3dxAOi
 iojQH33+eR+UMzVRzmn+BcyLa2wXvZeQ2opBZdVnnws0NJAyzFaNMZ1FAtom1m2L+fm2QJpOt
 mFkt3OSgQaRYsfxTdesyZte5R59m2kWrcnOmSEEfAWm2fstqkbZ3qkAMOgEavuoia+XjFbogb
 qVsATXDgr9fmSY9gjYC+U8NYeuDqRdxEFCTz+aZZM1oaaV/DjwgL50cShuydVYroA6D1nuRvz
 fZumco5baro1johazoQibG5b/3EC4SiWY/K6JRHWI1iMZe9dtnBSbGbuJt7U9Kv2arxlL6xZJ
 FMxpkfsoWgRHE5BXiZI7/gbPV8vvzCXYgBFlzn0JIG+EchLNYtwwJjFTy9XDHqLVdFQWkIhjN
 XYt8GeBdht8E4jS5cxdfG/gaMn531k9MQ24Sfifwoym2NlUAV6nqB+NO5kKBlTYmrkwXjmoLW
 pMq3sIr4JBdgO14t5S7ERMbCZr12r5XAkgSrixwGNNKhww+QjX57oS6dwBUd9/WNhPfqCr0md
 rvgprJRLNZhp+uZS6amY79aK9wqIMhZfxW8EbZ0gDJNogRgDeTEPRRnDWuygNllXpZXrzwxr3
 2C6N+c+gnt7d3gEn6xo7G5tV/fcUOytWmZFx6N4o+Mos076jaMWUzQ2LkRAeGu
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gtCbdb0RN3nDir7lNmOnbGN595BvnDcHQ
Content-Type: multipart/mixed; boundary="34TfCPpPFt84vEHGtmCqjyefW3eYtCF1a";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: nstgc379@gmail.com, linux-btrfs@vger.kernel.org
Message-ID: <02144936-a3f7-3d1a-cdd5-601337c50884@gmx.com>
Subject: Re: Errors after kernel panic not addressed during scrub or fsck.
References: <CAMOGTQm-xnYjetpQ6jzDL6Do4PZQwpHL0W_fGTzcWmW+4Npadg@mail.gmail.com>
In-Reply-To: <CAMOGTQm-xnYjetpQ6jzDL6Do4PZQwpHL0W_fGTzcWmW+4Npadg@mail.gmail.com>

--34TfCPpPFt84vEHGtmCqjyefW3eYtCF1a
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/18 =E4=B8=8A=E5=8D=889:33, nstgc379@gmail.com wrote:
> Hello,
>=20
> I have an issue that I first experienced a few years back which was
> never resolved. The timing was really bad so I just scrapped the
> effected volume and made another, but I'd like to actually fix it now.
>=20
> My system went down as the result of what I assume to be a kernel
> panic. After rebooting I ran `dmesg |grep BTRFS` and found two lines
> which concerned me.
>=20
>     [    9.493064] BTRFS info (device sde3): bdev /dev/sde3 errs: wr
> 432, rd 0, flush 4, corrupt 8, gen 3
>     [    3.086233] BTRFS info (device sde1): bdev /dev/sde1 errs: wr
> 5711892, rd 14399372, flush 104, corrupt 467, gen 2

That's from old statistics.
You could reset the statistics by "btrfs status -z" and then check if
the stats increase again.

But considering there are so many read/write errors, I really recommend
to check if there is something wrong with the devices (at least check
the SMART info).

>=20
> I then scrubbed the effected volumes (both RAID1s), but no errors were
> found. I've gotten messages like that before, and scrub normally
> identifies that there are errors and fixes them. I then also tried
> running `btrfs check --readonly` on the devices, but again the test
> showed everything was okay.

"btrfs check" by default only checks metadata, and since you're using
RAID1, it's possible that btrfs check only check the first copy of
metadata if nothing went wrong.

Thanks,
Qu

>=20
> Admittedly everything seems to be working.
>=20
> $ uname -r
> 4.20.7-arch1-1-ARCH
> $ btrfs --version
> btrfs-progs v4.20.1
> I don't have any journal logs as a result of the crash. `dmesg -l err`
> doesn't show anything out of the ordinary (complaints about not using
> ECC memory).
>=20


--34TfCPpPFt84vEHGtmCqjyefW3eYtCF1a--

--gtCbdb0RN3nDir7lNmOnbGN595BvnDcHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxqD7AACgkQwj2R86El
/qgSeQf/elatuf2v5z6oO8zPxZK20kN6RO3EygfzDqOsPw/g897X/lz4CvA4QwqV
RrI/QTwpl2PHsZ/D5pn63KxtYQb9CI8jsiY/72un0tQ67RuC6Vnj8fLCnKzUndIr
uQQUg3Gl3JZMHgs0ZAE9Uws45hy7Uui7eiFjZyrZP7paUdQrZ1nBjWOFqy9SSE0o
RIfWehyLA6oDHRSlWnq+licMiwyu9qoxY7J1KpplifNT3QkIJQxLQHSmh50ukR7i
NQRgVxG7Vzv2mx5AJaAYA5SEQzEwCAGGZKbD6DhoLQfEGOgZifzDxq2lSpTAXLet
/eY1ioou9XqPCwzl5U6yqX+dt1VkYg==
=cHJ4
-----END PGP SIGNATURE-----

--gtCbdb0RN3nDir7lNmOnbGN595BvnDcHQ--
