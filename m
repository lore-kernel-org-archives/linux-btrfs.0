Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47064 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbcFXLAG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 07:00:06 -0400
Date: Fri, 24 Jun 2016 10:59:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624105959.GJ3325@carfax.org.uk>
References: <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org>
 <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <20160624101658.GI3325@carfax.org.uk>
 <CAA91j0XuC4BCk5qXwDURQLHp6rg6qVL3fYrZbH=9RM65nMHbGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
In-Reply-To: <CAA91j0XuC4BCk5qXwDURQLHp6rg6qVL3fYrZbH=9RM65nMHbGA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2016 at 01:19:30PM +0300, Andrei Borzenkov wrote:
> On Fri, Jun 24, 2016 at 1:16 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Fri, Jun 24, 2016 at 12:52:21PM +0300, Andrei Borzenkov wrote:
> >> On Fri, Jun 24, 2016 at 11:50 AM, Hugo Mills <hugo@carfax.org.uk> wrot=
e:
> >> > On Fri, Jun 24, 2016 at 07:02:34AM +0300, Andrei Borzenkov wrote:
> >> >> 24.06.2016 04:47, Zygo Blaxell =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >> >> > On Thu, Jun 23, 2016 at 06:26:22PM -0600, Chris Murphy wrote:
> >> >> >> On Thu, Jun 23, 2016 at 1:32 PM, Goffredo Baroncelli <kreijack@i=
nwind.it> wrote:
> >> >> >>> The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to=
 the checksum.
> >> >> >>
> >> >> >> Yeah I'm kinda confused on this point.
> >> >> >>
> >> >> >> https://btrfs.wiki.kernel.org/index.php/RAID56
> >> >> >>
> >> >> >> It says there is a write hole for Btrfs. But defines it in terms=
 of
> >> >> >> parity possibly being stale after a crash. I think the term come=
s not
> >> >> >> from merely parity being wrong but parity being wrong *and* then=
 being
> >> >> >> used to wrongly reconstruct data because it's blindly trusted.
> >> >> >
> >> >> > I think the opposite is more likely, as the layers above raid56
> >> >> > seem to check the data against sums before raid56 ever sees it.
> >> >> > (If those layers seem inverted to you, I agree, but OTOH there are
> >> >> > probably good reason to do it that way).
> >> >> >
> >> >>
> >> >> Yes, that's how I read code as well. btrfs layer that does checksum=
ming
> >> >> is unaware of parity blocks at all; for all practical purposes they=
 do
