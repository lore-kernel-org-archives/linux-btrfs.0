From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 12:09:56 +0100
Message-ID: <201112171209.56877.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <201112162158.45819.Martin@lichtvoll.de> <20111217100302.6beffbcd@sf.vba.domain> (sfid-20111217_102134_745546_A2A977B8)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111217100302.6beffbcd@sf.vba.domain>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Sergei Trofimovich:
> On Fri, 16 Dec 2011 21:58:45 +0100
>=20
> Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Nope. Doesn=C2=B4t seem to help much.
> >=20
> > How to turn it off, after turning it on?
> >=20
> > deepdance:~> LANG=3DC mount -o remount,datacow /
> > mount: / not mounted already, or bad option
>=20
> In debian you can disable syncing on per-process basis:
>     http://packages.debian.org/sid/eatmydata
>=20
> $ eatmydata apt-get install foo
> $ eatmydata firefox
> $ eatmydata liferea
>=20
> makes things more bearable

I am not ready to accept that this is the proper answer to what I=20
experience. Applications using fsync() are realistic real world scenari=
os=20
and I think BTRFS has to cope with that.

Yesterday I upgraded the laptop to 3.2-rc4. After converting the inode=20
cache the filesystem appeared to be faster, but I have to wait for some=
=20
Debian packages to pile up on the repository servers to get a real=20
impression.

I think I will scrub / balance / defragment the filesystem after a back=
up.=20
But I am not sure in what order.

I understand that defragment defragments files. But then what does bala=
nce=20
do? For RAID setup I have seen it distributing data evenly across drive=
s=20
when I echo > /sys/block/sda/[=E2=80=A6]/delete a drive before and BTRF=
S had to=20
distribute unevenly cause of that. But what does it do on a filesystem =
on a=20
single drive? I bet it would balance out trees? Will it resize trees wi=
th=20
lots of unused space as well?

According to

deepdance:~> btrfs filesystem df /=20
Data: total=3D11.23GB, used=3D6.98GB
System, DUP: total=3D8.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.86GB, used=3D511.35MB
deepdance:~> btrfs filesystem show
[=E2=80=A6]
Label: 'debian'  uuid: 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        Total devices 1 FS bytes used 7.48GB
        devid    1 size 15.00GB used 14.97GB path /dev/dm-0

Btrfs Btrfs v0.19

the filesystem might have had some chances to fragment heavily, cause t=
he=20
tree sizes add up almost to the 15 GB of space available.

I also remember that for some time the filesystem was nearly full which=
=20
would explain the tree sizes.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
