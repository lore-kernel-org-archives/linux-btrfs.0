Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC86C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 10:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5BC20868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 10:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE5BC20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbeJLRvP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:51:15 -0400
Received: from mout.gmx.net ([212.227.15.15]:54001 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbeJLRvP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 13:51:15 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MFMEG-1gP9bo43sq-00EJCe; Fri, 12
 Oct 2018 12:19:29 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MFMEG-1gP9bo43sq-00EJCe; Fri, 12
 Oct 2018 12:19:29 +0200
Subject: Re: errors reported by btrfs-check
To:     =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>
Cc:     linux-btrfs@vger.kernel.org
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
 <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
 <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>
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
Message-ID: <979a7a81-6ffc-b0b9-abf4-1ad1ecfcbcd2@gmx.com>
Date:   Fri, 12 Oct 2018 18:19:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P4aIlWhIPVQNsrpQcxOybbI8Rgmb8Yzgj"
X-Provags-ID: V03:K1:rDaIBKrTfvts8E8V61xfG+QncnTDSMGf11cZ2VZJj57zuh1vbCX
 FdY5ZSz0A5b/zKhaO7JlZh9v3yrXtiGmo8Mif3sOWyXqS0nJeM5fQR0mT0Z7HwFvsyJwYYx
 yq5kXh1RCqOPu4CgSlHuYjfMHFfTn/kcJEGR+7pBj5XpslVt2pWR98DJpQd+QoC6enY9wtV
 MtIvgKr0WuIaQUNUwQ3WQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:gfltpg26fcc=:QTO5VqGV1YCraE42sp7PeG
 hfiv7Y6Jnyk+Vth2dfahSm7RoivEmwEISBQKSUxiqiMmYEN04SwJ7m1cK4YDNwtiYKphfAf1g
 NCtzWn03deL7ku6pYaxllmE51j2BNAm8HikrHNJzuKpi94A10KKjdmlYGmEcBXeRlc9PfH+DV
 nZd+BtPVgciCluN2E9AaAZx37a3QjK9TtOhUs5q3K5QSZ7LNlyF9JSyK28dThc0VFv2tuFwDi
 KI5bFB/+7B4Hkqg9B6yR5e0ABS0tU/JzKs8YNU0RDAGY2JAeqcx2ZCHuaExjTv2BPsj/yElFT
 mqSAz29WYmxu5MqZT32wPwGQe+9J93UgS/bl7ubEvIEMNMRhfToQ8rFrDQKHCotFJp1hys4RT
 niRqjTAp1mMusJTq9u1SK51o/dC0Rf8WH2MxBIfm69AGr8wonrmM5WwXaJy8h2hILvuwjJ4Wf
 vmfacoQOvcutxgkS6strzdY9DUaF3DR7zqkjQUwaezoRNZb6Dawg9c1KHQtEasOXNdqfONe88
 qIm/C7288pDnw0V88kY0snWWFMq9YcrkXCEbnHpQAc2w/RovqhL8Cfn6g9SY6GBzBUCa2iINt
 bmei6PDY7gQZ+3UaN3cC3IKaXXlkcfjg2C9UIwQ6fqgirlt/Wcst41B2tH9aEzghVgY9LoAu2
 55n3ldBQpDhhtCQbF0yvLovX3P3f909y83pqUNbM9GgFxDYt/QUDE8taQ49vwpafJ80vGeOsK
 bIf34PB0rALeAxmAA/FWWXBg51PfTjymmQoUpzz/tlJQQ3x0yJc3UysWR0e78juw3Y+qgRZgH
 ESGyk0TYhsqbeiS8+3jnkNQNU9bYw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P4aIlWhIPVQNsrpQcxOybbI8Rgmb8Yzgj
Content-Type: multipart/mixed; boundary="9PnNmgmVtuoHDYxHdWanyTOpuq9LoZgyk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <979a7a81-6ffc-b0b9-abf4-1ad1ecfcbcd2@gmx.com>
Subject: Re: errors reported by btrfs-check
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
 <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
 <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>
In-Reply-To: <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>

--9PnNmgmVtuoHDYxHdWanyTOpuq9LoZgyk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



[snip]
>=20
> Hi there!
>=20
> I ran btrfs check --repair on the filesystem. I dont' have this log
> anymore,
> as it was then sitting on the repaired fs), which is now dead.
> after repairing it I could still mount the fs.
>=20
> as my btrfs send problem still persists (another thread), I decided to
> run check
> again... this time i saved the logs to a different partition as it was =
more
> convenient at that time. here's the output:
>=20
> Checking filesystem on /dev/mapper/sda3c
> UUID: a914c141-72bf-448b-847f-d64ee82d8b7b
> [1/7] checking root items
> Fixed 0 roots.
> [2/7] checking extents
> No device size related problem found
> [3/7] checking free space cache
> cache and super generation don't match, space cache will be invalidated=

