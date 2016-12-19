Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from strugee.net ([216.160.72.225]:41336 "EHLO steevie.strugee.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932727AbcLSDPO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Dec 2016 22:15:14 -0500
Received: from localhost (unknown [192.168.0.8])
        by steevie.strugee.net (Postfix) with ESMTPSA id 597E3242603
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Dec 2016 19:15:13 -0800 (PST)
Date: Sun, 18 Dec 2016 19:15:12 -0800
From: Alex Jordan <alex@strugee.net>
To: linux-btrfs@vger.kernel.org
Subject: "crc32 mismatch" followed by segfault in btrfs receive
Message-ID: <20161219031511.GG31904@null-ptr-exception>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J2uG6jHjFLimDtBY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--J2uG6jHjFLimDtBY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey, all -

Recently my btrfs filesystem started hanging forever when mounted
read-write. However, mounting it readonly succeeded, so I backed up my
oldest backup subvolume with `btrfs send` and then saved the rest of
the backup subvolumes with `btrfs send -p`. Then I reformatted the
filesystem.

However, upon trying to restore the initial subvolume with `btrfs
receive -vvvvv --max-errors 10`, I get:

    mkfile o28626690-3011443-0
    rename o28626690-3011443-0 -> var/lib/logrotate/status
    utimes var/lib/logrotate
    truncate var/lib/logrotate/status size=3D3D18897
    chown var/lib/logrotate/status - uid=3D3D0, gid=3D3D0
    chmod var/lib/logrotate/status - mode=3D3D0644
    utimes var/lib/logrotate/status
    mkfile o28626715-3011443-0
    rename o28626715-3011443-0 -> var/lib/mlocate/mlocate.db
    utimes var/lib/mlocate
    ERROR: crc32 mismatch in command.
    ERROR: read from stream failed. Bad address
    ERROR: crc32 mismatch in command.
    ERROR: read from stream failed. Bad address
    ERROR: read from stream failed. Bad address
    Segmentation fault

at the end. Any idea what could be going on?

Here are some details about my system:

    % uname -a
    Linux steevie 4.7.0-0.bpo.1-amd64 #1 SMP Debian 4.7.8-1~bpo8+1 (2016-10=
-19) x86_64 GNU/Linux
   =20
    % btrfs --version # Installed from Debian's jessie-backports
    btrfs-progs v4.7.3
   =20
    % sudo btrfs fi show
    [sudo] password for alex:=20
    Label: '[root]'  uuid: 06c6565d-af6c-4123-9e42-3b6281f164e6
            Total devices 3 FS bytes used 430.48GiB
            devid    1 size 109.45GiB used 1.00GiB path /dev/mapper/sdc6_cr=
ypt
            devid    2 size 931.47GiB used 460.04GiB path /dev/mapper/sda2_=
crypt
            devid    3 size 931.47GiB used 461.04GiB path /dev/mapper/sdb2_=
crypt
   =20
    warning, device 4 is missing
    warning, device 3 is missing
    bytenr mismatch, want=3D895655870464, have=3D0
    ERROR: cannot read chunk root
    Label: '[root]'  uuid: 1c3126e2-2834-475b-92f2-853c1e13552b
            Total devices 4 FS bytes used 414.79GiB
            devid    5 size 109.45GiB used 3.00GiB path /dev/sdd6
            *** Some devices missing
   =20
    % sudo btrfs fi df /                              =20
    Data, RAID1: total=3D455.00GiB, used=3D426.58GiB
    System, RAID1: total=3D40.00MiB, used=3D96.00KiB
    Metadata, RAID1: total=3D6.00GiB, used=3D3.90GiB
    GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

dmesg has a single relevant line:

> traps: btrfs[27981] general protection ip:7fec861d81bd sp:7ffff8911240 er=
ror:0 in libc-2.19.so[7fec861a1000+1a1000]

The entire log is available at http://sprunge.us/UQWP. I know
pastebin-type services are discouraged on here, so sorry about that -
it's ~112K so my email got rejected when I sent it as an attachment.

Thanks in advance,

AJ

--J2uG6jHjFLimDtBY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQKTBAEBCgB9FiEE3TIG+G3O4jPMCddIJnlANGM9u8AFAlhXULRfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldERE
MzIwNkY4NkRDRUUyMzNDQzA5RDc0ODI2Nzk0MDM0NjMzREJCQzAACgkQJnlANGM9
u8DCmhAAnfgmrGVrzcieS3C9/odMuKeqxPKrs+8rg94I9Ezo+Lchf1L/4zF3LTKW
ZNbVUXhHRPRt/OkRMbybiICudOrJzSr1naTlzhHz5Qc+QHSqv3NoxLYY5nu/xySC
sncnQ/mfBzpYXY2n0Z+6VsH0DgHUM+dMozblzHcydbluM/UtNpgARYGlRaH0wCwB
ffuAKx4ncfXAFym5jpDOq19ns7eT41o2+6rIqz8tJTf2s1F69/y4MGhI9xPpBMtp
3PI3QNKzTfapwQ1Su2nMaA3XOzYMRmMqIlLf7Dhdqvg1yOCa76do9gx8SZepmfk/
/kxIJpY8y7rUv/HPz8md4N+oSYLDVutws3wI5yySdOKOODEVC8Oi7Dk5dFZbMYy4
mYC/qSbpzScfNLI/CqDTr/qIUHojUNH6MB874Uk78PX6IKA0guTs4mG/jdS2xK5P
S1g6QHwJz8FBAMAzIDDfPVomFX7urc6uSLCtPO8vOHT77ZZ7Eszv93Ok9JRmU8XD
Bd25WtJDY/AYEnk0mImqjAE6oVHXHdMQidAmmL9ORjlS5R4KXO7pdD5KnWcuMTE9
r6YbYHWYGcWuaGYqjAYTRfwJfnfph/qHPdYvAQPXuEoG20zuAwvaiPtYI8wyv6lN
0zfEEZDxtkJg1omvjj6gQxzmt+/X97hORNuQ3UfiaAK/P6eKsY8=
=xGsI
-----END PGP SIGNATURE-----

--J2uG6jHjFLimDtBY--
