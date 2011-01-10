From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Backup Command
Date: Mon, 10 Jan 2011 14:36:24 +0100
Message-ID: <201101101436.24713.hka@qbs.com.pl>
References: <201101100525.32427.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101100525.32427.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 10 of January 2011 14:25:32 Carl Cook wrote:
> Here is my proposed cron:
>=20
> btrfs subvolume snapshot hex:///home /media/backups/snapshots/hex-{DA=
TE}
>=20
> rsync --archive --hard-links --delete-during --delete-excluded --inpl=
ace
> --numeric-ids -e ssh --exclude-from=3D/media/backups/exclude-hex hex:=
///home
> /media/backups/hex
>=20
> btrfs subvolume snapshot droog:///home
> /media/backups/snapshots/droog-{DATE}
>=20
> rsync --archive --hard-links --delete-during --delete-excluded --inpl=
ace
> --numeric-ids -e ssh --exclude-from=3D/media/backups/exclude-droog
> droog:///home /media/backups/droog
>=20
> Comments?  Criticisms?

This will make the dates associated with snapshots offset by how often =
cron is=20
run.

In other words, if you run above script daily you will have data from=20
2011.01.01 in the hex-2011.01.02 directory.

I do save the current date, do a LVM snapshot on the source, rsync --in=
place=20
data over and do a local snapshot naming the folder using the saved dat=
e. This=20
way the date in the name of backup directory is exact to about a second=
=2E
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
