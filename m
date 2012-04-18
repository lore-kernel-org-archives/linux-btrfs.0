From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Btrfs in degraded mode
Date: Wed, 18 Apr 2012 18:45:11 +0200
Message-ID: <201204181845.11400.Martin@lichtvoll.de>
References: <loom.20120417T181336-69@post.gmane.org> <pan.2012.04.18.06.42.15@cox.net> (sfid-20120418_152838_787859_C21E7CF9)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.04.18.06.42.15@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 18. April 2012 schrieb Duncan:
> Shridhar Shetty posted on Tue, 17 Apr 2012 16:14:45 +0000 as excerpte=
d:
> > I have created a btrfs filesystem with RAID1 setup having 2 disks.
> > Everything works fine but when I try to umount the device and remou=
nt
> > it in degraded mode,
> > the data still goes into both the disk. ideally in degraded mode on=
ly
> > one disk show disk activity and not the failed ones.
> >
> >=20
> >
> > System Config:
> > Base OS: Slackware kernel: linux 3.3.2
> >
> >=20
> >
> > "sar -pd 2 10" shows me that the data is been written/read from bot=
h
> > devices.
> >
> >=20
> >
> > Also, Is there any way in which I can remove the failed disk withou=
t
> > adding a new one in a RAID1 (2 disk setup). The reason being we wan=
t
> > the option to keep it running in degraded(single disk) mode for
> > sometime and on a weekend replace the failed drive with a fresh one
> > :-).
>=20
> Are you sure you created the filesystem with raid1 mode for both data
> and  metadata?  Some people end up with only one or the other set to
> raid1 mode (metadata defaults to mirroring on two-device, but data
> will default to single if not specifically set).
>=20
> Meanwhile, AFAIK the degraded option doesn't force degraded, it only=20
> allows mounting degraded if the other device is non-functional.  If
> btrfs  detects all its devices and doesn't detect a problem with one,
> it'll still try to run all devices, regardless of the degraded
> mount-option.

You can echo 1 >

martin@merkaba:/sys/block/sda/device> ls -l delete
--w------- 1 root root 4096 Apr 18 18:40 delete

of the device you want to get rid of. (Double check that you have got t=
he=20
right device!)

But you either need to reboot (tested) or to rescan the bus to get the=20
device back (untested, don=C2=B4t know whether this works).

btrfs filesystem show should then report the device as missing and you=20
should be able to delete it from it.

But then btrfs device delete should do the same in a cleaner way. (I.e.=
=20
without remove the device from Linux entirely.)

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
