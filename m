From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Backup Command
Date: Tue, 11 Jan 2011 15:19:11 +0100
Message-ID: <201101111519.11246.hka@qbs.com.pl>
References: <201101100525.32427.CACook@quantum-sci.com> <201101101436.24713.hka@qbs.com.pl> <4D2C611E.7020004@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Ivan =?utf-8?q?Lab=C3=A1th?= <ilabath@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2C611E.7020004@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, January 11, 2011 14:54:38 Ivan Lab=C3=A1th wrote:
> On 01/10/11 14:36, Hubert Kario wrote:
> > On Monday 10 of January 2011 14:25:32 Carl Cook wrote:
> >> Here is my proposed cron:
> >>=20
> >> btrfs subvolume snapshot hex:///home /media/backups/snapshots/hex-=
{DATE}
> >>=20
> >> rsync --archive --hard-links --delete-during --delete-excluded --i=
nplace
> >> --numeric-ids -e ssh --exclude-from=3D/media/backups/exclude-hex
> >> hex:///home /media/backups/hex
> >>=20
> >> btrfs subvolume snapshot droog:///home
> >> /media/backups/snapshots/droog-{DATE}
> >>=20
> >> rsync --archive --hard-links --delete-during --delete-excluded --i=
nplace
> >> --numeric-ids -e ssh --exclude-from=3D/media/backups/exclude-droog
> >> droog:///home /media/backups/droog
> >>=20
> >> Comments?  Criticisms?
> >=20
> > This will make the dates associated with snapshots offset by how of=
ten
> > cron is run.
> >=20
> > In other words, if you run above script daily you will have data fr=
om
> > 2011.01.01 in the hex-2011.01.02 directory.
> >=20
> > I do save the current date, do a LVM snapshot on the source, rsync
> > --inplace data over and do a local snapshot naming the folder using=
 the
> > saved date. This way the date in the name of backup directory is ex=
act
> > to about a second.
>=20
> If you are mounting a LVM snapshot of an already mounted filesystem,
> would you be willing verify that it is really a snapshot that is moun=
ted?
>=20
> e.g. touch /mnt/live/its_alive && ls /mnt/snapshot/
>=20
> I am nearly willing to bet it is not a snapshot.

well, by "LVM snapshot on the source" I meant:
1. do lvcreate --snapshot
2. mount newly created volume=20
3. use the new directory as the base for rsync
4. arrange umount and destruction of the snapshot after rsync completes=
 (no=20
matter if it was successful)

and this will in fact not make the "its_alive" visible in /mnt/snapshot

You have to use this procedure if you use LVM snapshots for backup no m=
atter=20
to where do you copy data. That's why I shortened it to a single point =
-- it's=20
not the part that is important from btrfs perspective.

Regards.
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
