Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E252CC10F06
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFEB62173C
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="JMr3/V5L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbfCaORU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 10:17:20 -0400
Received: from mout.gmx.net ([212.227.15.15]:35825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbfCaORU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 10:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554041835;
        bh=DXMvuvpqag9aYv7sxMfTjvKNjzME+sKbQCU4NMxGfxM=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=JMr3/V5LygiC1BpXOuMZOtYnDziZpLtC/G2ZBzz4x3UV7a7SSD9Gv3R3q0A42LjM9
         b9dPsyYr92a4cp4YExGqQPu03wsPLiFi1/moxA5ZW4LuCk7UmQTI0T005TJiOaRQxk
         oi3JMmYSSkrDBltI2NCyncKokUi9Si2B/h+6fVRY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0McVns-1hS87d0VNo-00Hba9; Sun, 31
 Mar 2019 16:17:15 +0200
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Hannes Reinecke <hare@suse.de>,
        Alberto Bursi <alberto.bursi@outlook.it>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
 <371167e3-b1d1-48f5-e8a3-501cc41bddf6@gmx.com>
 <a340c3a4-65e7-a1f1-89a0-6b922dfb8755@suse.de>
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
Message-ID: <1ab38ef8-93b4-5b2d-4e10-093ba19ede13@gmx.com>
Date:   Sun, 31 Mar 2019 22:17:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <a340c3a4-65e7-a1f1-89a0-6b922dfb8755@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i6OZsnQgFw3IfWKYsiAIR5uJJPobf9vdf"
X-Provags-ID: V03:K1:B4QKmtHcr01eSvL14TgukPGd6xSJhbsQ216hRbcGPkawYuaw0Iw
 oqJqdjd4QNDGINR9ozDpP7KU9U+BbiBeKQ7S2hrBSesDWJrAtV39ZAHre/Vu28+FE/xCSXS
 d5yINZKmQVMlsvLSRa21ZBbQZUWO067waHCWNAanwuqFdvvHXhlI65fm1kLPKY48ZvTgSWK
 Uy9Wl0k4LSz6IbWGnhPAg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cw2zJBGE8iM=:QnEv5uk6809577MJ7LEIW8
 koGILmloxIPsri6JwefwObfga2L0felEHGthJlvqhTVp1qoRGKsPUkCYpH8HoFoMV4BOXqtRa
 3xrmW5l1z4K6TKhHuP9o5WiP2cbjyMgS/X4bejQaCVrFEPbGgAozTBQynti63PNq3J7bf1ucC
 8+zHewf9xQOgSUj0bZMDXCw4FnM9yjZpTlHbPA+dGtvFBWOvfpgAMTpwD5Ns7DKB9sctMewzx
 Wh7Gb1bgeTw/fz9uLkx0kDo0/NR94De6RqnIcF//1NpgzLcY06zavHxZ/zLJuamI1/sJ6JQpo
 dGzM/SI+5qdRVVd/kdYGFNjSYSpJoh9y+0m7QSzLP08LrOE/oosUzouEe7Mng+fI4O0i86XDb
 7705pi+4ZvoLhpteqnj34Jm0Z30XVyFJznBdyAjO4I8VQQO79hpOxNnYtjGeH0b+RRQGr8ta7
 RQ/u/ApWAUZKowSNLDKjaltDWRstxrWe16BdwJ+R7B4BMCF2OL58Wpmhur0ZMMQ3d26ggZVgJ
 dMHvzk13Tgz9o3W10TjaUVcVBUpZS+nFLJNojOs9TdJ4Wr0xyLBLyQ3/mtD3qqULcqsNLlqwu
 8UOHSLUPpj/DeSCKYxTQT42pQkn6BTjc6/p+6rzGi0h7WYqpc1Fj4/ZfzfVGiUPWMOnKAQ4vt
 s+PIbJMlSntGbwENe3fYyAbjcIkIDESqwU83EhV6R+fjrA66eBvQxmy5UzAISxffnu7XXJ729
 ELzgZph+Q5HAF+NdETINk/aHJTkmeAjNjGYMBiHETWrSNoc5XNXWLC/fqwWJSUZN4ucT2P2y8
 sHxgdTsRqsPKZfhzpSQzP6InDsNDxR06IaMaPCJzoY0wKO0wOhhXIrcPIbhT5aP316KGnWKxc
 ej4xP9Paf0Up73iVdLZ+SrGCjVBgLaqbM8hLLD+7YyL4IB6/OmNcG6ay0CTze/
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i6OZsnQgFw3IfWKYsiAIR5uJJPobf9vdf
Content-Type: multipart/mixed; boundary="Abn9scbzgb8CAjhPGZgPNaxkH34evZCsc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hannes Reinecke <hare@suse.de>, Alberto Bursi <alberto.bursi@outlook.it>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Message-ID: <1ab38ef8-93b4-5b2d-4e10-093ba19ede13@gmx.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
 <371167e3-b1d1-48f5-e8a3-501cc41bddf6@gmx.com>
 <a340c3a4-65e7-a1f1-89a0-6b922dfb8755@suse.de>
In-Reply-To: <a340c3a4-65e7-a1f1-89a0-6b922dfb8755@suse.de>

--Abn9scbzgb8CAjhPGZgPNaxkH34evZCsc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/31 =E4=B8=8B=E5=8D=889:36, Hannes Reinecke wrote:
> On 3/31/19 2:00 PM, Qu Wenruo wrote:
>>
>>
>> On 2019/3/31 =E4=B8=8B=E5=8D=887:27, Alberto Bursi wrote:
>>>
>>> On 30/03/19 13:31, Qu Wenruo wrote:
>>>> Hi,
>>>>
>>>> I'm wondering if it's possible that certain physical device doesn't
>>>> handle flush correctly.
>>>>
>>>> E.g. some vendor does some complex logical in their hdd controller t=
o
>>>> skip certain flush request (but not all, obviously) to improve
>>>> performance?
>>>>
>>>> Do anyone see such reports?
>>>>
>>>> And if proves to happened before, how do we users detect such proble=
m?
>>>>
>>>> Can we just check the flush time against the write before flush call=
?
>>>> E.g. write X random blocks into that device, call fsync() on it, che=
ck
>>>> the execution time. Repeat Y times, and compare the avg/std.
>>>> And change X to 2X/4X/..., repeat above check.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>
>>> Afaik HDDs and SSDs do lie to fsync()
>>
>> fsync() on block device is interpreted into FLUSH bio.
>>
>> If all/most consumer level SATA HDD/SSD devices are lying, then there =
is
>> no power loss safety at all for any fs. As most fs relies on FLUSH bio=

>> to implement barrier.
>>
>> And for fs with generation check, they all should report metadata from=

>> the future every time a crash happens, or even worse gracefully
>> umounting fs would cause corruption.
>>
> Please, stop making assumptions.

I'm not.

>=20
> Disks don't 'lie' about anything, they report things according to the
> (SCSI) standard.
> And the SCSI standard has two ways of ensuring that things are written
> to disk: the SYNCHRONIZE_CACHE command and the FUA (force unit access)
> bit in the command.

I understand FLUSH and FUA.

> The latter provides a way of ensuring that a single command made it to
> disk, and the former instructs the driver to:
>=20
> "a) perform a write medium operation to the LBA using the logical block=

> data in volatile cache; or
> b) write the logical block to the non-volatile cache, if any."
>=20
> which means it's perfectly fine to treat the write-cache as a
> _non-volative_ cache if the RAID HBA is battery backed, and thus can
> make sure that outstanding I/O can be written back even in the case of =
a
> power failure.
>=20
> The FUA handling, OTOH, is another matter, and indeed is causing some
> raised eyebrows when comparing it to the spec. But that's another story=
=2E

