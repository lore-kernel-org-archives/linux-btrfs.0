Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10C2C282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 02:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FA02175B
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 02:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="KkdRk2WV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDFCRx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 22:17:53 -0400
Received: from mout.gmx.net ([212.227.15.19]:40303 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfDFCRw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 22:17:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554517069;
        bh=SIez4lW98bBvrRqcy7I7An7OaIItdXzp2VTZ8PYpaFo=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=KkdRk2WVG8cmZ2mYLaY6IhMev/1THhFINmFK/33aI2CcHAcMgXtC3xtwVvxYNefWx
         V80GXS/JzD4qn2Ym24C3woJJf1m/PgqzYbZfjP8I0/SILYmCqub4BM8XASoZdP+gNz
         OPCfmp8Bir4sNAl6AydOvnF4OO+Bs6WZtbsEwKUg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M6zkD-1h0zTK3vKn-00wjyn; Sat, 06
 Apr 2019 04:17:48 +0200
Subject: Re: corrupt leaf, bad key order on kernel 5.0
To:     Hugo Mills <hugo@carfax.org.uk>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <af457d27-16b5-2900-8289-98462b6de770@mokrynskyi.com>
 <20190405193218.GC1084@carfax.org.uk>
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
Message-ID: <71dd7ece-7b58-98d8-cd33-7c543213d69f@gmx.com>
Date:   Sat, 6 Apr 2019 10:17:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190405193218.GC1084@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s2P2piMWGJXjXtSzk6pOEatKBTpJzjl1P"
X-Provags-ID: V03:K1:k4nVq4KQhzLZvWnIyyKUPjJ9N3KDORe2cOXiXbo3hYJ+01MsSJ6
 s++VolBiWyeCoq7cwt8bg+h1bW/JacXXt3lu68oKhZ2loRN3lBAS2m5gf3H5q8nKmVebXgT
 eXjxctmk2cKi0y1nHUc1cUGKVXBlw+gY2TDeI0exlDI6DrZVGqWOT4jWorIq7qdCj6aippN
 CswdZkm8tIY6N1vWpP5Fw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mAMplH8aVqQ=:6NPbAMJvDBchbkBTGVNRvs
 qgW3ib1hFTG8rOuAWEcax74GF9BwVYwAJKet+lsn5wXGjp0JTSv49MYgq2QVYE0E/m9PwpY5A
 Fv/PW3XALttrRD76pj8ZLCcZq360ZoL4rJU6CWZMKlRzW4mt0Oicz7rc+ldEPoPDXfny+NOCm
 RABg9RgnuxcgTHBFzNy5SENaLgO6Y39cfZlzgl+pb6n8P/6Tzza7GwGmNiADXV1lAjHAGhAiD
 WHHMwXeBQZ7rGT+YGPD+24maCOVqi/ITby1xsGohE+3X6HvKNL60w0XgZawUBvWWX5lQ0+mXg
 UNWhegSQWz4qTu0waU2qNQkCNEwO+qVFzCehrMBW0c+1taJ3PNPPpCAn7Nz94fnGg7dN9yDRk
 OEIFrmvQLbyrOk7RlrO+pirlpe23e0mL0aVr7LrXb7lWOlgdvzAYClACwu3UgGibWR06gF7t4
 uhD4Lty8wKwozymPMmsv1E/FcZx4GmngdwWPoPHtiZ5A8Us+d/khLGtOpM2jNGJKlsTMqGNZt
 HhtDziZ1wejOOay6JiQRrDTbl9T6S9Ivi9ewz9Ni16sA86TVFJ4lYEB/tYUss4IMnz+RoQFXS
 LZtJ+N/RhddsbaYAmECR9vMO0QSJ+gQKFrhmpERsQGaHEbJgh+w1x+5ZOmXIQE4uMyPgf2myo
 MSxMnf0gkO6Oq6yV0t2OwET2+M+zHZBjOO10/YJ92gHYhLBsTEEB0JSENZnrCnxUw05yea7tR
 rM3IgPzlUC1LAKhAClPo7HTb7Xj2p+8KolRyUcdpBk9PzeKnd1fV/Sw7p5OWuRWD7AAkEwPDv
 It0Nsen6/kZuLBVn9GqCpJ6qsl8gX3cvT0ZAfmUao6I65bf8GcZiQscSIc6C1AHvRjMYULGfj
 LF998m5/b4zf0hXRZj0gh3Re5X/pysJu3ASQ7s01BICXgPl+tXXS+ogQDEywps
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s2P2piMWGJXjXtSzk6pOEatKBTpJzjl1P
Content-Type: multipart/mixed; boundary="5vQgQL6guG1iDCN8Y2mBZY4gXPPBbSVSs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hugo Mills <hugo@carfax.org.uk>, Nazar Mokrynskyi <nazar@mokrynskyi.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <71dd7ece-7b58-98d8-cd33-7c543213d69f@gmx.com>
Subject: Re: corrupt leaf, bad key order on kernel 5.0
References: <af457d27-16b5-2900-8289-98462b6de770@mokrynskyi.com>
 <20190405193218.GC1084@carfax.org.uk>
In-Reply-To: <20190405193218.GC1084@carfax.org.uk>

--5vQgQL6guG1iDCN8Y2mBZY4gXPPBbSVSs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8A=E5=8D=883:32, Hugo Mills wrote:
> On Fri, Apr 05, 2019 at 10:11:57PM +0300, Nazar Mokrynskyi wrote:
>> NOTE: I do not need help with recovery, I have fully automated snapsho=
ts, backups and restoration mechanisms, the only purpose of this email is=
 to help developers find the reason of yet another filesystem corruption =
and hopefully fix it.
>=20
>    That's good news, at least.
>=20
>> Yet another corruption of my root BTRFS filesystem happened today.
>> Didn't bother to run scrub, balance or check, just created disk image =
for future investigation and restored everything from backup.
>>
>> Here is what corruption looks like:
>> [=C2=A0 274.241339] BTRFS info (device dm-0): disk space caching is en=
abled
>> [=C2=A0 274.241344] BTRFS info (device dm-0): has skinny extents
>> [=C2=A0 274.283238] BTRFS info (device dm-0): enabling ssd optimizatio=
ns
>> [=C2=A0 310.436672] BTRFS critical (device dm-0): corrupt leaf: root=3D=
268 block=3D42044719104 slot=3D123, bad key order, prev (1240717 108 4144=
7424) current (1240717 76 41451520)
>=20
>    "Bad key order" is usually an indicator of faulty RAM -- a piece of
> metadata gets loaded into RAM for modification, a bit gets flipped in
> it (because the bit is stuck on one value), and then the csum is
> computed for the page (including the faulty bit), and written out to
> disk. In this case, it's not obvious, but I'd suggest that the second
> field of the key has been flipped, as 108 is 0x6c, and 76 is 0x4c --
> one bit away from each other.

Furthermore, 108 is EXTENT_DATA_KEY, a completely valid type, while
there is no key type assigned to 76.

>=20
>    I recommend you check your hardware thoroughly before attempting to
> rebuild the FS.

Hugo's completely right.

Very much a symptom of memory bit flip.

>=20
>    Hugo.
>=20
>> [=C2=A0 310.449304] BTRFS critical (device dm-0): corrupt leaf: root=3D=
268 block=3D42044719104 slot=3D123, bad key order, prev (1240717 108 4144=
7424) current (1240717 76 41451520)
>> [=C2=A0 310.449309] BTRFS: error (device dm-0) in btrfs_dropa_snapshot=
:9250: errno=3D-5 IO failure
>> [=C2=A0 310.449311] BTRFS info (device dm-0): forced readonly
>> [=C2=A0 311.266789] BTRFS info (device dm-0): delayed_refs has NO entr=
y
>> [=C2=A0 311.277088] BTRFS error (device dm-0): cleaner transaction att=
ach returned -30
>>
>> My system just freezed when I was not looking at it and this is the st=
ate it is in now.
>> File system survived from March 8th til April 05, one of the fastest c=
orruptions in my experience.
>>
>> Looks like this happened during sending incremental snapshot to the ot=
her BTRFS filesystem, since last snapshot on that one was not read-only a=
s it should have been otherwise.
>>
>> I'm on Ubuntu 19.04 with Linux kernel 5.0.5 and btrfs-progs v4.20.2.
>>
>> My filesystem is on top of LUKS on NVMe SSD (SM961), I have 3 snapshot=
s created every 15 minutes from 3 subvolumes with rotation of old snapsho=
ts (can be from tens to hundreds of snapshots at any time).
>>
>> Mount options: compress=3Dlzo,noatime,ssd
>>
>> I have full disk image with corrupted filesystem and will create Qcow2=
 snapshots of it, so if you want me to run any experiments, including pot=
entially destructive, including usage of custom patches to btrfs-progs to=
 find out the reason of corruption, would be happy to help as much as I c=
an.
>>
>> P.S. I'm riding latest stable and rc kernels all the time and during l=
ast 6 months I've got about as many corruptions of different BTRFS filesy=
stems as during 3 years before that, really worrying if you ask me.

This is because btrfs is way more strict on any possible corruption
(sometimes too strict during development cycle, but this time is a real
problem).

I'm afraid it will report more and more problem, but at least next time,
it won't cause mount failure, but transaction abort before writing bad
data into disk.

Thanks,
Qu

>>
>=20


--5vQgQL6guG1iDCN8Y2mBZY4gXPPBbSVSs--

--s2P2piMWGJXjXtSzk6pOEatKBTpJzjl1P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoDEYACgkQwj2R86El
/qj22Qf/R+9pTc/ifxlMZsrcglqWJUMyYjcs7j0TPsFs/uQcalDt6oXwI1+GgaWT
pA334Uy8tdU3AvD6hkAjTLZKqmukiYKfQs6MdVS6wYsdA1NJbs3xJQZe7quvV6t7
WLj+x+yUhcYSUC7etLTGVQbavV/LiQrwBlLQ/KaNtpsA6uRUxMzaPkAGcDhg937P
RCOjAp05JfNHzaFjAGTr1Ume/PGsqr56l6iYStJo4W7eB3+mF/6xYZaPlxqYDkYv
xr0XSqM01udqU1AabG/IOKWi3clSedibZVeNBnE2YDVgXyXSVYi7U40HSiz1ThpE
WInnF7JJcXYPiymSyuziG0yFtqXjgg==
=OOHr
-----END PGP SIGNATURE-----

--s2P2piMWGJXjXtSzk6pOEatKBTpJzjl1P--
