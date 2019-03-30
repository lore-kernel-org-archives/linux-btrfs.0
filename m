Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927D1C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57EAB20700
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="HhmpQdJU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbfC3NAj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 09:00:39 -0400
Received: from mout.gmx.net ([212.227.15.15]:49805 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbfC3NAi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 09:00:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553950836;
        bh=SJulvpwaIYn6OGoiCesihBxycmrfb6p/dxTSpWEWiEs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=HhmpQdJUFV2sw4bRkInF5oBCGjHE1T4vuuMshnlcdHd9S7bPdSwc05TL+x5wI1aR/
         7KshUJjc8qEiWMZ0vQEF5Vm9BjiOUNbjXuwJQhn1KgcKNYCCzPxCsVEb8SLcLXb6gT
         BV4+GrBY2YhyPQVvOgv9H1n801tuC4XRY4RCwStk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MV5tl-1hSYJz4BtV-00YQt6; Sat, 30
 Mar 2019 14:00:36 +0100
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Supercilious Dude <supercilious.dude@gmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
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
Message-ID: <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
Date:   Sat, 30 Mar 2019 21:00:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kg4a6AzWtIyVL1sqmPTERaraa7oGO9wNc"
X-Provags-ID: V03:K1:rFjCH1ksFE+SKxkkqHCfWT+kNs4EpUlklPn7JjySsUkWFxZJN2u
 nBlolxrAi5SOAnt8xu/M38LR3KwwjYse9Vo9VJh7piPofhpo3HNIP5kFn3MGHmvxWQJlgG8
 zp16dIpZqUENbjTIaiqOZYSRBX35tAJ9PMeaMFRIXtQSa8hEum+B/3XFwVRlgXlUdkBWVmF
 DAR6LNAzZ9rzTTIh3KLmg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nfAcDOx4gps=:EEug02oXDsIfinqdWVBrAp
 x+9tBMo58G3K6Fy56VGY6UoC6P5TtWbZ6dIXeoplIICDTwtPpcTUyrMpq+GRYU/rNpopkYNYF
 GTXamM0hHyzPi12CZoI9sOnONaRhWkPybRUFtncjvzydzM7KIbxX+v4rlYegXP6FeLcY9Flrd
 BYjohPuMgH+5SzNPcSJYxPtgtbKmE5t3RJt8EMrWeRq5Hynxyraukx5gOLjmtI+1MQMFCrUjd
 ZSkXN1g/pXoz7lVMPudtJcJa7OE7ykgKtNxOwoB3J8T39TS//kspP+Rst4vIoErmY+ehRJHFx
 cko5zXYLfHkq3NGQ0VrorxMKu1ALhr/4KWZMjNC8Fuk+usah8jAEOGeLqJWTlLhHNHTWvSwty
 3AbZAiCq6a2CKPhhra98omJ2tr10BToqSw3v+30ErBqsqQJo0rCkwP4l/ARvMtoDXpfV46Shk
 IFcfUQHVZka7+spDbQN3NW4S8UfaqRUyDiEEhjZkQTEmr9X+wXB9B9HyuwERE/8HuiLtJsmV0
 CHpTIzpcfBggsbdI2baJ6mmC4S4/kYqkzbAH6ttW30dlLEJjZIAjSIqGOLOwa/NjuFdaEuBb0
 xfBaJxp6T1ZTQUQaVb9gP52vfLdqjglBFK3+v/eZGyRtO+MP9yRwh5L/vqs2ic1hiBAc65j1o
 b2BvrMXqLyfDM0rItJqfMxe2hOn5xlWk7AWrvORq9scVVGGXqcCsZpr3E65F0Zvf57MjD6q2P
 wETLMAHVRqStCycRFXHKwTuBlbr3nxDSahhaMwGIcn+xkW9ZOmTKnp1+Fuf7Hgh/12WAiKZNI
 2IqkekBr2BPF5FHomDt2MekmLFhsm8sqbQT8XAJ0BQn6kN2C1PrNf2AFpyYngfuYu/F001zd7
 cZBxrjokcHx8IsWoj8qjIkUDJkgzwi0y/0tZIGrN4u+/AJmGu3wZsxvXvZy93o
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kg4a6AzWtIyVL1sqmPTERaraa7oGO9wNc
Content-Type: multipart/mixed; boundary="BVY78Cjyw24CWtlDcC2vARtxHRilHetjJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Supercilious Dude <supercilious.dude@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org
Message-ID: <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
In-Reply-To: <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>

--BVY78Cjyw24CWtlDcC2vARtxHRilHetjJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/30 =E4=B8=8B=E5=8D=888:57, Supercilious Dude wrote:
> Hi,
>=20
> This would give a false positive on any controller with a cache as all
> requests would take 0ms until the cache is full and the controller has
> to actually flush to disk.

I'm purposing to measure the execution time of flush/fsync, not write.

And if flush takes 0ms, it means it doesn't really write cached data
onto disk.

Thanks,
Qu

> I am using an HP P841 controller in my test
> system and it has a 4GB cache making every IO instant unless there are
> enough of them that they can't be flushed to the disks as quickly as
> they come in - the latency variation is huge depending on load.
>=20
> Regards
>=20
> On Sat, 30 Mar 2019 at 12:34, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:=

>>
>> Hi,
>>
>> I'm wondering if it's possible that certain physical device doesn't
>> handle flush correctly.
>>
>> E.g. some vendor does some complex logical in their hdd controller to
>> skip certain flush request (but not all, obviously) to improve perform=
ance?
>>
>> Do anyone see such reports?
>>
>> And if proves to happened before, how do we users detect such problem?=

>>
>> Can we just check the flush time against the write before flush call?
>> E.g. write X random blocks into that device, call fsync() on it, check=

>> the execution time. Repeat Y times, and compare the avg/std.
>> And change X to 2X/4X/..., repeat above check.
>>
>> Thanks,
>> Qu
>>
>>


--BVY78Cjyw24CWtlDcC2vARtxHRilHetjJ--

--kg4a6AzWtIyVL1sqmPTERaraa7oGO9wNc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyfaGoACgkQwj2R86El
/qikNAf5AemUu9TcWp9/n90UrO5kXzqseCOFO6MsS2iGBTv8WGbQRB4acWW2ez/X
/mrRc0YIORaGUwhQbOeaGV7/2EA+M+8ac/6thU/FiRxjIDJPowYmSlDcSrDk8TiM
dYjNtt4MIAVM7fwTuS0T7n8iD5o68OP1YqgzpKQIUBFZPH1cLtpeVirztGkfSHko
ShtZjaIT1f7s1SXK4bhgu33fXZOAerUxSflN8arGHEtqMvcem+LJ/5r+Y4f2wYS9
V11ZTWXQxY/PYwM2svDGgsJOTaVRIQwldI1qaVG7H8Zb6hLGeFaXN2xYFOJ1VqCV
f2AY050Bb63ubVjzfxuaTY4btH1jRg==
=3e5G
-----END PGP SIGNATURE-----

--kg4a6AzWtIyVL1sqmPTERaraa7oGO9wNc--
