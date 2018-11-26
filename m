Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA37C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 08:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07D92082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 08:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E07D92082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbeKZTHG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 14:07:06 -0500
Received: from mout.gmx.net ([212.227.17.20]:55557 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbeKZTHG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 14:07:06 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LyS5K-1fNfE343XC-015nUf; Mon, 26
 Nov 2018 09:13:42 +0100
Subject: Re: unable to fixup (regular) error
To:     Alexander Fieroch <alexander.fieroch@mpi-dortmund.mpg.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <f367f1b4-f360-0f6d-ee30-42eb735a9bbc@mpi-dortmund.mpg.de>
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
Message-ID: <beefd32d-b34b-9242-b16d-e66c82b23d8f@gmx.com>
Date:   Mon, 26 Nov 2018 16:13:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <f367f1b4-f360-0f6d-ee30-42eb735a9bbc@mpi-dortmund.mpg.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="inIfbV4zhXKxqFCknRIZZ7la9ZIX3N8yP"
X-Provags-ID: V03:K1:alLRf4C25aFmlTok0Tv+7Fv0a41dTLDNSK/AKSBefXfONUNmgKE
 v8lnpGgViomVw2hxuSRWoRIHIleOuMfyeWHTVTSlshRAAgT433M3cA2zF0etGw9zz186yg0
 k9o01mDPeTNSJUZemGoCKtE/GBiUbl31CArXpzfHqFnAH0oy3qxN04pctB3Q3Ev4XcOaIgq
 PbtGe+aCClSjywKLNG3jg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yjCxqzi9mrA=:mbtAKsL1ADC5gXdp5oR09B
 vdOpl+yOb/PZMCNreHty7IFyNXlniuMFMDKDF/OP6E7HBAbsX79t5eY9QU4ECjNherwPZAGGd
 O91ihMUYIbzH6F9gcyReT123JiIDSJJ8RGnlEiB3myt3b1h3Yx95M3NztVQtwSMnmmHl1Bjvc
 5vo4XbO3NRJEdo/AxuWPJZSSdbTzbTA4gcalGMy11rB297enPaIe4BJHtwas14hx5k2tMVfCs
 CrylrswfFxjyBgy/J50Ri/EicwPHJQCB4E00lnb7kVUE21t3wB11yspS3uiwpGTNukrNCy6w3
 VvehVhO7ZMhmBx1ht5aDqIPu8K6J+WprLKXK0FX/M5W6uYcqI8jFhZfEexW7Mrrcjlcr+4Twq
 1rD/9+aPcNPEcxxZu7w/OLr7vd3i7MqebOhM1xx8wMTLMnj28BA7uJX/ZVJtR1ERqmQk5sudS
 8cih+T2tKCzkGys5wbQc0mO0yg29bd4A2jY1Zk7EnkfkIesiGD1BdSd385Ao8w0qHv2Wtxw1U
 6N1zG/ahlQHtgFSEH2Ur6lekngGpB/U+Lk/Q48vYFXwLQCxaf4pke0PGGHbN45oz+4NgqjlUn
 4Sia0S9Vs3Qx/WtcUvpyg1VZzA2oDWKe6/DNJ25JAU/cHOZn8S1rjqHYsXx9hdVhZK2ZOEycL
 EnHBUd7X7isiUfX6MHyKfKVM5zVPtlvlaBGUMz0VUsFxwCSxdikJlKE1ZAlc/CJRliCGxBljC
 XnhgrTV/qmhzoL5XnnCNlJUkz5l9Zc6QuYu1MeqUbsIjlJJDUeRQ0q3/y0Qg47gatKlpx1sqp
 9wXaYSuiHilm1lqGVNVswvn4wWlPqZwatDW/NvjwGsl0+qfPOT5JU1JK1gHT4iSNE3wPt7I36
 pOK9uSQtes7KCc36baIu9UNwOCmJRkAsIIsAjDgaI=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--inIfbV4zhXKxqFCknRIZZ7la9ZIX3N8yP
Content-Type: multipart/mixed; boundary="lb2O3BNFuaqF7Csyc05WwaJZySUOhdQ2Y";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Alexander Fieroch <alexander.fieroch@mpi-dortmund.mpg.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <beefd32d-b34b-9242-b16d-e66c82b23d8f@gmx.com>
Subject: Re: unable to fixup (regular) error
References: <f367f1b4-f360-0f6d-ee30-42eb735a9bbc@mpi-dortmund.mpg.de>
In-Reply-To: <f367f1b4-f360-0f6d-ee30-42eb735a9bbc@mpi-dortmund.mpg.de>

--lb2O3BNFuaqF7Csyc05WwaJZySUOhdQ2Y
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/26 =E4=B8=8B=E5=8D=883:19, Alexander Fieroch wrote:
> Hi,
>=20
> My data partition with btrfs RAID 0 (/dev/sdc0 and /dev/sdd0) shows
> errors in syslog:
>=20
> BTRFS error (device sdc): cleaner transaction attach returned -30
> BTRFS info (device sdc): disk space caching is enabled
> BTRFS info (device sdc): has skinny extents
> BTRFS info (device sdc): bdev /dev/sdc errs: wr 0, rd 0, flush 0,
> corrupt 3, gen 1
> BTRFS info (device sdc): bdev /dev/sdd errs: wr 0, rd 0, flush 0,
> corrupt 6, gen 2

Generation mismatch means something more serious.

>=20
>=20
> BTRFS error (device sdc): scrub: tree block 858803990528 spanning
> stripes, ignored. logical=3D3D858803929088

While the spanning stripes only means scrub code can't really check it
since it crosses stripe boundary.

It's normally nothing to worry, and it's normally caused by old kernel.
Newer kernel will avoid such problem from happening, but for existing
one, it will just skip it.

> BTRFS error (device sdc): scrub: tree block 858803990528 spanning
> stripes, ignored. logical=3D3D858803994624
> BTRFS warning (device sdc): checksum error at logical 858803961856 on
> dev /dev/sdd, physical 385263894528: metadata leaf (level 0) in tree 7
> BTRFS warning (device sdc): checksum error at logical 858803961856 on
> dev /dev/sdd, physical 385263894528: metadata leaf (level 0) in tree 7

This means some csum tree blocks get corrupted.

> BTRFS error (device sdc): bdev /dev/sdd errs: wr 0, rd 0, flush 0,
> corrupt 4, gen 1
> BTRFS error (device sdc): scrub: tree block 858820505600 spanning
> stripes, ignored. logical=3D3D858820444160
> BTRFS error (device sdc): scrub: tree block 858820505600 spanning
> stripes, ignored. logical=3D3D858820509696
> BTRFS error (device sdc): unable to fixup (regular) error at logical
> 858803961856 on dev /dev/sdd
> BTRFS error (device sdc): scrub: tree block 858821292032 spanning
> stripes, ignored. logical=3D3D858821230592
> BTRFS error (device sdc): scrub: tree block 858821292032 spanning
> stripes, ignored. logical=3D3D858821296128
> BTRFS warning (device sdc): checksum error at logical 858821263360 on
> dev /dev/sdd, physical 385281196032: metadata leaf (level 0) in tree 7
> BTRFS warning (device sdc): checksum error at logical 858821263360 on
> dev /dev/sdd, physical 385281196032: metadata leaf (level 0) in tree 7
> BTRFS error (device sdc): bdev /dev/sdd errs: wr 0, rd 0, flush 0,
> corrupt 5, gen 1
> BTRFS error (device sdc): unable to fixup (regular) error at logical
> 858821263360 on dev /dev/sdd
> BTRFS warning (device sdc): checksum/header error at logical
> 858820476928 on dev /dev/sdd, physical 385280409600: metadata leaf
> (level 0) in tree 7
> BTRFS warning (device sdc): checksum/header error at logical
> 858820476928 on dev /dev/sdd, physical 385280409600: metadata leaf
> (level 0) in tree 7
> BTRFS error (device sdc): bdev /dev/sdd errs: wr 0, rd 0, flush 0,
> corrupt 5, gen 2
> BTRFS warning (device sdc): checksum error at logical 858820489216 on
> dev /dev/sdd, physical 385280421888: metadata leaf (level 0) in tree 2
> BTRFS warning (device sdc): checksum error at logical 858820489216 on
> dev /dev/sdd, physical 385280421888: metadata leaf (level 0) in tree 2

This is some error in extent tree, and I'd say it's a serious problem
which may affect later write operation.

> BTRFS error (device sdc): bdev /dev/sdd errs: wr 0, rd 0, flush 0,
> corrupt 6, gen 2
> BTRFS error (device sdc): unable to fixup (regular) error at logical
> 858820476928 on dev /dev/sdd
> BTRFS error (device sdc): unable to fixup (regular) error at logical
> 858820489216 on dev /dev/sdd0
>=20
>=20
> $ btrfs filesystem show /mnt/data/
> Label: none=C2=A0 uuid: 5e6506b0-bf15-4b2e-b5f4-322c44b89db6
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 2 =
FS bytes used 10.17TiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=
=C2=A0 1 size 5.46TiB used 5.43TiB path /dev/sdc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=
=C2=A0 2 size 5.46TiB used 5.43TiB path /dev/sdd
>=20
> $ btrfs --version
> btrfs-progs v4.15.1
>=20
> $ uname -a
> Linux gpur1 4.15.0-39-generic #42-Ubuntu SMP Tue Oct 23 15:48:01 UTC
> 2018 x86_64 x86_64 x86_64 GNU/Linux
>=20
>=20
> $ btrfs dev stats /dev/sdc
> [/dev/sdc].write_io_errs=C2=A0=C2=A0=C2=A0 0
> [/dev/sdc].read_io_errs=C2=A0=C2=A0=C2=A0=C2=A0 0
> [/dev/sdc].flush_io_errs=C2=A0=C2=A0=C2=A0 0
> [/dev/sdc].corruption_errs=C2=A0 3
> [/dev/sdc].generation_errs=C2=A0 1
>=20
> $ btrfs dev stats /dev/sdd
> [/dev/sdd].write_io_errs=C2=A0=C2=A0=C2=A0 0
> [/dev/sdd].read_io_errs=C2=A0=C2=A0=C2=A0=C2=A0 0
> [/dev/sdd].flush_io_errs=C2=A0=C2=A0=C2=A0 0
> [/dev/sdd].corruption_errs=C2=A0 3
> [/dev/sdd].generation_errs=C2=A0 1
>=20
> $ btrfs fi show
> Label: 'system'=C2=A0 uuid: ae121e8e-d483-45f4-8568-2817f5c5d497
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes use=
d 194.05GiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 228.66GiB used 199.03GiB path /dev/sda3
> Label: none=C2=A0 uuid: 5e6506b0-bf15-4b2e-b5f4-322c44b89db6
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes use=
d 10.17TiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 5.46TiB used 5.43TiB path /dev/sdc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 si=
ze 5.46TiB used 5.43TiB path /dev/sdd
>=20
> $ btrfs fi df /mnt/data/
> Data, RAID0: total=3D10.84TiB, used=3D10.15TiB
> System, RAID1: total=3D8.00MiB, used=3D896.00KiB
> Metadata, RAID1: total=3D15.00GiB, used=3D13.28GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00
>=20
> $ btrfs scrub start -B /dev/sdc
> ERROR: scrubbing /dev/sdc failed for device id 1: ret=3D-1, errno=3D5
> (Input/output error)
> scrub canceled for 5e6506b0-bf15-4b2e-b5f4-322c44b89db6
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scrub started at Thu N=
ov 22 07:43:45 2018 and was aborted after
> 02:31:49
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total bytes scrubbed: =
1.58TiB with 10 errors
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error details: verify=3D=
1 csum=3D3
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 corrected errors: 0, u=
ncorrectable errors: 10, unverified
> errors: 0
>=20
>=20
>=20
> I've tried
> $ btrfs check /dev/sdc
> Checking filesystem on /dev/sdc
> UUID: 5e6506b0-bf15-4b2e-b5f4-322c44b89db6
> btrfs check --repairchecking extents

Don't use --repair unless you know what you're doing.

> =C2=A0 ERROR: add_tree_backref failed (extent items shared block): File=
 exists
> ERROR: add_tree_backref failed (extent items tree block): File exists
> ERROR: add_tree_backref failed (extent items tree block): File exists
> /dev/sdc
> ERROR: add_tree_backref failed (non-leaf block): File exists
>=20
> ERROR: add_tree_backref failed (non-leaf block): File exists
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> Csum didn't match
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> Csum didn't match
> ref mismatch on [8631607296 77824] extent item 1, found 0
> incorrect local backref count on 8631607296 parent 858803974144 owner 0=

> offset 0 found 0 wanted 1 back 0x55f8522a5b10
> backref disk bytenr does not match extent record, bytenr=3D8631607296, =
ref
> bytenr=3D0
> backpointer mismatch on [8631607296 77824]
> owner ref check failed [8631607296 77824]
> ref mismatch on [35613634560 77824] extent item 1, found 0
> incorrect local backref count on 35613634560 parent 858803974144 owner =
0
> offset 0 found 0 wanted 1 back 0x55f86d87d810
> backref disk bytenr does not match extent record, bytenr=3D35613634560,=

> ref bytenr=3D0
> backpointer mismatch on [35613634560 77824]
> owner ref check failed [35613634560 77824]
> ref mismatch on [36010762240 77824] extent item 1, found 0
> [...]
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> extent_io.c:605: free_extent_buffer_internal: BUG_ON `eb->refs < 0`
> triggered, value 1
> btrfs(+0x29d87)[0x55f83fd51d87]
> btrfs(+0x2a0b4)[0x55f83fd520b4]
> btrfs(alloc_extent_buffer+0x77)[0x55f83fd527af]
> btrfs(read_tree_block+0x44)[0x55f83fd45802]
> btrfs(btrfs_next_leaf+0x6e)[0x55f83fd43ad9]
> btrfs(count_csum_range+0x1e1)[0x55f83fd89fac]
> btrfs(+0x14b33)[0x55f83fd3cb33]
> btrfs(cmd_check+0x19fb)[0x55f83fd7bfe2]
> btrfs(main+0x143)[0x55f83fd3ec87]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xe7)[0x7ff69e81cb97]=