> [4/7] checking fs roots
> root 1387 inode 3082380 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 233472
> ERROR: errors found in fs roots
> found 470636822528 bytes used, error(s) found
> total csum bytes: 452176524
> total tree bytes: 4579753984
> total fs tree bytes: 3822665728
> total extent tree bytes: 245301248
> btree space waste bytes: 847442809
> file data blocks allocated: 9670623588352
> =C2=A0referenced 932405829632
>=20
> I did a repair once again but the error did not go away.
>=20
> after rebooting the fs is no longer mountable:
> mint@mint:/tmp$ sudo /tmp/btrfs check /dev/mapper/sda3c
> Opening filesystem to check...
> parent transid verify failed on 166475366400 wanted 127054 found 127060=

> parent transid verify failed on 166475366400 wanted 127054 found 127060=

> Ignoring transid failure
> ERROR: child eb corrupted: parent bytenr=3D166456229888 item=3D22 paren=
t
> level=3D2 child level=3D0

Please run the following command:

# btrfs ins dump-tree --follow -b 166456229888

It could be caused by the fact that btrfs-progs --repair doesn't handle
log tree well.

If that's the case, "btrfs rescue zero-log" should help.

But anyway, feel free to re-create the fs if zero-log doesn't help.

Thanks,
Qu


> ERROR: cannot open file system
>=20
> If anyone wants me to help debugging this issue you will have to respon=
d
> fast, because i need my laptop back in working condition and will soon
> nuke the fs. after all I will try one more time with a freshly formatte=
d
> btrfs partition. if i still get these kinds of errors i will have to
> move back to
> the tried and true xfs :/
>=20
> best regards,
> J=C3=BCrgen


--9PnNmgmVtuoHDYxHdWanyTOpuq9LoZgyk--

--P4aIlWhIPVQNsrpQcxOybbI8Rgmb8Yzgj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvAdS4ACgkQwj2R86El
/qj5dwgAnFPRRDqvzdL+KUXjauWTAP0BRCHp1kz60bQBod3racXZLyIpT/+ezhgq
/IE2fqfWQuSBrgY4CnN0M5AQnjZCFaWzuETotdh8xUb3XGE9glPCzgJHZT+tTQZQ
NsbMIRc2ftVJxhuD8K1ZDLjMz+BsMiIEKq+YX5eFPS4Y8tkd98x1XnsGuE7fNwtX
FD3DvPLMQMn8rMx1Bl7WTDQd0YlOB2Rzcb2KEJYpRQvi7MDqmgwDILfO146N21+F
pCK9XlAFlABsutA8ChnPfg0MyUT2jzlYtUZWWmhdgt/zr8TDCEm2kXzLSP9EbuTB
KURxPsulUuw7Z8yRzajj7adKyn/G5w==
=WFNu
-----END PGP SIGNATURE-----

--P4aIlWhIPVQNsrpQcxOybbI8Rgmb8Yzgj--
