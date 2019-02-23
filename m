Return-Path: <SRS0=jbNX=Q6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064C1C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 00:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D9E205C9
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 00:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfBWAsC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 19:48:02 -0500
Received: from mout.gmx.net ([212.227.17.20]:45755 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfBWAsC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 19:48:02 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MXDo1-1gU0ux32xx-00WFl1; Sat, 23
 Feb 2019 01:47:43 +0100
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
 <20190222151832.GG9874@twin.jikos.cz>
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
Message-ID: <29397247-a244-ea7c-3c34-8e65642b927c@gmx.com>
Date:   Sat, 23 Feb 2019 08:47:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190222151832.GG9874@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PNxN1QOnoVdWrBnG10iwihehCXrEkiTAz"
X-Provags-ID: V03:K1:HRff7oEZpGD9LlcspTxdcAoJlSh1hMpUz879yEXXRpGXfTnY/Ro
 sDsrwKw+1PpngWey0BhfFTCjVb34BVdHuTMYKY5kBLSfWHYhwLiSg5j/dzYS0ZS4aVymwk0
 HZk2+rvruPYmjCAbckLfrYkx+3ZNExDvcNXJXu+zXrD/wwtoCIfT4mDO6+QJNJH9a0fHcwZ
 Ch8uwj9Y+2xFIpvtRqlIA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:EAt+v9+FBHQ=:CkKiW7jF7ddaoQ9SUaZaQP
 KVkXdbtob+7WG7opLmhObVw0XlSSp0u+kGozfj/5GHx7uRMjFlHEjiigY6YjvJ6uvZ5NRLrk+
 5hddo02EoggtBefaW7hinzZ4Vu6a1qVEAKkGn5yWylY3vBwHFpK/787HlettezjnXHbTtDwLj
 0XOti5ANLj9PAh0RxAynESpwOeBroGxGL85GeAGVIgDpSd6scV97qiMM6XR7FyMjT2z+nlEfW
 5YNxCRnoMHQrbU1scLY6lSk1x+fFY4u+J39d+NzMOuAg1Avwq0vKtSmeDpK0TUjjyKapHWLDs
 rP/SV50KfHEJ3InPYIYyFaeEv27zINa1pV9ghBNwk8z9bZr/J3vJl1fqCxG9W710BeaqIhmDa
 VDhFXcA7W4uxNcNOPIExNv8C+d2QoFHwteT5KNdg5YU1yD8y8Jxit8wXQdJrR9xu4BcrATYkC
 +2aA3QQ5tz+8Cuc0ZvoEjHGoaDe3+iT1mdE96C0FNdmyKXu+S/+pQaoZvVEEqN75kjuTUwYze
 AokeuFS1qvIA0r5G8PSAPZVphAPMNnoi05iPHnSifufHUaIRkdfthFKbNRhjymclvwdxXQcEl
 F0mEzHk5FY+sZwXMtrauIxoAz0cBrk9/8mXz3qCTLHU9YLwZN6fqzJoAMiJ4/MSqXUPIbBUKH
 mNNasvaPu2g5HmtXuaWG+0sF4ZLBFjSRYn7y4Y+9RyYCMPaCN3Osf1eP+gFeaO4KBdd28qCpX
 EEJtAayfVvY4eRBDW3Ld7r1jnjK35XiHqQsEd7P0Ktz1SADGqWuKmQ4LUforjPf/MeWjNCOpB
 yHrpjKUO3oeMM2oVVPiqE7EJ/a3Dvewj9q1A4DMe1HpnoTHsmrWVzOevA9RwrDOlwgcgHfjrP
 S2Qu9Pma5wvsCkJIyacTne7hOq5yMdDNgys4r1yBhdY/og2jcuiv1O0+E4N4Et
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PNxN1QOnoVdWrBnG10iwihehCXrEkiTAz
Content-Type: multipart/mixed; boundary="yEgw0V0SbJC7nXquApAErgjijiNBv7ORO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <29397247-a244-ea7c-3c34-8e65642b927c@gmx.com>
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
References: <20190218052753.24138-1-wqu@suse.com>
 <20190222151832.GG9874@twin.jikos.cz>
In-Reply-To: <20190222151832.GG9874@twin.jikos.cz>

--yEgw0V0SbJC7nXquApAErgjijiNBv7ORO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/22 =E4=B8=8B=E5=8D=8811:18, David Sterba wrote:
> On Mon, Feb 18, 2019 at 01:27:41PM +0800, Qu Wenruo wrote:
>> v5.1:
>> - Add "block=3D%llu " output for write/read time error line.
>> - Also output read time error message for fsid/start/level check.
>=20
> I see reports from tests btrfs/124 and btrfs/125,

That two tests are RAID1 reconstruction.
It's known to trigger read error on missing devices.

Especially for bytenr mismatch, as all read from missing device will
result 0 filled page.

I could change the read time error message to skip bytenr/csum mismatch
to avoid such report.

> the tested branch was
> for-next-20190220. Something's wrong, check the large numbers of
> checksums from the messages, eg.
>=20
> hex(506381209866536711) =3D 0x707070707070707
> hex(217020518514230019) =3D 0x303030303030303
> hex(1085102592571150095) =3D 0xf0f0f0f0f0f0f0f
> hex(72340172838076673) =3D 0x101010101010101

The pattern is strange. Looks like some poisoned value.
Maybe we missed to clean allocated pages?

But considering the context, it's from the missing device, it shouldn't
cause much problem.

Thanks,
Qu

>=20
> there's a pattern. And the number of the 'read time' messages is quite
> high to be some random fluke.
>=20
> [ 2847.704946] BTRFS: device fsid 8b8c51ce-59de-439f-847a-bcfce3e10a5d =
devid 1 transid 7 /dev/vdb
> [ 2847.710386] BTRFS info (device vdb): allowing degraded mounts
> [ 2847.713405] BTRFS info (device vdb): disk space caching is enabled
> [ 2847.716586] BTRFS info (device vdb): has skinny extents
> [ 2847.753599] BTRFS warning (device vdb): devid 2 uuid 307c73fe-349e-4=
b34-8233-4e35431aae31 is missing
> [ 2847.758479] BTRFS warning (device vdb): devid 2 uuid 307c73fe-349e-4=
b34-8233-4e35431aae31 is missing
> [ 2859.881984] BTRFS: device fsid e4579131-1621-417b-8464-cfaf6cd15204 =
devid 1 transid 241 /dev/vda
> [ 2859.896416] BTRFS info (device vdb): disk space caching is enabled
> [ 2859.899049] BTRFS info (device vdb): has skinny extents
> [ 2859.992305] BTRFS error (device vdb): bad tree block start, want 321=
61792 have 0
> [ 2859.996611] BTRFS error (device vdb): block=3D32161792 read time tre=
e block corruption detected
> [ 2860.001694] BTRFS info (device vdb): read error corrected: ino 0 off=
 32161792 (dev /dev/vdc sector 21856)                                    =
                                                              =20
> [ 2860.007079] BTRFS info (device vdb): read error corrected: ino 0 off=
 32165888 (dev /dev/vdc sector 21864)                                    =
                                                              =20
> [ 2860.012447] BTRFS info (device vdb): read error corrected: ino 0 off=
 32169984 (dev /dev/vdc sector 21872)                                    =
                                                              =20
> [ 2860.017817] BTRFS info (device vdb): read error corrected: ino 0 off=
 32174080 (dev /dev/vdc sector 21880)                                    =
                                                              =20
> [ 2860.023669] BTRFS error (device vdb): bad tree block start, want 322=
43712 have 0
> [ 2860.027865] BTRFS error (device vdb): block=3D32243712 read time tre=
e block corruption detected
> [ 2860.032961] BTRFS info (device vdb): read error corrected: ino 0 off=
 32243712 (dev /dev/vdc sector 22016)                                    =
                                                              =20
> [ 2860.037602] BTRFS info (device vdb): read error corrected: ino 0 off=
 32247808 (dev /dev/vdc sector 22024)                                    =
                                                              =20
> [ 2860.042185] BTRFS info (device vdb): read error corrected: ino 0 off=
 32251904 (dev /dev/vdc sector 22032)                                    =
                                                              =20
> [ 2860.046738] BTRFS info (device vdb): read error corrected: ino 0 off=
 32256000 (dev /dev/vdc sector 22040)                                    =
                                                              =20
> [ 2860.089197] BTRFS info (device vdb): balance: start -d -m -s
> [ 2860.092227] BTRFS info (device vdb): relocating block group 24798822=
40 flags data
> [ 2860.098064] BTRFS error (device vdb): bad tree block start, want 316=
53888 have 0
> [ 2860.102289] BTRFS error (device vdb): block=3D31653888 read time tre=
e block corruption detected
> [ 2860.107409] BTRFS info (device vdb): read error corrected: ino 0 off=
 31653888 (dev /dev/vdc sector 20864)                                    =
                                                              =20
> [ 2860.111997] BTRFS info (device vdb): read error corrected: ino 0 off=
 31657984 (dev /dev/vdc sector 20872)                                    =
                                                              =20
> [ 2860.166451] BTRFS error (device vdb): bad tree block start, want 316=
70272 have 0
> [ 2860.167172] BTRFS error (device vdb): bad tree block start, want 316=
86656 have 0
> [ 2860.167375] BTRFS error (device vdb): bad tree block start, want 317=
03040 have 0
> [ 2860.167377] BTRFS error (device vdb): block=3D31703040 read time tre=
e block corruption detected
> [ 2860.167384] BTRFS error (device vdb): bad tree block start, want 317=
19424 have 0
> [ 2860.167386] BTRFS error (device vdb): block=3D31719424 read time tre=
e block corruption detected
> [ 2860.167394] BTRFS error (device vdb): bad tree block start, want 317=
35808 have 0
> [ 2860.167396] BTRFS error (device vdb): block=3D31735808 read time tre=
e block corruption detected
> [ 2860.170120] BTRFS error (device vdb): block=3D31670272 read time tre=
e block corruption detected
> [ 2860.174308] BTRFS error (device vdb): block=3D31686656 read time tre=
e block corruption detected
> [ 2860.205288] BTRFS error (device vdb): bad tree block start, want 316=
86656 have 0
> [ 2860.208875] BTRFS error (device vdb): block=3D31686656 read time tre=
e block corruption detected
> [ 2860.244462] BTRFS error (device vdb): bad tree block start, want 317=
03040 have 0
> [ 2860.248013] BTRFS error (device vdb): block=3D31703040 read time tre=
e block corruption detected
> [ 2860.284017] BTRFS error (device vdb): block=3D31719424 read time tre=
e block corruption detected
> [ 2860.315705] BTRFS error (device vdb): block=3D31735808 read time tre=
e block corruption detected
> [ 2860.336001] BTRFS error (device vdb): block=3D31752192 read time tre=
e block corruption detected
> [ 2860.336054] BTRFS error (device vdb): block=3D31768576 read time tre=
e block corruption detected
> [ 2860.339786] BTRFS error (device vdb): block=3D31784960 read time tre=
e block corruption detected
> [ 2860.366693] BTRFS error (device vdb): block=3D31768576 read time tre=
e block corruption detected
> [ 2860.389495] BTRFS error (device vdb): block=3D31784960 read time tre=
e block corruption detected
> [ 2860.418551] BTRFS error (device vdb): block=3D31866880 read time tre=
e block corruption detected
> [ 2860.418713] BTRFS error (device vdb): block=3D31883264 read time tre=
e block corruption detected
> [ 2860.418721] BTRFS error (device vdb): block=3D31916032 read time tre=
e block corruption detected
> [ 2860.418736] BTRFS error (device vdb): block=3D31932416 read time tre=
e block corruption detected
> [ 2860.418744] BTRFS error (device vdb): block=3D31948800 read time tre=
e block corruption detected
> [ 2860.419721] BTRFS error (device vdb): block=3D31899648 read time tre=
e block corruption detected
> [ 2860.462401] BTRFS error (device vdb): block=3D31866880 read time tre=
e block corruption detected
> [ 2860.490821] BTRFS error (device vdb): block=3D31932416 read time tre=
e block corruption detected
> [ 2860.506718] BTRFS error (device vdb): block=3D31899648 read time tre=
e block corruption detected
> [ 2860.535013] BTRFS error (device vdb): block=3D31916032 read time tre=
e block corruption detected
> [ 2860.568602] BTRFS error (device vdb): block=3D31948800 read time tre=
e block corruption detected
> [ 2860.590434] BTRFS error (device vdb): block=3D31965184 read time tre=
e block corruption detected
> [ 2860.590532] BTRFS error (device vdb): block=3D31981568 read time tre=
e block corruption detected
> [ 2860.590677] BTRFS error (device vdb): block=3D31997952 read time tre=
e block corruption detected
> [ 2860.590688] BTRFS error (device vdb): block=3D32014336 read time tre=
e block corruption detected
>=20
> [ 2860.590697] BTRFS error (device vdb): block=3D32030720 read time tre=
e block corruption detected
> [ 2860.590705] BTRFS error (device vdb): block=3D32047104 read time tre=
e block corruption detected
> [ 2860.625834] BTRFS error (device vdb): block=3D31965184 read time tre=
e block corruption detected
> [ 2860.658723] BTRFS error (device vdb): block=3D31981568 read time tre=
e block corruption detected
> [ 2860.696644] BTRFS error (device vdb): block=3D32014336 read time tre=
e block corruption detected
> [ 2860.735014] BTRFS error (device vdb): block=3D32030720 read time tre=
e block corruption detected
> [ 2860.743240] BTRFS error (device vdb): block=3D32096256 read time tre=
e block corruption detected
> [ 2860.780296] BTRFS error (device vdb): block=3D32047104 read time tre=
e block corruption detected
> [ 2860.807073] BTRFS error (device vdb): block=3D32063488 read time tre=
e block corruption detected
> [ 2860.807173] BTRFS error (device vdb): block=3D32079872 read time tre=
e block corruption detected
> [ 2860.841582] BTRFS error (device vdb): block=3D32079872 read time tre=
e block corruption detected
> [ 2862.476657] BTRFS info (device vdb): found 3 extents
> [ 2864.186610] BTRFS info (device vdb): found 3 extents
> [ 2864.190233] BTRFS error (device vdb): block=3D31637504 read time tre=
e block corruption detected
> [ 2864.306413] BTRFS info (device vdb): relocating block group 24463278=
08 flags system
> [ 2864.418449] BTRFS info (device vdb): relocating block group 21778923=
52 flags metadata
> [ 2864.530002] BTRFS info (device vdb): relocating block group 11041505=
28 flags data|raid1
> [ 2864.582024] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2097152 csum 0x6e65c49f expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.582156] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2162688 csum 0x5ce6193f expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.587210] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2101248 csum 0x6e65c49f expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.594057] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2228224 csum 0x89780ae9 expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.594156] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2359296 csum 0xfd497142 expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.594200] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2363392 csum 0xfd497142 expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.594228] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2367488 csum 0xfd497142 expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.594267] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2371584 csum 0xfd497142 expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.594291] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2490368 csum 0xddddd09d expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.594294] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 2375680 csum 0xfd497142 expected csum 0x98f94189 mirror 1            =
                                                              =20
