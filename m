From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 12:38:07 +0100
Message-ID: <201112171238.07681.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <201112171209.56877.Martin@lichtvoll.de> <20111217112619.GD17573@carfax.org.uk> (sfid-20111217_123300_387471_1F2ACC5D)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111217112619.GD17573@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Hugo Mills:
> On Sat, Dec 17, 2011 at 12:09:56PM +0100, Martin Steigerwald wrote:
> > I think I will scrub / balance / defragment the filesystem after a
> > backup. But I am not sure in what order.
> >=20
> > I understand that defragment defragments files. But then what does
> > balance do? For RAID setup I have seen it distributing data evenly
> > across drives when I echo > /sys/block/sda/[=E2=80=A6]/delete a dri=
ve before
> > and BTRFS had to distribute unevenly cause of that. But what does i=
t
> > do on a filesystem on a single drive? I bet it would balance out
> > trees? Will it resize trees with lots of unused space as well?
>=20
>    The metadata trees are automatically balanced, simply by the natur=
e
> of the B-tree algorithms used. Balance won't, in general, affect them=
=2E
> The only thing that a balance will achieve on a single-disk filesyste=
m
> is to reclaim unused space from allocated block groups -- so the
> "total" value in your Data and Metadata entries below will go down.

But thats only for optical viewing pleasure as far as I understood you?

Only if there would be not enough free space for one tree to extend the=
n a=20
balance would make sense? I.e. when I had a lot of metadata so that the=
=20
metadata would need to extend (which seems unlikely given below figures=
).

> > According to
> >=20
> > deepdance:~> btrfs filesystem df /
> > Data: total=3D11.23GB, used=3D6.98GB
> > System, DUP: total=3D8.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D1.86GB, used=3D511.35MB
> > deepdance:~> btrfs filesystem show
> > [=E2=80=A6]
> > Label: 'debian'  uuid: 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
> >=20
> >         Total devices 1 FS bytes used 7.48GB
> >         devid    1 size 15.00GB used 14.97GB path /dev/dm-0
> >=20
> > Btrfs Btrfs v0.19
> >=20
> > the filesystem might have had some chances to fragment heavily, cau=
se
> > the tree sizes add up almost to the 15 GB of space available.
> >=20
> > I also remember that for some time the filesystem was nearly full
> > which would explain the tree sizes.
>=20
>    For metadata, the lower bound on size is 0.1% of the data size
> (because checksums are computed at 4 bytes for every 4096 bytes of
> data). However, data usage can be very much greater than this with
> inline extents, where small files can get embedded directly in the
> metadata section. This is probably more likely what explains the tree
> sizes.
>=20
>    I understand (although I've not done the analysis myself) that the
> maximum "wasted" space in btrfs's B-tree implementation is 50%. To th=
e
> best of my knowledge, there's no compaction process for btrfs's trees
> available -- nor, in general, should you need one, as a fully-
> compacted tree would only have to be rearranged when more data is
> added to it, thus slowing the system down after compaction.

If I understand this correctly this means I can skip the balance step=20
completely.

I might still be doing the balance for that optical viewing pleasure ;)=
=2E

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
