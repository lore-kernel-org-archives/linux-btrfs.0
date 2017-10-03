Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45846 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdJCQAF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 12:00:05 -0400
Date: Tue, 3 Oct 2017 16:00:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: fred.larive@free.fr
Cc: "Hugo Mills - hugo@carfax.org.uk"
        <btrfs.fredo.d1c3ddb588.hugo#carfax.org.uk@ob.0sg.net>,
        linux-btrfs@vger.kernel.org, btrfs fredo <btrfs.fredo@xoxy.net>
Subject: Re: Lost about 3TB
Message-ID: <20171003160004.GD3293@carfax.org.uk>
References: <20171003105405.GC3293@carfax.org.uk>
 <762341433.435173804.1507045554405.JavaMail.root@zimbra65-e11.priv.proxad.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AkbCVLjbJ9qUtAXD"
In-Reply-To: <762341433.435173804.1507045554405.JavaMail.root@zimbra65-e11.priv.proxad.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--AkbCVLjbJ9qUtAXD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 03, 2017 at 05:45:54PM +0200, fred.larive@free.fr wrote:
> Hi,
>=20
>=20
> >   What does "btrfs sub list -a /RAID01/" say?
> Nothing (no lines displayed)
>=20
> >   Also "grep /RAID01/ /proc/self/mountinfo"?
> Nothing (no lines displayed)
>=20
>=20
> Also server has been rebooted many times and no process has left "deleted=
 open files" on the volume (lsof...).

   OK. The second command (the grep) was incorrect -- I should have
omitted the slashes. However, it doesn't matter too much, because the
first command indicates that you don't have any subvolumes or
snapshots anyway.

   This means that you're probably looking at the kind of issue
Timofey mentioned in his mail, where writes into the middle of an
existing extent don't free up the overwritten data. This is most
likely to happen on database or VM files, but could happen on others,
depending on the application and how it uses files.

   Since you don't seem to have any snapshots, I _think_ you can deal
with the issue most easily by defragmenting the affected files. It's
worth just getting a second opinion on this one before you try it for
the whole FS. I'm not 100% sure about what defrag will do in this
case, and there are some people round here who have investigated the
behaviour of partially-overwritten extents in more detail than I have.

   Hugo.

> Fred.
>=20
>=20
> ----- Mail original -----
> De: "Hugo Mills - hugo@carfax.org.uk" <btrfs.fredo.d1c3ddb588.hugo#carfax=
=2Eorg.uk@ob.0sg.net>
> =C0: "btrfs fredo" <btrfs.fredo@xoxy.net>
> Cc: linux-btrfs@vger.kernel.org
> Envoy=E9: Mardi 3 Octobre 2017 12:54:05
> Objet: Re: Lost about 3TB
>=20
> On Tue, Oct 03, 2017 at 12:44:29PM +0200, btrfs.fredo@xoxy.net wrote:
> > Hi,
> >=20
> > I can't figure out were 3TB on a 36 TB BTRFS volume (on LVM) are gone !
> >=20
> > I know BTRFS can be tricky when speaking about space usage when using m=
any physical drives in a RAID setup, but my conf is a very simple BTRFS vol=
ume without RAID(single Data type) using the whole disk (perhaps did I do s=
omething wrong with the LVM setup ?).
> >=20
> > My BTRFS volume is mounted on /RAID01/.
> >=20
> > There's only one folder in /RAID01/ shared with Samba, Windows also see=
 a total of 28 TB used.
> >=20
> > It only contains 443 files (big backup files created by Veeam), most of=
 the file size is greater than 1GB and be be up to 5TB.
> >=20
> > ######> du -hs /RAID01/
> > 28T     /RAID01/
> >=20
> > If I sum up the result of : ######> find . -printf '%s\n'
> > I also find 28TB.
> >=20
> > I extracted btrfs binary from rpm version v4.9.1 and used ######> btrfs=
 fi du
