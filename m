From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: btrfs-progs: New utility to swap subvolumes
Date: Wed, 6 Jan 2010 21:21:26 +0100
Message-ID: <201001062121.35342.kreijack@libero.it>
References: <4B32CF4D.90406@jp.fujitsu.com> <201001060856.17940.kreijack@libero.it> <4B4450C0.3050607@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4859778.ps7o7qZhqh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
	linux-btrfs@vger.kernel.org
To: Piavlo <piavka@cs.bgu.ac.il>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4450C0.3050607@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4859778.ps7o7qZhqh
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

Hello,

here [*] you can find my script.=20
=2D---> Please pay attention to the fact that it is only tested on my *ubun=
tu*=20
box. <----

The program has 4 main commands:

$ ./snapmng.sh
        snapmng.sh [-n] create <snapname> [<comment>]   Create a new snapsh=
ot.
        snapmng.sh list                                 List the  snapshots.
        snapmng.sh [-n] delete <snapname>               Delete a snapshot.
        snapmng.sh update-grub                          Update grub menulis=
t.
        snapmng.sh help                                 Show help (this).

        If the switch '-n' is passed, then 'create' and 'delete' commands
	don't update the grub menu.
        If <snapname> is equal to '.' in the 'create' command, the name is
        generated automatically like snap-YYYYMMDD.

** list
This is the simplest; this function lists the snapshot on the basis of the=
=20
content of the file /var/btrfs/snaplist.txt

** update-grub
This is the most triky function. This function update the grub menu on the=
=20
basis of the snapshot contained in the /var/btrfs/snaplist.txt.

The first entry of the grub menu is extracted. Then for every snapshots thi=
s=20
entry is added to the end of the "/boot/grub/menu.lst", replacing=20
"subvol=3Drootfs" with "subvol=3D<snapshotname>".
These entries are delimited by the two following rows:

	### BEGIN BTRFS SNAPSHOT ITEMS
	[...]
	### END BTRFS SNAPSHOT ITEMS

So it is possible to update the "/boot/grub/menu.lst" file without affectin=
g=20
the other entries.

** create
this command creates a new snapshot and update the grub config file. If the=
=20
switch "-n" is passed the menu.lst file will not be updated.

** delete
this command deletes a snapshot  and update the grub config file. If the=20
switch "-n" is passed the menu.lst file will not be updated


I repeat the btrfs filesystem layout.

Nomenclature:=20
=2D- root of system -> where there are the typical directories/files like /=
bin,=20
/sbin /usr /etc...
=2D- root of the (btrfs) file-system -> where there are the snapshots or=20
subvolumes

Under root of the filesystem there are the *subvolume* for the root of the=
=20
system. Its name is "rootfs", and contains the standard filesystem  (/bin /=
usr=20
/sbin /etc ... ).
The snapshot of the root of the system is still under /

So the filesystem layout is

/
  \
  +--rootfs	system root (subvolume)
  |    \
  |     +--/bin
  |     +--/sbin
  |     +--/etc
  |     +--/usr
  |	    [...]
  +--snap-123      snapshot of the system root #123
  |    \
  |     +--/bin
  |     +--/sbin
  |	    [...]
  +--snap-3456     snapshot of the system root #3456
  |    \
  |     +--/bin
  |     +--/sbin
  |	    [...]

At the boot time as root is not mounted the root of the filesystem, but the=
=20
subvolume/snapshot "rootfs"

Tipically in my ubuntu the grub entry is

	title           Ubuntu 9.10, kernel 2.6.31-17-generic
	root            (hd0,0)
	kernel          /vmlinuz root=3D/dev/sdX ro rootflags=3Dsubvol=3Drootfs=20
	initrd          /initrd.img-2.6.31-17-generic
	quiet

Note the part "rootflags=3Dsubvol=3Drootfs".
Pay attention that the prefix "rootflags" is debian related (it should work=
s=20
for both debian and ubuntu). For examples for Fedora, the prefix would be=20
"rootfsflags".

for administration purpose the root of the btrfs filesystem is mounted unde=
r=20
/var/btrfs. In my /etc/fstab there are the following lines:

  /dev/sdX  /           btrfs  subvol=3Drootfs,errors=3Dremount-ro,noatime =
 0 1
  /dev/sdX  /var/btrfs  btrfs  subvol=3D.,errors=3Dremount-ro,noatime      =
 0 1


[*] http://cassiopea.homelinux.net/git/?p=3Dsnapmng/.git;a=3Dsummary

BR
Goffredo

On Wednesday 06 January 2010, you (Piavlo) wrote:
>  Hi Goffredo,
>=20
> I'm interested in your script.
>=20
> BTW great article - seems to be very similar to how opensolaris handles
> boot environments with zfs.
>=20
> Also I think it's better to keep the /boot as separate btrfs subvolume -
> in order to have only one
> instance of /boot/grub/menu.lst and kernels independent of all the
> rootfs snapshots - of course this will
> work only of grub2 can be told to look for /boot/grub/menu.lst under the
> btrfs boot subvolume - otherwise
> we need to store the /boot as normal directory under the root subvolume
> of the btrfs filesystem.
>=20
> I've implemented your idea , but currently the /boot is stored under
> ext3 with legacy-grub.
> Need to check it will work with boot inside btrfs with grub2.
>=20
> Thanks
> Alex
>=20
> Goffredo Baroncelli wrote:
> > On Wednesday 06 January 2010, TARUISI Hiroaki wrote:
> >  =20
> >> Thanks for your greetings.
> >>
> >> I read your article, and could follow your idea, which looks
> >> very practical rule to me.
> >> But we may need some application which support to create or maintain
> >> these rules because the relation mount point and subvolumes and
> >> snapshots gets complicated as number of subvolumes increases.
> >>    =20
> >
> > I wrote a little script which handle the snapshot=20
creation/deleting/listing=20
> > and grub config file update.
> >
> > This script supposing the layout which I discussed
> >
> > - under /var/btrfs is mounter the real root btrfs filesystem
> > - under the real root file-system there are the snapshots and the root =
of=20
the=20
> > system (rootfs)
> > - in /var/btrfs/snaplist.txt there is the list of snaphsot
> > - in /boot/grub/menu.lst there is the grub configuration
> >
> > In you are interested, I can send you.
> >
> > BR=20
> > Goffredo
> >
> >  =20
>=20
>=20


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart4859778.ps7o7qZhqh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLRPDGvwTxYT3FBRIRAreCAJ40HTlPnDoqR4rp7Mzk28LHP7cX1gCeLJxN
bGxAw/ijrABLO2+NtxXEoBs=
=5R6T
-----END PGP SIGNATURE-----

--nextPart4859778.ps7o7qZhqh--
