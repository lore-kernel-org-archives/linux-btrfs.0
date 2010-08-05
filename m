From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Raid0 with btrfs
Date: Thu, 5 Aug 2010 16:40:51 +0200
Message-ID: <201008051640.51662.hka@qbs.com.pl>
References: <AANLkTimS=bgDsbk9jdcPqW-88eQnq+qss1m2mZBfAif2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimS=bgDsbk9jdcPqW-88eQnq+qss1m2mZBfAif2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 05 August 2010 16:15:22 Leonidas Spyropoulos wrote:
> Hi all,
>=20
> I want to make a btrfs raid0 on 2 partitions of my pc.
> Until now I am using the mdadm tools to make a software raid of the 2
> partitions /dev/sde2, /dev/sdd2
> and then mkfs.etx4 the newly created /dev/md0 device.
> From performance point of view is it better to keep the configuration=
 of
> mdadm and just format the /dev/md0 device as btrfs OR
> delete the raid device and format the 2 partitions /dev/sde2 /dev/sdd=
2
> as a btrfs with 2 devices?
> mkfs.btrfs /dev/sde2 /dev/sdd2

Btrfs already supports metadata mirroring when the data is striped. Wha=
t this=20
means, is while the performance should be more-or-less identical to MD =
RAID0=20
(if it isn't it's a bug), your data is a bit more secure as the metadat=
a=20
describing it resides on both drives. Later on it will be possible to s=
elct=20
which directories/files should have what level of redundancy. This will=
 allow=20
to have ~/work RAID1-ed and ~/videos RAID0-ed while keeping both direct=
ories=20
on the same partition and filesystem.

> On a sidenote:
> If I decide to go for raid5 which is not supported currently from mkf=
s
> I have to use the mdadm tool anyway, right?

yes, RAID5 code is not in trunk yet.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
