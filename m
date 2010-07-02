From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: Copy/move btrfs volume
Date: Fri, 02 Jul 2010 08:15:03 +0200
Message-ID: <03lj9ujtp4.fsf@msgid.viggen.net>
References: <i0hqkk$r4h$1@dough.gmane.org>
	<AANLkTin1O6Oa7oq4nFMfNhv4N5FWCko7bcuTMoR5Xkob@mail.gmail.com>
	<i0huf7$98a$1@dough.gmane.org> <4C2D14DA.3040301@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* [Matt Brown]=20

> With backed up files consisting of hard links, I usually use dd to co=
py
> the file systems at the block level
>
> # dd if=3D/dev/sda of=3D/dev/sdb bs=3D20M
>
> and then expand the file system. This is because I found that tools l=
ike
> rsync, while usually fast, are extremely slow when dealing with milli=
ons
> of hard linked files.
>
> This could also be used for btrfs to keep its snapshots.

If you can (temporarily) attach the old and new drives to the same
computer, putting the ext4 BackupPC store on LVM and moving the LV
around might be more convenient, or at least feel more "high level".

=46or btrfs with lots of snapshots, I believe "btrfs device add" of the
new device followed by "btrfs device remove" of the old one would be th=
e
most convenient.

One advantage of using LVM and btrfs multi device support in this way i=
s
that the actual downtime is minimal -- you can keep the filesystems
online.  Even on cheap hardware, the only downtime should be to
attach/remove disks.

=D8ystein
--=20
If it ain't broke, don't break it.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
