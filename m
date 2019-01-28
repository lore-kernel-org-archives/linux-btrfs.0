Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411FEC282CA
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 00:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1156E20880
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 00:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfA1Awg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 27 Jan 2019 19:52:36 -0500
Received: from mout.gmx.net ([212.227.15.15]:49059 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfA1Awf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Jan 2019 19:52:35 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M7pDs-1h9yHg1DNI-00vMep; Mon, 28
 Jan 2019 01:52:33 +0100
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
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
Message-ID: <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
Date:   Mon, 28 Jan 2019 08:52:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FxsVs7vomKvRsvFQWJsTzRfetOaZ0jUyz"
X-Provags-ID: V03:K1:Rrx8A363mOkVLfjlqezewG1EG+EBK4+RpLDARppl3BLkmsAakTB
 bhI5xrK/8aJ7W7JF8EqXDlU7+1/0CeMs4HkolJMEJs6rF8p5lBgVwrRc4V4eL9ARpU561Ck
 9I3Wq9bllrMzTeHE4ek3iYJXqTyPrMU5SqAsCgMTmRuvkxCFBTvd4sR8wFOHmeJxy0lsThI
 RZ7znCv11FI19ewsYCysQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nLS20B4RMoE=:3/QxIrLjfsYorXm4FdNERg
 OL2JTpm/c8NaPWLl2XfpSoC+ziu0wJvrUzsk/lq1582ZQ3vZLg2hVW6HjoWrPnlMKF4zS1xOf
 rnXZIfRMN6HtMe5+0obpu3VfnP/N4xVQ/vMBxAZlvjiUeZJZA7ThdxtUkOhB8JOhKdyvuKGWZ
 I6UxinHj9CAyt3W3B64uhUTt7NRiawgwT2/QaHLCjtpYPTROGGiE50w6uFjSNt39WPh4DRNO6
 516P1Eupe3MW8hinqrh34YggpquFV4cBsNXvhLZpYyKg1Bgnz7i5+4wPikIL0VGJ6BITsNnz3
 7KpE+EJ8fIoSvvx7+OPUxQEtf1m7/SyN/mvsjOU0pmLi5E9ExjYMQ2f4bWCA07E+0+mJFy/a7
 hdsNPCOyCo6WDgq2q7GrenMZOkIHYo5oreLGo9yFfFjkquh5fjjMNCQVg+EEWhxIj+45aQOpA
 SM2i5FRbJT3xbjHr+V5e8x3/N936KjQjng9d9CQshXiQbNEqqnWpM4vA/EbA5ZTUglgAXvWPu
 eWaG+24L8HCg025HZ/up07JzKEOAV+lq4ag75VF8PPxaGG4JBB7aWPYN8EhMa4TdS4E/nA21m
 iu9vaP9LGiJek3s7Prz40CYA9xYvtU5QP5z3KlJnrjOU9/VVUpsY/WNeuYTi5y1kJkcd7dy4C
 EYBF9VPm/GBsmXlgOODAjRezr2AAd99qNutSerIilxA6DK1Rvf5WYDspmU7p+U6iDtDk+btgk
 Fw0Ltku+znnvvWxuX7L7L3R24PBpn89I1P2u0w+ovnV/clLXs1cuYqdhom2MkT7dFL0nTG1AU
 F8aU/ELv6jWKzlGit7zUBeNoAfSC+m93mww0PqVlLVfIg/0LTlijFkdPJQEEjf8LcpiKsXJmk
 YTq90l5vd7QSBAaw/3LDTwh2cja6rvbgOjI9qWfz1QdfR3v19Acqi6+BpJ0NhC
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FxsVs7vomKvRsvFQWJsTzRfetOaZ0jUyz
Content-Type: multipart/mixed; boundary="VRfKD5OZN0hoARZ3l23kmBT5EoMdpNXWI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: DanglingPointer <danglingpointerexception@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
In-Reply-To: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>

--VRfKD5OZN0hoARZ3l23kmBT5EoMdpNXWI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/26 =E4=B8=8B=E5=8D=887:45, DanglingPointer wrote:
>=20
>=20
> Hi All,
>=20
> For clarity for the masses, what are the "multiple serious data-loss
> bugs" as mentioned in the btrfs wiki?
> The bullet points on this page:
> https://btrfs.wiki.kernel.org/index.php/RAID56
> don't enumerate the bugs.=C2=A0 Not even in a high level.=C2=A0 If anyt=
hing what
> can be closest to a bug or issue or "resilience use-case missing" would=

> be the first point on that page.
>=20
> "Parity may be inconsistent after a crash (the "write hole"). The
> problem born when after "an unclean shutdown" a disk failure happens.
> But these are *two* distinct failures. These together break the BTRFS
> raid5 redundancy. If you run a scrub process after "an unclean shutdown=
"
> (with no disk failure in between) those data which match their checksum=

> can still be read out while the mismatched data are lost forever."
>=20
> So in a nutshell; "What are the multiple serious data-loss bugs?".

There used to be two, like scrub racing (minor), and screwing up good
copy when doing recovery (major).

Although these two should already be fixed.

So for current upstream kernel, there should be no major problem despite
write hole.

Thanks,
Qu

> If
> there aren't any, perhaps updating the wiki should be considered for
> something less the "dramatic" .
>=20
>=20
>=20


--VRfKD5OZN0hoARZ3l23kmBT5EoMdpNXWI--

--FxsVs7vomKvRsvFQWJsTzRfetOaZ0jUyz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxOUk0ACgkQwj2R86El
/qj5sQgAqoCN+MLzSTRdCxoxQdXnL1bJk35+OdSu/Y4jUr/S5IJ5IDcaGqLUJmZc
jLrNqbIMYL8MmXZ+e0+UoqfdeZ4JBMuJaPfj7grUVdLtb4Dl6dBuLoWkfwJ8BB1h
RsvrgBThAnVvqbsomhamwcPshscFyIi3OKuNSMJpRdn3lIvQ7yBppm1S5WTzw/f5
1dsyTigkcyqSgsAZ3BuS9sXf9r22Ac8w/zyVoPZv5e9q8uUa18Y8MRGHk0Xwd2B8
bhP14u7cIrhCnAbvBgcp2K2HK9cTUajzIvOPmaeqtyj9aUiqyvEjyFIOU/DDqdpb
TQP6tkMp2++ttKeKNegr3xOxM4uKew==
=XxR9
-----END PGP SIGNATURE-----

--FxsVs7vomKvRsvFQWJsTzRfetOaZ0jUyz--
