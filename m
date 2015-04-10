Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54991 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbbDJK4B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 06:56:01 -0400
Date: Fri, 10 Apr 2015 10:55:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?utf-8?B?7J247KCV7Iud?= <js7.in@samsung.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Re: Re: Re: Porting BTRFS to user space
Message-ID: <20150410105557.GZ13864@carfax.org.uk>
References: <20150409233751.GX13864@carfax.org.uk>
 <176622419.680101428625585006.JavaMail.weblogic@epmlwas07d>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZuvoxmZMh0nHqhEq"
In-Reply-To: <176622419.680101428625585006.JavaMail.weblogic@epmlwas07d>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZuvoxmZMh0nHqhEq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2015 at 12:26:26AM +0000, =EC=9D=B8=EC=A0=95=EC=8B=9D wrote:
> Many parts I agree.
> One thing is I don't think it will be easy as much as you feel from my wo=
rds.
>=20
> I don't clearly understand the following.
> >> There's no reason that the overlay FS can't use all the fundamental fe=
atures of the underlying non-cluster FS. You could very easily implement sn=
apshots in the DFS using snapshots in the underlying btrfs... *provided* th=
at you can work out the semantics of snapshots in the DFS in the first plac=
e.

> Does it mean I will be able to implement snapshot in my DFS more
> easily using the snapshoting function of underlying FS?

   Yes, that's exactly what I'm suggesting.

> I guess it may be possible depending on the DFS design, but may
> limit some design options.

> Anyway thank you for your opinion.

   Opinions are cheap, but you're welcome anyway. :)

   Hugo.

> ------- Original Message -------
> Sender : Hugo Mills<hugo@carfax.org.uk>=20
> Date   : 2015-04-10 08:37 (GMT+09:00)
> Title  : Re: Re: Re: Porting BTRFS to user space
>=20
> On Wed, Apr 08, 2015 at 11:56:20PM +0000, =EC=9D=B8=EC=A0=95=EC=8B=9D wro=
te:
> > My goal is to make a "native" DFS, with native as contrast to overlay.
> > It's about performance and features.
> >=20
> > 1. With overlay DFS, overlying system and underlying system do pretty m=
uch overlaping tasks:
> >         maintain/lookup meta-data, keep data/meta-data consistency, and=
 etc.
> >     They are both implementational duplication and performance overhead.
>=20
>    Accepted, but the differences in what the underlay and overlay have
> to do are huge.
>=20
> > 2. If I overlay some FS over BTRFS, many of the BTRFS features would be=
 hidden: especially COW and snapshot.