> [ 2864.686125] BTRFS error (device vdb): parent transid verify failed o=
n 30539776 wanted 8 found 5
> [ 2864.859090] BTRFS error (device vdb): parent transid verify failed o=
n 30556160 wanted 8 found 5
> [ 2864.936897] BTRFS error (device vdb): parent transid verify failed o=
n 30572544 wanted 8 found 6
> [ 2865.003123] repair_io_failure: 5828 callbacks suppressed
> [ 2865.003127] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43462656 (dev /dev/vdc sector 2200472)                                =
                                                              =20
> [ 2865.003141] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43683840 (dev /dev/vdc sector 2200904)                                =
                                                              =20
> [ 2865.003210] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43659264 (dev /dev/vdc sector 2200856)                                =
                                                              =20
> [ 2865.003223] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43651072 (dev /dev/vdc sector 2200840)                                =
                                                              =20
> [ 2865.005980] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43663360 (dev /dev/vdc sector 2200864)                                =
                                                              =20
> [ 2865.006063] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43446272 (dev /dev/vdc sector 2200440)                                =
                                                              =20
> [ 2865.006098] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43638784 (dev /dev/vdc sector 2200816)                                =
                                                              =20
> [ 2865.010374] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43655168 (dev /dev/vdc sector 2200848)                                =
                                                              =20
