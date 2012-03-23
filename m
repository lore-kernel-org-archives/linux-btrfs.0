From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: heterogeneous raid1
Date: Fri, 23 Mar 2012 23:13:07 +0600
Message-ID: <20120323231307.283be0fb@natsu>
References: <20120323061159.GA11099@mcelrath.org>
	<20120323164435.4c21f92e@natsu>
	<20120323164932.GB11099@mcelrath.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YE.Dun7AGGsdV/He=Gbh5BP"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Bob McElrath <bob@mcelrath.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120323164932.GB11099@mcelrath.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/YE.Dun7AGGsdV/He=Gbh5BP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Mar 2012 16:49:32 +0000
Bob McElrath <bob@mcelrath.org> wrote:

> Roman Mamedov [rm@romanrm.ru] wrote:
> (can't reliably tolerate an any-two-disks failure even).

s/even/event/

> > I suggest that you go with http://linuxconfig.org/prouhd-raid-for-the-e=
nd-user
> > instead. Depending on how many drives you have, the widest portion can =
be raid
> > 6, then decreasing to RAID5 for the second stage, then finally to RAID1=
 for
> > the tail.
>=20
> The algorithm I proposed wastes a lot less space.  The above article wast=
es 2Tb
> in his first example, while mine would waste 0 in a raid1.  (2Tb+1Tb+1Tb)=
 and
> 4Tb in raid1.

Aye, but I consider space used for redundancy to be wasted as well, especia=
lly
when the same (or even higher) amount of redundancy can be achieved by spen=
ding
less storage space on it.

E.g. I'd consider a 16-disk LINEAR+RAID1(which is kinda what your algorithm
is) more wasteful than a 16-disk RAID6. Because even with varying disk size=
s,
using PROUHD and also implementing "stackable" RAIDs where needed, you can
achieve either a complete coverage with parity-based redundancy (RAID5 and
RAID6), or have to resort to the mirror-based redundancy only for a small
"tail" portion of the volume.

> I'm aware of that, and decided against it.  The way btrfs does things is =
the way
> of the future.  Using multiple raids there are so many layers (md+md+lvm+=
btrfs)
> that it becomes an administration nightmare, and I've had enough of rebui=
lding
> raid arrays by hand for one lifetime.

Again no argument here, just wanted to throw the link out there as it was an
eye opener for me, and for my primary storage I currently use a 6-member RA=
ID6
consisting of 5x 2TB physical disks and a 2TB RAID0 from 1.5TB+500GB (yes,
mdadm can also do RAID0 of differently-sized drives! it'll stripe while it
can, and after that it's just the tail of the larger drive).

Sorry for all the mdadm off-topic. :)

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/YE.Dun7AGGsdV/He=Gbh5BP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9sryMACgkQTLKSvz+PZwgfQQCfb4ezCxJUTs2wIdEnrVTig6VS
DyoAnjMgo/1L6ZOHO8CAgbSDfDZhAfsG
=ghB2
-----END PGP SIGNATURE-----

--Sig_/YE.Dun7AGGsdV/He=Gbh5BP--