> >    It means I have to implement them independently if I need them.
> >    On the other hand, by embedding distribution layer into BTRFS, all t=
he BTRFS features could be inherited with minimal cost.
>=20
>    I don't believe this at all.
>=20
>    There's no reason that the overlay FS can't use all the fundamental
> features of the underlying non-cluster FS. You could very easily
> implement snapshots in the DFS using snapshots in the underlying
> btrfs... *provided* that you can work out the semantics of snapshots
> in the DFS in the first place.
>=20
> > If any of the existing DFS were fine for me, I would have been using it.
> >=20
> > Of course I have to deal with all the issues coming from the distributi=
on.
>=20
>    Here, you dismiss with a single sentence the fundamental
> difficulties of a distributed filesystem. This is not, I feel,
> something that can be hand-waved, or dealt with in an ad-hoc
> manner. This is the core of the problem. If you haven't got a really
> good handle on the distributed part of it, it doesn't matter in the
> slightest what the rest of the system is doing.
>=20
>    I'm not saying it can't be done -- clearly it can (by a
> construction proof; these things exist already :) ). However, from
> what you've said so far, I get the impression that you think that that
> part is going to be easy. I am willing to bet that the effort involved
> in making a distributed filesystem of reasonable performance and
> reliability is going to outweigh by several times the effort of
> "merely" porting 100k lines of kernel code to userspace (and that's
> probably the wrong approach anyway).
>=20
>    Observe, for example, that Inktank has been working on Ceph for at
> least 10 years, and still doesn't have a reliable, performant, general
> purpose network filesystem.
>=20
>    My feeling is, build the distributed part first, on top of an
> existing, unmodified backing store. Then deal with the deep
> integration with the underlying FS later if, and only if, you think
> you need it when you get to that point.
>=20
>    Hugo.
>=20
> > ------- Original Message -------
> > Sender : Hugo Mills<hugo@carfax.org.uk>=20
> > Date   : 2015-04-08 21:27 (GMT+09:00)
> > Title  : Re: Re: Porting BTRFS to user space
> >=20
> > On Wed, Apr 08, 2015 at 12:03:29PM +0000, =EC=9D=B8=EC=A0=95=EC=8B=9D w=
rote:
> > > Thank you for the advise.
> > > I am still wonder why there are same-name files in btrfs(kernel sourc=
e) and btrfs-progs.
> > > They are quite many as follows.
> > >     backref.{c, h}
> > >     ctree.{c, h}
> > >     dir-item.c
> > >     disk-io.{c, h}
> > >     extent_io.{c, h}
> > >     extent-tree.c
> > >     file.c
> > >     file-item.c
> > >     free-space-cashe.{c, h}
> > >     hash.h
> > >     inode.c
> > >     inode-item.c
> > >     inode-map.c
> > >     print-tree.{c, h}
> > >     props.{c, h}
> > >     qgroup.{c, h}
> > >     root-tree.c
> > >     send.h
> > >     ulist.{c, h}
> > >     uuid-tree.c
> > >     volumes.{c, h}
> > >=20
> > > It seems btrfs-progs files have been ported from kernel files.
> > > Are they the result of efforts to port btrfs from kernel to user spac=
e?
> >=20
> >    Kind of. They were copied from kernel space some time ago, but have
> > diverged from that point significantly since. There's all kinds of
> > extra flags and options in the userspace code that allow it to bypass
> > particular kinds of checks for the recovery tools. The kernel
> > implementation will have moved on in different ways since, as well.
> >=20
> > > Or at least can I utilize the them so that I have to only port the re=
maining files?
> >=20
> >    You'll probably find that a lot of the remainder are to do with the
> > interface to the block layer, which I think (without actually knowing
> > much about FUSE) you won't need to do much of.
> >=20
> >    I have to say, I'm somewhat more concerned about your distributed
> > systems design. You haven't mentioned anywhere any of the design
> > features that you would have to think about for a distributed
> > filesystem. For example, how do you handle concurrent access from
> > different machines, node failures, network failures, caching of
> > data/metadata, synchronisation of write followed by read (possibly by
> > a different node)?
> >=20
> >    I would suggest that you're better off spending your effort on
> > those issues in your userspace distributed filesystem, and simply
> > using btrfs itself as a backing store. This gives you a useful
> > separation between the relatively simple underlying "write some bytes
> > to permanent storage" layer and the horrible, nasty, complicated
> > "manage a distributed data store in a usable way" layer on top of it.
> >=20
> >    It's noticeable that pretty much all of the network and distributed
> > filesystems that I'm aware of have this kind of architecture: an
> > ordinary boring non-distributed filestore running on each storage
> > node, and a networking, metadata, caching and management layer on top
> > of that to deal with the distributed parts. (NFS, Ceph, Gluster
> > certainly work this way. I would be surprised if any of the others out
> > there at the moment didn't work like that).
> >=20
> >    Hugo.
> >=20
> > > ------- Original Message -------
> > > Sender : Austin S Hemmelgarn<ahferroin7@gmail.com>=20
> > > Date   : 2015-04-08 20:37 (GMT+09:00)
> > > Title  : Re: Porting BTRFS to user space
> > >=20
> > > On 2015-04-07 19:57, =EC=9D=B8=EC=A0=95=EC=8B=9D wrote:
> > > > Thank you for the information.
> > > > I just found that btrfs-progs includes several files that seem modi=
fied from btrfs kernel source.
> > > > I am not sure exactly what they are.
> > > > Web pages say libbtrfs is to provide interface for apps that use bt=
rfs.
> > > > Why should there be duplicated codes between kernel and user space?
> > > > Is it an on-going effort to port whole btrfs to user space?
> > > >=20
> > > > Could you lead me to some more information about libbtrfs or how to=
 port btrfs to user space?
> > > >=20
> > > > Thank you,
> > > > Jeongsik
> > > >=20
> > > >=20
> > > As far as I understand it, the intent is to allow things like btrfs
> > > check and btrfs restore to still work even if the kernel doesn't have
> > > btrfs support.  From what I can tell, you are the first person to
> > > actually be serious about getting BTRFS running in userspace, so there
> > > probably isn't much BTRFS specific literature out there.
> > >=20
> > > I would, however suggest looking at the FUSE drivers for ext4 and ZFS,
> > > as those are both ported from kernel space, and should give some good
> > > examples of where to start.
> > >=20
> > > <p>&nbsp;</p><p>&nbsp;</p>
> >=20
>=20

--=20
Hugo Mills             | In theory, theory and practice are the same. In
hugo@... carfax.org.uk | practice, they're different.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ZuvoxmZMh0nHqhEq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVJ6w9AAoJEFheFHXiqx3kTlMP/1C7gQcDyqSvk/TzHoEy0pyT
K1RH2SutqFejedjZlixm+hHtDBSogaGpFfsCCs79fUxPqfRx3bMYHNOR91PyH12S
8AOLgPuC2fNOuCKLL2lX7IVDKaxszPiKjovpb8dVqtBR1YNITNIU3x2G6kuD42Bl
UTAWr1zgCkMalAWRhtTyHhG1cVlvRx+UI4AQhEVcBKDMSGMx8NWxhVJn4RMOny6l
UBcjM3an18Fld9pgArf5lD9zGvVqNx82MgVO48Ml3EkVruEeq6muHZjJhdvVgka5
zFvItzfXghO8q94T/VNMxz5jrgcRMjTfUrMS23Gn2AzaFGCFjLD8HA8mj91iI4so
PG0MyZG/faP5TTFguP4N9D4dBfZtA8MBmm3FHM/czaNynJXjXylWq0iOx7Mqd9tn
haKI4Wa8P7l3WqFSk8c6WjY39MLkcim6jjetF7HvBM9X/7SPv8xaY9+NNumQV5Xt
+xPK7czfa0APwmxNPEIKQklflNtsIHGaw3MkuSrnBQKLZRtqqtMRQoCNgxXW0dTL
k1Xk8VA//Zwf9+LyjbNkcwRpABqsnLM9fbzGtIXk1G7syWPtGpkskDw/La93IFac
h53v68roeyxb5gFXXX124nCwmXjD92tFwRjmJGtQ6Ia1BVOeDOo23SQWsLKOgtdh
w1iDYdu5hoeYT8OyK/VQ
=wqMo
-----END PGP SIGNATURE-----

--ZuvoxmZMh0nHqhEq--
