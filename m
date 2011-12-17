From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 13:50:10 +0100
Message-ID: <2297283.SPUU0GRYgu@venice>
References: <201112171254.47334.Martin@lichtvoll.de>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112171254.47334.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 17 December, 2011 12:54:47 you wrote:
[...]
>=20
> This reminds me of the delayed allocation discussion as Ext4 introduc=
ed
> that feature.
>=20
> Ext3/4 developer Theodore T=B4so  said if the applications are not us=
ing
> fsync() its their fault. But before OTOH applications began to avoid =
using
> fsync() since it has had serious performance drawbacks on ext3 (not e=
xt4)
> with data=3Dordered.
>=20
> Ext4 now has workarounds for the rename and truncate cases, after Lin=
us
> requested boldly to not break existing userspace.

IIRC the problem was data loss. Instead you was blaming (correctly) a s=
lowness=20
problem. Are two very different problem.

> Now applications that use fsync() the way Theodore T=B4so and other s=
ee it
> correctly used should now skip the fsync() on a BTRFS?

I never say to not use the fsync() call. I am only arguing that for a p=
ackage=20
manager the fsync() call is not the best API.=20

The package manager were designed with capabilities of the old file-sys=
tems in=20
mind. At the time the sync(2) API was the only available.
With this API it is impossible to have an atomic upgrade (all or nothin=
g) of a=20
package.=20

With the new filesystems (BTRFS and ZFS ), the package manager have mor=
e=20
options. They can create a snapshot at the beginning (of the old filesy=
stem)=20
and rollback if something goes wrong (I am simplifying a bit) . But the=
=20
package manager have to be updated.

As bonus you can avoid to use sync(2) which has performance drawbacks=20
(specially with BTRFS).

=20
[...]


>=20
> > Using the snapshot during an upgrade open a lot of possibility whic=
h
> > are not allowed with EXT4. With snapshot you can always go back if
> > during an upgrade if something goes wrong (like strange packages
> > dependencies). Or you can have the previous configuration to go bac=
k
> > in case of trouble.
>=20
> Adding new possibilities is one thing. And supporting snapshots prope=
rly
> would depend on some support side from the applications. I think that
> using snapshots for upgrades is a good idea.
>=20
> But OTOH I think that BTRFS should not break or slow down existing
> userspace. I think that existing approaches like using fsync() like
> according to quite some filesystem developers it should be used shoul=
d
> continue to work nicely.

Nobody wants to slowdown the application. But the life is full of compr=
omises.
If you want the speed of ext4, you can use ext4. If you want the snapsh=
ot=20
capability and the COW guarantee you can use BTRFS, but you have some=20
slowness.

Of course the best would be have the speed of the ext4 with the capabil=
ities=20
of btrfs.... :-) Unfortunately today this is not available.

[....]


>=20
> Thanks,
Regards
--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
