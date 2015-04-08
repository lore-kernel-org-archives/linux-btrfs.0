Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42410 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbDHM2C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 08:28:02 -0400
Date: Wed, 8 Apr 2015 12:27:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?utf-8?B?7J247KCV7Iud?= <js7.in@samsung.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Re: Porting BTRFS to user space
Message-ID: <20150408122757.GN13864@carfax.org.uk>
References: <1463140364.591861428494608421.JavaMail.weblogic@epmlwas09b>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D9sZ58tf58331Q5M"
In-Reply-To: <1463140364.591861428494608421.JavaMail.weblogic@epmlwas09b>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--D9sZ58tf58331Q5M
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 08, 2015 at 12:03:29PM +0000, =EC=9D=B8=EC=A0=95=EC=8B=9D wrote:
> Thank you for the advise.
> I am still wonder why there are same-name files in btrfs(kernel source) a=
nd btrfs-progs.
> They are quite many as follows.
>     backref.{c, h}
>     ctree.{c, h}
>     dir-item.c
>     disk-io.{c, h}
>     extent_io.{c, h}
>     extent-tree.c
>     file.c
>     file-item.c
>     free-space-cashe.{c, h}
>     hash.h
>     inode.c
>     inode-item.c
>     inode-map.c
>     print-tree.{c, h}
>     props.{c, h}
>     qgroup.{c, h}
>     root-tree.c
>     send.h
>     ulist.{c, h}
>     uuid-tree.c
>     volumes.{c, h}
>=20
> It seems btrfs-progs files have been ported from kernel files.
> Are they the result of efforts to port btrfs from kernel to user space?

   Kind of. They were copied from kernel space some time ago, but have
diverged from that point significantly since. There's all kinds of
extra flags and options in the userspace code that allow it to bypass
particular kinds of checks for the recovery tools. The kernel
implementation will have moved on in different ways since, as well.

> Or at least can I utilize the them so that I have to only port the remain=
ing files?

   You'll probably find that a lot of the remainder are to do with the
interface to the block layer, which I think (without actually knowing
much about FUSE) you won't need to do much of.

   I have to say, I'm somewhat more concerned about your distributed
systems design. You haven't mentioned anywhere any of the design
features that you would have to think about for a distributed
filesystem. For example, how do you handle concurrent access from
different machines, node failures, network failures, caching of
data/metadata, synchronisation of write followed by read (possibly by
a different node)?

   I would suggest that you're better off spending your effort on
those issues in your userspace distributed filesystem, and simply
using btrfs itself as a backing store. This gives you a useful
separation between the relatively simple underlying "write some bytes
to permanent storage" layer and the horrible, nasty, complicated
"manage a distributed data store in a usable way" layer on top of it.

   It's noticeable that pretty much all of the network and distributed
filesystems that I'm aware of have this kind of architecture: an
ordinary boring non-distributed filestore running on each storage
node, and a networking, metadata, caching and management layer on top
of that to deal with the distributed parts. (NFS, Ceph, Gluster
certainly work this way. I would be surprised if any of the others out
there at the moment didn't work like that).

   Hugo.

> ------- Original Message -------
> Sender : Austin S Hemmelgarn<ahferroin7@gmail.com>=20
> Date   : 2015-04-08 20:37 (GMT+09:00)
> Title  : Re: Porting BTRFS to user space
>=20
> On 2015-04-07 19:57, =EC=9D=B8=EC=A0=95=EC=8B=9D wrote:
> > Thank you for the information.
> > I just found that btrfs-progs includes several files that seem modified=
 from btrfs kernel source.
> > I am not sure exactly what they are.
> > Web pages say libbtrfs is to provide interface for apps that use btrfs.
> > Why should there be duplicated codes between kernel and user space?
> > Is it an on-going effort to port whole btrfs to user space?
> >=20
> > Could you lead me to some more information about libbtrfs or how to por=
t btrfs to user space?
> >=20
> > Thank you,
> > Jeongsik
> >=20
> >=20
> As far as I understand it, the intent is to allow things like btrfs
> check and btrfs restore to still work even if the kernel doesn't have
> btrfs support.  From what I can tell, you are the first person to
> actually be serious about getting BTRFS running in userspace, so there
> probably isn't much BTRFS specific literature out there.
>=20
> I would, however suggest looking at the FUSE drivers for ext4 and ZFS,
> as those are both ported from kernel space, and should give some good
> examples of where to start.
>=20
> <p>&nbsp;</p><p>&nbsp;</p>

--=20
Hugo Mills             | "I lost my leg in 1942. Some bastard stole it in a
hugo@... carfax.org.uk | pub in Pimlico."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--D9sZ58tf58331Q5M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVJR7NAAoJEFheFHXiqx3kRv0QAJR1ycr9dKC0962JFVnFmn/O
WZHeaFF61R+69qXepX+O2xJqZLcvZKIYs291o3rfP6vfFZCDGXGIzMwdrUm5JPL0
1NgdSpnELnf3ppYquV0MOraXooko6CvMeiP3SmKK9N0MUMVOC9bCyYPpo1KG4DpV
JRZ+Tt20NtoTaimFwgOnSw6VQrW1RLmqL2TcyHI4FE09fSlAwesGmc0mab/rR40v
muHDqpTXTHoEpRRq6t5u5wqKjwj5odNcBRjnwqEhm+F/Gs9FmkcrPOG2vh+R21z+
FLqKm7znt0MSduan+5irnngMic5YqdyavzUAFeEPYwWJsLORaXaZuTN506Hng8/I
uzztOQq4zd9BEq7q4hYYEHje9HPz7QkE4nPdz7l/lAmoiD9RTy1uqcXtgXFq19OI
WE07f3V27ZPgCk3brrDYjDasYImQQdSPfKareSN7iWfLhXu/2TLVQirJd/trJGhL
1jnYfarKRI7RLB6XXXcrGr62Y21QPrctAUkYpIygWj0W2OOxEFEu/7VryJIdz9Kt
QszDAP24rGmHwlyqvYnqSas5JmSjjGApH6YfF6YuxJbw70aIObl3Y9wA31aDp19J
tBL1KLNJ89ZZ8v/rvj/IUgDn0EzsnAQD4hcpj/3vU/fkvmcQUOCObgJ/fNCyZ7By
vGHuCuZep2mx9yiaHqP2
=i3s8
-----END PGP SIGNATURE-----

--D9sZ58tf58331Q5M--
