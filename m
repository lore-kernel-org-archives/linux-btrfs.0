Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:35753 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab2I1SC1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 14:02:27 -0400
Date: Sat, 29 Sep 2012 00:02:23 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: kreijack@inwind.it
Cc: kreijack@libero.it,
        =?UTF-8?B?U8OpYmFzdGllbg==?= Maury <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
Message-ID: <20120929000223.4827d375@natsu>
In-Reply-To: <5065D3D7.8080101@inwind.it>
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
	<5064B96B.7060502@libero.it>
	<5064BEEB.1090707@libero.it>
	<20120928091759.6d096016@natsu>
	<5065D3D7.8080101@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2ezB/AXoSsdK/_zB/EziQ5/"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/2ezB/AXoSsdK/_zB/EziQ5/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Sep 2012 18:44:07 +0200
Goffredo Baroncelli <kreijack@inwind.it> wrote:

> This means that the ration of space physically allocated on the disk and=
=20
> the space available is 7GB/10GB =3D 0.7 . So on 135GB of disk, only 94GB=
=20
> are available.

You assume metadata allocation will always grow linearly with data, which is
not true. So in my opinion it is not a good estimate.

> > Are you ready to answer the flood of questions from people why their di=
sk is
> > only 62% efficient, and how to tune it to 100%? :-)
>=20
> I don't understand your question

You mentioned that the aim was to make the output more friendly, i.e. to ma=
ke
it less confusing. But I find this percentage and the way it is labeled lik=
ely
to achieve the opposite effect, causing a lot of new questions on what does
this mean (while the percentage reported is likely not even being correct),
how to improve it, etc.

> Because on BTRFS the metadata are a lot

Keep in mind that there is also inlining; so even if the space is allocated
for metadata, it will be used to store small files. So it might be not
completely fair to count the metadata allocated space as unusable space.

> > Why use underscores instead of spaces?
>=20
> Simplify the parsing in scripts

I think it looks awkward and is not warranted since this is a primarily
user-facing utility. Also none of the other similar tools shy from having
spaces anywhere they need to, e.g.

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed May 25 00:07:38 2011
     Raid Level : raid5
     Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
  Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Sep 28 21:20:51 2012
          State : active=20
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : avdeb:0  (local to host avdeb)
           UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
         Events : 14254

    Number   Major   Minor   RaidDevice State
       7       8       17        0      active sync   /dev/sdb1
       6       8       33        1      active sync   /dev/sdc1
       3       8       65        2      active sync   /dev/sde1
       4       8       49        3      active sync   /dev/sdd1
       5       8       81        4      active sync   /dev/sdf1

# lvdisplay=20
  --- Logical volume ---
  LV Path                /dev/alpha/lv1
  LV Name                lv1
  VG Name                alpha
  LV UUID                HP19fU-oMhM-sdqN-yFWa-N3Rs-ktBw-21GSD2
  LV Write Access        read/write
  LV Creation host, time ,=20
  LV Status              available
  # open                 0
  LV Size                3.52 TiB
  Current LE             115431
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           252:0

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/2ezB/AXoSsdK/_zB/EziQ5/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBl5i8ACgkQTLKSvz+PZwgDawCcDeN8R7gSMaUc9+eIFm3d8QYo
n1wAn0unMF7r6ICyTolSQ6saD81jVoMq
=Dg7j
-----END PGP SIGNATURE-----

--Sig_/2ezB/AXoSsdK/_zB/EziQ5/--