> [ 2865.010425] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43700224 (dev /dev/vdc sector 2200936)                                =
                                                              =20
> [ 2865.010664] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 43843584 (dev /dev/vdc sector 2201216)                                =
                                                              =20
> [ 2865.112654] BTRFS error (device vdb): parent transid verify failed o=
n 30588928 wanted 8 found 6
> [ 2865.267513] btree_readpage_end_io_hook: 34 callbacks suppressed
> [ 2865.267518] BTRFS error (device vdb): bad tree block start, want 306=
70848 have 0
> [ 2865.267544] BTRFS error (device vdb): bad tree block start, want 306=
87232 have 0
> [ 2865.267549] BTRFS error (device vdb): bad tree block start, want 307=
03616 have 0
> [ 2865.267551] BTRFS error (device vdb): block=3D30703616 read time tre=
e block corruption detected
> [ 2865.267578] BTRFS error (device vdb): bad tree block start, want 307=
36384 have 0
> [ 2865.267580] BTRFS error (device vdb): block=3D30736384 read time tre=
e block corruption detected
> [ 2865.267823] BTRFS error (device vdb): bad tree block start, want 307=
20000 have 0
> [ 2865.267825] BTRFS error (device vdb): block=3D30720000 read time tre=
e block corruption detected
> [ 2865.276321] BTRFS error (device vdb): block=3D30670848 read time tre=
e block corruption detected
> [ 2865.380720] BTRFS error (device vdb): block=3D30687232 read time tre=
e block corruption detected
> [ 2865.477717] BTRFS error (device vdb): bad tree block start, want 306=
87232 have 0
> [ 2865.487564] BTRFS error (device vdb): block=3D30687232 read time tre=
e block corruption detected
> [ 2865.628551] BTRFS error (device vdb): bad tree block start, want 307=
03616 have 0
> [ 2865.636510] BTRFS error (device vdb): block=3D30703616 read time tre=
e block corruption detected
> [ 2865.842136] BTRFS error (device vdb): bad tree block start, want 307=
20000 have 0
> [ 2865.845901] BTRFS error (device vdb): block=3D30720000 read time tre=
e block corruption detected
> [ 2866.072213] BTRFS error (device vdb): bad tree block start, want 307=
36384 have 0
> [ 2866.081387] BTRFS error (device vdb): block=3D30736384 read time tre=
e block corruption detected
> [ 2866.253507] BTRFS error (device vdb): bad tree block start, want 307=
69152 have 0
> [ 2866.253527] BTRFS error (device vdb): block=3D30801920 read time tre=
e block corruption detected
>=20
> [ 2866.253538] BTRFS error (device vdb): block=3D30752768 read time tre=
e block corruption detected
> [ 2866.253550] BTRFS error (device vdb): block=3D30818304 read time tre=
e block corruption detected
> [ 2866.263700] BTRFS error (device vdb): block=3D30769152 read time tre=
e block corruption detected
> [ 2866.273628] BTRFS error (device vdb): block=3D30785536 read time tre=
e block corruption detected
> [ 2866.474143] BTRFS error (device vdb): block=3D30769152 read time tre=
e block corruption detected
> [ 2866.576807] BTRFS error (device vdb): block=3D30785536 read time tre=
e block corruption detected
> [ 2866.793977] BTRFS error (device vdb): block=3D30801920 read time tre=
e block corruption detected
> [ 2866.997914] BTRFS error (device vdb): block=3D30818304 read time tre=
e block corruption detected
> [ 2867.157625] BTRFS error (device vdb): block=3D30834688 read time tre=
e block corruption detected
> [ 2867.157684] BTRFS error (device vdb): block=3D30851072 read time tre=
e block corruption detected
> [ 2867.162566] BTRFS error (device vdb): block=3D30867456 read time tre=
e block corruption detected
> [ 2867.162581] BTRFS error (device vdb): block=3D30883840 read time tre=
e block corruption detected
> [ 2867.162591] BTRFS error (device vdb): block=3D30900224 read time tre=
e block corruption detected
> [ 2867.393541] BTRFS error (device vdb): block=3D30851072 read time tre=
e block corruption detected
> [ 2867.556641] BTRFS error (device vdb): block=3D30867456 read time tre=
e block corruption detected
> [ 2867.787270] BTRFS error (device vdb): block=3D30883840 read time tre=
e block corruption detected
> [ 2867.997127] BTRFS error (device vdb): block=3D30900224 read time tre=
e block corruption detected
> [ 2868.205510] BTRFS error (device vdb): block=3D30916608 read time tre=
e block corruption detected
> [ 2868.205532] BTRFS error (device vdb): block=3D30949376 read time tre=
e block corruption detected
> [ 2868.205536] BTRFS error (device vdb): block=3D30932992 read time tre=
e block corruption detected
> [ 2868.205562] BTRFS error (device vdb): block=3D30965760 read time tre=
e block corruption detected
> [ 2868.205569] BTRFS error (device vdb): block=3D30982144 read time tre=
e block corruption detected
> [ 2868.388272] BTRFS error (device vdb): block=3D30932992 read time tre=
e block corruption detected
> [ 2868.592079] BTRFS error (device vdb): block=3D30949376 read time tre=
e block corruption detected
> [ 2868.794379] BTRFS error (device vdb): block=3D30965760 read time tre=
e block corruption detected
> [ 2868.999973] BTRFS error (device vdb): block=3D30982144 read time tre=
e block corruption detected
> [ 2869.207738] BTRFS error (device vdb): block=3D31014912 read time tre=
e block corruption detected
> [ 2869.207772] BTRFS error (device vdb): block=3D30998528 read time tre=
e block corruption detected
> [ 2869.207849] BTRFS error (device vdb): block=3D31031296 read time tre=
e block corruption detected
> [ 2869.207859] BTRFS error (device vdb): block=3D31047680 read time tre=
e block corruption detected
> [ 2869.207865] BTRFS error (device vdb): block=3D31064064 read time tre=
e block corruption detected
> [ 2869.430131] BTRFS error (device vdb): block=3D31014912 read time tre=
e block corruption detected
> [ 2869.583069] btrfs_print_data_csum_error: 178079 callbacks suppressed=

