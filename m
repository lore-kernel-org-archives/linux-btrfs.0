Return-Path: <SRS0=9zy5=PO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14E9C43387
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Jan 2019 14:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CCF206A3
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Jan 2019 14:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfAFOM7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 6 Jan 2019 09:12:59 -0500
Received: from mout.gmx.net ([212.227.15.19]:56049 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfAFOM7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 6 Jan 2019 09:12:59 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MFMEG-1gU5wa2Qaa-00EQU1; Sun, 06
 Jan 2019 15:12:50 +0100
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
To:     Giuseppe Della Bianca <giusdbg@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2282965.574ZSNQ4d8@exnet.gdb.it>
 <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
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
Message-ID: <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
Date:   Sun, 6 Jan 2019 22:12:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <2971657.kkKnYu9ILp@exnet.gdb.it>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6AnFUZuEyAzUFgjrRmdUzjv9d771rrvPL"
X-Provags-ID: V03:K1:vkCqeb2XJ6zRHM4lo+vtlEkHxF6H263i2fZARHyuIBIH/uUeUtc
 8mJerxTf7Wxxy8b2Bw2VVQld8aHn06p66rgvKpcGYvMdbxcWK7tLq1dIpGxuMXoomSR5RtJ
 60QNTzxKwzf7nj2lmnbpdIIMyDPqxu+2HFEdo3X59FStXOa6e7RbYRBzNZLkFM1TTud4T8m
 XZFrlGpi4FCTxRJjH9l3w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vgVOtKxD7DU=:9OtzYD7SecGvCPbIa4TMLm
 uJNVt+OemCcyv6yNqA90bZ0S8RqJNDZgDV4MmGB48gWgZbdfCxn+q83/Atq0A7yXbF/a1aV3J
 IKD+wtYy2JriLwEPkPCNz/3NEJD7bO+/gqKEKK2s5krjaXAUHJvU/8tEfqwPixkmy/qoie0VF
 RFzv5QBpFgZdiXKvtBICBS1AcDyeTB5yXzi+Z1k7qEQ97fSdOv2U3lD1uzw/NKiXJQG86pq9I
 79cXDMDKQHUOLfLoLj36syUEjzODFJRjFQ1Cu0jNyEIDHhWtMSfAsO3jsPn9hTY8qjlVhQ/08
 ixQ7mBWlM9oW8sBAdnLGnja5chJzcLMQojyhR/gOvcepg+iiTRaJEyTb+3SBkmzHSCsYHYI77
 byhu6yk6vdbCajoneDpuwmC0i/8FL79VkcRAT51f+qwMJXhls/PPMV6cbqGHPz9BECu4OxmxK
 I5BUkxRAIPhTK3K5DpCYWQh5naVhDQ3lJdDXS1Ky2tVAre1XcE1rUo4rZ129kjOaWAmPUSjNw
 EqlFLOBIBxGW0AxMtCkth1UJOGi9Ipa8W/F6LP3eY91qe90tZFhy64VvgRBMKQc4tyYfE37mQ
 wXv+Pc5QkviaE6FO53g/FcX5nDtmjeK6KXG9GosEvIS1I0EPWATdA8jB043pJNh5tFwDrRBSl
 SGdpDXAPvoDAZS6Ne7r1pLipVpHtJe3XKbMO9TqJI8+Nj9BP4gmAwU+BKBp9Li1uiMULKyBay
 6hXLF6EiO8N3RlKfaElh+vVEukVBAqni8coAoRLMXpCTy2LIqUNq/nJAUu3wItAhqorC1Ue8X
 IiNCviHEJLnaAzGU5F5zqB2mL5mgfi6jgdztL2VT6JsYuRIT4c4zqwNJsAnVhqxW+pC/sFsH2
 Lvq0JXbaZ9vz4DNawxm37QIiCa0NW5QLY4yeaq4wYb5/4kODuZAGkJGGRvTgrt
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6AnFUZuEyAzUFgjrRmdUzjv9d771rrvPL
Content-Type: multipart/mixed; boundary="tPPE8IMYnz4UdCOFfeXPjA7lNLd1ghlxA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Giuseppe Della Bianca <giusdbg@gmail.com>, Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2282965.574ZSNQ4d8@exnet.gdb.it>
 <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
In-Reply-To: <2971657.kkKnYu9ILp@exnet.gdb.it>

--tPPE8IMYnz4UdCOFfeXPjA7lNLd1ghlxA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/5 =E4=B8=8B=E5=8D=888:30, Giuseppe Della Bianca wrote:
> In data venerd=C3=AC 4 gennaio 2019 21:34:03 CET, Jeff Mahoney ha scrit=
to:
> ]zac[
>>>
>>> root     17133 17127  0 17:17 ?        00:00:00 btrfs subvolume sync =
-s 2
>>> /
>>> tmp/tmp.p9SiQ1GnpV
>>>
>>> cat /proc/17133/stack
>>> [<0>] hrtimer_nanosleep+0xce/0x1e0
>>> [<0>] __x64_sys_nanosleep+0x77/0xa0
>>> [<0>] do_syscall_64+0x5b/0x160
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> [<0>] 0xffffffffffffffff
>>
>> Ok, so this is it just sleeping between tree searches.
> ]zac[
>> This part is actually important since we see below that we're searchin=
g
>> for bytenr 76428623872 which, if present, would be in the cut portion =
of
>> your log.
> ]zac[
>=20
> If you want, I can send you the full log (very long).
> From what you wrote below it seems to me that you do not need it
>=20
> ]zac]
>>
>> This is the more important part.  The file system has gone read-only d=
ue
>> to a missing extent backref.  This is corruption.
>=20
> Yes, but this is an autocorruption of btrfs, which occurred (it seems t=
o me),=20
> during a cleanup after a deleting of a snapshoot of an operating system=
=20
> installation (perhaps interrupted by an umount).

