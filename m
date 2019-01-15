Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600E4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3327220651
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfAOMRx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:17:53 -0500
Received: from mout.gmx.net ([212.227.15.18]:46817 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbfAOMRw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 07:17:52 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M70Td-1hUCze2GAv-00wpJl; Tue, 15
 Jan 2019 13:17:48 +0100
Subject: Re: BTRFS critical corrupt leaf bad key order
To:     dsterba@suse.cz, Leonard Lausen <leonard@lausen.nl>,
        linux-btrfs@vger.kernel.org
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115115109.GF2900@twin.jikos.cz>
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
Message-ID: <1e28687c-b75e-4cc0-d289-5216a6bfabca@gmx.com>
Date:   Tue, 15 Jan 2019 20:17:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190115115109.GF2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HQdZ2xKY5tQXPCMEbrxeBS51HFbTKDc7R"
X-Provags-ID: V03:K1:eitB8P7MAWjUfH4/2cSAvJzoNJKYQcs3pnx42lNUE9zRWRIgOZV
 sNclRjybcHkWhDfBOrVu+H60UR4Hyyt6kN+O9+QJBoHtB93m1SjJCdUmfPfHgO+NAuamhrL
 4jYDqpVJuJne5s28LuDeZTLaMVrWiqfcGgVo1eYG7lwNPUsDIH9wJfz7EZvFkyv78Q1DF3x
 CXuJYw+Pp4NlbFnEhcqKg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:o/QcWClybN4=:wDdV6xne5BqPeVQQgdMV0V
 VAGRmKmfJcE9oXbwD45JFSCzCuTzBsjSy/SYkPVMOGAFo+OUvwt6kyua3lVN/Bg3POlaqS0sX
 yWNkO9axDI+0FwO2OgqBb9zNOwywj5oTqDJSeD7d7AeD1B/H78X+gL9aWASCU4hjHUQHaVaMV
 NS2zkvLThgPispLgjs6tpDCI9XfR6YPqyksGZyoxSsWTN26nADcKJ2/jZQ0lsuejmacvL8HYp
 Rl7u7txlPScQMbI0HAVZUAONd76BBefhvWstKp51FwScgd5nQ38Ano6gN6pR/6Qg0NeiLuAiY
 r0b8U64CEPJz5Hzcl6QKH5PxIq60NYOjFOLtdYZ9+g9UrbATZA3owzVQa0WsR4PHxe5xDGdIl
 TFYTO2IoA6zIizhrBDamknUop6djO+TuYHhmlAJ0ie6y0LT9C4rZcJp9CqTDfpiD40R7JNWQ9
 ZYifoqtCIv5nN+ECcDPOvDvZBLNLfDVJaWvHRq1y0+GWSmT+79uhyxkbyAu6axgbTcRDkhbCw
 5LSwqXSFDJHBp4KzCkfXlBZGRiC4tmWJyELPEE6pKbj8HAUYkdV1IZYURXpdYuiPfKkPx3b/C
 HGeGbPfG1t9+3cqdZs4tzU7lOd4+kgBFw7Z52ZQTsXqjbQBm3v0z4Ksk6TmWHLpmCpzsQfJpF
 6FAfShedEM2bq64MsKkMeGKwRUdtrBeGnGG/EbxMljWsyc3IVTeQTFD73Gs3tWnDPOrUGQ24F
 HNR5/t4+IEcDbuGxyOQXAiuUN8S9CU2q54U1uK8P3l6J5RZGscXs9BJ6LjiCCHc6gmuBoC58G
 NTHXXq5fz50kZQKbjUj4OcC7CQyoKiEcaC0haZ6RPn0kbj6kONvqcdT88CNqNxQTKpdINYqp6
 nzOicshXFLbXwRJNQTWpl64a7iQbLQeDrPNpd8u0OIZuIPir1u2WVNinvVLR4c
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HQdZ2xKY5tQXPCMEbrxeBS51HFbTKDc7R
Content-Type: multipart/mixed; boundary="jSxPTV4kWA5oYe0jtZ9ZC18JnMZHrkbxP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Leonard Lausen <leonard@lausen.nl>,
 linux-btrfs@vger.kernel.org
Message-ID: <1e28687c-b75e-4cc0-d289-5216a6bfabca@gmx.com>
Subject: Re: BTRFS critical corrupt leaf bad key order
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115115109.GF2900@twin.jikos.cz>
In-Reply-To: <20190115115109.GF2900@twin.jikos.cz>

--jSxPTV4kWA5oYe0jtZ9ZC18JnMZHrkbxP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8B=E5=8D=887:51, David Sterba wrote:
> On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
>>> following tree-dumps:
>>>
>>>   sudo btrfs inspect dump-tree -t root /dev/mapper/vg1-root > /tmp/bt=
rfsdumproot
>>>   sudo btrfs inspect dump-tree -b 1350630375424 /dev/mapper/vg1-root =
> /tmp/btrfsdump1350630375424
>>>
>>> The root dump is at https://termbin.com/lz0l and the block dump at
>>> https://termbin.com/oev5 . The number 1350630375424 does not occur in=

>>> the root dump. The root dump has 16715 lines, the block dump only 645=
=2E
>>
>> Super nice move, it shows the corruption and the cause.
>>
>> 	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33=

>> 	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 4=
2
>> 	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33=

>>
>> See the key objectid of key 67 is way larger than item 66/68.
>>
>> And furthermore, it indeed looks like a bit rot:
>> 0x18f19810000 (1714119835648)
>> 0x98f19814000 (10510212874240)
>> 0x18f19818000 (1714119868416)
>>
>> See one bit got flipped.
>>
>> I don't know it's corrupted in memory or on the SSD, although I tend t=
o
>> believe it's caused by memory bit flip.
>=20
> Single bit flips are almost always caused by RAM, not storage (that
> fails in larger blocks or does not even return any data)

Yep, as I don't really think a bit flip could sneak in without
triggering both the disk internal csum and the tree block csum.

>=20
>> But anyway, it can be fixed by patching the corrupted leaf manually.
>=20
> That will fix one instance of the corrupted key, without an analysis ho=
w
> far the wrong key got spred it's still risky.

Looking from the content of the culprit leaf, it doesn't look too
problematic.

I would recommend to fix it first, then do a full btrfs check
--readonly, just as all repair routine.

Thanks,
Qu


--jSxPTV4kWA5oYe0jtZ9ZC18JnMZHrkbxP--

--HQdZ2xKY5tQXPCMEbrxeBS51HFbTKDc7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw9z2QACgkQwj2R86El
/qjhegf/doCJXXkUnEN6nzxKLNQFGF1569se+UFX5UcI465fNscrUIiVs4tDbIhl
TuBcjgmFbKxvVrAbKvlvTyJN/dssp09w3tsfGie+NHHuGBMmsSY6CTnxgUh8CYwQ
ysznyLvydo1SbT4gJoK48ptkSN4S4KQgVvLzINclSp4Zl8/N/s0GT/wlnbOBgsuF
+NX2XqQyzTh1nSzjY/ypWdGlhNLfP+i892Nni0cr0IPWzK8DdbSiq+UkR9A6TPSK
aA812XL90IAkP32PP0TmYNMjzcC+S6wU4s33ZHdWmtEb9rCuD1J4qbMpptEVx0MR
WcUhc7P8fbeuOChRxhKLRNl4R8F0qw==
=i/3e
-----END PGP SIGNATURE-----

--HQdZ2xKY5tQXPCMEbrxeBS51HFbTKDc7R--
