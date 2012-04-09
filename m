From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: "Invalid argument" when mounting a btrfs raid1 filesystem
Date: Mon, 9 Apr 2012 13:58:16 +0200
Message-ID: <201204091358.17229.Martin@lichtvoll.de>
References: <87vclt99tg.fsf@falma.de> <20120326085134.GK2040@x2.net.home> <1332774058.22830.2.camel@ayu> (sfid-20120326_183334_799404_40348DC5)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	Karel Zak <kzak@redhat.com>, Hugo Mills <hugo@carfax.org.uk>,
	Christoph Groth <cwg@falma.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332774058.22830.2.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 26. M=C3=A4rz 2012 schrieb Calvin Walton:
> On Mon, 2012-03-26 at 10:51 +0200, Karel Zak wrote:
> > On Sat, Mar 24, 2012 at 06:21:05PM +0000, Hugo Mills wrote:
> > >    As Sadner says, you have to run "btrfs dev scan" before you tr=
y
> > >    to
> > >=20
> > > mount the FS. If you have root on btrfs, this will have to go in =
an
> > > initrd; otherwise, it can go in your initscripts anywhere before
> > > the non-root filesystem mounts.
> > >=20
> > >    Basically, the kernel needs to know which devices hold which
> > >    btrfs
> > >=20
> > > filesystems (organised by UUID) before it tries to mount them. So=
,
> > > there's an ioctl that is used for sending that data to the kernel=
,
> > > and a userspace tool (btrfs dev scan) that enumerates all of the
> > > block devices it can see, looks for a btrfs superblock on them,
> > > and tells the kernel.
> > =20
> >  Please, move all this logic to udev rules where we already scans a=
ll
> >  devices. It's really bad to scan all device more than once. We spe=
nt
> >  years to fix this problem for LVM, I don't think that btrfs has to
> >  repeat the same mistakes.
>=20
> Oh, this is already possible to do with udev rules, quite easily. In
> fact, dracut ships with the appropriate udev rules, which it uses to
> initialize btrfs filesystems in the initramfs:
>=20
> http://git.kernel.org/?p=3Dboot/dracut/dracut.git;a=3Dblob;f=3Dmodule=
s.d/90bt
> rfs/80-btrfs.rules;hb=3DHEAD
>=20
> which would be suitable with minor modifications for use in a system
> udev installation as well.

I reported this for Debian long time ago as:

please support raid configurations automatically
http://bugs.debian.org/bug=3D634658

I will be forwarding your mail to the bug report as to suggest this ude=
v=20
based solution.

I has also been reported as:

btrfs-tools: add initramfs boot and hook scripts
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D559710

please provide non-initramfs-tools integration
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D585568

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
