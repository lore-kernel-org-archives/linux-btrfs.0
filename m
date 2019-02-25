Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4EFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 13:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 445E720842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 13:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfBYNKt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 08:10:49 -0500
Received: from mout.gmx.net ([212.227.15.19]:57629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfBYNKt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 08:10:49 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LikE1-1haL0P246P-00cwVz; Mon, 25
 Feb 2019 14:10:41 +0100
Subject: Re: [PATCH 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
To:     Hans van Kranenburg <hans@knorrie.org>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190102052945.16325-1-wqu@suse.com>
 <01eb72d8-73b2-049e-a6f4-37668742a2b8@knorrie.org>
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
Message-ID: <79f01a1d-97b3-d7c1-91b7-01b7830b3f18@gmx.com>
Date:   Mon, 25 Feb 2019 21:10:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <01eb72d8-73b2-049e-a6f4-37668742a2b8@knorrie.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BQyiejei2G5vjuRb0XrxaYdSfhGnYZeng"
X-Provags-ID: V03:K1:bRrOZCul1rgiYhvZPPTdRBvevZbYe0sXpI+W7gSUNi/cZSrWm0w
 oaHRS1cqgYi7PpbJajrx+PtdVn0LeqHOE0hN2l8VRo2kTTZb18ZJ0l+71uZqyHhkWQ2Qpuq
 Vi62iIAK8DsgSjaBapr3Ewup0ZNjO9rBdz0o3NdjLYPhRZQV2hIKJJPIl7+0iFz/YUPOrIC
 +eKo8LPIvh+LQnGUQV5cQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:05IFI2PBAw4=:287LrtAU1DsjKJMnr6mDqx
 a6OdBJ5UkVlMQbRz54Dsiwt079tGecm2nYAatlqZY2O9ZPOjEUWg/y5TUsq9tDPCEzVEH75uI
 s4XEkqjqXPw+dmh423rfdTzNEdcVHsPl1pJc0biuOZCaAuinQOyAgueQqTZnFo+SqAuDIlH/T
 28Es/3M6dVYCcK+DZU1Q4i1Q8/kkxI8+VnfDqnmjqlmjiUrLcapIPjPR0VmY7hya50H7IHkYs
 fTFx0Xy/FidKMI3kwVRXFQdPSgYJvulAdFUMlI7YWQb1qOc2rMea8XUgOw78oti/Z3OmXU2ld
 fYyLT6yrZ+dtnHdWvJAYIskQCzBemHM710scX4l1HjDeV8Lccmz2q5PJatcfvVlcQqiFewes9
 4p3dy1H55PKE4zBjL0acbeL3ONs3I9h7K4UsBGL7FNl/ifb61ybWozQiZNf5h14ebxc25IswS
 nfh+dPtKLqat7Ma6SSbpCufcoQgFUM6bbE35pRWgUlTj16hxoDkkbNXvsgOQQ0PZZAj1stiWJ
 724jLEN/IfTUAfdwLWGGSuoJQ1P94LIJ+6GaB9mQDVLAzniiPfZdmNwxJwPtJ4y2xMzrkyzzn
 OVSM6e6ipi3UdJLzkACbV/XA4YgttN+PKNcppnXnbpy4Jzd0+GHcpF4qI1UW1t3Th0ZH33q0l
 ddbTHSdtjgn2kjAsE6zI5sYGhlkZ9bXTt249qxSxXCbItTNX0TlXmJqn9r+B4uKEG/XadTN0+
 PxROyvFniZiMtXKEVlYKVW35MZVVDc8mlMxUCJ+vXVd1viW07ZeJJMA5iL2e+O8Gf6UQ9WMfM
 D1D55Ej6pbxfOOeQRa2Qghc3jeM5OCC2PBZqpWCzE9AcYvLLPNbFWmsSSCdoppB/QIAE8LoJj
 GLH7fuguBjXekWEAVLbUmdl8Dp4sB4jMfy2gcFrVHf58hBi7B/Nx/jwl1PZYEb
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BQyiejei2G5vjuRb0XrxaYdSfhGnYZeng
Content-Type: multipart/mixed; boundary="jD7cL2XyeXlLOQgJaJZQQrMIlTnyXVl9c";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans@knorrie.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <79f01a1d-97b3-d7c1-91b7-01b7830b3f18@gmx.com>
Subject: Re: [PATCH 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
References: <20190102052945.16325-1-wqu@suse.com>
 <01eb72d8-73b2-049e-a6f4-37668742a2b8@knorrie.org>
In-Reply-To: <01eb72d8-73b2-049e-a6f4-37668742a2b8@knorrie.org>

--jD7cL2XyeXlLOQgJaJZQQrMIlTnyXVl9c
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/25 =E4=B8=8B=E5=8D=889:02, Hans van Kranenburg wrote:
> Hi Qu,
>=20
> On 1/2/19 6:29 AM, Qu Wenruo wrote:
>> This patchset can be fetched from:
>> https://github.com/adam900710/linux/tree/bg_tree
>> Which is based on v4.20-rc1 tag.
>>
>> This patchset will hugely reduce mount time of large fs by putting all=

>> block group items into its own tree.
>=20
> I'm going to test this.
>=20
> Is there some specific command you'd like me to use to produce results
> for benchmarks?

Nope. If I provides some commands, those must be super beneficial for
BG_TREE.

So just use whatever you like, near real world use case would be more
appreciated.

Thanks,
Qu


--jD7cL2XyeXlLOQgJaJZQQrMIlTnyXVl9c--

--BQyiejei2G5vjuRb0XrxaYdSfhGnYZeng
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxz6UsACgkQwj2R86El
/qjAxQf/cJc4sjioZB4pu6YEkNe/Tr0lN8TIjnioJUIoelvLvwPax/8V0ZP9pTJS
0hMERtxyp4SBImJDbsRnU3FJVGIF+nzpfAVFZDzq4QtSRxyWz+AJNl+PO0NrVzhk
bIKsrTTF/ybix2HcqDHa6dU5h6WnsJmDbzpis16iZi65z8hAR0zWZvLCxIdKgcGa
w8W/bQ7zgNie4tO5hYGoYoCsJdhw8SocyfBQZlFaO2mLfaqqbAyGNIlaYXDcvkYc
T56mTo5Ks8uuZbfYZSabrthy3QW5EM7RCXocq+lEcYScBRDpMh2W/FN6RBY/3CQd
ogohjtOAQvL4yeFVHs+HQvv/0zse/Q==
=kcP9
-----END PGP SIGNATURE-----

--BQyiejei2G5vjuRb0XrxaYdSfhGnYZeng--
