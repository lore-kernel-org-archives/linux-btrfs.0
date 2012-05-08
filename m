From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 08 May 2012 23:42:10 +0200
Message-ID: <5156602.piaP8M9t4d@bursa22>
References: <C8TEkB+PCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TEkB+PCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 08 of May 2012 12:00:00 Helmut Hullen wrote:
> Hallo, Fajar,
>=20
> Du meintest am 08.05.12:
> >>> And you can use three BTRFS filesystems the same way as three Ext=
4
> >>> filesystems if you prefer such a setup if the time spent for
> >>> restoring the backup does not make up the cost for one additional
> >>> disk for you.
> >>=20
> >> But where's the gain? If a disk fails I have a lot of tools for
> >> repairing an ext2/3/4 system.
> >=20
> > It won't work if you use it in RAID0 (e.g. with LVM spanning three
> > disks, then use ext4 on top of the LV).
>=20
> But when I use ext2/3/4 I neither need RAID0 nor do I need LVM.
>=20
> > As others said, if your only concern is "if a disk is dead, I want =
to
> > be able to access data on other disks", then simply use btrfs as
> > three different fs, mounted on three directories.
>=20
> But then I don't need especially btrfs.
>=20
> > btrfs will shine when:
> > - you need checksum and self-healing in raid10 mode
> > - you have lots of small files
> > - you have highly compressible content
> > - you need snapshot/clone feature
>=20
> For my video collection (mpeg2) nothing fits ...
>=20
> The only advantage I see with btrfs is
>=20
>         adding a bigger disk
>         deleting/removing a smaller disk
>=20
> with really simple commands.

Playing the Devil's advocate here (not that I don't use The Other Linux=
 FS=20
;)

I don't see btrfs commands much different from
pvcreate /dev/new-disk
vgextend videos-volume-42 /dev/new-disk
pvmove /dev/old-disk /dev/new-disk
vgreduce videos-volume-42 /dev/old-disk
resize2fs /dev/videos-volume-42/logical-volume

Unlike with shrinking, there's really no place for error. Messing up th=
ose=20
commands will give quite clear error messages and definetly won't destr=
oy=20
data (unless a hardware error occurs). And the FS on the LV is online a=
ll=20
the time, just like with btrfs.

The only difference is that with btrfs you can both extend and shrink t=
he FS=20
online, with ext2/3/4 you can only extend online...

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