> [ 2869.583073] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400269312 csum 0x5ce6193f expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.583088] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 399634432 csum 0x362910d4 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.584130] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400273408 csum 0xe3b70302 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.586502] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400277504 csum 0xe3b70302 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.586609] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400130048 csum 0x0bd5f454 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.601709] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400281600 csum 0xe3b70302 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.601732] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400134144 csum 0x0bd5f454 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.606867] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400138240 csum 0x0bd5f454 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.606878] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400285696 csum 0xe3b70302 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.606912] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 400289792 csum 0xe3b70302 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2869.678550] BTRFS error (device vdb): block=3D31031296 read time tre=
e block corruption detected
> [ 2869.782906] BTRFS error (device vdb): block=3D31047680 read time tre=
e block corruption detected
> [ 2870.010786] repair_io_failure: 89687 callbacks suppressed
> [ 2870.010790] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430133248 (dev /dev/vdc sector 2955688)                               =
                                                              =20
> [ 2870.010830] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430178304 (dev /dev/vdc sector 2955776)                               =
                                                              =20
> [ 2870.010844] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430116864 (dev /dev/vdc sector 2955656)                               =
                                                              =20
> [ 2870.011103] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430182400 (dev /dev/vdc sector 2955784)                               =
                                                              =20
> [ 2870.011133] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430194688 (dev /dev/vdc sector 2955808)                               =
                                                              =20
