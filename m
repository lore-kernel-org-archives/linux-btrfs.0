Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C53BC282C3
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 13:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFB81218A2
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 13:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfAXNhN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 08:37:13 -0500
Received: from mout.gmx.net ([212.227.17.21]:55657 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbfAXNhN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 08:37:13 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIQlv-1glp2Z2n1T-004G1A; Thu, 24
 Jan 2019 14:37:02 +0100
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190123071518.2528-1-wqu@suse.com>
 <20190123174736.GW2900@twin.jikos.cz>
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
Message-ID: <69c99dd1-8a1a-eaf9-57cf-3445906fe966@gmx.com>
Date:   Thu, 24 Jan 2019 21:36:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190123174736.GW2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SMlPtQYFfvo2UJc4oaVsvewHWUd08Seg7"
X-Provags-ID: V03:K1:BmaBmymEkSMqwwcDRklx36YfGcDaBVuWlx3b7qF6QRPv2poK8NU
 4YrrjMgtFRlI594DkvFhW+fNNItPn5nG9R4VXfONwICGBaRIdf5D0pjsVarnMVuQmzWUyCM
 stTagBHoUji/zg+1dUXSL9MIoqebH/UTxULhORsrFnctjWnAryt50U2bcho6k7RYEqHiL4A
 WUzqX+JZBJeDnqLa9zcrA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kub72tv9Xlc=:uf8JyFnx5UOiNqKnfaYtKW
 VC3NQAtN22zQNJypKCG9o764z8j5W1WjpcM7pwVS4WuByWcM1OWklsT497XFIdJZqFZWKrzmz
 ceBLr9dVI3jMHiiNfZOaLSgMsVAnYlWYJXGOzlu/8eaHjeE7eLM08gRZhYQac4M+UlNQnlt+8
 Bcak4NPqMGug52P37IIwziEdNr4mGSG+nOon3NsMSfAtpZ18LnylYIlfBy8xryHziCeJtw4l/
 4P2wlBRrGxbrKrrKQom+Ed9ucaKCQHZkh/EumfaCt3yKPVm8dGqWbrT/vFVS0mGlB7OGlN1qk
 1u5lt0KA/B6Zbunkg0Tv9eieSOnAjVhLzL/GsWw0JYTmadiM9OdVzw3U0Q7J7TvbQ21T+6cDT
 mGRDpeJ29pJ3m4mslAzlBzXA8Rnv4DgNRMxUKjvXxiuNOZOh/+gucJ4fwEs8+VugjZ3iJX9SN
 KPFT3EIeo5rPaZfbIixO926iI4CLSYEDOgCzswIWpolfpGgtCWsibeWaIR3j8+an5Pu1L3rpy
 XfrEpZ2O85U4Ab8N4fdDL/YDXJpS/rmWuhxyo4zVnuVt+2OWjX1HaYmPXPkjFfJdOldv8fZ/I
 2DpJQ9xNc9dpUJSIPjToQ2mzqqZXjbk1W7uOcViHhQRTT09YxnAo4VEPbdoGhWikastzPXHYm
 4+0vSMNrHxr/anf7ioeNrtqap7StQB3Le2PTV3PVCatm/b8SEn5g0BwBU7d/Rx8Ji9s09Gzsb
 j3UgSAR4yuRJczBILF24Tm0OMZzo/su8yPqByfA4trQ51kCl7p9tMGeU3mbW91LzfGAsR/UbB
 TyB+VOTicy2e608QqHaMc+f7SyCelXiTOdkKAyDL2KfsUBd4+OQysGMD6sBAyddeU1x1WbHGi
 fnXv9weCWXYKJ8bWmNLpYSW4YyRhSa8kTDyg7/Hjc7cSazL6FEjFJNQAaZKh9x
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SMlPtQYFfvo2UJc4oaVsvewHWUd08Seg7
Content-Type: multipart/mixed; boundary="Ak4BNbmqZfOHlKHLfFoCfBOFnIkFet6RP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <69c99dd1-8a1a-eaf9-57cf-3445906fe966@gmx.com>
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190123071518.2528-1-wqu@suse.com>
 <20190123174736.GW2900@twin.jikos.cz>
In-Reply-To: <20190123174736.GW2900@twin.jikos.cz>

--Ak4BNbmqZfOHlKHLfFoCfBOFnIkFet6RP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/24 =E4=B8=8A=E5=8D=881:47, David Sterba wrote:
> On Wed, Jan 23, 2019 at 03:15:11PM +0800, Qu Wenruo wrote:
>> v5:
>> - Use Josef's superior qgroup deadlock fix.
>>   No performance regression now.
>=20
> Does this pass fstests on your side? Namely if test btrfs/007 does not
> crash,
> https://lore.kernel.org/linux-btrfs/20190123135120.GT2900@twin.jikos.cz=
/
>

BTW, I will drop the 1st and the 2nd (this) patch from next push.

The 1st patch is completely independent from the delayed subtree, so is
the 2nd patch.

For the deadlock or possible performance regression caused by my
original fix, it's unrelated to delayed subtree scan anyway.

Thanks,
Qu


--Ak4BNbmqZfOHlKHLfFoCfBOFnIkFet6RP--

--SMlPtQYFfvo2UJc4oaVsvewHWUd08Seg7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxJv3UACgkQwj2R86El
/qjubQf+LQh/EylTu5ZVTajCBMhE+tn9KWWvXNV8ni2WCzi0LB2pQYrwFC9Wu8BI
DJDpoj64ziOYjo4dgwDmzTQ6WHTu4eB3OYsMj3zEcIGCQrawoHQjeD4YKcdxSp72
6Q6LcmjglAQXHOxYGfjBCEckCiLG71T5jd3MySLUWkp9jgwUuYoZA944gWSFAF8u
DZGjXd8oVpWrFCCK34aYxLf8pDbWUrKhVaqq5znEqBV98MrdM8+BmZb7BTKGJNmS
PMeihN7BsliFuD/hnDA/VO9r+YlcvZs2wN4z9TT8Y6A4YPqCmhB0hUywVO5OZBtX
MJ5yC9629FcdPValRb4MBOylo3pmhQ==
=Z/Qj
-----END PGP SIGNATURE-----

--SMlPtQYFfvo2UJc4oaVsvewHWUd08Seg7--
