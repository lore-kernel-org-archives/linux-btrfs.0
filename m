Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F9EC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA9B42084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA9B42084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbeLLNUs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:20:48 -0500
Received: from mout.gmx.net ([212.227.17.22]:36131 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbeLLNUs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 08:20:48 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LhNwC-1hArEU26i0-00mbOG; Wed, 12
 Dec 2018 14:20:39 +0100
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181212003953.5643-1-wqu@suse.com>
 <20181212123739.GR23615@twin.jikos.cz>
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
Message-ID: <fde0326c-0590-eb4e-4f61-250b7e202c05@gmx.com>
Date:   Wed, 12 Dec 2018 21:20:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181212123739.GR23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vtAOzW1dCrZjCPCJbde0bi5oqQTJeQOKE"
X-Provags-ID: V03:K1:yS4cxUpRBnAkDmyKbzHIppVeKzlWovZsFmAgqDjNlKTdo0W7N85
 ysdPh9yugKfO+PX5NAxpn3sK+hVsnSwEyDK0N28kxroLgX/PG6mw0muYMY6icrPZz/7Q8XJ
 MzvO0N92SxfQpLaHtayhI9j8Srd4Wm9IEMCq9T0tPymcu2VXJ8jcC7TJloRjatwusBjmaRf
 fgfHGaRr7jL389+/5CtxQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xDOtoARg3BA=:qtphLiPbky5a2I/+rBaykV
 adW9rJd6gDDEnhMEXrAMGEebCQB6AmP9gaHZoEbNw1WSbvA1Kgh7pIRcwgNrtBaXCsERQobV7
 E+6WkNb6opyfzb+bL0q9wIiPRbVYqzAwS8ScAB1BIzlEUNO5KXlKY13eFyt6aX9TQnXPgC6YU
 LhOzjdvFOXfxE1F9SIXUCV0wS4M1gij3gVOR1YtHrmAN7GMcy8/tonXkoP/LUUj2Tv69rsQrQ
 68VUCROq0Ho2t8G58cbXPb51MERV1Alxr41UpEXcEg0UZ0WAWSZ/XyA+lfCyzTeBL6glsZNpc
 XtpWbMsXDcjH93rJU10bRzkK914grYqNCf22U3QcBYZtreXowx0FG1pJFUgpUSgfykv73meu8
 zLvx1tF+Ywk1fhYtSICmuGBK8ell59t0PSP4KAeIc1FXZnFGdRqOLh1/b7qeJyWtbg0x9XfyQ
 nzENdnZMDCaR7ZKIOC+KnRlXmHxLLN10RnVFaiQnP1eMkV8RnWNZNXo2h8T0T5N0a2RjA+qUj
 KYPRv8wVCkG8kirEfrJyzRpWOarOLFRgnTEXGMY+ci7T7dBnL1Q0jaGEXp63IyUeReP+miksh
 KSmZ2XRwiXOvBLhNjWHG+q6zNHKaEJfuJf0fYAU0OBbbU2TH83heXu2+ag+x/qKJ9BjZWhx4G
 NYaoeaMhj0yDfmtLYEak4EMD/t7ktOqytsh+pQ677C2ND1D81r4GEi9ygTI0RwDSDTwCpHKQA
 B83Y+S7XMXw+zsJLHpp8TJP0VnPXFMitEFQXn4C1tzWGmKHKoyQCRVDlhqFQ0gp/Y0TYUQlqF
 PkfcjinNQ0rQFIIA/Ujc2gLSvYdCxgoMJeuLf6x0r38XW8cWS4MEwoNjuDwBn8kZ+UE7d1TuI
 nEpt1rSQEEKYd/p5b6wNOz5p100b0zJBW0XMVzT15u8dNUkMJQzWgHMMT97qYj
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vtAOzW1dCrZjCPCJbde0bi5oqQTJeQOKE
Content-Type: multipart/mixed; boundary="pYlDCjt4j6sXAtXQ9r0X6CMtwGqcXaQqr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fde0326c-0590-eb4e-4f61-250b7e202c05@gmx.com>
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20181212003953.5643-1-wqu@suse.com>
 <20181212123739.GR23615@twin.jikos.cz>
In-Reply-To: <20181212123739.GR23615@twin.jikos.cz>

--pYlDCjt4j6sXAtXQ9r0X6CMtwGqcXaQqr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/12 =E4=B8=8B=E5=8D=888:37, David Sterba wrote:
> On Wed, Dec 12, 2018 at 08:39:46AM +0800, Qu Wenruo wrote:
>> changelog:
>> v2:
>> - Rebase to v4.20-rc1.
>> - Instead commit transaction after each reloc tree merge, delay it unt=
il
>>   merge_reloc_roots() finishes.
>> - This provides a more natural behavior, and reduce the unnecessary
>>   transaction commits.
>> v3:
>> - Fix backref walk deadlock by not triggering it at all.
>>   This also removes the need for @exec_post refactor and replace the
>>   patch to allow @old_root unpopulated.
>> - Include the patch that fixes the unexpected data rsv free.
>=20
> I've tested the deadlock fix but it still locks up and there are some
> lockdep warnings. I can't spend more time on that given the pre-merge
> window timing so I'm going to postpone all qgruop things until the next=

> cycle.

No problem.

But would you please provide the reproducer?
My test script can't reproduce lockup this time.

Thanks,
Qu

>=20
> The deadlock fix can go to a -rc independently, so once I'm able to
> gather logs I'll let you know.
>=20


--pYlDCjt4j6sXAtXQ9r0X6CMtwGqcXaQqr--

--vtAOzW1dCrZjCPCJbde0bi5oqQTJeQOKE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwRCyEACgkQwj2R86El
/qg/1Af/SVVpjwrZElTUmW9BWvklvx6I8v5a0KZuH0j7EGQRtuxwbZWDhNfKFexo
lFRV2B59Z3GqNlbIZhDTwBGx/8aI3o1EZ/2ZWwA7+00U8EQnCC7gRMQNx6ymweAH
e/GeeX354XxkVralEhKxqrf1saDw9f5qzRfnsKS8h3X73VHPaBKFWmElV0WyiCPF
YP/8z9tyFFQJAO46rYL7ihu8si/ML/9qd5Zx3o/1h8Kp+/OyAK22drJSky4lKsDH
qV4cgG8oDBZ23blMDco02GYbOQl54LP2hUiO8WO5gtNFAp94Ltc2ClALWBoDIdvq
fM33Z6e+/lZjfnjw4wNrLdH5t4/yPA==
=6eWx
-----END PGP SIGNATURE-----

--vtAOzW1dCrZjCPCJbde0bi5oqQTJeQOKE--