> [ 2870.011168] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430112768 (dev /dev/vdc sector 2955648)                               =
                                                              =20
> [ 2870.011313] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430071808 (dev /dev/vdc sector 2955568)                               =
                                                              =20
> [ 2870.011328] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430047232 (dev /dev/vdc sector 2955520)                               =
                                                              =20
> [ 2870.011396] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 430051328 (dev /dev/vdc sector 2955528)                               =
                                                              =20
> [ 2870.011456] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 429916160 (dev /dev/vdc sector 2955264)                               =
                                                              =20
> [ 2870.017915] BTRFS error (device vdb): block=3D31064064 read time tre=
e block corruption detected
> [ 2870.254803] BTRFS error (device vdb): block=3D31096832 read time tre=
e block corruption detected
> [ 2870.254814] BTRFS error (device vdb): block=3D31080448 read time tre=
e block corruption detected
> [ 2870.254816] BTRFS error (device vdb): block=3D31113216 read time tre=
e block corruption detected
> [ 2870.254851] BTRFS error (device vdb): block=3D31129600 read time tre=
e block corruption detected
> [ 2870.254868] BTRFS error (device vdb): block=3D31145984 read time tre=
e block corruption detected
> [ 2870.468150] btree_readpage_end_io_hook: 40 callbacks suppressed
>=20
> [ 2870.468154] BTRFS error (device vdb): bad tree block start, want 310=
96832 have 0
> [ 2870.481275] BTRFS error (device vdb): block=3D31096832 read time tre=
e block corruption detected
> [ 2870.659389] BTRFS error (device vdb): bad tree block start, want 311=
13216 have 0
> [ 2870.663667] BTRFS error (device vdb): block=3D31113216 read time tre=
e block corruption detected
> [ 2870.919169] BTRFS error (device vdb): bad tree block start, want 311=
29600 have 0
> [ 2870.927705] BTRFS error (device vdb): block=3D31129600 read time tre=
e block corruption detected
> [ 2871.058301] BTRFS error (device vdb): bad tree block start, want 311=
45984 have 0
> [ 2871.058336] BTRFS error (device vdb): bad tree block start, want 311=
62368 have 0
> [ 2871.072181] BTRFS error (device vdb): bad tree block start, want 311=
78752 have 0
> [ 2871.072185] BTRFS error (device vdb): bad tree block start, want 312=
11520 have 72340172838076673
> [ 2871.072187] BTRFS error (device vdb): block=3D31211520 read time tre=
e block corruption detected
> [ 2871.072197] BTRFS error (device vdb): bad tree block start, want 312=
27904 have 72340172838076673
> [ 2871.072198] BTRFS error (device vdb): block=3D31227904 read time tre=
e block corruption detected
> [ 2871.072264] BTRFS error (device vdb): bad tree block start, want 311=
95136 have 188978565376
> [ 2871.072266] BTRFS error (device vdb): block=3D31195136 read time tre=
e block corruption detected
> [ 2871.076187] BTRFS error (device vdb): block=3D31162368 read time tre=
e block corruption detected
> [ 2871.081901] BTRFS error (device vdb): block=3D31178752 read time tre=
e block corruption detected
> [ 2871.091522] BTRFS error (device vdb): block=3D31145984 read time tre=
e block corruption detected
> [ 2871.686871] BTRFS error (device vdb): bad tree block start, want 311=
45984 have 0
> [ 2871.701355] BTRFS error (device vdb): block=3D31145984 read time tre=
e block corruption detected
> [ 2871.883082] BTRFS error (device vdb): block=3D31162368 read time tre=
e block corruption detected
> [ 2872.070858] BTRFS error (device vdb): block=3D31227904 read time tre=
e block corruption detected
> [ 2872.209604] BTRFS error (device vdb): block=3D31195136 read time tre=
e block corruption detected
> [ 2872.524825] BTRFS error (device vdb): block=3D31211520 read time tre=
e block corruption detected
> [ 2872.773657] BTRFS error (device vdb): block=3D31260672 read time tre=
e block corruption detected
> [ 2872.773661] BTRFS error (device vdb): block=3D31277056 read time tre=
e block corruption detected
> [ 2872.773668] BTRFS error (device vdb): block=3D31244288 read time tre=
e block corruption detected
> [ 2872.773674] BTRFS error (device vdb): block=3D31293440 read time tre=
e block corruption detected
> [ 2872.773681] BTRFS error (device vdb): block=3D31309824 read time tre=
e block corruption detected
> [ 2872.930060] BTRFS error (device vdb): block=3D31260672 read time tre=
e block corruption detected
> [ 2873.179606] BTRFS error (device vdb): block=3D31277056 read time tre=
e block corruption detected
> [ 2873.346103] BTRFS error (device vdb): block=3D31293440 read time tre=
e block corruption detected
> [ 2873.517863] BTRFS error (device vdb): block=3D31309824 read time tre=
e block corruption detected
> [ 2873.705657] BTRFS error (device vdb): block=3D31326208 read time tre=
e block corruption detected
> [ 2873.705665] BTRFS error (device vdb): block=3D31358976 read time tre=
e block corruption detected
> [ 2873.705735] BTRFS error (device vdb): block=3D31375360 read time tre=
e block corruption detected
> [ 2873.705743] BTRFS error (device vdb): block=3D31391744 read time tre=
e block corruption detected
> [ 2873.706274] BTRFS error (device vdb): block=3D31342592 read time tre=
e block corruption detected
> [ 2874.081625] BTRFS error (device vdb): block=3D31342592 read time tre=
e block corruption detected
> [ 2874.408558] BTRFS error (device vdb): block=3D31358976 read time tre=
e block corruption detected
> [ 2874.587058] btrfs_print_data_csum_error: 132544 callbacks suppressed=

