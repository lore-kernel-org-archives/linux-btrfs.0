From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Raid0 with btrfs
Date: Sat, 7 Aug 2010 01:02:20 +0200
Message-ID: <201008070102.20580.hka@qbs.com.pl>
References: <AANLkTimS=bgDsbk9jdcPqW-88eQnq+qss1m2mZBfAif2@mail.gmail.com> <AANLkTimAvZZdz0LnxM2H+2B4t1L4VDUi43NmsZpZQONm@mail.gmail.com> <AANLkTimOin7isn9Gyi42x4evVnY6KW1H_ycAWUid-JKG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>,
	linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimOin7isn9Gyi42x4evVnY6KW1H_ycAWUid-JKG@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 07 of August 2010 00:24:08 Leonidas Spyropoulos wrote:
> On Fri, Aug 6, 2010 at 7:32 PM, Sebastian 'gonX' Jensen
>=20
> <gonx@overclocked.net> wrote:
> > On 6 August 2010 20:23, Leonidas Spyropoulos <artafinde@gmail.com> =
wrote:
> >> Do I have to change the partition ID flag of each partition?
> >> Currently is set to fd (Linux Raid autodetect) for used from mdadm
> >> mkfs.btrfs supports that or needs to be 83 (Linux) ?
> >=20
> > FD is for mdraid integrated into the Linux kernel. I have mine at 8=
3.
> > It won't hurt to have them at FD, but the kernel will spend extra t=
ime
> > as it probes the devices on boot, causing a slight slowdown.
>=20
> Ok done them id 83 and used 3 devices eventually
> Using raid0 for data and metadata
> # mkfs.btrfs -m raid0 -d raid0 /dev/sdc1 /dev/sdd2 /dev/sde2
>=20
> 2 SATA and 1 ATA drive
> I thought that ATA will bottleneck the other 2 drives but seems like =
I gain
> something from it.
> Using iozone for benchmark:
> # iozone -s 8g -r 1024 -i 0 -i 1
> with 2 SATA devices and then 3 devices (SATA + ATA):
>         KB  reclen      write   rewrite       read     reread
> 8388608    1024  134869  139607   229146   228800
> 8388608    1024  135151  139050   233461   235929
>=20
> The above is with -o compress option enabled and my cpu topped up on
> 100% cpu (both cores) while test and copy huge data.
> Is it possible I am bottlenecked by my cpu speed?
> AMD Opteron 165 @ 2700 Mhz

Considering you have 100% CPU usage during the test, it would seem so.

>=20
> >> On Thu, Aug 5, 2010 at 3:40 PM, Hubert Kario <hka@qbs.com.pl> wrot=
e:
> >>> On Thursday 05 August 2010 16:15:22 Leonidas Spyropoulos wrote:
> >>>> Hi all,
> >>>>=20
> >>>> I want to make a btrfs raid0 on 2 partitions of my pc.
> >>>> Until now I am using the mdadm tools to make a software raid of =
the 2
> >>>> partitions /dev/sde2, /dev/sdd2
> >>>> and then mkfs.etx4 the newly created /dev/md0 device.
> >>>> From performance point of view is it better to keep the configur=
ation
> >>>> of mdadm and just format the /dev/md0 device as btrfs OR
> >>>> delete the raid device and format the 2 partitions /dev/sde2 /de=
v/sdd2
> >>>> as a btrfs with 2 devices?
> >>>> mkfs.btrfs /dev/sde2 /dev/sdd2
> >>>=20
> >>> Btrfs already supports metadata mirroring when the data is stripe=
d.
> >>> What this means, is while the performance should be more-or-less
> >>> identical to MD RAID0 (if it isn't it's a bug), your data is a bi=
t
> >>> more secure as the metadata describing it resides on both drives.
> >>> Later on it will be possible to selct which directories/files sho=
uld
> >>> have what level of redundancy. This will allow to have ~/work RAI=
D1-ed
> >>> and ~/videos RAID0-ed while keeping both directories on the same
> >>> partition and filesystem.
> >>>=20
> >>>> On a sidenote:
> >>>> If I decide to go for raid5 which is not supported currently fro=
m mkfs
> >>>> I have to use the mdadm tool anyway, right?
> >>>=20
> >>> yes, RAID5 code is not in trunk yet.
> >>>=20
> >>> --
> >>> Hubert Kario
> >>> QBS - Quality Business Software
> >>> 02-656 Warszawa, ul. Ksawer=F3w 30/85
> >>> tel. +48 (22) 646-61-51, 646-74-24
> >>> www.qbs.com.pl
> >>=20
> >> --
> >> Caution: breathing may be hazardous to your health.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-bt=
rfs"
> >> in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> > Regards,
> > Sebastian J.
> >=20
> > PS. Please try to bottom-post rather than top-post. Here's a link I
> > can advise reading for a clarification on why bottom posting is
> > essential: http://www.caliburn.nl/topposting.html
>=20
> Thanks for the heads up about bottom-posting.

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
