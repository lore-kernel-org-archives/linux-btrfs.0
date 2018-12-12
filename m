Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716EAC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3579A2084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:22:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3579A2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbeLLNWC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:22:02 -0500
Received: from mout.gmx.net ([212.227.17.21]:51503 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbeLLNWB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 08:22:01 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LgNGi-1hBxht2KIO-00ngbo; Wed, 12
 Dec 2018 14:21:54 +0100
Subject: Re: [PATCH v2 0/8] btrfs: Refactor delayed ref parameter list
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181212073102.7736-1-wqu@suse.com>
 <20181212124228.GS23615@twin.jikos.cz>
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
Message-ID: <0aed9183-3d59-694a-8207-4f28339c4cc0@gmx.com>
Date:   Wed, 12 Dec 2018 21:21:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181212124228.GS23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C56GC5epZrKL8l7ylfME7SU5rxGrhpFKs"
X-Provags-ID: V03:K1:iH0qCJE6meTHPrSRf+vHaN22FxaS1pdr3ggV46LuB28K+wU9+PW
 uUoZGvmQjwzIHmVikOUj4wTdiDhlErjEgTf/SG51yjy2KOMGdnMrKka4hm+NUsaHXtBA0rF
 TeMYWPeQLJ/zP3Tv+MEfLiTIm9x6h7QcF22RRSFOVopaamu+uAHkckPugRhx0KpxsU2sAiq
 Wu1ddfVUDmUbMZbezaCGQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0TW08NVXEqk=:JLsxhgiWN7zbpvGxw0r4k1
 YZk+WWV7NdXmapFd9dN/bCrZKzrjWc4e4KH5T+4ycEGsImrwUamQ54xDr/rFEcWANCLYGme8d
 ROew+cz++4ado73ILh46+MBIvP0ZM2w4lWc4/wHAYlyM3ZIAKf1AW9VIBw7zuoRo/5NaDkdkK
 DmmJMxei7+7BxQNYc9PgMZPoXNRQ4yMtusOJwkHLpGPHrnHhEMZVGqzVzLqbTlvBGET7meJOo
 7G/B/CQadlxmrKm4PWG/KSvKLKG0roYzVKYJ8kMxJDBq4aM+u80h06OsAD6aow/GCaeSaUjJj
 UTzzovpJnDj2mxXS0nCneuYB4hGJyVXai5c5v5xSgpI9vJQ+XS1DbZ7k7u7wcgVduKxtayS9o
 De0EeV2SFWPofghC02QErA4ybSJrdcmdWzCjOqiZDFDvSgXFfyyxVYrk3q1eOBHFJcPYvN9le
 yQ67lDOW/dMhw4GfUN2cpkTihDkv4bh03cocH0zQYWuJANrpYEQufv/pBDsrepgI35OWYASbh
 fDAGewEVwVeqrHRwtmzfNAiTTeUlSl3sT6//6wRqzdqG64U/PSfEGLSSgyo0V9DqnZvfF2lZR
 Ll4yVsX/G+JFrd2n9LS/bBaGO4J5MERPezmLPNIxgZaZcUu3gRjoBQ/AEXLzYT61H8GlBlLy5
 jEy1XXpzUZFcC1PvHI7T5YguSLkOa6rAIX/rjrPQVuAsIpZYHk9+j4C141HePUvr4wKsUQCjw
 eb6DtuqE8E2q68CBpn08R68ztCrBFJpmGtZf5qEiRjwNaDgjlKDGFaHKQDlFRTagWFAp83cMS
 Id0JqOgYR8V8d0goeaStP9L51rTijzAlCdQ+PjbkK9hYaOpNWrjmJuIk3Wc696E/xKOGOCY4/
 pR4pxAM1PF9cs9IRgpfmKm7nQbpASc/EVnf6Lq0c5qJtebT+3o6MDje34YFI94
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C56GC5epZrKL8l7ylfME7SU5rxGrhpFKs
Content-Type: multipart/mixed; boundary="kkAhkoSiWdS29tDAP36Q9IXk6D0oE0yD0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <0aed9183-3d59-694a-8207-4f28339c4cc0@gmx.com>
Subject: Re: [PATCH v2 0/8] btrfs: Refactor delayed ref parameter list
References: <20181212073102.7736-1-wqu@suse.com>
 <20181212124228.GS23615@twin.jikos.cz>
In-Reply-To: <20181212124228.GS23615@twin.jikos.cz>

--kkAhkoSiWdS29tDAP36Q9IXk6D0oE0yD0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/12 =E4=B8=8B=E5=8D=888:42, David Sterba wrote:
> On Wed, Dec 12, 2018 at 03:30:54PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/refactor_delayed_ref_paramete=
r
>>
>> Which is based on previous delayed subtree scan patchset.
>> (https://github.com/adam900710/linux/tree/qgroup_delayed_subtree)
>=20
> I like the cleanups however due to the dependency it would need to be
> reworked on top of misc-next without it. At this point the pull request=

> branch is being finalized, I'm not sure I'd squeeze that one in.

Feel free to postpone this cleanup.

This cleanup is not that emergency.

Thanks,
Qu

> So same
> as with the delayed subtree, postponed to the next cycle.


--kkAhkoSiWdS29tDAP36Q9IXk6D0oE0yD0--

--C56GC5epZrKL8l7ylfME7SU5rxGrhpFKs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwRC2sACgkQwj2R86El
/qjO0Af+ItLkaUk3yMq310NLzN7gjovil7rZ3kSMY3cp4hIf8GAIbVrFhb3derH8
uNX3L9y9RQJZP73bU9ZPqz36eRfoFzgcVe7ds2ufqAX3GsTTrrdGBgC7B8Enprbn
Uo6u1/CCBP7EnNvCOfra/b1C8qJUDVZGq8HyFqNQtgj6UiIFWbSFHGb57zrTNRug
R4vsMZAV0MDWTo18Or9H5K+T1SdeqY2d0IbzVP0qYe2ITIx0MH5uY0Nx6jl+CRbx
SPv7LoFKoFqQGUj5YMh+kurUTN3IqrB8ZRBTsN/nTFpvBrI1IyLbH+ClT61M5eX7
tGYf8X4UsE7noLJAHpkmU9uG9Ra6Fg==
=GKUl
-----END PGP SIGNATURE-----

--C56GC5epZrKL8l7ylfME7SU5rxGrhpFKs--
