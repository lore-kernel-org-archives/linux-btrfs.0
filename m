Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49717C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 23:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 213CD20830
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 23:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfB1Xbd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 18:31:33 -0500
Received: from mout.gmx.net ([212.227.17.22]:53763 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731080AbfB1Xbc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 18:31:32 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MGWR2-1gmHkJ070K-00DDLn; Fri, 01
 Mar 2019 00:31:23 +0100
Subject: Re: [PATCH] btrfs: qgroup: Don't scan leaf if we're modifying reloc
 tree
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181213054856.22340-1-wqu@suse.com>
 <20190228182603.GQ31119@twin.jikos.cz>
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
Message-ID: <10fcd431-d365-056b-a052-2f887905cc86@gmx.com>
Date:   Fri, 1 Mar 2019 07:31:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190228182603.GQ31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CdGk7sIXKmu7w4jAWWSzx6lMloPXFAY71"
X-Provags-ID: V03:K1:XiC47qobl6J3z5AFO4bRuiEkaFfLYk3lw+id3DKtzu/2e5ZcY0V
 peXF8TjdV+Y7fPf8x4lw3tyq7tGvLWiIsqfyocl78ZX1KoIloDnfUumygCNPhlVO/Cqd267
 +Tazfd/HZTT0dK3btWwCcBTJkFZsYSOX1ocKpBssT1UhfaaIRNFhlVRqqd7Jvl4wajq8EQL
 CkTOnpeFub3mVA+K7n9+A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ly5C41i4iBQ=:qRApzHfGWDtp175OlgFZP1
 WHtQQJyOJt6j6W3oungn8mce8yCKfdYsl7qUvCjLGLvkf18vf+x3NJCitAbmW+Hhi84gbQYbh
 vORXI3Npz3Ob15Wu3SSnPlZjHHNuj8MPEhMTdtgE7f7FoR0g2NvMCs32si8cqEOhaWEluYSGA
 bwwFLTbDwiObI6GIDjtryA165MJN/HErD31ZNR+IqWt2i82nRz+tOCxUP+DfFsFCUWHsJZi7f
 PuJRso9xOgJxokMTf0oaQNO0BZsuk/aIQ0lOU/IMw5QQ8risdLJPrL+zKA2RTtoigMwjMk9fK
 KJobzGz9mn8YLGtpBCe0bJQqwnTDXXJV7dupAzxcAUsl9AjJi5l5SgZXTd+zWpyyrBb3pFmbi
 3M1sZBtPWErg2oYzo2/ETmzFfRR5DbzMi+FuCE5bCytNor5gd6f4ImolkyXu0sIhpqMfZRNyO
 zByFhi/M530v+xE4DMKDgSFNDSTieH6H86U/rgKpMNPyKuf0w8AFSWXl5c+nIM92KixwTH+OE
 Rjps+1DrRpnUDQ7dRBcoc+dFuCABSztD0yRmal0Y1T8Ke7+o3rYnvfT8NXqsIu6MCZ1Bm50iI
 cl3U7MNuz/P7jAx3S93tEc9nwC6sMsWIK/y5hq5Nk2z+D+hDcKMmaNP8zVIw5NTVBhuP0vCCI
 fRYd6d3ZQ8fIXAS6f1BUMnwntXuDIEv32snpTHxW2yACV4Sgn+Fb3cfbrS86vBxNrCySJMO1P
 3yL8Vvwfv2ipA9ZsPN2Jwnp5UPSvQ/cp//7CxY0dH0oDz2C19P8YVLzJWlDgm16QwFVRvtytx
 XfTqSjCGtYyVy41cU+lmUyQlT4YWN0f/++Qw79o97EBpQT2hF3p9Bz1Ce/WBandjyJjCJrw6B
 kNXbQHTZfo8rYP5jfy2ZmCl5G1fPE9UYikEBwgmXyNNoMUs3RhT0yvVJKPJV3Q
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CdGk7sIXKmu7w4jAWWSzx6lMloPXFAY71
Content-Type: multipart/mixed; boundary="eG50iTgQru6CMetDUvORwyDy4lREd0KJh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <10fcd431-d365-056b-a052-2f887905cc86@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Don't scan leaf if we're modifying reloc
 tree
References: <20181213054856.22340-1-wqu@suse.com>
 <20190228182603.GQ31119@twin.jikos.cz>
In-Reply-To: <20190228182603.GQ31119@twin.jikos.cz>

--eG50iTgQru6CMetDUvORwyDy4lREd0KJh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/1 =E4=B8=8A=E5=8D=882:26, David Sterba wrote:
> On Thu, Dec 13, 2018 at 01:48:56PM +0800, Qu Wenruo wrote:
>> Since reloc tree doesn't contribute to qgroup numbers, just skip them.=

>>
>> This should catch the final leakage of unnecessary data refs for qgrou=
p.
>> The 4G data 16 snapshots test should explain it pretty well:
>>
>>              | delayed subtree | refactor delayed ref | this patch (*)=

>> ---------------------------------------------------------------------
>> relocated    |           22653 |                22673 |         22744
>> qgroup dirty |          122792 |                48360 |            70
>> time         |          24.494 |               11.606 |         3.944
>>
>> *: Needs to be applied upon delayed subtree scan and delayed ref
>> refactor patchsets.
>>
>> Finally, we're at the stage where qgroup + metadata balance cost no
>> obvious overhead.
>=20
> I don't see this patch in any of the development branches but given the=

> above I think it should be there. It's possible that I have missed an
> update, sorry, please let me know the current status.

This patch doesn't receive any update, so this version should be the
latest version.

Just in case, you could fetch this patch from my
'refactor_delayed_ref_parameter' branch, it's at the last patch.


Please also keep in mind that, the performance can only be reached with
all the delayed ref API refactor. I haven't test it without delayed ref
refactor.

Thanks,
Qu

>=20
> The dependencies have been merged for 5.1 so I could still queue it, an=
d
> the performance improvement is quite desired.
>=20


--eG50iTgQru6CMetDUvORwyDy4lREd0KJh--

--CdGk7sIXKmu7w4jAWWSzx6lMloPXFAY71
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx4b0EACgkQwj2R86El
/qhyeAf/f/zsRLfHgsE9dUrSbm0V+CoG0bdJHeYDf9czbcahGOPGgfKla2YRb3x8
4Wk6Hsqh4IapkGFr0WdlsJ08m3gixebzOD0ZZaMA09LvdWXKQew1pUSIZm20zFk8
3GfR+xMES8FOAIDGbbz7RhviVhDKs2aSxgNbfIHd4oUB1P+IGaZ/s0EFSXffXUpd
RigikavzD4bIs0DyBFYiVc8dAM3YawpXUotbtXaw4JdJGafRSb7MWKTBoAWEkY1v
nmb0xXSU8oM6xw/T8S7bRRQ2HVNsDd61KIXKdwatTBrdGO7QoRvvf8kRbdVQ8yg2
0yqYO9GO4XpZr55KdzlE8qP7Gfwhcw==
=QYCq
-----END PGP SIGNATURE-----

--CdGk7sIXKmu7w4jAWWSzx6lMloPXFAY71--