> btrfs(_start+0x2a)[0x55f83fd3ecca]
> Aborted (core dumped)
>=20
>=20
>=20
> $ btrfs check --repair /dev/sdc
> enabling repair mode
> Checking filesystem on /dev/sdc
> UUID: 5e6506b0-bf15-4b2e-b5f4-322c44b89db6
> Fixed 0 roots.
> checking extents
> ERROR: add_tree_backref failed (extent items shared block): File exists=

> ERROR: add_tree_backref failed (extent items tree block): File exists
> ERROR: add_tree_backref failed (extent items tree block): File exists
> ERROR: add_tree_backref failed (non-leaf block): File exists
> ERROR: add_tree_backref failed (non-leaf block): File exists
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> checksum verify failed on 858803961856 found B2C0FAD9 wanted F31F8495
> Csum didn't match
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> checksum verify failed on 858821263360 found 15208BF4 wanted D68B2514
> Csum didn't match
> well this shouldn't happen, extent record overlaps but is metadata?
> [858803974144, 16384]
> Aborted (core dumped)
>=20
>=20
>=20
>=20
> How can I fix the error?
> Is there any possibility to see which files are affected?

It's not data/files (at least from what I read), it's all about some
essential metadata get corrupted.

Unlike other traditional fs, corruption in extent tree could lead to a
lot of problem and it's pretty hard to fix due to its complexity.

