Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39336C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 14:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0862C20643
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 14:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfBYOrP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 09:47:15 -0500
Received: from mout.gmx.net ([212.227.15.15]:39885 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfBYOrP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 09:47:15 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LpsIh-1hTByY15Ed-00fiZa; Mon, 25
 Feb 2019 15:47:06 +0100
Subject: Re: [PATCH 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
To:     Hans van Kranenburg <hans@knorrie.org>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190102052945.16325-1-wqu@suse.com>
 <01eb72d8-73b2-049e-a6f4-37668742a2b8@knorrie.org>
 <79f01a1d-97b3-d7c1-91b7-01b7830b3f18@gmx.com>
 <e2794bf1-4a0c-c9aa-eeb3-843c644dbf59@knorrie.org>
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
Message-ID: <6a1bb4d1-cf3e-865d-c597-e50e65a4423a@gmx.com>
Date:   Mon, 25 Feb 2019 22:46:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <e2794bf1-4a0c-c9aa-eeb3-843c644dbf59@knorrie.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o2TVPmj8OCsXhAGltuoOgJ3GWbGBmKIjN"
X-Provags-ID: V03:K1:r0NEdMG9XSmFueO/I0sxi2qyGulo5g56BWOn9zOf44GkwcNgAgV
 mkbrVccz+dfhD+HxCvEfJuqpOYNgDGFPYeegzIKW4V3BMcHVNhPiy6WujIZUcjTi2d/oxFP
 BiSK0V+1DdahH2hSjXDUhlkltYMhwUrP+F2QFj0N7V9BDl0sVWeEaD/Ntyzlc1jR1viCuY5
 /aFmbYMz6NkJi2ssisjAw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PCVMaGXxOyo=:sPiGYFH8fAVVdpfGE+llOu
 GMOZuFVytiTzp7xmgIRdlWTovY7KH12WD99n4C76KSLewLsCDP23j/ERKf+gFexZ8Gd5fbISF
 bWZaEhDVRmdWieoKhM1ViyON6zmdEiMLHgX4asHAg9xdbpCxao9tKrZIpiRJToHtQLctSC5sj
 PPb0PcChIIietLKCkNfHoHIfkdlqCCzzVkhBOzXbqUqEmZTLR9SpTkUode7ANaC3FW0CMnUQF
 pJO2MR9O2447fSfJzYdRVVjt9+qxspAL8c5Lv22eJx5PoW06FYTDi3qDognwkpDgfKSDJdw77
 aQ1/i2TN/inO+Mc6ta4/PmM5+IMa8T72ONbTrtUjfqbbw/kKawpnwU6FuuYlYw6XgFFWggy6M
 Zi6EP9pitudZklgqDB6VHFV9pukuCsP6UJx6bALWy5AkEI49ws4TqAwEVwQCqE5P/99mqlwZF
 ZkkYtrScj0U58DQ26HOMIqbXtzSS4IvvI07WExz3eFImz23GXNrtVD8S6Y+Vk8J5j/FiMpenI
 a+DmWc4y3wQZqqNcTxfLONeKTZOv3QMIdiWF9IiGACin2E6anBwxT8UxOzC00Xw1smpewkRXQ
 xxwcsrYHipgkV05JCqONZ27wYwQKTYlUCoefd65ZsW7f5xrgeNI5Bn47oVQtegSMW9brIfFdX
 3AbpJMQBzjCfSJbHl0AWSiO4VlupNCsotrlzojdqNQzAsqpuExHd0rNqK9Dl4TQbWHSWc3kFr
 JsbznhCLT6QVSZERtB+0hv2H7VbBTbsU6vKkBwpJd7uw04c1iCfSDion4zgByYy9bxB184ql2
 Nx0CvMtCJlISlPtrlk/zQvarQB8wh+tdvrh2OVrvF/EqGgdGkV98H4G4FlOiN0slYUQ4saQHk
 T2ahgIdZ5qc4yc3D4yY2Znq+yhQfE5O98coNPpJD95Zri/kvrHF+9rWqbzzqhm
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o2TVPmj8OCsXhAGltuoOgJ3GWbGBmKIjN
Content-Type: multipart/mixed; boundary="9AZDDf6EaXtupWLoyju09hDMstJRqhloO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans@knorrie.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <6a1bb4d1-cf3e-865d-c597-e50e65a4423a@gmx.com>
Subject: Re: [PATCH 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
References: <20190102052945.16325-1-wqu@suse.com>
 <01eb72d8-73b2-049e-a6f4-37668742a2b8@knorrie.org>
 <79f01a1d-97b3-d7c1-91b7-01b7830b3f18@gmx.com>
 <e2794bf1-4a0c-c9aa-eeb3-843c644dbf59@knorrie.org>
In-Reply-To: <e2794bf1-4a0c-c9aa-eeb3-843c644dbf59@knorrie.org>

--9AZDDf6EaXtupWLoyju09hDMstJRqhloO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/25 =E4=B8=8B=E5=8D=889:16, Hans van Kranenburg wrote:
> On 2/25/19 2:10 PM, Qu Wenruo wrote:
>>
>>
>> On 2019/2/25 =E4=B8=8B=E5=8D=889:02, Hans van Kranenburg wrote:
>>> Hi Qu,
>>>
>>> On 1/2/19 6:29 AM, Qu Wenruo wrote:
>>>> This patchset can be fetched from:
>>>> https://github.com/adam900710/linux/tree/bg_tree
>>>> Which is based on v4.20-rc1 tag.
>>>>
>>>> This patchset will hugely reduce mount time of large fs by putting a=
ll
>>>> block group items into its own tree.
>>>
>>> I'm going to test this.
>>>
>>> Is there some specific command you'd like me to use to produce result=
s
>>> for benchmarks?
>>
>> Nope. If I provides some commands, those must be super beneficial for
>> BG_TREE.
>=20
> Ah, I meant, to produce output for the mount timings, like your 'ftrace=

> function graph'.

I don't have anything better than ftrace function graph so far.

I assume you may need extra scripts to parse such output to create some
beautiful graph.

Thanks,
Qu

>=20
>> So just use whatever you like, near real world use case would be more
>> appreciated.
>=20
> Hans
>=20


--9AZDDf6EaXtupWLoyju09hDMstJRqhloO--

--o2TVPmj8OCsXhAGltuoOgJ3GWbGBmKIjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxz/+MACgkQwj2R86El
/qj28gf/bKr77Tm3knf6jcS81eQhfbe6ezgWbJMziJ2gTe0iYRNCWF2LjWQkB75p
we9zOLWrNhO4nZJjJSbl5EDn+wlcsbKQWJlePe7ENbgAH9ZPV+bgrk94iTgR626X
9rWBwcYpkBfTOYfZGQy1RsEc7EsVi/U+T/NGxybsorQVTJ02P7cQNRNQYld8rYtY
/ZunhiVjsOxs8CpijGT9pZA8HHxE+1YBk0K7xK0jcPKDseMQe8KpuLz6en5zTNmi
Wc9ne2opR/SMHL4qG0ylOYe5BNMxxfMqrK3WMhYIhV04G3wadoHkhjSYEt6iBVMR
VQTL/cEY1hqb+Bg6f3yNLTQtUlk1eQ==
=xWT0
-----END PGP SIGNATURE-----

--o2TVPmj8OCsXhAGltuoOgJ3GWbGBmKIjN--