> > on each file and the result is 28TB.
>=20
>    The conclusion here is that there are things that aren't being
> found by these processes. This is usually in the form of dot-files
> (but I think you've covered that case in what you did above) or
> snapshots/subvolumes outside the subvol you've mounted.
>=20
>    What does "btrfs sub list -a /RAID01/" say?
>    Also "grep /RAID01/ /proc/self/mountinfo"?
>=20
>    There are other possibilities for missing space, but let's cover
> the obvious ones first.
>=20
>    Hugo.
>=20
> > OS : CentOS Linux release 7.3.1611 (Core)
> > btrfs-progs v4.4.1
> >=20
> >=20
> > ######> ssm list
> >=20
> > -----------------------------------------------------------------------=
--
> > Device        Free      Used      Total  Pool                 Mount poi=
nt
> > -----------------------------------------------------------------------=
--
> > /dev/sda                       36.39 TB                       PARTITION=
ED
> > /dev/sda1                     200.00 MB                       /boot/efi
> > /dev/sda2                       1.00 GB                       /boot
> > /dev/sda3  0.00 KB  36.32 TB   36.32 TB  lvm_pool
> > /dev/sda4  0.00 KB  54.00 GB   54.00 GB  cl_xxx-xxxamrepo-01
> > -----------------------------------------------------------------------=
--
> > -------------------------------------------------------------------
> > Pool                    Type   Devices     Free      Used     Total
> > -------------------------------------------------------------------
> > cl_xxx-xxxamrepo-01     lvm    1        0.00 KB  54.00 GB  54.00 GB
> > lvm_pool                lvm    1        0.00 KB  36.32 TB  36.32 TB
> > btrfs_lvm_pool-lvol001  btrfs  1        4.84 TB  36.32 TB  36.32 TB
> > -------------------------------------------------------------------
> > -----------------------------------------------------------------------=
----------------------------------------------
> > Volume                         Pool                    Volume size  FS =
       FS size       Free  Type    Mount point
> > -----------------------------------------------------------------------=
----------------------------------------------
> > /dev/cl_xxx-xxxamrepo-01/root  cl_xxx-xxxamrepo-01        50.00 GB  xfs=
      49.97 GB   48.50 GB  linear  /
> > /dev/cl_xxx-xxxamrepo-01/swap  cl_xxx-xxxamrepo-01         4.00 GB     =
                           linear
> > /dev/lvm_pool/lvol001          lvm_pool                   36.32 TB     =
                           linear  /RAID01
> > btrfs_lvm_pool-lvol001         btrfs_lvm_pool-lvol001     36.32 TB  btr=
fs    36.32 TB    4.84 TB  btrfs   /RAID01
> > /dev/sda1                                                200.00 MB  vfa=
t                          part    /boot/efi
> > /dev/sda2                                                  1.00 GB  xfs=
    1015.00 MB  882.54 MB  part    /boot
> > -----------------------------------------------------------------------=
----------------------------------------------
> >=20
> >=20
> > ######> btrfs fi sh
> >=20
> > Label: none  uuid: df7ce232-056a-4c27-bde4-6f785d5d9f68
> >         Total devices 1 FS bytes used 31.48TiB
> >         devid    1 size 36.32TiB used 31.66TiB path /dev/mapper/lvm_poo=
l-lvol001
> >=20
> >=20
> >=20
> > ######> btrfs fi df /RAID01/
> >=20
> > Data, single: total=3D31.58TiB, used=3D31.44TiB
> > System, DUP: total=3D8.00MiB, used=3D3.67MiB
> > Metadata, DUP: total=3D38.00GiB, used=3D35.37GiB
> > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> >=20
> >=20
> >=20
> > I tried to repair it :
> >=20
> >=20
> > ######> btrfs check --repair -p /dev/mapper/lvm_pool-lvol001
> >=20
> > enabling repair mode
> > Checking filesystem on /dev/mapper/lvm_pool-lvol001
> > UUID: df7ce232-056a-4c27-bde4-6f785d5d9f68
> > checking extents
> > Fixed 0 roots.
> > cache and super generation don't match, space cache will be invalidated
> > checking fs roots
> > checking csums
> > checking root refs
> > found 34600611349019 bytes used err is 0
> > total csum bytes: 33752513152
> > total tree bytes: 38037848064
> > total fs tree bytes: 583942144
> > total extent tree bytes: 653754368
> > btree space waste bytes: 2197658704
> > file data blocks allocated: 183716661284864 ?? what's this ??
> >  referenced 30095956975616 =3D 27.3 TB !!
> >=20
> >=20
> >=20
> > Tried the "new usage" display but the problem is the same : 31 TB used =
but total file size is 28TB
> >=20
> > Overall:
> >     Device size:                  36.32TiB
> >     Device allocated:             31.65TiB
> >     Device unallocated:            4.67TiB
> >     Device missing:                  0.00B
> >     Used:                         31.52TiB
> >     Free (estimated):              4.80TiB      (min: 2.46TiB)
> >     Data ratio:                       1.00
> >     Metadata ratio:                   2.00
> >     Global reserve:              512.00MiB      (used: 0.00B)
> >=20
> > Data,single: Size:31.58TiB, Used:31.45TiB
> >    /dev/mapper/lvm_pool-lvol001   31.58TiB
> >=20
> > Metadata,DUP: Size:38.00GiB, Used:35.37GiB
> >    /dev/mapper/lvm_pool-lvol001   76.00GiB
> >=20
> > System,DUP: Size:8.00MiB, Used:3.69MiB
> >    /dev/mapper/lvm_pool-lvol001   16.00MiB
> >=20
> > Unallocated:
> >    /dev/mapper/lvm_pool-lvol001    4.67TiB
> > The only btrfs tool speaking about 28TB is btrfs check (but I'm not sur=
e if it's bytes because it speaks about "referenced blocks" and I don't und=
erstand the meaning of "file data blocks allocated")
> > Code:
> > file data blocks allocated: 183716661284864 ?? what's this ??
> >  referenced 30095956975616 =3D 27.3 TB !!
> >=20
> >=20
> >=20
> > I also used the verbose option of https://github.com/knorrie/btrfs-heat=
map/ to sum up the total size of all DATA EXTENT and found 32TB.
> >=20
> > I did scrub, balance up to -dusage=3D90 (and also dusage=3D0) and ended=
 up with 32TB used.
> > No snasphots nor subvolumes nor TB hidden under the mount point after u=
nmounting the BTRFS volume =20
> >=20
> >=20
> > What did I do wrong or am I missing ?
> >=20
> > Thanks in advance.
> > Frederic Larive.
> >=20
>=20

--=20
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Go=
ons

--AkbCVLjbJ9qUtAXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZ07QEAAoJEFheFHXiqx3ke3MP/j5wU18o4FwWIJVfzNmw3ahM
hske/e/vH9ByhrlcTXH94iPdM7zcH9HV5sjBlqJQzDHY4UqAfGt6XBHG7Y7TwO6A
d7vGzoC+GoLT/0pM56eLZYEZgLF4MKAGEZhr5T6VOdb/CwQUjzzaS+I+8PnIaLcX
vQ/5VybRoqfPjO1u1HgOXtLYYRyg58LfzMrCwWz2NtHMnZhqpQJrL7J5ZmwgB5fe
4FZqEiAioCsQneRuGJuDgFDXYj/TZ3SUe2lM8pRct7YNn2baw+gMAzmQ98jML9Pc
U8JyhXYNMb3Tz5+c5LCRWcPjo72IB9mTvvB/TUHKJuR36zPyFJStQOx6IGGNsBAm
l+omkSdEVgsbIXyNr4NfoNmAyHBVKegddPWGwg/npBMpN0wLpIyaA9UKcx/CWU2S
L7rLME3oAd1pqjsGgmdmk8VQI50aqFY891LB3zabWXRoFPgQLnGvdAdpwHUJNE4W
bn6oRq5s9XJmtzrAdjcA9O0WO3QybUjMD+kZuo2G1gxAU9vrX8WIeJHhrV8bjgax
O+O5ETA1k0fBdUNZmIORTHyJGLA9L4d6xN2pBVu7ji1Qa0GeDCPx5kQo9Lnx/AIH
34Yk69aLaX4/CjqPj8EO2KUXHKA+vjqCJAaoeWKAJnm01gmX5/P7MoPUYjpGrPor
1FvDNY7f2t6jGXR33SXu
=eKSM
-----END PGP SIGNATURE-----

--AkbCVLjbJ9qUtAXD--