Do you have a full history of the kernel versions?

I'm not sure when the corruption happened.
It's completely possible that some old kernel caused the corruption but
not exposed until now.

Also, would you please run "btrfs check --readonly" on the fs?
It should show all corruption.

And if "btrfs check" shows no corruption, then it's completely a bug in
that given kernel (and even current kernel).

Thanks,
Qu

>=20
>> It also means that the subvolume is never going to disappear during th=
is
>> mount and 'btrfs subvol sync' will wait forever.
> ]zac[
>=20
> In my opinion this is bad.
>=20
> The infinite wait occurs during the execution of a backup script, so I =
will=20
> have to find a bypass even for this problem (the sync was a patch to an=
other=20
> autocorruption problem).
>=20
> Gdb
>=20
>=20


--tPPE8IMYnz4UdCOFfeXPjA7lNLd1ghlxA--

--6AnFUZuEyAzUFgjrRmdUzjv9d771rrvPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwyDNYACgkQwj2R86El
/qi8bQgApd4XK778Fr+xXBETtDttxQqDBPIlU+3qBylxveiVxl4bVoG6U5cUDgtF
ZN9L7LKHuTUga2VAMd9EUgFfF1CYfsBKeUQvxApZql4qnHBCT7NDNGKCyGvUfgHl
AZ9C+0a0KRQERs4RNmBJlfVkTZq0FkDMWZTaaRxDcFTjHnMJLWNoUUVSAjDCzUtc
0cYjUMM7Rh8bkuhea6+RhxGSu7AuSPGK3FnldNrwlrj1iAH1Ymjyc1L0C3dIyvDi
HTQ9WfQDQy5+QOnnrQmPFRfbnnWNJvoHrQUcmdd63jZADRZ+roIXPvxv2yvr0W5z
vDwfR1SccPx8eX/PXNNOlssDbr9xxw==
=2iV+
-----END PGP SIGNATURE-----

--6AnFUZuEyAzUFgjrRmdUzjv9d771rrvPL--
