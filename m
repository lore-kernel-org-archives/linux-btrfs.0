From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs-convert processing time
Date: Sat, 31 Mar 2012 22:50:18 +0200
Message-ID: <2242145.EfLMMUx4vA@bursa22>
References: <4F4241D1.4080506@daevel.fr> <4F451E1A.4000802@daevel.fr> <4F760848.4020600@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F760848.4020600@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 30 of March 2012 21:23:52 Olivier Bonvalet wrote:
> Le 22/02/2012 17:55, Olivier Bonvalet a =E9crit :
> > So, the btrfs-convert for the smaller drive is done... after near 5
> > days. Which stats can I give you ?
> >=20
> > It's a 340GB LVM block device, and "btrfs filesystem df /backup/" s=
ay
> > that :
> >=20
> > Data: total=3D225.97GB, used=3D181.94GB
> > System: total=3D32.00MB, used=3D24.00KB
> > Metadata: total=3D111.00GB, used=3D91.56GB
> >=20
> >=20
> > If I mount the ext2_saved/image copy, I can see 257GB of data (78% =
of
> > the block device used), with 17M of inodes.
> >=20
> >=20
> > The other btrfs-convert stay running.
>=20
> Well, the second one is still running :
>=20
> root! backup:~# uptime
>   21:17:43 up 41 days, 19:59,  1 user,  load average: 2.06, 1.90, 1.8=
8
>=20
>=20
> root! backup:~# ps auxw | grep btrfs
> root      1978 25.6 74.3 1269072 1141212 ?     D    Feb18 15421:50
> btrfs-convert /dev/vg-backup/backup

Wow, that's /long/...


> root! backup:~# iostat -k
> Linux 2.6.42.3-dae-xen (backup) 	30/03/2012 	_x86_64_	(2 CPU)
>=20
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            10,54    0,06    2,36   54,21    0,09   32,74
>=20
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrt=
n
> xvda            724,70       175,50      3181,13  634342597 114983704=
00
> xvdy              0,00         0,00         0,00       1381          =
0
> xvdz              0,00         0,00         0,00       4065          =
0
> dm-0              0,49         3,22         1,78   11627497    643502=
8
> dm-1            837,57       171,69      3178,57  620593936 114891054=
16
> dm-2              0,34         0,59         0,78    2120800    283058=
4
>=20
> 11498370400 kB written, so, 11TB written to convert a 518GB partition=
 ?
>=20
>=20
> but more important : is it safe to abort the process ?

I'm quite sure you won't get a mountable filesystem, either ext or btrf=
s.=20
btrfs-convert has to move at least some ext3 metadata blocks, so ext FS=
 will=20
be broken. I don't know if btrfs-convert writes whole btrfs tree and th=
en=20
updates it as it finds new inodes in ext3 or just goes over it sequenti=
ally.=20
But either way, you'll get at best btrfs with lots of files missing.

So the short answer is: no.

Regards,
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
