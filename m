From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Sun, 9 Jan 2011 09:59:46 -0800
Message-ID: <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<201101061342.23991.CACook@quantum-sci.com>
	<AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
	<201101071720.08298.hka@qbs.com.pl>
	<4D29A033.7000803@chandlerfamily.org.uk>
	<AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
	<4D29D508.6080006@chandlerfamily.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Alan Chandler <alan@chandlerfamily.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D29D508.6080006@chandlerfamily.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 9, 2011 at 7:32 AM, Alan Chandler
<alan@chandlerfamily.org.uk> wrote:
> I think I start to get it now. =C2=A0Its the fact that subvolumes can=
 be
> snapshotted etc without mounting them that is the difference. =C2=A0I=
 guess I am
> too used to thinking like LVM and I was thinking subvolumes where lik=
e an
> LV. =C2=A0They are, but not quite the same.

Let see if I can match up the terminology and layers a bit:

LVM Physical Volume =3D=3D Btrfs disk =3D=3D ZFS disk / vdevs
LVM Volume Group =3D=3D Btrfs "filesystem" =3D=3D ZFS storage pool
LVM Logical Volume =3D=3D Btrfs subvolume =3D=3D ZFS volume
'normal' filesysm =3D=3D Btrfs subvolume (when mounted) =3D=3D ZFS file=
system

Does that look about right?

LVM: A physical volume is the lowest layer in LVM and they are
combined into a volume group which is then split up into logical
volumes, and formatted with a filesystem.

Btrfs: A bunch of disks are "formatted" into a btrfs "filesystem"
which is then split up into sub-volumes (sub-volumes are
auto-formatted with a btrfs filesystem).

ZFS: A bunch of disks are combined into virtual devices, then combined
into a ZFS storage pool, which can be split up into either volumes
formatted with any filesystem, or ZFS filesystems.

Just curious, why all the new terminology in btrfs for things that
already existed?  And why are old terms overloaded with new meanings?
I don't think I've seen a write-up about that anywhere (or I don't
remember it if I have).

Perhaps it's time to start looking at separating the btrfs pool
creation tools out of mkfs (or renaming mkfs.btrfs), since you're
really building a a storage pool, and not a filesystem.  It would
prevent a lot of confusion with new users.  It's great that there's a
separate btrfs tool for manipulating btrfs setups, but "mkfs.btrfs" is
just wrong for creating the btrfs setup.
--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
