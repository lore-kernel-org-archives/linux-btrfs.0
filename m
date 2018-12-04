Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A4CC04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 00:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F3720851
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 00:17:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53F3720851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbeLDARI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 19:17:08 -0500
Received: from mout.gmx.net ([212.227.15.18]:59451 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbeLDARH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 19:17:07 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LvlTo-1hYv0S3Zlc-017UEj; Tue, 04
 Dec 2018 01:17:01 +0100
Subject: Re: BTRFS Mount Delay Time Graph
To:     "Wilson, Ellis" <ellisw@panasas.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
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
Message-ID: <e6c1dd8d-b3cf-ff71-bb64-b28bcaa78d14@gmx.com>
Date:   Tue, 4 Dec 2018 08:16:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VUqicgwPZeK64g5ZJIAupwEPkwtBnSyQ7"
X-Provags-ID: V03:K1:CUYrBDzPW250/V3e/mqRh1/dQ8//FswXlHLQ1ASva1E6vvJAOI4
 GyxySh/jjjIPvHwgQ4I/UFb6CfdB+zcI50XmABhnCoTcTKOP05DjJXPYGeAwlyEhayE/HEn
 8YOcDdUt/qoPRpgFXKona9TlM0wC9Z0pW2/Z8wpryyw9IXSRV7R/RcjQeNm7i0ZpxSGs3/v
 T5EQ6yhmlePROr+GaNKhA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CV5W11FsWgI=:tJgH1J9cFJVffieZHjggFc
 3mNk5cwsJ5SAkAm3bD4YIZMwjRtGzBXA+qz4KvohmsREBoOhdtE2SmG0xPGxTFrMkrHbcvLqq
 SQabMcZQMvjhNKeMeICp5wAdubzZfGq7cjX4nsw/tkr8kc+eee3yUSRXARS7UMBkoVIUVFawJ
 7e7ZUKS97e4glXNX4QiAWjhjxuDckP2zfw0YLQP1s27/VrF0u3UXGPBFqRvzCNGlZtaXcAcDo
 dH+ajGCy36LvNsw/0bl0PtJ4q/AygriZHZnbWK6rmBhyb7tcTMvT2CFj5IFKwVm1xeHkU6bof
 JvpY9UePlhKKsDxEhjeRCf6ajPWGgRA/gl0XsscccIufUxjCks+FfVFB2f7NGQxafCuE9JfNC
 VTqEDnKKOaPeY8t88GZEDDRhpxQPjSWhL9HNFinIGyZ02FybIWYz2AgxnKzvnKiOCcORFkFz3
 JL9cTc8Tb52FBeqBJi9KdaPiLdi5SvjwKHGAVvGJcxpvGoX+30jVnarn779AU0lt/WeIAC5Dx
 iE2bujADzuH++4MtOrFmDl9eGQerP/ztAyl/eChr2VL/Q2DEQHADXkrpbT4XBq1fcAmwfyYMU
 CnkQcpl6aVO8e5EDh61dPh3/e4brxZ6iYoO93YI1JjB4sGLuevlMOh9dHKeDxmxQprPFBcp0D
 bxrm+a4pCTyRoCqjhGKuzm9rNsf4RnWy1E4LgMhbnR5Ddm+UbFR7G83zQTpz+S08HnmWB6y6y
 J917u51je3IJQwXe52jEF6KTmGDZ5/Ffg6O9CQ4qjmZJdwudQJq8/x75Q9r0LXyo7/naS2N9r
 6QtPXqOtqW6DXaU86mDXdsoEynieutbmdhXgIgDbOjdlpkj9rzt293X4bWOTYD8LYZ+Tyf/cq
 oAF9NLeeV8bFqo/nHIv9G5f+f3e4D+EL3gU7Dx+OmnHqm3HdGbZ7oulbsjvkzj
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VUqicgwPZeK64g5ZJIAupwEPkwtBnSyQ7
Content-Type: multipart/mixed; boundary="cXB67Qq2PRYdD12uDNuY3AAD27xKjX0vK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Wilson, Ellis" <ellisw@panasas.com>, BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <e6c1dd8d-b3cf-ff71-bb64-b28bcaa78d14@gmx.com>
Subject: Re: BTRFS Mount Delay Time Graph
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
In-Reply-To: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>

--cXB67Qq2PRYdD12uDNuY3AAD27xKjX0vK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/4 =E4=B8=8A=E5=8D=882:20, Wilson, Ellis wrote:
> Hi all,
>=20
> Many months ago I promised to graph how long it took to mount a BTRFS=20
> filesystem as it grows.  I finally had (made) time for this, and the=20
> attached is the result of my testing.  The image is a fairly=20
> self-explanatory graph, and the raw data is also attached in=20
> comma-delimited format for the more curious.  The columns are:=20
> Filesystem Size (GB), Mount Time 1 (s), Mount Time 2 (s), Mount Time 3 =
(s).
>=20
> Experimental setup:
> - System:
> Linux pgh-sa-1-2 4.20.0-rc4-1.g1ac69b7-default #1 SMP PREEMPT Mon Nov 2=
6=20
> 06:22:42 UTC 2018 (1ac69b7) x86_64 x86_64 x86_64 GNU/Linux
> - 6-drive RAID0 (mdraid, 8MB chunks) array of 12TB enterprise drives.
> - 3 unmount/mount cycles performed in between adding another 250GB of d=
ata
> - 250GB of data added each time in the form of 25x10GB files in their=20
> own directory.  Files generated in parallel each epoch (25 at the same =

> time, with a 1MB record size).
> - 240 repetitions of this performed (to collect timings in increments o=
f=20
> 250GB between a 0GB and 60TB filesystem)
> - Normal "time" command used to measure time to mount.  "Real" time use=
d=20
> of the timings reported from time.
> - Mount:
> /dev/md0 on /btrfs type btrfs=20
> (rw,relatime,space_cache=3Dv2,subvolid=3D5,subvol=3D/)
>=20
> At 60TB, we take 30s to mount the filesystem, which is actually not as =

> bad as I originally thought it would be (perhaps as a result of using=20
> RAID0 via mdraid rather than native RAID0 in BTRFS).  However, I am ope=
n=20
> to comment if folks more intimately familiar with BTRFS think this is=20
> due to the very large files I've used.  I can redo the test with much=20
> more realistic data if people have legitimate reason to think it will=20
> drastically change the result.
>=20
> With 14TB drives available today, it doesn't take more than a handful o=
f=20
> drives to result in a filesystem that takes around a minute to mount.=20
> As a result of this, I suspect this will become an increasingly problem=
=20
> for serious users of BTRFS as time goes on.  I'm not complaining as I'm=
=20
> not a contributor so I have no room to do so -- just shedding some ligh=
t=20
> on a problem that may deserve attention as filesystem sizes continue to=
=20
> grow.

This problem is somewhat known.

If you dig further, it's btrfs_read_block_groups() which will try to
read *ALL* block group items.
And to no one's surprise, when the fs goes larger, the more block group
items need to be read from disk.

We need to do some delay for such read to improve such case.

Thanks,
Qu

>=20
> Best,
>=20
> ellis
>=20


--cXB67Qq2PRYdD12uDNuY3AAD27xKjX0vK--

--VUqicgwPZeK64g5ZJIAupwEPkwtBnSyQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwFx3YACgkQwj2R86El
/qi5ZQf/Yf3ZigEMHUVQ+gZb0G/v9bBeo0Q7gmIafIQQNjnT6TpknXG9D0hCdx4h
rGZaGmGKwgPcHXRHR5K95yk+K+29mzqnOrJfg5gmmtL7LlVRW1ejckjM3FIBjr/K
jBnn5VabfvckCFwi0a2mijOSHR9zsA7cZ9wQPVlnRjJft4bC1sBEwcgs5GEVxdby
HScl1MM8jlxjFY8zvOYEsOFAc1GBXmvVGx3Z2Mbm8SUnk83cp1GDvgI3R0Zx2uY7
35ZYGRQyWNzdqUqtEI6rQUtmIQrd2fdl8MiJMk/oKQf3v9Tu2A0gPgFnGb/ojAPW
x2D/2ZPCWoXz+GWvRx0NCc1Diwytrw==
=7Csw
-----END PGP SIGNATURE-----

--VUqicgwPZeK64g5ZJIAupwEPkwtBnSyQ7--
