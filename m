From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: btrfs fi df gives only the total size that is currently
 allocated
Date: Sat, 19 Mar 2011 15:51:49 -0400
Message-ID: <1300564311.19466.10.camel@nayuki.kepstin.ca>
References: <4D850120.9030701@torus.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Gal Buki <buki@torus.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D850120.9030701@torus.ch>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2011-03-19 at 21:16 +0200, Gal Buki wrote:
> Hi
>=20
> I made a test RAID 10 with several old disks with various sizes.
> I copied some files (~800MB)
> When using btrfs fi df /mountpoint I get
> Data: total=3D1.00GB, used=3D800.00MB
> When I copy another ~800MB I get a total size of 2GB.
>=20
> This goes on and on until I hit the max size of the RAID.
> e.g.
> Data: total=3D5.00GB, used=3D4.97GB
>=20
> Is there a way to see what the max size will be without having to fil=
l=20
> the RAID first?

As I understand it: the simple answer is, unfortunately, =E2=80=9Cno=E2=
=80=9D. Because
metadata and data chunks are allocated on demand depending on how you
use the space, the best you could do would be to make a guess based on
current allocation ratios.

That is something which is pretty hard to do manually though=E2=80=94
particularly in the case of differently-sized disks=E2=80=94so some sor=
t of
estimation tool could be useful. (But it would be just that: an
estimate, not an exact count.)

This will get worse once btrfs supports having data with different raid
levels on the same filesystem, because you=E2=80=99ll have different am=
ounts of
=E2=80=9Cavailable=E2=80=9D space depending on which raid type the data=
 in question is
stored with.

--=20
Calvin Walton <calvin.walton@kepstin.ca>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