> [ 2874.587063] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 688840704 csum 0x434957d2 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587069] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 688975872 csum 0x0107a017 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587074] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 688984064 csum 0x7ef574ea expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587090] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 688988160 csum 0xf077c653 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587096] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 688992256 csum 0xcd9f8290 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587109] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 689090560 csum 0x9d2a64a2 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587111] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 688996352 csum 0x60f06185 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587124] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 689094656 csum 0x6ad9235d expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.587129] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 689098752 csum 0xe2cb848d expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2874.597159] BTRFS error (device vdb): block=3D31375360 read time tre=
e block corruption detected
> [ 2874.881178] BTRFS error (device vdb): block=3D31391744 read time tre=
e block corruption detected
> [ 2874.892860] BTRFS error (device vdb): block=3D31408128 read time tre=
e block corruption detected
> [ 2874.892885] BTRFS error (device vdb): block=3D31457280 read time tre=
e block corruption detected
> [ 2874.892932] BTRFS error (device vdb): block=3D31440896 read time tre=
e block corruption detected
> [ 2874.893058] BTRFS error (device vdb): block=3D31473664 read time tre=
e block corruption detected
> [ 2874.893063] BTRFS error (device vdb): block=3D31490048 read time tre=
e block corruption detected
> [ 2874.952101] BTRFS error (device vdb): block=3D31424512 read time tre=
e block corruption detected
> [ 2875.011131] repair_io_failure: 65834 callbacks suppressed
> [ 2875.011136] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 711217152 (dev /dev/vdc sector 3504680)                               =
                                                              =20
