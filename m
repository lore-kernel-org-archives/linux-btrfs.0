From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Mon, 30 Apr 2012 19:10:26 +0200
Message-ID: <4295276.7uL8mlRAJE@bursa01>
References: <4F98B447.30102@ennit.de> <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com> <201204290813.48417.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201204290813.48417.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 29 of April 2012 08:13:48 Martin Steigerwald wrote:
> Am Donnerstag, 26. April 2012 schrieb Bart Noordervliet:
> > On Thu, Apr 26, 2012 at 11:06, Thomas Rohwer <trohwer@ennit.de> wro=
te:
> > >> As for the two filesystems shown in btrfs fi show... I have no c=
lue
> > >> what that is about. Did you maybe make a mistake to create a btr=
fs
> > >> filesystem on the whole disk at first?
> > >=20
> > > That is possible. But afterwards I certainly repartioned the devi=
ce
> > > and created a btrfs filesystem on /dev/sda1. Maybe this info is o=
nly
> > > in the partition table? I understand that I should avoid mounting
> > > /dev/sda in this situation.
> >=20
> > Well I think there is a btrfs superblock still present from the
> > full-disk filesystem. Due to the offset of the first partition from
> > the start of the disk, this superblock was not overwritten when you
> > created the filesystem inside the partition. But they very much
> > overlap and the full-disk superblock will probably eventually be
> > overwritten by elements from the partition filesystem. How you woul=
d
> > go about erasing the stale superblock and whether it is safe to do =
so
> > I can't say though.
>=20
> There is the command wipefs. Whether its safe to use here I do not kn=
ow. I
> wouldn=B4t try without a backup.

Sorry, but I'm unable to find it. Is it a `btrfs` tool option or is it =
a=20
standalone application (in similar form as is the `btrfs-zero-log`)?

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
