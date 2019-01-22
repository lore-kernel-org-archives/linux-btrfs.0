Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106D5C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 23:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D24FF217D6
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 23:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfAVXq3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 18:46:29 -0500
Received: from mout.gmx.net ([212.227.15.18]:52239 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbfAVXq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 18:46:28 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LcBin-1hSXup19Mr-00jXNK; Wed, 23
 Jan 2019 00:46:27 +0100
Subject: Re: Do btrfs provide filesystem debugger?
To:     Matthew Friday <lkmfriday@gmail.com>, linux-btrfs@vger.kernel.org
References: <CANmnzbMpBsE5dcmc9_mHOTB9tUY7enWxicRCbmTwpZ2HuDOhaw@mail.gmail.com>
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
Message-ID: <94fb82b7-1395-7fad-5d95-87a9d96927f8@gmx.com>
Date:   Wed, 23 Jan 2019 07:46:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CANmnzbMpBsE5dcmc9_mHOTB9tUY7enWxicRCbmTwpZ2HuDOhaw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uAtAelTMd14qXqZtoEyXwd3np1zYvGd31"
X-Provags-ID: V03:K1:nKP45VBrUn6AEXcifNAWBbUIoAhMIAsXw96RYmd/E5zIIT6FSy2
 rYraFLNT+pZLTMoW+MIE/CANUAjC9XZRLDpwRHlR89lG5DEnourAoWbFKhI3l4OS5B4fBra
 r3bg+hJxbDmSYR1yx3Va6ZEhUZWKPtQ0dC0/jgsKjFc9n8NEEMO5hDLWoQntjkAVRqKIcwn
 r6GDCxxB9G+uAo0PDaGdg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vACLZFLLFy8=:CnlOH2bEEzfbw+KqNnlxbY
 uITXvKK5ppABdGAWbI7an3gsLxOUy5Q5mynmFMMq9XjBdhCULJBGQytX/fBwy2tFNLqxSK0Gd
 Qb8oT4RL87kmqMhWSPF+/ffqS+vqUdGuY9B7GB4U9G9tZJJWVUZyL3by79CXo3fmQudOZ8X34
 PHP7d7uZCyn+7Qv1DEF4b/Aq9sqK1JlLpVosN+FMLI0yxxcn6yWWWC9e924/PMkRiC5gb1fRJ
 ZgX7LqMwWCjP2cfnJAagowpMiHCcqAy0WvBIFwJcdPq1hw9rKineQQw6qbEVxbBSxwAaUiPYe
 JkDSSF0EZcqk9NHLRMOpuxq7OmC0mN8Z3oJB5kwK1t31Wk9rSVl8ny0rstPUWxvl+feyMXRxD
 tPmJDwUqh0VNRno9GmJTk7GHKkEp7fN1Cyui9Ngur0EUXt2UCGgItqTDWa1j339sK26xa75l8
 90vZZGeXY8eVL5NuSBLyMVpzQbBjCc7o04RHe/3v1kWX9r0gBDZ8cC/dw5HcMxIwp6+yu9JJj
 u47Dwvvoi9Gs7eaS2BJENl/IPYpcOfq/Es8QfJGQQxRKNpSkLSAloMzubkgpq4ml6pW1ykpuV
 snGF9z0FvUH0bOSG8oreMRD+Z2q5P4vWnBgeltenPgWBChLEkgGrkA+f5yosUCu5tZ0XoR+63
 C43O4cSVAd09zu3jeSZroQCCvdTAutsrpB1qvCUyE+5+Njf/sAIA33A9hElLYataL0GkYZfQ8
 nGc2NqoQaTGqR+Qng2bDcGyS3vB+t8qeRP5mI0SlEQ+9O+CSYvn/+wZpmqxWBVuRt4etk0EqD
 nKtDTNaI629FXpsD3rgUFSV1D7EcZAJCBUhVKV0R4W2e47R8FtWDuiUKeivzkgqDH1LnxOeWN
 Y10cLFklrXRoMAYL7FmWs1FxmddZiRhoCZAJ2GU+YtIFXLm+xhZ5fUKRMX3q/Y
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uAtAelTMd14qXqZtoEyXwd3np1zYvGd31
Content-Type: multipart/mixed; boundary="knwK0fpFMYb4pyYhRC4OeUESpRfRmGdb2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Matthew Friday <lkmfriday@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <94fb82b7-1395-7fad-5d95-87a9d96927f8@gmx.com>
Subject: Re: Do btrfs provide filesystem debugger?
References: <CANmnzbMpBsE5dcmc9_mHOTB9tUY7enWxicRCbmTwpZ2HuDOhaw@mail.gmail.com>
In-Reply-To: <CANmnzbMpBsE5dcmc9_mHOTB9tUY7enWxicRCbmTwpZ2HuDOhaw@mail.gmail.com>

--knwK0fpFMYb4pyYhRC4OeUESpRfRmGdb2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/23 =E4=B8=8A=E5=8D=887:41, Matthew Friday wrote:
> Hi all,
>=20
> I recently started learning BTRFS internals, and one think that I
> cannot find is filesystem debugger to browse on disk data structures
> (like xfs_db or ext debugfs).

You need "btrfs inspect dump-tree" and "btrfs inspect dump-super"

> Do BTRFS provide similar way to navigate on disk structures? I can see
> the btrfs-debug-tree utility which provide whole tree of the
> informations, is this something that can be then perhaps parsed in
> easy way to view the internal structures?

It's already all the internal structures.

Unlike other fs, btrfs uses a generic way to organize all its info, as
btrfs btree.

So dump tree provides everything you need, from inode and dentry info to
all internal data like allocation and csum data.

Thanks,
Qu

>=20
> Many Thanks
> Matt
>=20


--knwK0fpFMYb4pyYhRC4OeUESpRfRmGdb2--

--uAtAelTMd14qXqZtoEyXwd3np1zYvGd31
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxHq08ACgkQwj2R86El
/qhlvAf/e9r7Flggx8Snl3/jO3uFOH9sSL7KLGP/8Uu8AEpdE9R2LaP+ex0QOQrv
c3hbgrINwXJ7TN/m+LslfsYjJCcFtT588+DHyTauh/HYZsEGk3wjIaLJWreUG74a
sRZ5L7r/CrwqiCmha1CQhD90EZn3m/Y4GWb3IjjDH2il7hbp5vjFEDQEuHT5p+1v
uYUQ38ZRIONRdG5vZqObk/w6voqbWXYGqQaCU51uCyhEDCX2x5PC95/rbe11uG1x
O6SyGIYEDCGMplBiJ9BVoFEvP/AM6ffia0ToNSLoxvLFfyGVSvwx/mzxaM+L/4ed
v5kdeIUyOhs4nQAkuWpnlsIIAkI/0w==
=psnS
-----END PGP SIGNATURE-----

--uAtAelTMd14qXqZtoEyXwd3np1zYvGd31--