> >> >> not exist. What happens is approximately
> >> >>
> >> >> 1. logical extent is allocated and checksum computed
> >> >> 2. it is mapped to physical area(s) on disks, skipping over what wo=
uld
> >> >> be parity blocks
> >> >> 3. when these areas are written out, RAID56 parity is computed and =
filled in
> >> >>
> >> >> IOW btrfs checksums are for (meta)data and RAID56 parity is not dat=
a.
> >> >
> >> >    Checksums are not parity, correct. However, every data block
> >> > (including, I think, the parity) is checksummed and put into the csum
> >> > tree. This allows the FS to determine where damage has occurred,
> >> > rather thansimply detecting that it has occurred (which would be the
> >> > case if the parity doesn't match the data, or if the two copies of a
> >> > RAID-1 array don't match).
> >> >
> >>
> >> Yes, that is what I wrote below. But that means that RAID5 with one
> >> degraded disk won't be able to reconstruct data on this degraded disk
> >> because reconstructed extent content won't match checksum. Which kinda
> >> makes RAID5 pointless.
> >
> >    Eh? How do you come to that conclusion?
> >
> >    For data, say you have n-1 good devices, with n-1 blocks on them.
> > Each block has a checksum in the metadata, so you can read that
> > checksum, read the blocks, and verify that they're not damaged. From
> > those n-1 known-good blocks (all data, or one parity and the rest
>=20
> We do not know whether parity is good or not because as far as I can
> tell parity is not checksummed.

   I was about to write a devastating rebuttal of this... then I
actually tested it, and holy crap you're right.

   I've just closed the terminal in question by accident, so I can't
copy-and-paste, but the way I checked was:

# mkfs.btrfs -mraid1 -draid5 /dev/loop{0,1,2}
# mount /dev/loop0 foo
# dd if=3D/dev/urandom of=3Dfoo/file bs=3D4k count=3D32
# umount /dev/loop0
# btrfs-debug-tree /dev/loop0

then look at the csum tree:

     item 0 key (EXTENT_CSUM EXTENT_CSUM 351469568) itemoff 16155 itemsize =
128
     	  extent csum item

There is a single csum item in it, of length 128. At 4 bytes per csum,
that's 32 checksums, which covers the 32 4KiB blocks I wrote, leaving
nothing for the parity.

   This is fundamentally broken, and I think we need to change the
wiki to indicate that the parity RAID implementation is not
recommended, because it doesn't actually do the job it's meant to in a
reliable way. :(

   Hugo.

> > data) you can reconstruct the remaining block. That reconstructed
> > block won't be checked against the csum for the missing block -- it'll
> > just be written and a new csum for it written with it.
> >
>=20
> So we have silent corruption. I fail to understand how it is an improveme=
nt :)
>=20
> >    Hugo.
> >
> >> ...
> >> >
> >> >> > It looks like uncorrectable failures might occur because parity is
> >> >> > correct, but the parity checksum is out of date, so the parity ch=
ecksum
> >> >> > doesn't match even though data blindly reconstructed from the par=
ity
> >> >> > *would* match the data.
> >> >> >
> >> >>
> >> >> Yep, that is how I read it too. So if your data is checksummed, it
> >> >> should at least avoid silent corruption.
> >> >>
> >

--=20
Hugo Mills             | Debugging is like hitting yourself in the head with
hugo@... carfax.org.uk | hammer: it feels so good when you find the bug, and
http://carfax.org.uk/  | you're allowed to stop debugging.
PGP: E2AB1DE4          |                                        PotatoEngin=
eer

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXbRKvAAoJEFheFHXiqx3kTxcQAI5i9LFaHY4bGH2GLSpc2P4E
bBufs0IZiF5DfvyJuFvFih2ob/QJJbwH+UU2iofgC95Omx5ge7LDrW4d5Y/kr2Hi
8U4Fb50e5QcqHv8cYf051jAg+jiiud4XFKvF6HXTzkTVZ54La6+1NPt0psikl8Qu
Z7qmc5WR56FjJMQh1MrKphJi6u/Vi5uGz5UVmvB5Yth1Z/uooM1wOO1G7sVaV8rE
Js5WgZCDAPhHhtvwKP/6CiWPV4TTITi6N8+jZB8fUlL+FLiwedVZ/OpE1BoBOD90
odXDu0EiKF9RAt/EX29KSLtNEZHVgktKUsJl+eQrjpsYBIkwRojv1iK4UW0Z5EpA
PRufKi7FsG1QlhOLYCzMifOz4z6gdK9OXiaK22Ivp39Yun0Y3PW2JFQCldSiKsab
Vrmql5/OErPtNbGexRyUCvepIAN6rHLjkn5N01j83OpdIvIqzsQAYVEYL7ooeenB
Q1Y7nRK4/16zQV5IgKtyGZfjjcp6xl0ckpdmo0rUCtZkKS0NmO7qODMD3mYl008H
Fj+XeeQvx7QHCGtWfw/I4KCa/xlQMtxcJ9EeFjIsm62RVf77pZY4X/ecS8EOvjNY
EwhffvfWGD73oOHu6pR0gtvyL3Ik3Txlo7U6RQS+WxfGqn2qAg8ORZA2Sa5Ftcrt
cBVW7mqGkLODC7ZxusTt
=gBlO
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
