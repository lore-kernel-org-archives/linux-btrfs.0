From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: How to remount btrfs without compression?
Date: Mon, 7 Nov 2011 13:19:14 +0100
Message-ID: <201111071319.14493.Martin@lichtvoll.de>
References: <4EB72C1B.1030702@parallels.com> (sfid-20111107_092907_276831_5BC15106)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB72C1B.1030702@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 7. November 2011 schrieb dima:
> Hello,

Hi Dima,
=20
> Is there any possibility to remount a compressed btrfs without any
> compression at all?
>=20
> Syslinux bootloader does not understand any btrfs compression and
> whenever I edit syslinux.cfg on my compressed / subvolume, the file
> becomes compressed and thus unreadable by syslinux on the next boot.
>=20
> I tried to remount / without the 'compress' option (and edit
> syslinux.cfg in uncompressed state) and while the "mount" command wou=
ld
> not show compression any more, I can see in the /proc/mounts that
> compression is still there and the file still gets compressed after
> editing. But there seem to be no mount option like compress=3Dnone or
> something.
>=20
> The only workaround I found is to boot from a live CD mount / without
> any compression and re-save syslinux.cfg. Then it the file gets
> uncompressed.
>=20
> Are there any other options except for this workaround to temporarily
> remount btrfs without compression?

What does lsattr show on the file? Have you tried chattr -c on the file=
? It=20
might help to do a btrfs filesystem defrag on the file to remove=20
compression, cause I don=C2=B4t think chattr -c itself will uncompress =
it.

As far as I understand it is possible to individually set compression=20
on/off on single files. Although the global thing should work as well I=
MHO=20
as least when the file is rewritten.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