> [ 2875.011145] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 710975488 (dev /dev/vdc sector 3504208)                               =
                                                              =20
> [ 2875.011167] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 711225344 (dev /dev/vdc sector 3504696)                               =
                                                              =20
> [ 2875.011266] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 711041024 (dev /dev/vdc sector 3504336)
>=20
> [ 2875.011310] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 711348224 (dev /dev/vdc sector 3504936)                               =
                                                              =20
> [ 2875.014273] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 710987776 (dev /dev/vdc sector 3504232)                               =
                                                              =20
> [ 2875.014288] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 710979584 (dev /dev/vdc sector 3504216)                               =
                                                              =20
> [ 2875.014330] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 710983680 (dev /dev/vdc sector 3504224)                               =
                                                              =20
> [ 2875.014400] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 710995968 (dev /dev/vdc sector 3504248)                               =
                                                              =20
> [ 2875.014595] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 711266304 (dev /dev/vdc sector 3504776)                               =
                                                              =20
> [ 2875.147908] BTRFS error (device vdb): block=3D31408128 read time tre=
e block corruption detected
> [ 2875.380354] BTRFS error (device vdb): block=3D31424512 read time tre=
e block corruption detected
> [ 2875.565748] btree_readpage_end_io_hook: 30 callbacks suppressed
> [ 2875.565753] BTRFS error (device vdb): bad tree block start, want 314=
57280 have 0
> [ 2875.581223] BTRFS error (device vdb): block=3D31457280 read time tre=
e block corruption detected
> [ 2875.788290] BTRFS error (device vdb): bad tree block start, want 314=
73664 have 1085102592571150095
> [ 2875.798989] BTRFS error (device vdb): block=3D31473664 read time tre=
e block corruption detected
> [ 2877.767277] BTRFS error (device vdb): bad tree block start, want 314=
90048 have 1085102592571150095
> [ 2877.772654] BTRFS error (device vdb): block=3D31490048 read time tre=
e block corruption detected
> [ 2878.524728] BTRFS error (device vdb): bad tree block start, want 315=
06432 have 1085102592571150095
> [ 2878.524766] BTRFS error (device vdb): bad tree block start, want 315=
22816 have 217020518514230019
> [ 2878.524798] BTRFS error (device vdb): bad tree block start, want 315=
39200 have 217020518514230019
> [ 2878.524800] BTRFS error (device vdb): block=3D31539200 read time tre=
e block corruption detected
> [ 2878.524835] BTRFS error (device vdb): bad tree block start, want 315=
71968 have 217020518514230019
> [ 2878.524837] BTRFS error (device vdb): block=3D31571968 read time tre=
e block corruption detected
> [ 2878.524848] BTRFS error (device vdb): bad tree block start, want 315=
55584 have 217020518514230019
> [ 2878.524849] BTRFS error (device vdb): block=3D31555584 read time tre=
e block corruption detected
> [ 2878.529852] BTRFS error (device vdb): block=3D31506432 read time tre=
e block corruption detected
> [ 2878.534202] BTRFS error (device vdb): block=3D31522816 read time tre=
e block corruption detected
> [ 2879.386342] BTRFS error (device vdb): bad tree block start, want 315=
22816 have 217020518514230019
> [ 2879.400043] BTRFS error (device vdb): block=3D31522816 read time tre=
e block corruption detected
> [ 2879.638124] btrfs_print_data_csum_error: 59720 callbacks suppressed
> [ 2879.638128] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 817057792 csum 0x576bf9a1 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.638139] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 816893952 csum 0x7d29d791 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.638760] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 816898048 csum 0x4c64848f expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.638814] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 816902144 csum 0x0107a017 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.638856] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 817061888 csum 0x3dc46475 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.638890] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 817065984 csum 0x63f98f58 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.638915] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 817070080 csum 0x2a2250eb expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.638940] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 817074176 csum 0x90ece4b7 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.640899] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 817000448 csum 0xe61df820 expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2879.640961] BTRFS warning (device vdb): csum failed root -9 ino 260 =
off 817078272 csum 0x222426ee expected csum 0x98f94189 mirror 1          =
                                                              =20
