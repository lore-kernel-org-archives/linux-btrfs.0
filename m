From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Questions regarding COW-related behaviors
Date: Mon, 8 Nov 2010 18:31:54 +0100
Message-ID: <201011081831.55168.kreijack@libero.it>
References: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 08 November, 2010, Jo=E3o Eduardo Lu=EDs wrote:
> Hello list.
[...]
> Basically, I need to be aware how the COW works in BTRFS, and what it=
 may=20
allow one to achieve. Questions follow.
>=20
> 1) Is COW only used when creating or updating a file? While testing B=
TRFS,=20
using 'btrfs subvolume find-new', I got the idea that neither creation =
of=20
directories, nor any kind of deletion are covered by COW. Is this right=
?

The command "btrfs subvolume find-new" search through the keys with typ=
e =3D=3D=20
BTRFS_EXTENT_DATA_KEY.
Because the COW is per disk-block basis, it is no so simple to track a =
change=20
in a metadata (in a disk-block there are a lot of metadata). In fact th=
ere are=20
a lot of false-positive.
I thought a bit about a way to compare two tree(s). But it is not so si=
mple.=20
If I understood correctly even if only a leaf is different, you have to=
=20
compare a full branch (from the root to the leaf) of different disk-blo=
cks.

>=20
> 2) Each time a COW happens, is there any kind implicit 'snapshotting'=
 that=20
may keep track of changes around the filesystem for each COW?=20
> By Rodeh's paper and some info on the wiki, I gather that a new root =
is=20
created for each COW, due to shadowing, but will the previous tree be k=
ept?=20
The wiki, at "BTRFS Design", states that "after the commit finishes, th=
e older=20
subvolume root items may be removed". This would make impossible to tra=
ck=20
changes to files, but 'btrfs subvolume find-new' still manages to outpu=
t file=20
generations, so there must be some info left behind.=20
>=20
> 3) Following (2), is there any way to access this informations and, l=
et's=20
say, recover an older version of a given file? Or an entire previous tr=
ee?

Snapshotting a tree is the method to track "an older version of a given=
=20
file"(s) or a tree.=20
[...]
>=20
> I would greatly appreciate any answer regarding any of this topics,=20
including any pointers to additional documentation that I may have miss=
ed.
>=20
>=20
> Regards.
>=20
>=20
> ---
> Jo=E3o Eduardo Lu=EDs
Ciao
Goffredo
--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
