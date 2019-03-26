Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5824C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 05:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6925920811
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 05:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="UpEd1rdg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfCZFS1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 01:18:27 -0400
Received: from mout.gmx.net ([212.227.17.22]:38371 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfCZFS1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 01:18:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553577497;
        bh=kDsBpqiQI9EkI7cKGV0JJXept74RfqNgIkmbwOORr08=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=UpEd1rdgAH0Sm3DthvZ3J/YXPEJksWUvlzBc7M+bJbRAUv3/i0DLUKcpfOEWWCLRM
         NTB0Qz0rFgTVr6WGVRTEZoAYAa9qLvjD/NrsS+bi8G5rNhEk0xqqiQSggef0tckh/H
         4HWKCGyAqB5EjI7IgFNeZ2a6NYycH8Yu8ayERVqQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M1nOg-1gpLEo32zK-00tjLZ; Tue, 26
 Mar 2019 06:18:17 +0100
Subject: =?UTF-8?Q?Re=3a_backup_uuid=5ftree_generation_not_consistent_across?=
 =?UTF-8?Q?_multi_device_=28raid0=29_btrfs_-_won=c2=b4t_mount?=
To:     berodual_xyz <berodual_xyz@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
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
Message-ID: <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
Date:   Tue, 26 Mar 2019 13:18:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QORQOJsknXiIlO9v4x894GnwQreqOHKg9"
X-Provags-ID: V03:K1:tbz4R0oi/msBFDwS73cmR059ONSHlzidy1xGCFwCrJlawzLt7LW
 LYz6LOh7utrEo23nRMPWWKeckPvAgkJa5Zp72/CIIEf/EFJ7RAkOy2lUEf6NFCuER9+8qRn
 IukO9yAdMYY4jsv3AuRy32rhqgthaH+IMQLd/dyucBfeomStwwFC8BqChG/YZkLHC54Pjai
 BC4jG799lGrP0Q2Xk6xdg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tRgA7qxUGpo=:tykzpt3CatFBQ1dxar6x3b
 Am0XlL1wTgKp82wAULoJuUj00bomZeVcfP4zUUpJ61aPyawD/2a9ybsXJTSpYBtyPjVBXhpxY
 klGb81o5vGbzDXC2acXzbC5aSbL1IEwhiRXzHQV3tYrZniKbN7FlfVlZqCVIN4H+GpPee4edt
 JpQ10btejj6IZq4hrsRd+3rxRVDVwQLma4FKOVcZyCKp5SRElJffpJP1a/jftRP+fj2WNWejL
 74D/IyELfTWV0+iSlX2mfYlfF+u7VC7cvf3WHWQ/9HazKKT58DWeVfhaz8xsspBe0b6ZWcGJ0
 PMYf1KRBR6DZqpUG0IB/1fcxBhXa/wrdxU+bu5aveGHp+IFh0ThXJyvjYu1EeQueuFHGTcH4n
 GQfij2hl3UGsnRR8Qxyt/cqAoEecevYo5eUVOGW3S6uS0Ry3qtBgVBFEZO6/vK6GWrW/iPGHh
 VZp5JjXb6bdAReNHPYTqZTLoxK2AoCrz9HXv7Esnd/CsiV9mI+Tb74zU329TAaOGl9468Adxw
 1sUn3zMprmaygbddWxpKJZ2QOUU5hcRWTd9qMYq9r4GSHfFtbTF7o22lZT5SVacCOTykHfZRr
 WHRi2ggX8l9/8y8L65fPCluVd0QvoScE79n4N6AHijMNaN+IBa+Hgpyanx2CxQsEapDf7vExz
 H5f9rt02c0VimTbhbAl979TcCHsxCM9hoVPO290dCZDZiZCSDKdchyYnNeSNa5p4bw8cUjOtR
 Y84YyEPXvCPCXbkCUNsb471sn/bAvwyte3O3oy6CGC3FAoF2VFwmJ5ytPVwm243jOezAY3xtF
 to//TwEaoahfYZExIRFPfPHk2uUP9ndrZ1XCGvnlBB2+Gv9R76ivAtJcGH65/pdp628/LFrgl
 /N6tOC5btNHVajF/OsTgbdvgDMs8Zd31ySPvGvj/kW/rbn6gCIOsFe0+fto3i/
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QORQOJsknXiIlO9v4x894GnwQreqOHKg9
Content-Type: multipart/mixed; boundary="Hd5ypPjh8Br76IOLnk4o26yhg6J8FGPUh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: berodual_xyz <berodual_xyz@protonmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
Subject: =?UTF-8?Q?Re=3a_backup_uuid=5ftree_generation_not_consistent_across?=
 =?UTF-8?Q?_multi_device_=28raid0=29_btrfs_-_won=c2=b4t_mount?=
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
In-Reply-To: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>

--Hd5ypPjh8Br76IOLnk4o26yhg6J8FGPUh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/26 =E4=B8=8A=E5=8D=887:50, berodual_xyz wrote:
> Dear all, I had posted already (excuse for separate mails) that I have =
a corrupt filesystem that would be very important to get recovered.
>=20
> Please note I would really appreciate assistance and am willing to PAY =
for consultation and time.

That's not the way open source community works.
That's how the commercial support works.

>=20
> Kernel 4.20.17
> btrfs-progs 4.20.2
>=20
> The filesystem consists of 4 (HW raid6) devices, each of them shows dif=
ferent superblock backups but my hope is that backup 2 is "consistent" ac=
ross all of them.
>=20
> Is there any way to restore a specific superblock backup and attempt to=
 mount the filesystem? Running "btrfs restore" did partially recover the =
data, but the most important bit is still missing.

You sda and sdb are at gen 60233 while sdd and sde are at gen 60234.

It's possible to allow kernel to manually assemble its device list using
"device=3D" mount option.

Since you're using RAID6, it's possible to recover using 2 devices only,
but in that case you need "degraded" mount option.
And to avoid further problem, you should mount it with "ro,nologreplay"
too, as sda/sdb/sdc has dirty log while sde doesn't.

Furthermore, you still has SINGLE system chunk, it means either your fs
is pretty old, or you haven't balanced the fs forever.

Anyway, that means you have to include sda and sdb.

So the conclusion is, try to mount the fs with sda, mount option
"device=3D/dev/sda,device=3D/dev/sdb,ro,degraded,nologreplay".

If it still fails due to extent tree corruption, then try my
experimental patches:
https://github.com/adam900710/linux/tree/rescue_options

It adds a new mount option "rescue=3Dskip_bg" to skip extent tree
completely, to work as a kernel solution like btrfs-restore.

Thanks,
Qu

>=20
> See also how "generation" is different between devices 1,2 and 3,4.
>=20
> Please see below output of the different devices.
>=20
> My hope is that I can somehow "restore" the smallest common generation =
of superblock on 60232 to make the FS at least read-only mountable.
>=20
>=20
> ################# SDB ############
>=20
> # btrfs inspect-internal dump-super -f /dev/sdb
> superblock: bytenr=3D65536, device=3D/dev/sdb
> ---------------------------------------------------------
> csum_type		0 (crc32c)
> csum_size		4
> csum			0xebea13e2 [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> metadata_uuid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> label			FS1
> generation		60233
> root			55432745107456
> sys_array_size		194
> chunk_root_generation	60232
> root_level		1
> chunk_root		1146880
> chunk_root_level	1
> log_root		55432747958272
> log_root_transid	0
> log_root_level		0
> total_bytes		95999901040640
> bytes_used		60378125692928
> sectorsize		4096
> nodesize		16384
> leafsize (deprecated)	16384
> stripesize		4096
> root_dir		6
> num_devices		4
> compat_flags		0x0
> compat_ro_flags		0x3
> 			( FREE_SPACE_TREE |
> 			  FREE_SPACE_TREE_VALID )
> incompat_flags		0x161
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  SKINNY_METADATA )
> cache_generation	18446744073709551615
> uuid_tree_generation	60233
> dev_item.uuid		7833ce66-ffa3-4baa-a2db-e98d5ec2e369
> dev_item.fsid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
> dev_item.type		0
> dev_item.total_bytes	23999975260160
> dev_item.bytes_used	15122592432128
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		1
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
> sys_chunk_array[2048]:
> 	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
> 		length 4194304 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 4096 io_width 4096 sector_size 4096
> 		num_stripes 1 sub_stripes 0
> 			stripe 0 devid 1 offset 1048576
> 			dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
> 	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
> 		length 33554432 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 65536 io_width 65536 sector_size 4096
> 		num_stripes 1 sub_stripes 1
> 			stripe 0 devid 2 offset 15033460326400
> 			dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
> backup_roots[4]:
> 	backup 0:
> 		backup_tree_root:	55432745107456	gen: 60233	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> 	backup 1:
> 		backup_tree_root:	55432755216384	gen: 60230	level: 1
> 		backup_chunk_root:	1048576	gen: 60230	level: 1
> 		backup_extent_root:	55432754511872	gen: 60230	level: 3
> 		backup_fs_root:		55432756281344	gen: 60231	level: 2
> 		backup_dev_root:	55432755625984	gen: 60230	level: 1
> 		backup_csum_root:	55432750727168	gen: 60230	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60372281278464
> 		backup_num_devices:	4
>=20
> 	backup 2:
> 		backup_tree_root:	55432746385408	gen: 60231	level: 1
> 		backup_chunk_root:	1048576	gen: 60230	level: 1
> 		backup_extent_root:	55432738242560	gen: 60231	level: 3
> 		backup_fs_root:		55432756281344	gen: 60231	level: 2
> 		backup_dev_root:	55432755625984	gen: 60230	level: 1
> 		backup_csum_root:	55432750727168	gen: 60230	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60372283375616
> 		backup_num_devices:	4
>=20
> 	backup 3:
> 		backup_tree_root:	55432763015168	gen: 60232	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> ########### SDC ############
>=20
> btrfs inspect-internal dump-super -f /dev/sdc
> superblock: bytenr=3D65536, device=3D/dev/sdc
> ---------------------------------------------------------
> csum_type		0 (crc32c)
> csum_size		4
> csum			0x310a7e9a [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> metadata_uuid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> label			FS1
> generation		60233
> root			55432745107456
> sys_array_size		194
> chunk_root_generation	60232
> root_level		1
> chunk_root		1146880
> chunk_root_level	1
> log_root		55432747958272
> log_root_transid	0
> log_root_level		0
> total_bytes		95999901040640
> bytes_used		60378125692928
> sectorsize		4096
> nodesize		16384
> leafsize (deprecated)	16384
> stripesize		4096
> root_dir		6
> num_devices		4
> compat_flags		0x0
> compat_ro_flags		0x3
> 			( FREE_SPACE_TREE |
> 			  FREE_SPACE_TREE_VALID )
> incompat_flags		0x161
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  SKINNY_METADATA )
> cache_generation	18446744073709551615
> uuid_tree_generation	60233
> dev_item.uuid		bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
> dev_item.fsid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
> dev_item.type		0
> dev_item.total_bytes	23999975260160
> dev_item.bytes_used	15122613403648
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		2
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
> sys_chunk_array[2048]:
> 	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
> 		length 4194304 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 4096 io_width 4096 sector_size 4096
> 		num_stripes 1 sub_stripes 0
> 			stripe 0 devid 1 offset 1048576
> 			dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
> 	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
> 		length 33554432 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 65536 io_width 65536 sector_size 4096
> 		num_stripes 1 sub_stripes 1
> 			stripe 0 devid 2 offset 15033460326400
> 			dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
> backup_roots[4]:
> 	backup 0:
> 		backup_tree_root:	55432745107456	gen: 60233	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> 	backup 1:
> 		backup_tree_root:	55432755216384	gen: 60230	level: 1
> 		backup_chunk_root:	1048576	gen: 60230	level: 1
> 		backup_extent_root:	55432754511872	gen: 60230	level: 3
> 		backup_fs_root:		55432756281344	gen: 60231	level: 2
> 		backup_dev_root:	55432755625984	gen: 60230	level: 1
> 		backup_csum_root:	55432750727168	gen: 60230	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60372281278464
> 		backup_num_devices:	4
>=20
> 	backup 2:
> 		backup_tree_root:	55432746385408	gen: 60231	level: 1
> 		backup_chunk_root:	1048576	gen: 60230	level: 1
> 		backup_extent_root:	55432738242560	gen: 60231	level: 3
> 		backup_fs_root:		55432756281344	gen: 60231	level: 2
> 		backup_dev_root:	55432755625984	gen: 60230	level: 1
> 		backup_csum_root:	55432750727168	gen: 60230	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60372283375616
> 		backup_num_devices:	4
>=20
> 	backup 3:
> 		backup_tree_root:	55432763015168	gen: 60232	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> ########### SDD ##########
>=20
> btrfs inspect-internal dump-super -f /dev/sdd
> superblock: bytenr=3D65536, device=3D/dev/sdd
> ---------------------------------------------------------
> csum_type		0 (crc32c)
> csum_size		4
> csum			0x56f1abb4 [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> metadata_uuid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> label			FS1
> generation		60234
> root			55432766062592
> sys_array_size		194
> chunk_root_generation	60234
> root_level		1
> chunk_root		1048576
> chunk_root_level	1
> log_root		0
> log_root_transid	0
> log_root_level		0
> total_bytes		95999901040640
> bytes_used		60382615777280
> sectorsize		4096
> nodesize		16384
> leafsize (deprecated)	16384
> stripesize		4096
> root_dir		6
> num_devices		4
> compat_flags		0x0
> compat_ro_flags		0x3
> 			( FREE_SPACE_TREE |
> 			  FREE_SPACE_TREE_VALID )
> incompat_flags		0x161
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  SKINNY_METADATA )
> cache_generation	18446744073709551615
> uuid_tree_generation	60234
> dev_item.uuid		cc6e5f1c-081c-441f-9634-6908164e1375
> dev_item.fsid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
> dev_item.type		0
> dev_item.total_bytes	23999975260160
> dev_item.bytes_used	15123653591040
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		3
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
> sys_chunk_array[2048]:
> 	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
> 		length 4194304 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 4096 io_width 4096 sector_size 4096
> 		num_stripes 1 sub_stripes 0
> 			stripe 0 devid 1 offset 1048576
> 			dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
> 	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
> 		length 33554432 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 65536 io_width 65536 sector_size 4096
> 		num_stripes 1 sub_stripes 1
> 			stripe 0 devid 2 offset 15033460326400
> 			dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
> backup_roots[4]:
> 	backup 0:
> 		backup_tree_root:	55432745107456	gen: 60233	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> 	backup 1:
> 		backup_tree_root:	55432766062592	gen: 60234	level: 1
> 		backup_chunk_root:	1048576	gen: 60234	level: 1
> 		backup_extent_root:	55432746352640	gen: 60234	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432755789824	gen: 60234	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60382615777280
> 		backup_num_devices:	4
>=20
> 	backup 2:
> 		backup_tree_root:	55432746385408	gen: 60231	level: 1
> 		backup_chunk_root:	1048576	gen: 60230	level: 1
> 		backup_extent_root:	55432738242560	gen: 60231	level: 3
> 		backup_fs_root:		55432756281344	gen: 60231	level: 2
> 		backup_dev_root:	55432755625984	gen: 60230	level: 1
> 		backup_csum_root:	55432750727168	gen: 60230	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60372283375616
> 		backup_num_devices:	4
>=20
> 	backup 3:
> 		backup_tree_root:	55432763015168	gen: 60232	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> ####### SDE #######
>=20
>  btrfs inspect-internal dump-super -f /dev/sde
> superblock: bytenr=3D65536, device=3D/dev/sde
> ---------------------------------------------------------
> csum_type		0 (crc32c)
> csum_size		4
> csum			0x6fcc7a25 [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> metadata_uuid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> label			FS1
> generation		60234
> root			55432766062592
> sys_array_size		194
> chunk_root_generation	60234
> root_level		1
> chunk_root		1048576
> chunk_root_level	1
> log_root		0
> log_root_transid	0
> log_root_level		0
> total_bytes		95999901040640
> bytes_used		60382615777280
> sectorsize		4096
> nodesize		16384
> leafsize (deprecated)	16384
> stripesize		4096
> root_dir		6
> num_devices		4
> compat_flags		0x0
> compat_ro_flags		0x3
> 			( FREE_SPACE_TREE |
> 			  FREE_SPACE_TREE_VALID )
> incompat_flags		0x161
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  SKINNY_METADATA )
> cache_generation	18446744073709551615
> uuid_tree_generation	60234
> dev_item.uuid		d97063ad-078a-44b5-ae47-4f0f9f9755f9
> dev_item.fsid		8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
> dev_item.type		0
> dev_item.total_bytes	23999975260160
> dev_item.bytes_used	15123653591040
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		4
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
> sys_chunk_array[2048]:
> 	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
> 		length 4194304 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 4096 io_width 4096 sector_size 4096
> 		num_stripes 1 sub_stripes 0
> 			stripe 0 devid 1 offset 1048576
> 			dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
> 	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
> 		length 33554432 owner 2 stripe_len 65536 type SYSTEM
> 		io_align 65536 io_width 65536 sector_size 4096
> 		num_stripes 1 sub_stripes 1
> 			stripe 0 devid 2 offset 15033460326400
> 			dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
> backup_roots[4]:
> 	backup 0:
> 		backup_tree_root:	55432745107456	gen: 60233	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> 	backup 1:
> 		backup_tree_root:	55432766062592	gen: 60234	level: 1
> 		backup_chunk_root:	1048576	gen: 60234	level: 1
> 		backup_extent_root:	55432746352640	gen: 60234	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432755789824	gen: 60234	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60382615777280
> 		backup_num_devices:	4
>=20
> 	backup 2:
> 		backup_tree_root:	55432746385408	gen: 60231	level: 1
> 		backup_chunk_root:	1048576	gen: 60230	level: 1
> 		backup_extent_root:	55432738242560	gen: 60231	level: 3
> 		backup_fs_root:		55432756281344	gen: 60231	level: 2
> 		backup_dev_root:	55432755625984	gen: 60230	level: 1
> 		backup_csum_root:	55432750727168	gen: 60230	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60372283375616
> 		backup_num_devices:	4
>=20
> 	backup 3:
> 		backup_tree_root:	55432763015168	gen: 60232	level: 1
> 		backup_chunk_root:	1146880	gen: 60232	level: 1
> 		backup_extent_root:	55432763981824	gen: 60233	level: 3
> 		backup_fs_root:		55432763850752	gen: 60233	level: 2
> 		backup_dev_root:	55432753725440	gen: 60232	level: 1
> 		backup_csum_root:	55432764342272	gen: 60233	level: 0
> 		backup_total_bytes:	95999901040640
> 		backup_bytes_used:	60378125692928
> 		backup_num_devices:	4
>=20
> ###########################
>=20


--Hd5ypPjh8Br76IOLnk4o26yhg6J8FGPUh--

--QORQOJsknXiIlO9v4x894GnwQreqOHKg9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyZthQACgkQwj2R86El
/qj9BggApBg+Jz5VazEtagqHDMw9Obn6uJylowuQnGni0qP+epCDpK5Pwa41SxSr
JJ2dIRDzFcqOTeDf8Bt+bbpSijkisiYAzFrjNn7T8iC7UUw+scGFAk2yBXG9+g+O
WiL8Zhgxetv31pKbk5B0gFii/uIr+6ZdrhXCL7UULOeBfBZ0TrIRHFoL4D8yRm/Q
8ZejKOPTjb2w5mP05+oYxO6xwAOUPEe3d2kTqV5Xrsr7bOdPad33Q8aVSbALQtSR
mDL1t6ykFVn4tbEmpE//SCJaREax+w9QrKQ0HUUKfQgDH50yRxaw61H2Mkxoxs70
/voD9am/trAAZAcbOEqMPH717yPpnQ==
=eoyF
-----END PGP SIGNATURE-----

--QORQOJsknXiIlO9v4x894GnwQreqOHKg9--
