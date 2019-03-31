Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5A8C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C5820882
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:43:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="VCOdGyLB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbfCaOnH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 10:43:07 -0400
Received: from mout.gmx.net ([212.227.15.19]:55621 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731130AbfCaOnH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 10:43:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554043383;
        bh=5dNjuA1fX8CfKrGTm7wkjZ141DJ/6m7QlpWtX4A/YdY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=VCOdGyLBImqNxT8l226xH98GD6bSAyDFSvRK8OlKf6AjPZ8hADIAS9E1fjl+qci8t
         +V5DOylTq52szNU0gQ8zQeCMhWiGykhfBGbWm3MO0fCemecIxFe459niDz7FpMiyPz
         ek0l5JAzsSMRiYAM95WRT+hIVsYsaIur/S3DuPE0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LxgHz-1grS7K3Dn1-017E1b; Sun, 31
 Mar 2019 16:43:02 +0200
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
To:     Qu Wenruo <wqu@suse.de>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
 <cd66b736-dc8f-dbc4-5253-68117920b8ec@suse.de>
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
Message-ID: <b4f5c3f5-3f8b-08b2-5552-e7f9b6b670e7@gmx.com>
Date:   Sun, 31 Mar 2019 22:42:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <cd66b736-dc8f-dbc4-5253-68117920b8ec@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3UEwajR1NGEM87OScRj2ohkivtRaYehTB"
X-Provags-ID: V03:K1:9huzjs0DCA0U5v0Kiu46PjM1bt+G52u7BelOQvwKoi45NN19XTa
 XLaw7iLojavb5ZUsqOGYMdnk3LYyduEHb4RpoX4x2ql6Fzfu+3nyE0m/zdU0Rp3xZZh14ew
 KOUi8hTGSrh20w8i8mbDoAjdSGhNChR6RZdk8ID2aEWGdCjCfcVnxJj85IWhfruf5+l9INa
 3G9BtqKqn6n2lUVeow+cw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:g+r/XufgFPA=:cW2LmmFyrDx5bDxEXhlohT
 y2OCV/2K19JGQ6fBkvjroS0O9RQ9yl8JT8brwmfqBMtDcuZF5HBNxC3qpXHUP9mU51SUQ19uB
 V1litGb107uKQcv4oDP0/hFpbPzQ+ZTLU+PrmSFIwO8xbgZnjJTc7u/nEI7Mvv8zEa+GaSRev
 xeprlsg4dQ6nlIAcv3DwJi6f185jX6h2PI1V8MMDx8YHkOtrxtWF3wAOwYbPikdZbby35XE73
 mN9k2nE93XdXR4vec5KEtLHgzKdRx834qTgKzUM1j/SLADpT78A1Tfug5SI1hi2Aqd6yX9gYG
 cal5hHsuzGUYpV+ltMtQC8assA1DxLSHmLGqb/l0hwxK42pu+QlacYzFcsM8/Y1zsUnkDpr6T
 WhS6Ru/HyQV5AdqIl4PBUbqtDgCHxR/oMUwP1sihSBQc7dJU+rPW3vRQm4/egGm5h5OHTkBK2
 KghlUy4w+gSSrvjwjg4183rNOWMx2EhVP92YVHeKWABwYpgUGEhKBrEARm99aY+6BgcFjTv2s
 HEbVDZ2PmqUJh0LpgFlN/UfIcd98otnjfzBM17w+aTjH9TJi+c5FAs7qqmCzurJH2uJTYZxBt
 QN6SHwLNP5+IkVnOv6yBPci24iAx+Tn6m1epGZApO9ekIBVD6uzCVbZBgAS0S/d/smvye/SFY
 6Mw/N26FxXfoxVclX1hY1Mr+QALvw2RdA+Dxz1hLmUKB1TRA6lLVqtLFXp1VXAELr7N0YigqL
 6aP9501QtX4xA2XBNz8Q7o11poWcipjjd0S56QDaWpt4lez57UkpHZJbAj2Tr9cGrrRc7xjWE
 XLXNqmvGXw760HIGrglHuoFWNsDGDrCGxTbl3z0K7TvG3JqBz8VXUuISlFcI+P0dwIkwWuywv
 yMIjtdi66NfCs4fR7cWzqVUcNLNi6ar91K6xbI0CEbAQIybP8Fs4qIZpbBEW5o
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3UEwajR1NGEM87OScRj2ohkivtRaYehTB
Content-Type: multipart/mixed; boundary="W9WkicAmphxCc4gixOphAExKYo8LvSDIX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.de>, Adam Borowski <kilobyte@angband.pl>,
 David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <b4f5c3f5-3f8b-08b2-5552-e7f9b6b670e7@gmx.com>
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
 <cd66b736-dc8f-dbc4-5253-68117920b8ec@suse.de>
In-Reply-To: <cd66b736-dc8f-dbc4-5253-68117920b8ec@suse.de>

--W9WkicAmphxCc4gixOphAExKYo8LvSDIX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Not so gentle ping.

IMHO this fix itself should be worthy a minor release.

Thanks,
Qu

On 2019/3/27 =E4=B8=8B=E5=8D=8810:48, Qu Wenruo wrote:
>=20
>=20
> On 2019/3/27 =E4=B8=8B=E5=8D=8810:07, Adam Borowski wrote:
>> On Wed, Mar 27, 2019 at 05:46:50PM +0800, Qu Wenruo wrote:
>>> This urgent patchset can be fetched from github:
>>> https://github.com/adam900710/btrfs-progs/tree/flush_super
>>> Which is based on v4.20.2.
>>>
>>> Before this patch, btrfs-progs writes to the fs has no barrier at all=
=2E
>>> All metadata and superblock are just buffered write, no barrier betwe=
en
>>> super blocks and metadata writes at all.
>>>
>>> No wonder why even clear space cache can cause serious transid
>>> corruption to the originally good fs.
>>>
>>> Please merge this fix as soon as possible as I really don't want to s=
ee
>>> btrfs-progs corrupting any fs any more.
>>
>> How often does this happen in practice?  I'm slightly incredulous abou=
t
>> btrfs-progs crashing often.   Especially that pwrite() is buffered on =
the
>> kernel side, so we'd need a _kernel_ crash (usually a power loss) to b=
reak
>> consistency.  Obviously, a potential data loss bug is always something=
 that
>> needs fixing, I'm just wondering about severity.
>=20
> Here is a valid case where a crash could cause transid error:
>=20
> - transaction 1
>   new em at 16K (fs root, gen =3D 1)
>   new em at 32K (extent root, gen =3D 1)
>   new em at 48K (tree root, gen =3D 1)
>   sb->fs root =3D gen 1
>   sb->extent root =3D gen 1
>   sb->tree root =3D gen 1
>=20
> - transaction 2
>   new em at 64K (extent root, gen =3D 2)
>   new em at 80K (tree root, gen =3D 2)
>   sb->fs root =3D gen 1 at 16K
>   sb->extent root =3D gen 2
>   sb->tree root =3D gen 2
>=20
> - transaction 3, half backed due to error commit transaction
>   new eb at 16K (tree root, gen =3D 3) submitted
>=20
> In above case, we will write the newest eb at 16K to disk, but with sb
> from transaction 2.
>=20
> Then sb expects to read out a tree with gen 1, but get a tree with gen =
3.
> Further more, even we ignore the generation mismatch, the content of em=

> 16K is completely wrong, super block of gen 2 expects fs root content
> from em at 16K, but its content is tree root.
>=20
> This should explain the severity much better.
>=20
> Thanks,
> Qu
>=20
>>
>> Or do I understand this wrong?
>>
>> Asking because Dimitri John Ledkov stepped down as Debian's maintainer=
 of
>> this package, and I'm taking up the mantle (with Nicholas D Steeves be=
ing
>> around) -- modulo any updates other than important bug fixes being on =
hold
>> because of Debian's freeze.  Thus, I wonder if this is important enoug=
h to
>> ask for a freeze exception.
>>
>>
>> Meow!
>>
>=20


--W9WkicAmphxCc4gixOphAExKYo8LvSDIX--

--3UEwajR1NGEM87OScRj2ohkivtRaYehTB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyg0e4ACgkQwj2R86El
/qgBqQf/QFTjV6HbLrW+uUSlw4QnlKZ5yn8Sycp0eKiEyC+4cie6NaNUUARi6OIb
/InJfg29gq01pt5zjI/jV172KAG6Cjtb9iyyK6MumJbODrKaDGiFBEhpyWXsF3/v
vCiQsCHPkjx01RFQYAYAnsQ063akiYrFMQvNjtdtKhj/OY2A8njCTuANO20FQowq
7xHhPbf3oEY2xSPK6vjx5+sTdA8toWhsw/xhrauEHFrLtXjdLmu1jIQU5dfsKz36
59QLWjVFLJoPQvvEoG8wPYV5AGylOrxcym7enNVYHNo92FyO/pBDJo6a+jdTjF/j
rZB+OJBEc/DiS/fi2YHPI9gaQDCU0Q==
=6EvQ
-----END PGP SIGNATURE-----

--3UEwajR1NGEM87OScRj2ohkivtRaYehTB--
