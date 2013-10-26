Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44789 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3JZLuW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 07:50:22 -0400
Date: Sat, 26 Oct 2013 12:50:17 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: "karim.allah.ahmed@gmail.com" <karim.allah.ahmed@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: swapfile on btrfs, temporary solution for wiki
Message-ID: <20131026115017.GE31029@carfax.org.uk>
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
 <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
 <20131025163546.4cf3291a@natsu>
 <20131025104414.GD31029@carfax.org.uk>
 <CAOTdububnKzatt1ojXhXry36vkr1D3DgBc-HFks46=P6R40gmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
In-Reply-To: <CAOTdububnKzatt1ojXhXry36vkr1D3DgBc-HFks46=P6R40gmg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2013 at 10:30:18AM +0100, karim.allah.ahmed@gmail.com wrote:
> Is the swap over NFS code upstream ?

   Yes:

Symbol: NFS_SWAP [=3Dy]
Type  : boolean
Prompt: Provide swap over NFS support
  Location:
    -> File systems
      -> Network File Systems (NETWORK_FILESYSTEMS [=3Dy])
(2)     -> NFS client support (NFS_FS [=3Dm])
  Defined at fs/nfs/Kconfig:89
  Depends on: NETWORK_FILESYSTEMS [=3Dy] && NFS_FS [=3Dm]
  Selects: SUNRPC_SWAP [=3Dy]

   Hugo.

> On 10/25/13, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Fri, Oct 25, 2013 at 04:35:46PM +0600, Roman Mamedov wrote:
> >> On Thu, 24 Oct 2013 23:52:01 +0300
> >> Timofey Titovets <nefelim4ag@gmail.com> wrote:
> >>
> >> > Hello, i suggest temporary solution to use swap file under btrfs.
> >> > I test it, and it work good.
> >> >
> >> > I invent simple the way, how create and using swap file, just see
> >> > following sh code:
> >> >
> >> > swapfile=3D$(losetup -f) #free loop device
> >> > truncate -s 8G /swap   #create 8G sparse swap file
> >> > losetup $swapfile /swap #mount file to loop
> >> > mkswap  $swapfile
> >> > swapon  $swapfile
> >> >
> >> > i just adding this to rc.local and this work good.
> >> > May be, add it to btrfs Wiki as temporary solution to using swap fil=
e?
> >>
> >> I always thought Btrfs does not allow swap files on purpose, because i=
t is
> >> not
> >> deadlock-proof when used in the swapping context.
> >
> >    It's more that the current swap interface is based on device+block
> > list, and if you balance a filesystem, the blocks for a file move --
> > but there's no way of telling the swap code to cope with that.
> >
> >> Imagine you try swapping out pages to free up some memory, and in the
> >> process
> >> Btrfs needs to allocate some memory to actually perform the write, the
> >> kernel
> >> says "Sure, but for that we need to swap out some more pages..." You s=
ee
> >> where
> >> that goes.
> >>
> >> Same issue is possible with swap on other complex filesystems an examp=
le
> >> being networked ones like NFS and SMB/CIFS.
> >
> >    The network filesystems have a similar problem as btrfs -- they
> > don't export devices, and you don't get direct access to the low-level
> > blocks under the FS, so the swap code can't deal with it.
> >
> >    That said, there's been a lot of work recently on getting
> > swap-over-NFS to work properly -- effectively giving a new interface
> > for the swap code that doesn't rely on direct mapping to device
> > blocks. That new interface gives us the minimal external
> > infrastructure necessary to consider doing swapfiles on btrfs.
> >
> >> It might work for some time (or even work 99% of time), but you still =
may
> >> be
> >> endangering your system to a possibility of a lock-up, and certainly
> >> adding
> >> that to any Wiki/FAQ/website as "the solution" might not be the best
> >> choice.
> >
> >    The deadlock situation is dealt with by adding a flag to the memory
> > allocator in the swap-critical paths, which says you're not allowed to
> > swap anything when you make the allocation. That at least allows the
> > memory allocation to fail (hopefully gracefully) without deadlocking.
> > I suspect that this is also part of the swap-on-NFS work -- adding
> > that flag everywhere necessary.
> >
> >    Hugo.
> >

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- =A91973 Unclear Research Ltd ---                  =
=20

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUmuseVheFHXiqx3kAQKXEw//coMoj39QPRP53xuViosjE47KEdD5tAY4
6uiYhrrURO8u8VSY7jpSV1EyYsgYM1Us16jX/sd42Zva4mxMi+OdqCT8XDaMddvh
u/fs0RgOjRqDHpVIT3sgN5+bJ/PC6viwocqkNl4f8/1IL7CNmz+iUKe0z27Mwauy
U0m2qGBleDqBjOvz+64y/59HGyrkOR9BgiPunpceu2dt6w7SsG+0bw/xpdBk/aC1
PCML5+7KqC7MDwCiVYRB1xbnQdfbzpC74tmyZpa9LxCwKnA2NVzwEAA3yvPWo8Rv
erf+8AZveMOroqK22jjQyl7VmPoXMvbt56BrIz/ibeaxyvSiU6YwlpCeHocsg8ZB
8jHtBM+hkFL9QgN4R6fb4bCfFN3lJVQrjuzuzAaJMVMTdmKBKaqVgF3fU+pwXyRg
5rSHS+epVB7JYmvXMrtTs6sP9t5X+/G/k4VIJQT/+E+2v1Z+fnJBTnNTk+PYU+SK
blFdIXY10dNfuC/yJElCMSe1mDG1nZBhq7aIYewm/DQVMTMVzuqQzGlWYEb2AQ96
aZTkcmrTSGVIpJqlByzfo/fT4CXewANyo/o0P75q1Gy91eiz8zYmOHCBMNVqzFtK
iD1ZL8nh/8occveTVqISEpHehSLcjzOTJug9FK4GHokUnGtY5tgD+mmuhd0EG6A4
+ifcljdQXYc=
=+1id
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