I don't care FUA as much, since libata still doesn't support FUA by
default and interpret it as FLUSH/WRITE/FLUSH, so it doesn't make things
worse.

I'm more interesting in, are all SATA/NVMe disks follows this FLUSH
behavior?

For most case, I believe it is, or whatever the fs is, either CoW based
or journal based, we're going to see tons of problems, even gracefully
unmounted fs can have corruption if FLUSH is not implemented well.

I'm interested in, is there some device doesn't completely follow
regular FLUSH requirement, but do some tricks, for certain tested fs.

E.g. the disk is only tested for certain fs, and that fs always does
something like flush, write flush, fua.
In that case, if the controller decides to skip the 2nd flush, but only
do the first flush and fua, if the 2nd write is very small (e.g.
journal), the chance of corruption is pretty low due to the small window.=


In that case, the disk could perform a little better, with increase
corruption possibility.

I just want to wipe out this case.

Thanks,
Qu

>=20
> Cheers,
>=20
> Hannes


--Abn9scbzgb8CAjhPGZgPNaxkH34evZCsc--

--i6OZsnQgFw3IfWKYsiAIR5uJJPobf9vdf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlygy98ACgkQwj2R86El
/qjs2Af/TQHHa9lS2B8Dw0yoFWcJ5aSClPPfCl9w3O9I+UJqw6iN7KMQtZd3ZfH6
spde0ykEjU+xyOhvwPVVp44107A9tLx5YBeUdCDa8u8XfP2mntH2gd67G3VA0gr7
ZnyOofHAzxDbNMOQuPOYtbyWBPSjJVHSfrnIYV0xYeQbKtLBNZFcYRydwFKI4TVt
byvi3fmWtlbWGV4cbE8kHolZlslH/Q+bGZbJcMKSZAAIO1Qak5BuFkDNybOCUdBs
ZpPGoOmHIR5QhtCPD2g9XWtu3H+fHo9TnD7stkQXwHckeKtSmteRjPzXlcWHjBHc
gfODJbpTsGR607JHwr3ljlVrnQnO2Q==
=n0jN
-----END PGP SIGNATURE-----

--i6OZsnQgFw3IfWKYsiAIR5uJJPobf9vdf--