> [ 2880.015085] repair_io_failure: 25064 callbacks suppressed
> [ 2880.015089] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819994624 (dev /dev/vdc sector 3717136)                               =
                                                              =20
> [ 2880.015186] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819200000 (dev /dev/vdc sector 3715584)                               =
                                                              =20
> [ 2880.017126] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819195904 (dev /dev/vdc sector 3715576)                               =
                                                              =20
> [ 2880.017197] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819204096 (dev /dev/vdc sector 3715592)                               =
                                                              =20
> [ 2880.017226] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819212288 (dev /dev/vdc sector 3715608)                               =
                                                              =20
> [ 2880.017359] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819216384 (dev /dev/vdc sector 3715616)                               =
                                                              =20
> [ 2880.017392] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819220480 (dev /dev/vdc sector 3715624)                               =
                                                              =20
> [ 2880.017430] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819224576 (dev /dev/vdc sector 3715632)                               =
                                                              =20
> [ 2880.017598] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819228672 (dev /dev/vdc sector 3715640)                               =
                                                              =20
> [ 2880.017706] BTRFS info (device vdb): read error corrected: ino 260 o=
ff 819232768 (dev /dev/vdc sector 3715648)                               =
                                                              =20
> [ 2880.948226] BTRFS error (device vdb): bad tree block start, want 315=
39200 have 217020518514230019
> [ 2880.952594] BTRFS error (device vdb): block=3D31539200 read time tre=
e block corruption detected
> [ 2881.118537] BTRFS error (device vdb): bad tree block start, want 315=
55584 have 217020518514230019
> [ 2881.126228] BTRFS error (device vdb): block=3D31555584 read time tre=
e block corruption detected
> [ 2881.253287] BTRFS error (device vdb): bad tree block start, want 315=
71968 have 217020518514230019
> [ 2881.259086] BTRFS error (device vdb): block=3D31571968 read time tre=
e block corruption detected
> [ 2881.474356] BTRFS error (device vdb): bad tree block start, want 315=
88352 have 0
> [ 2881.474364] BTRFS error (device vdb): bad tree block start, want 316=
04736 have 0
> [ 2881.474368] BTRFS error (device vdb): bad tree block start, want 316=
21120 have 0
> [ 2881.474371] BTRFS error (device vdb): block=3D31621120 read time tre=
e block corruption detected
> [ 2881.474373] BTRFS error (device vdb): block=3D31588352 read time tre=
e block corruption detected
> [ 2881.478266] BTRFS error (device vdb): block=3D31604736 read time tre=
e block corruption detected
> [ 2881.742489] BTRFS error (device vdb): bad tree block start, want 316=
04736 have 0
> [ 2881.746510] BTRFS error (device vdb): block=3D31604736 read time tre=
e block corruption detected
>=20
> [ 2882.057412] BTRFS error (device vdb): bad tree block start, want 316=
21120 have 0
> [ 2882.073918] BTRFS error (device vdb): block=3D31621120 read time tre=
e block corruption detected
> [ 2888.507510] BTRFS info (device vdb): found 8 extents
> [ 2890.081934] BTRFS info (device vdb): found 8 extents
> [ 2890.201963] BTRFS info (device vdb): relocating block group 30408704=
 flags metadata|raid1
> [ 2890.348951] BTRFS info (device vdb): found 82 extents
> [ 2890.452777] BTRFS info (device vdb): relocating block group 22020096=
 flags system|raid1
> [ 2890.564087] BTRFS info (device vdb): found 1 extents
> [ 2890.648211] BTRFS info (device vdb): balance: ended with status: 0
>=20


--yEgw0V0SbJC7nXquApAErgjijiNBv7ORO--

--PNxN1QOnoVdWrBnG10iwihehCXrEkiTAz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxwmA0ACgkQwj2R86El
/qhjlgf/b90rWfYc0uCL8qj7QL6cAkehTmEGWSFDBzo4Yb8sCF+gAvuZxkSRnDi6
b523zUcCUx6RhpXPkxX7sOU7TeuvFtjoY7gVTHhO7aRxQL/iQdO5nZHOqpb/l5y7
BfCm1n6ya5HRPyveZuOpw8svTQYtLBW7s69O0ideJrvyLSpALsE1HADEba6ztYg2
Nc9vDp+BNDk+C2rOF4kKL3gXPx9hFAg+FJnbJv7hr6aq7xxna5xZnGUwRmuAAiaH
CJ5x1pPQGnN8pH3aoaMTRHY0bs9Grr6pIaC+2s2GQ7yOVh0MO78Lxn7xCL3FbR4B
N6sRbrvNuhH981W19juJNfNhZmlrMg==
=1NWl
-----END PGP SIGNATURE-----

--PNxN1QOnoVdWrBnG10iwihehCXrEkiTAz--
