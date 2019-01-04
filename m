Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6671C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 04:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A78802070D
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 04:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfADEcB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 23:32:01 -0500
Received: from mout.gmx.net ([212.227.17.22]:37463 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfADEcB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 23:32:01 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lu7ty-1hLO8Y45rS-011Ulx; Fri, 04
 Jan 2019 05:31:58 +0100
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
 <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
 <CAJCQCtSjaWDCz9rc9_xzQMB+Xa1Ff3CqZA=hWnX=N6E2tshBrQ@mail.gmail.com>
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
Message-ID: <94c4f848-ba6b-2ad2-b956-997b33fa0778@gmx.com>
Date:   Fri, 4 Jan 2019 12:31:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSjaWDCz9rc9_xzQMB+Xa1Ff3CqZA=hWnX=N6E2tshBrQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DiMEfwHzK6YzP7F4yX21l5IUmiApVjbe9"
X-Provags-ID: V03:K1:8GDhkpZMautMjQjHfnGhE8UbWB+MBbJ+J7Q3aujDcBpqz7Z3Fke
 l6WrdnIej6YNneMwZyK7/jEPzFxXJq8Xve1OWGgXtsE7SxczFw4Gl4wYrk9VCPtisr2bsTA
 CNlD5LAjWut+6XSVJPV9Lwg6Re0Ls6S/L/jIKD3Op9Zogxg+zyK7iNeUxcmOgukOKW+d6/e
 bZOnSpVjISTXP6x1isNxA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bJc1Gz/j70k=:adtrwLmR0TzDvw75y8SNsw
 JZKlOujqbBfmY1myQa68Ucinf2RFdePMdxm33AkJKQBnM/ZnYcEVdc0chxcA4BXFD2aGgXGrZ
 KBsIe6U4AEwxECCMZ/ON8FY9k8XbfePuFHBPEGJzxaHFFOylPtqGXtMR5hFtrrxvKsO2/DYDj
 JeggharAks4106P0NbsizEmkm8iCTxwOWVu1tG8U1lBKsWNfvHlgKU1HO/MaSDaZ0rE2LH5bO
 6ZsNPhIV1WWQhFt6BdTzgdJwFr8JXzB6JbloS2Wc9N5WB5erinaqrCEb/m9T/qF3G+LEpkcx4
 UhkK2H/PRvOsSnvhLpdaSoZeU2GDoEcznUL2S+OaH9Zqj9S5USQloPoOaEeRCHYtU+8UzIE7p
 ff/dyOF3omXGept8d9oHKTyrTGjH4YLiGZ3j4HiFxsScr8azjkdWkC+f2WZST3Z+6X1enHSO+
 EnaeA1qj1wAM0TFUe7yNkFaQYJCfqEB05yzw1EwIAgp4LJWcd8RGUxvPPPksLuYr1N5GKrCUg
 GurlO+VEfVbgXSloodZNOXhEztdfZgc6UkJ2yFACov8fi5xGHlAuLy862DpXKuxS4XEhYBTHn
 b2znqpBUAAz3x7doWg7XC9QhbIFYQUzGa7Zci9PgVk4DRsihSbha6f+2FOhixJpuXc6CaPHHk
 BZtP1tBOmzHQVKIjoCy2UjTk9oiujElbGvd/Y689NmMc698VRdKOESA2LqlcuL5F6b2GPdkZR
 iHIIOIswZvvRZXHaHHnjLNYar02JscBWPb7KmfvhaPt3AQ61yNbo0z/8M+oS0BNcRm5A7wREU
 +boMs1ObgQ18NSqc/xLJceNPxaZawqVQwnOJUBJxc+g3JItORJz8SFVutYvGvyJALlbTHgCYz
 k7iNYJQScHIn4BI4u/26LOajfqvlrtIdEHj+ktXQJ/d31WVHCQ2v533mNO1Tou
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DiMEfwHzK6YzP7F4yX21l5IUmiApVjbe9
Content-Type: multipart/mixed; boundary="ENP8H5X6HOnxj8dxyKVND5wvBsgQ6VTto";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Nazar Mokrynskyi <nazar@mokrynskyi.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <94c4f848-ba6b-2ad2-b956-997b33fa0778@gmx.com>
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
 <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
 <CAJCQCtSjaWDCz9rc9_xzQMB+Xa1Ff3CqZA=hWnX=N6E2tshBrQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSjaWDCz9rc9_xzQMB+Xa1Ff3CqZA=hWnX=N6E2tshBrQ@mail.gmail.com>

--ENP8H5X6HOnxj8dxyKVND5wvBsgQ6VTto
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/4 =E4=B8=8A=E5=8D=8811:43, Chris Murphy wrote:
> On Thu, Jan 3, 2019 at 6:32 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>
>>
>>
>> On 2019/1/4 =E4=B8=8A=E5=8D=889:15, Chris Murphy wrote:
>>> If you use btrfs-image -ss option, there won't be any sensitive
>>> information included. Files are hashed. Some short name files or dirs=

>>> can't be hashed (you'll see a warning) and those are replaced with
>>> random garbage instead. There is only metadata with the image, no use=
r
>>> data.
>>
>> Please don't advice -ss for btrfs-image. It's super slow and will easi=
ly
>> cause tons of noise when running btrfs check on it.
>=20
> I thought in recent btrfs-progs that -ss was quite a bit faster. The
> last time I used it I don't think it was much slower than -s. Anyway I
> don't have a preference between hash or garbage, but I don't think
> it's realistic for users to give out filenames in images. So is -s OK?

For -s/-ss the problem is, btrfs check will report tons of hash
mismatch, and recent kernel will even refuse to mount due to enhanced
dir item hash check.

The extra problem of -ss is, it can't ensure all filenames to have a
conflict hash, so it's not that much different from -s.


For User don't want to give any filenames, then don't give any files name=
s.
We could find a way to get needed info just using btrfs ins dump-tree,
especially for this case where only one error is reported.

Thanks,
Qu

>=20
>=20
>=20


--ENP8H5X6HOnxj8dxyKVND5wvBsgQ6VTto--

--DiMEfwHzK6YzP7F4yX21l5IUmiApVjbe9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwu4bgACgkQwj2R86El
/qg0Dgf/cREKP2i2A1rDAt35P5SaCNbCMiidiR15GfJNddcuCjnenuXBMbmiEsNv
kNtY9yOGqvznelqSJVEtLWEJV0qNZq7uA97kmDthAVqx8FsSNd4UouOnSGdMUsjy
h3KZYfb3DTiXzc4TnECSsvR2+kjKaMMaMrFHTX6Ln9/A08m3+5y+a9myk/APmTgy
kImcfcqMnYCUMBN0NxcnAWrbwl2br7NZqSta81Cw4FVXRTUQApJRtQ20HFDzx7NI
tgF3RnLTQshDTHweiUmwhjuseLwlNLBbxSdnYDOPij0X3yXvRO3xfX1Olds5ACLn
cFKkjaUr6GxDigiLOrdOu57mbMo4ow==
=APt4
-----END PGP SIGNATURE-----

--DiMEfwHzK6YzP7F4yX21l5IUmiApVjbe9--
