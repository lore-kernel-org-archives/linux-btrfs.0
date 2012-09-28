Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58061 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030249Ab2I1UUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 16:20:30 -0400
Date: Fri, 28 Sep 2012 21:20:26 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.ru>
Cc: kreijack@inwind.it, kreijack@libero.it,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
Message-ID: <20120928202026.GG6136@carfax.org.uk>
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
 <5064B96B.7060502@libero.it>
 <5064BEEB.1090707@libero.it>
 <20120928091759.6d096016@natsu>
 <5065D3D7.8080101@inwind.it>
 <20120929000223.4827d375@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
In-Reply-To: <20120929000223.4827d375@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 29, 2012 at 12:02:23AM +0600, Roman Mamedov wrote:
> On Fri, 28 Sep 2012 18:44:07 +0200
> Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
> > This means that the ration of space physically allocated on the disk and 
> > the space available is 7GB/10GB = 0.7 . So on 135GB of disk, only 94GB 
> > are available.
> 
> You assume metadata allocation will always grow linearly with data, which is
> not true. So in my opinion it is not a good estimate.

   No, but it's the best model we have right now. (And probably about
the best model we will have, without knowledge of the future
intentions of the user). Without inlining file data, the metadata is
dominated by checksums, which is a linear relationship (approx
1000:1). With inlining file data, metadata is probably dominated by
inline data; assuming the ratio of small-to-large files on the FS
remains unchanged in future, a linear relationship also applies. For
general usage, I'm happy to assume that the current ratio of data to
metadata will remain largely unchanged over the lifetime of the FS.

> > > Why use underscores instead of spaces?
> > 
> > Simplify the parsing in scripts
> 
> I think it looks awkward and is not warranted since this is a primarily
> user-facing utility. Also none of the other similar tools shy from having
> spaces anywhere they need to, e.g.
> 
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Wed May 25 00:07:38 2011
>      Raid Level : raid5
>      Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
>   Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Fri Sep 28 21:20:51 2012
>           State : active 
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            Name : avdeb:0  (local to host avdeb)
>            UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
>          Events : 14254
> 
>     Number   Major   Minor   RaidDevice State
>        7       8       17        0      active sync   /dev/sdb1
>        6       8       33        1      active sync   /dev/sdc1
>        3       8       65        2      active sync   /dev/sde1
>        4       8       49        3      active sync   /dev/sdd1
>        5       8       81        4      active sync   /dev/sdf1
> 
> # lvdisplay 
>   --- Logical volume ---
>   LV Path                /dev/alpha/lv1
>   LV Name                lv1
>   VG Name                alpha
>   LV UUID                HP19fU-oMhM-sdqN-yFWa-N3Rs-ktBw-21GSD2
>   LV Write Access        read/write
>   LV Creation host, time , 
>   LV Status              available
>   # open                 0
>   LV Size                3.52 TiB
>   Current LE             115431
>   Segments               3
>   Allocation             inherit
>   Read ahead sectors     auto
>   - currently set to     4096
>   Block device           252:0

   ... and I've always found those hard to deal with in scripts. :)

   (But they do have "plumbing" options, to use the git terminology,
so I'd be happy with having a parsable output option).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Hey, Virtual Memory! Now I can have a *really big* ramdisk! ---   

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGYGir9z9OVl50rAAQLdUw//cvwWbJ5otuzeOictYFZ0xyBnwRk4tk46
D+20TOv1S9wHukQYnQ25vOb33mq38LkFPSdw90GjgnnI116Y3mq4L56+nYbuBF+v
aXzxlZqfOb065J7My12b0exeHlnksbvjIIsArD8HkH4dKv6XkQAsl0Ail4Kp7Vw7
V21r6jPDmtGdd63CCRQkIZNX0unIJAofaDjaiynJUhUCDDYCYxQJAy8KDfj/7E88
dA6LG5+hxCetah08tV6L1Tdkz5cA1noQ2s4dauMU3ADJRWidjLv7db2ys5QLqHSt
ap6DfUiFCpbZTQLUpH7E+CH74Mh7Ep30x3giWC6mVArBArDuLAS4qle9a51mztk0
Hwjx56o+JZQF+JU9ItP34FFOcBF75X70Lhj3pibm5wqAtgQ2pNgi14xK3Dk3liwn
mwLW1XrHzFC8niB1pwflHVobS8jySgiWu1QJQjn2R2W0UlQID7kMT8rkqCODC7LR
hP7fIrRtmBv7TOCR9P4tnS/WmXB96KmKxGqW60wRgk4TX7qSalyQjQWqBnekVnbu
8mLlDpL+1/BMJ4RRsaJKiOjkVtAn68el/naEYMTbPqMsTTNiEvo/029iEzjAiUVf
IbrwCDQpdmCmNs7wu59l1LwIJumlI4UoIPkq4gZ/TDeW1Ltj9v5XG2UTNn/saJoq
58tME1JFHNQ=
=3JXy
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
