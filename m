From: J G <yoosty_cmn@yahoo.com>
Subject: Re: Odd mkbtrfs behavior inside of chroot
Date: Tue, 4 Jan 2011 15:16:11 -0800 (PST)
Message-ID: <736694.94344.qm@web112520.mail.gq1.yahoo.com>
References: <4D2106D0.80609@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2106D0.80609@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

You're little trick with touching a blank /proc/mounts works, FWIW.

You're "--force" patch works even better however ;)
Thanks!

=2E:Justin:.


--- On Sun, 1/2/11, Goffredo Baroncelli <kreijack@libero.it> wrote:

> From: Goffredo Baroncelli <kreijack@libero.it>
> Subject: Re: Odd mkbtrfs behavior inside of chroot
> To: "J G" <yoosty_cmn@yahoo.com>
> Cc: linux-btrfs@vger.kernel.org
> Date: Sunday, January 2, 2011, 3:14 PM
> On 01/02/2011 08:52 PM, J G wrote:
> > I just encountered some odd behavior from mkbtrfs.
> > The end goal is to restore a backup to newly created
> BTRFS partitions while using the latest btrfs-tools.=20
> > Here's the steps to what I did:
> > * Booted SystemRescueCD
> > * Partitioned the drives (two 750GB drives with 12
> partitions each)
> > * Created an extra partition on sda as a temporary
> holding place for the backed up files and so I can update
> btrfs-tools
> > * Formatted/mounted/restored backup files to the
> temporary partition which I mounted on /mnt/backup
> > * mount -t proc none /mnt/backup/proc; mount -o bind
> /dev /mnt/backup/dev
> > * chroot /mnt/backup /bin/bash
> > * Updated btrfs-tools to the latest git pull from
> today (v0.19-35-g1b444cd-dirty).
> > * mkbtrfs /dev/sda5 /dev/sdb5 -L root
> >=20
> > mkbtrfs returned with:
> >=20
> > error checking /dev/sda5 mount status
> >=20
> > So I used strace to find out how it was checking for
> the mount status. Now, I'm no expert here, but I'm confused
> as to just why it failed. The last thing of note:
> >=20
> > lstat("/boot", {st_mode=3DS_IFDIR|0755, st_size=3D4096,
> ...}) =3D 0
> > lstat("/boot/sysrcd.dat", 0x7fffb29681e0) =3D -1 ENOENT
> (No such file or directory)
> > close(3)=A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =3D 0
> > munmap(0x7f11df372000, 4096)=A0 =A0 =A0
> =A0 =A0 =A0 =3D 0
> > write(2, "error checking /dev/sda5 mount s"...,
> 38error checking /dev/sda5 mount status
> > ) =3D 38
> >=20
> >=20
> > doesn't explain much. I see that it's checking
> /proc/mounts to see what's mounted, and then it fails on
> stating /boot/sysrcd.dat (which doesn't exist in the
> non-chrooted FS, btw).
> >=20
> > To make this even weirder, if I format sda5/sdb5 using
> the SysRescCD version of mkbtrfs (v0.19) and then format
> sda5/sdb5 using the chroot version, it works fine.
> >=20
> > Any ideas here? I would expect that mkbtrfs would work
> inside of a chroot without any assistance from the original
> root.
> >=20
> > I have the full strace from the chrooted mkbtrfs
> failing and from it succeeding, if that's helpful.
>=20
> On the basis of the provided information, and on the code
> it seems that
> mkfs.btrfs tries hard to check that the user is not
> formatting a mounted
> disk (or loop). So mkfs.btrfs scan the /proc/mount file and
> checks every
> devices. To do the check it needs to access the original
> file if this is
> a "loop backend". This is reasonable.
>=20
> In this case in a chroot-ed environment the loop file is
> not accessible.
>=20
> If you need a [dirty] "quick hack" to by-pass the problem
> (not tested):
> - unmount the proc filesystem
> - create an empty file /proc/mounts
> - run btrfs.fsck
> - mount the proc filesystem (removing the fake mounts
> file)
> - perform a "btrfs device scan"
> - mount the filesystem
>=20
> Of course the "right" solution is to add a "--force" switch
> which
> permits to by-pass these checks. Other mkfs.* tools have
> this switch.
>=20
> From the mkfs.ext4 man page:
> [...]
> =A0 =A0 =A0=A0=A0-F=A0
> =A0=A0=A0Force mke2fs to create a filesystem,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 even if
> the specified device is=A0 not
> =A0 =A0 =A0 =A0 =A0 =A0 =A0
> a=A0=A0=A0partition=A0 on=A0 a=A0
> block=A0 special
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 device, or
> if=A0 other=A0 parameters=A0 do
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 not=A0
> make=A0 sense.=A0 In order to force
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mke2fs to
> create a=A0 filesystem=A0 even
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if=A0
> the=A0 filesystem appears to be in
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 use or is
> mounted (a truly dangerous
> =A0 =A0 =A0 =A0 =A0 =A0 =A0
> thing=A0 to=A0 do),=A0 this option must be
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 specified
> twice.
>=20
> [...]
>=20
>=20
> >=20
> > .:Justin:.
> >=20
> >=20
> >=A0 =A0 =A0=A0=A0
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at=A0 http://vger.kernel.org/majordomo-info.htm=
l
> > .
> >=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
