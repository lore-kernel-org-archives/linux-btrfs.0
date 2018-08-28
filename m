Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:48563 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbeH1PwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 11:52:04 -0400
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: Menion <menion@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d804450e-8d49-3114-52be-6492e00193f8@gmx.com>
Date: Tue, 28 Aug 2018 19:54:03 +0800
MIME-Version: 1.0
In-Reply-To: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tetOdj7s1BGTtxU7XP5i1UD9NJyBGLky3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tetOdj7s1BGTtxU7XP5i1UD9NJyBGLky3
Content-Type: multipart/mixed; boundary="Wf55Ww1VkYucsXjQW7dS1BZ6TAlpTGkYX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Menion <menion@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <d804450e-8d49-3114-52be-6492e00193f8@gmx.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
In-Reply-To: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>

--Wf55Ww1VkYucsXjQW7dS1BZ6TAlpTGkYX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/28 =E4=B8=8B=E5=8D=885:34, Menion wrote:
> Hi all
> I have run a distro upgrade on my Ubuntu 16.04 that runs ppa kernel
> 4.17.2 with btrfsprogs 4.17.0
> The root filesystem is BTRFS single created by the Ubuntu Xenial
> installer (so on kernel 4.4.0) on an internal mmc, located in
> /dev/mmcblk0p3
> After the upgrade I have cleaned apt cache and checked the free space,
> the results were odd, following some checks (shrinked), followed by
> more comments:
>=20
> root@Menionubuntu:/home/menion# df -h
> Filesystem      Size  Used Avail Use% Mounted on
> ...............................................................
> /dev/mmcblk0p3   28G   24G  2.7G  90% /
>=20
> root@Menionubuntu:/home/menion# btrfs fi usage /usr
> Overall:
>     Device size:                  27.07GiB
>     Device allocated:             25.28GiB
>     Device unallocated:            1.79GiB
>     Device missing:                  0.00B
>     Used:                         23.88GiB
>     Free (estimated):              2.69GiB      (min: 2.69GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:               72.94MiB      (used: 0.00B)
>=20
> Data,single: Size:24.00GiB, Used:23.10GiB
>    /dev/mmcblk0p3         24.00GiB
>=20
> Metadata,single: Size:1.25GiB, Used:801.97MiB
>    /dev/mmcblk0p3          1.25GiB
>=20
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/mmcblk0p3         32.00MiB
>=20
> Unallocated:
>    /dev/mmcblk0p3          1.79GiB
>=20
> root@Menionubuntu:/home/menion# btrfs fi df /mnt
> Data, single: total=3D24.00GiB, used=3D23.10GiB
> System, single: total=3D32.00MiB, used=3D16.00KiB
> Metadata, single: total=3D1.25GiB, used=3D801.92MiB
> GlobalReserve, single: total=3D72.89MiB, used=3D0.00B
>=20
> The different ways to check the free space are coherent, but if I
> check the directories usage on root, surprise:
>=20
> root@Menionubuntu:/home/menion# du -x -s -h /*
> 17M     /bin
> 189M    /boot
> 36K     /dead.letter
> 0       /dev
> 18M     /etc
> 6.1G    /home
> 4.0K    /initrd.img
> 4.0K    /initrd.img.old
> 791M    /lib
> 8.3M    /lib64
> 0       /media
> 4.0K    /mnt
> 0       /opt
> du: cannot access '/proc/24660/task/24660/fd/3': No such file or direct=
ory
> du: cannot access '/proc/24660/task/24660/fdinfo/3': No such file or di=
rectory
> du: cannot access '/proc/24660/fd/3': No such file or directory
> du: cannot access '/proc/24660/fdinfo/3': No such file or directory
> 0       /proc
> 2.9M    /root
> 2.9M    /run
> 17M     /sbin
> 4.0K    /snap
> 0       /srv
> 0       /sys
> 0       /tmp
> 6.1G    /usr
> 2.0G    /var
> 4.0K    /vmlinuz
> 4.0K    /vmlinuz.old
> 4.0K    /webmin-setup.out
>=20
> The computed usage is 15Gb which is what I expected, so there are 9Gb
> lost somewhere.
> I have run scrub and then full balance with:

I think this is related to btrfs CoW and extent booking.

One simple example would be:

xfs_io -f -c "pwrite 0 128k" -c "sync" -c "pwrite 0 64K" \
	/mnt/btrfs/file1

The result "/mnt/btrfs/file1" will only be sized 128K in du, but it
on-disk usage is 128K + 64K.

The first 128K is the data written by the first "pwrite" command, it
caused a full 128K extent on disk.
Then the 2nd pwrite command also created a new 64K extent, which is the
default data CoW behavior.
The first half of the original 128K extent is not used by anyone, but it
still takes space.

Above btrfs extent booking behavior could cause a lot of wasted space
even there is only one single subvolume without any snapshot.

In that case, instead of balance, defrag should be your friend to free
up some space.

Thanks,
Qu

>=20
> btrfs scrub start /
> btrfs balance start /
> The balance freed 100Mb of space, it was running in background so I
> have checked dmesg when "btrfs balance status" said that was completed
>=20
> dmesg of balance:
>=20
> [47264.250141] BTRFS info (device mmcblk0p3): relocating block group
> 37154193408 flags system
> [47264.592082] BTRFS info (device mmcblk0p3): relocating block group
> 36046897152 flags data
> [47271.499809] BTRFS info (device mmcblk0p3): found 73 extents
> [47272.329921] BTRFS info (device mmcblk0p3): found 60 extents
> [47272.471059] BTRFS info (device mmcblk0p3): relocating block group
> 35778461696 flags metadata
> [47280.530041] BTRFS info (device mmcblk0p3): found 3199 extents
> [47280.735667] BTRFS info (device mmcblk0p3): relocating block group
> 34704719872 flags data
> [47301.460523] BTRFS info (device mmcblk0p3): relocating block group
> 37221302272 flags data
> [47306.038404] BTRFS info (device mmcblk0p3): found 5 extents
> [47306.481371] BTRFS info (device mmcblk0p3): found 5 extents
> [47306.673135] BTRFS info (device mmcblk0p3): relocating block group
> 37187747840 flags system
> [47306.874874] BTRFS info (device mmcblk0p3): found 1 extents
> [47307.073288] BTRFS info (device mmcblk0p3): relocating block group
> 34704719872 flags data
> [47371.059074] BTRFS info (device mmcblk0p3): found 16258 extents
> [47388.191208] BTRFS info (device mmcblk0p3): found 16094 extents
> [47388.985462] BTRFS info (device mmcblk0p3): relocating block group
> 31215058944 flags metadata
> [47439.164167] BTRFS info (device mmcblk0p3): found 7378 extents
> [47440.163793] BTRFS info (device mmcblk0p3): relocating block group
> 30141317120 flags data
> [47593.239048] BTRFS info (device mmcblk0p3): found 15636 extents
> [47618.389357] BTRFS info (device mmcblk0p3): found 15634 extents
> [47620.020122] BTRFS info (device mmcblk0p3): relocating block group
> 29012000768 flags data
> [47637.708444] BTRFS info (device mmcblk0p3): found 1154 extents
> [47639.757342] BTRFS info (device mmcblk0p3): found 1154 extents
> [47640.375483] BTRFS info (device mmcblk0p3): relocating block group
> 27938258944 flags data
> [47743.312441] BTRFS info (device mmcblk0p3): found 17009 extents
> [47756.928461] BTRFS info (device mmcblk0p3): found 17005 extents
> [47757.607346] BTRFS info (device mmcblk0p3): relocating block group
> 9416212480 flags metadata
> [47825.819449] BTRFS info (device mmcblk0p3): found 11503 extents
> [47826.465926] BTRFS info (device mmcblk0p3): relocating block group
> 8342470656 flags data
> [47900.754062] BTRFS info (device mmcblk0p3): found 20607 extents
> [47928.061348] BTRFS info (device mmcblk0p3): found 20607 extents
> [47929.125750] BTRFS info (device mmcblk0p3): relocating block group
> 4852809728 flags metadata
> [47993.308492] BTRFS info (device mmcblk0p3): found 13214 extents
> [47994.883308] BTRFS info (device mmcblk0p3): relocating block group
> 3779067904 flags data
> [48108.871895] BTRFS info (device mmcblk0p3): found 13256 extents
> [48124.623607] BTRFS info (device mmcblk0p3): found 13255 extents
> [48125.156150] BTRFS info (device mmcblk0p3): relocating block group
> 3510632448 flags metadata
> [48191.030178] BTRFS info (device mmcblk0p3): found 12394 extents
> [48193.202016] BTRFS info (device mmcblk0p3): relocating block group
> 2436890624 flags data
> [48347.733120] BTRFS info (device mmcblk0p3): found 22889 extents
> [48371.149135] BTRFS info (device mmcblk0p3): found 22889 extents
> [48373.723037] BTRFS info (device mmcblk0p3): relocating block group
> 20971520 flags metadata
> [48449.367016] BTRFS info (device mmcblk0p3): found 13755 extents
> [48451.058818] BTRFS info (device mmcblk0p3): relocating block group
> 12582912 flags data
> [48453.657685] BTRFS info (device mmcblk0p3): found 726 extents
> [48461.188484] BTRFS info (device mmcblk0p3): found 726 extents
> [48463.496116] BTRFS info (device mmcblk0p3): relocating block group
> 4194304 flags metadata
> [48476.405722] BTRFS info (device mmcblk0p3): found 403 extents
> [48479.254106] BTRFS info (device mmcblk0p3): 17 enospc errors during b=
alance
>=20
> There is this enospc errors, can anyone help me in understanding what
> is going on?
> Bye
>=20


--Wf55Ww1VkYucsXjQW7dS1BZ6TAlpTGkYX--

--tetOdj7s1BGTtxU7XP5i1UD9NJyBGLky3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluFN9sACgkQwj2R86El
/qgQFwf8C4fsO5g3m3HJyvMiIrvj6dPK9DAQl3Uq52IXJ0RX2NmaY5DN20De9GqZ
2K48gHnM8gZNEQNdS48fivfqzsyr5BVwfgy+UDCen4lGyms1U16sITb0PAFGIi6W
0w+wBWUyEohMilBDYhikQaUr6O/b9yjsdxm/22A+TXe6v+vGn2cKXKxrze0mpo49
WZGH2ZnUAz6C9Z+8VLIREc3sHPVHIzVzMhwEjZ/nnrOFJ4EfZxYGDurVDJvlpH3N
gNUA307rhqJgue7YDFcG/S489gNjAl4P84pzkoDue5KCryYjgHTp28d1aeGeBV5Q
vsttl3/pV4axTYpWRMpYIj/RXEU+Aw==
=sxnC
-----END PGP SIGNATURE-----

--tetOdj7s1BGTtxU7XP5i1UD9NJyBGLky3--