The corruption itself looks like some disk error, not some btrfs error
like transid error.

I recommend to mount the fs RO and salvage your data.
If something even went wrong doing the RO mount, you could go "btrfs
restore".

Since there is something wrong with csum tree, some EIO would be
expected during copy.

Thanks,
Qu

> Please have a look at the full log attached.
>=20
> Thanks!
>=20
> Best regards,
> Alexander
>=20


--lb2O3BNFuaqF7Csyc05WwaJZySUOhdQ2Y--

--inIfbV4zhXKxqFCknRIZZ7la9ZIX3N8yP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv7qzIACgkQwj2R86El
/qhN/ggAhNF7xZUv1kkgDF/oBn+4EA3sx2wTpxjSdWZCVWlIrrk0SeAqE63vTvEP
pKBcC89BArAhMhJ2llYaGi7xL6anZtGTrUe+FeiJX0R/MA9yBzgoW6vlu4q08nPn
BxdWbg8wtTP43kGKsDFHLcS1NigQZl5qN3dIY7xAOBRY0OuXiMFGq2YyvFetjZKl
j6+4xqP3MVKgeqNKQG2BO3jj7MH5SMZf15aOoHZJBH+W/ioqNQ6TRThzkXUOxsY+
aDUfJQeLuN0ZFKCVQjI8h1qLiB2y4qFRCgNeQ1Gc5BrYpxA6WNBlG7QMUZk15i0i
6HYjpNnS7SCiltaAJeyjFMwzcyo/1A==
=Clld
-----END PGP SIGNATURE-----

--inIfbV4zhXKxqFCknRIZZ7la9ZIX3N8yP--
