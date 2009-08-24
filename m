From: Chris Mason <chris.mason@oracle.com>
Subject: Re: The first character disappears
Date: Mon, 24 Aug 2009 07:52:32 -0400
Message-ID: <20090824115232.GC15449@think>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Markus Suvanto <markus.suvanto@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 24, 2009 at 08:17:21AM +0300, Markus Suvanto wrote:
> After bcp the first character disappears.
> Kernel:=A0 2.6.31-rc7
> Btrfs v0.19-1-g4f89b6e
>=20
>=20
> Way to reproduce:
>=20
> htpc ~ # lvm lvcreate -L 5G -n btrfs_test /dev/vg_md1
> =A0 Logical volume "btrfs_test" created
>=20
> htpc ~ # mkbtrfs /dev/mapper/vg_md1-btrfs_test
>=20
> WARNING! - Btrfs v0.19-1-g4f89b6e IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>=20
> fs created label (null) on /dev/mapper/vg_md1-btrfs_test
> =A0=A0=A0=A0=A0=A0=A0 nodesize 4096 leafsize 4096 sectorsize 4096 siz=
e 5.00GB
> Btrfs v0.19-1-g4f89b6e
>=20
> mount -t btrfs -o subvol=3D. /dev/mapper/vg_md1-btrfs_test /tmp/btrfs=
/
>=20
> htpc ~ # btrfsctl -S test /tmp/btrfs/
> operation complete
> Btrfs v0.19-1-g4f89b6e
>=20
> htpc ~ # cd /tmp/btrfs/test/
>=20
> htpc test # git clone /usr/src/linux-2.6/
> Initialized empty Git repository in /tmp/btrfs/test/linux-2.6/.git/
> Checking out files: 100% (29110/29110), done.
>=20
> htpc test # btrfs-bcp linux-2.6/ linux-2.6_copy
> htpc test # ls -la linux-2.6_copy/

Well, that's not good.  Thanks for this report, I'll take a look as I g=
o
through my mountain of vacation backlog.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
