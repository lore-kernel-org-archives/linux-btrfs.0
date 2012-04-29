From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Sun, 29 Apr 2012 08:13:48 +0200
Message-ID: <201204290813.48417.Martin@lichtvoll.de>
References: <4F98B447.30102@ennit.de> <4F991027.6000903@ennit.de> <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com> (sfid-20120426_132755_567365_AE299C6C)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 26. April 2012 schrieb Bart Noordervliet:
> On Thu, Apr 26, 2012 at 11:06, Thomas Rohwer <trohwer@ennit.de> wrote=
:
> >> As for the two filesystems shown in btrfs fi show... I have no clu=
e
> >> what that is about. Did you maybe make a mistake to create a btrfs
> >> filesystem on the whole disk at first?
> >=20
> > That is possible. But afterwards I certainly repartioned the device
> > and created a btrfs filesystem on /dev/sda1. Maybe this info is onl=
y
> > in the partition table? I understand that I should avoid mounting
> > /dev/sda in this situation.
>=20
> Well I think there is a btrfs superblock still present from the
> full-disk filesystem. Due to the offset of the first partition from
> the start of the disk, this superblock was not overwritten when you
> created the filesystem inside the partition. But they very much
> overlap and the full-disk superblock will probably eventually be
> overwritten by elements from the partition filesystem. How you would
> go about erasing the stale superblock and whether it is safe to do so
> I can't say though.

There is the command wipefs. Whether its safe to use here I do not know=
=2E I=20
wouldn=C2=B4t try without a backup.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
