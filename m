From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs fi df returns nothing
Date: Wed, 9 Mar 2011 12:47:45 +0100
Message-ID: <201103091247.46177.hka@qbs.com.pl>
References: <il7npu$5lh$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <il7npu$5lh$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

There's a daily kernel build PPA:
http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/2011-03-08-natty/

Sorry to note, but have you even tried googling for it?

On Wednesday, March 09, 2011 12:20:28 Brian J. Murrell wrote:
> I am using btrfs on Ubuntu's LTS kernel (2.6.32-22-generic) and have
> updated the btrfs-tools to 0.19+20101101-1~lucid1.  I have also built
> the latest from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unsta=
ble.gi
> t.
>=20
> The problem is that I don't get anything from btrfs fi df $mountpoint=
=2E
> i.e., for the btrfs filesystem mounted at /mnt/btrfs-test/
>=20
> # ./btrfs fi df /mnt/btrfs-test/
> #
>=20
> See, no output.  Is my kernel module too old for that feature?  Maybe=
 it
> is:
>=20
> stat64("/mnt/btrfs-test/", {st_mode=3DS_IFDIR|0755, st_size=3D72, ...=
}) =3D 0
> open("/mnt/btrfs-test/",
> O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) =3D 3
> fcntl64(3, F_GETFD)                     =3D 0x1 (flags FD_CLOEXEC)
> ioctl(3, 0xc0109414, 0x999c320)         =3D -1 ENOTTY (Inappropriate =
ioctl
> for device)
> exit_group(-1)                          =3D ?
>=20
> If my kernel module is too old, anyone know of a successful backport =
of
> a newer btrfs for Ubuntu Lucid?  In a PPA or otherwise?
>=20
> Cheers,
> b.

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
