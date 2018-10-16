Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40163C04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 14:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E68E6205C9
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 14:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E68E6205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbeJPWI3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 18:08:29 -0400
Received: from mout.gmx.net ([212.227.15.19]:57025 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbeJPWI3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 18:08:29 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LqhmM-1fi16J32Ze-00eKiL; Tue, 16
 Oct 2018 16:17:46 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LqhmM-1fi16J32Ze-00eKiL; Tue, 16
 Oct 2018 16:17:46 +0200
Subject: Re: btrfs check: Superblock bytenr is larger than device size
To:     Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
References: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
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
Message-ID: <9154342a-fd07-b7d7-1cec-791d21418f98@gmx.com>
Date:   Tue, 16 Oct 2018 22:17:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WL6oeSRwRsQFJBT3dqIa3GS2FJL7YqP0C"
X-Provags-ID: V03:K1:lvEBhb6AqjuDH4TKIefd/PtCmvsETEArLwv8fRcDupw4tEO6GQO
 3gXk18TAbEjFVQ6LF67n5YFPChs7B/LgVjRxBZf+6vExqgmr6KQoru4WVqVGTp13769VUZ5
 7kaH/xg/uHTwDaAzJ7yRVD3HWD57+eyhxms+wJutMCQR2buASTvIc3q+PeeqmcyqYPcUnYj
 QYwYdQquBwSVDVc59fG2g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:/UYcrqQoneE=:HjG92ez9VwfTWt7m1DZAWG
 5svNnlxie4kMbep0cP7S6ScSHhuAG4ALGhp90+tN1WEYhCUyxcI8yaJxODf+YTPvL+nH+snhe
 JJsZIv8Ha46kmezJiYJn4h4aHcqRSUclY042vc7RiwZSvJ38y+HWwuzfY32XfBf1h4wUUWldW
 qUgQ2qMH30/80wDNGStXJpD0YzWGBC4lEI5SaCo4dMxn/UFMe5EGI7jRSHh6GuA9Kt2OrxB/r
 b8UBkognwFEgLQHOC1RiNLBtU2syC11qPabpdF0DQ/IvNjI0tpZ4lkXU8kKBmKzjIJfeqcGNj
 8WRrCT8poLe92mLBu6kg4WoNuCaa4jV0w9fciLM8r4EqPZ2me0pbR3ffwTYVXaP+PFq1voxSW
 yeOZrqJWuUaX9VfUPbsGNZXnP0qZo3BJPq/QgDSp4p5vf7fuCmhjGJzgIoCYy8SOzo+4YinJz
 ha8YIZe4maM39yjOMBQfFQ7QlQQJw/t1bw9XlDCXPk9UHoN4sYiQ84NyvIpSQ262eonR8357Y
 46/yH6uTU5qmerUrVJB8GGAUY+EtSyFUK5/PS0Mn3OLArOdI5TtLhgqqeCeykD1HI0Lb9AAYv
 qeZ3dlanFi2YvjAY4Kzlz6rVC5ZT6+P6hAX9udCh2pOR4ucYj/HAlThp8HjIIROSU2z3bHWmP
 9pQDmow++hy6bySTZS2LJfaXWB/S//npfh8W5oJr7WI7BPpTfZCpXDjXYtVhLFU7ZEqtEaQVe
 26IhmVuSYzD1/sgSLpOEcREf3zgGAnXHWr2xgRgx4uh1+2KSPeh+UamF/iM/6E6bpKAn175JU
 N+UDTzS3wst4yazx5/G2aM7xkF29Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WL6oeSRwRsQFJBT3dqIa3GS2FJL7YqP0C
Content-Type: multipart/mixed; boundary="2nq8TdzqquzHXeLyzXnBeuEin3nk9wnCY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <9154342a-fd07-b7d7-1cec-791d21418f98@gmx.com>
Subject: Re: btrfs check: Superblock bytenr is larger than device size
References: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
In-Reply-To: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>

--2nq8TdzqquzHXeLyzXnBeuEin3nk9wnCY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/16 =E4=B8=8B=E5=8D=8810:05, Anton Shepelev wrote:
> Hello, all
>=20
> On all our servers with BTRFS, which are otherwise working
> normally, `btrfs check /' complains that

Btrfs check shouldn't continue on mount point.

Latest one would report error like:

  Opening filesystem to check...
  ERROR: not a regular file or block device: /mnt/btrfs
  ERROR: cannot open file system


>=20
>    Superblock bytenr is larger than device size

This shouldn't be a big problem, normally related to unaligned numbers,
and older kernel/btrfs-progs.

Please try latest btrfs-progs and see if btrfs check reports any error.

>    Couldn't open file system
>=20
> Since am not using any "dangerous" options and want merely
> to analyse the system for errors without any modifications,
> I don't think I must unount my FS, which in my case would
> mean booting from a live CD.  What may be causeing this
> error?

Normally old mkfs or old kernel.

Latest btrfs check result would definitely help to solve the problem.
And the follow result will also help (can be dumpded even with fs
mounted, also needs latest btrfs-progs):

  # btrfs ins dump-super -FfA <device>
  # btrfs ins dump-tree -t chunk <device>

Thanks,
Qu

>=20


--2nq8TdzqquzHXeLyzXnBeuEin3nk9wnCY--

--WL6oeSRwRsQFJBT3dqIa3GS2FJL7YqP0C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvF8wUACgkQwj2R86El
/qgEYgf/TDOHGOzWIaJXEF+ZoOU5BcHoTC3cPzK2S/eTOLpFv8zo8vIyNSbw/go6
B5SwQdtP/G4nutzARX5qgO9752Fco1ScQtjsydHiM2vflLiFMqJQgPqSoHVo+4tm
GZ1Y0aYoyBxRLJvI1o2GzNwJXnoXWNhqgJeuECjpRZHecp/cjdN5/MhkXfX3mm+q
/fspwk3EXEp9qSrwB/lwVPJe4Kc5uZoSCmmcOQ1UOfwJ1a7Z3wD9gNf1NNg2RDJ9
MRW1bnwn1tSPlUOal0VE3lbmfMfbShNy3d4pX4RtAmpBILCP0+3GfB3Pj4DzVi6C
r+HivP+CL4+jSt6vnwyDRx46f2Sf3Q==
=I4Xm
-----END PGP SIGNATURE-----

--WL6oeSRwRsQFJBT3dqIa3GS2FJL7YqP0C--
