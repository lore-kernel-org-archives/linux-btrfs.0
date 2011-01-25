From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Synching a Backup Server
Date: Tue, 25 Jan 2011 18:43:20 +0100
Message-ID: <201101251843.21037.hka@qbs.com.pl>
References: <201101060935.14059.CACook@quantum-sci.com> <201101221455.45968.hka@qbs.com.pl> <4D3F087F.20905@schleiser.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: Kaspar Schleiser <kaspar@schleiser.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3F087F.20905@schleiser.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, January 25, 2011 18:29:35 Kaspar Schleiser wrote:
> On 01/22/2011 02:55 PM, Hubert Kario wrote:
> >> It looks like ZFS, Btrfs, and LVM should work in similar manners, =
but
> >> the overloaded terminology (pool, volume, sub-volume, filesystem a=
re
> >> different in all three) and new terminology that's only in Btrfs i=
s
> >> confusing.
> >=20
> > With btrfs you need to have *a* filesystem, once you have it, you c=
an add
> > and remove disks/partitions from it, no need to use 'mkfs.btrfs', j=
ust
> > 'btrfs'.
>=20
> That's just a design decision, right? There's no need for a "default"=
 or
> "root" subvolume.
>=20
> It should be rather easy to change btrfs so that you first have to
> create a "storage pool" which combines disks for btrfs, and on top of
> that you can create "filesystems" which are just subvolumes.
>=20
> The creation of a "storage pool" could be very similar to the current
> mkfs, just without the creation of a root subvolume.
>=20
> A new, simpler mkfs would then just create a subvolume on top of the
> "storage pool" that can be mounted.
>=20
> Regards,
> Kaspar

I'm not sure, but for btrfs to support storage pools the way ZFS does w=
ould=20
require change in disk layout.

Besides, I don't see *why* this should be done...

And as far as I know ZFS doesn't support different reduncancy levels fo=
r=20
different files residing in the same directory. You can have=20
~/1billion$-project.tar.gz with triple redundancy and ~/temp.video.mkv =
with no=20
reduncancy with btrfs...

Regards,
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
