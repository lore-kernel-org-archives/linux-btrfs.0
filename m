Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55329 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbdBGAiD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Feb 2017 19:38:03 -0500
Subject: Re: [Regression 4.7-rc1] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
To: dsterba@suse.cz, Joseph Salisbury <joseph.salisbury@canonical.com>,
        luke@dashjr.org, luke-jr+git@utopios.org, jbacik@fb.com,
        dsterba@suse.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        clm@fb.com, linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
References: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
 <20170109112815.GE12081@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <f0e0fba1-a142-15f5-9ea7-718766d3b072@suse.com>
Date: Mon, 6 Feb 2017 19:37:53 -0500
MIME-Version: 1.0
In-Reply-To: <20170109112815.GE12081@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vVwu1GOUaNo84OS3b5UU9A3tlwc3q5Ejm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vVwu1GOUaNo84OS3b5UU9A3tlwc3q5Ejm
Content-Type: multipart/mixed; boundary="tdV0v4ulx0GXQKSjJmjCSOHuRHTdouX8K";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Joseph Salisbury <joseph.salisbury@canonical.com>,
 luke@dashjr.org, luke-jr+git@utopios.org, jbacik@fb.com, dsterba@suse.com,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org, clm@fb.com,
 linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
Message-ID: <f0e0fba1-a142-15f5-9ea7-718766d3b072@suse.com>
Subject: Re: [Regression 4.7-rc1] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
References: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
 <20170109112815.GE12081@twin.jikos.cz>
In-Reply-To: <20170109112815.GE12081@twin.jikos.cz>

--tdV0v4ulx0GXQKSjJmjCSOHuRHTdouX8K
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/9/17 6:28 AM, David Sterba wrote:
> On Fri, Jan 06, 2017 at 12:22:34PM -0500, Joseph Salisbury wrote:
>> A kernel bug report was opened against Ubuntu [0].  This bug was fixed=

>> by the following commit in v4.7-rc1:
>>
>> commit 4c63c2454eff996c5e27991221106eb511f7db38
>>
>> Author: Luke Dashjr <luke@dashjr.org>
>> Date:   Thu Oct 29 08:22:21 2015 +0000
>>
>>     btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in
>> btrfs_ioctl
>>
>>
>> However, this commit introduced a new regression.  With this commit
>> applied, "btrfs fi show" no longer works and the btrfs snapshot
>> functionality breaks.
>=20
> A plain 32bit kernel with 32bit userspace works fine. The bug seems to
> be on a 64bit kernel with 32bit userspace and the CONFIG_COMPAT compile=
d
> in. Strace does not show anything special:
>=20
> stat64("subv1", 0xffc64fcc)             =3D -1 ENOENT (No such file or =
directory)
> statfs64(".", 84, {f_type=3DBTRFS_SUPER_MAGIC, f_bsize=3D4096, f_blocks=
=3D5110784, f_bfree=3D4076143, f_bavail=3D4010951, f_files=3D0, f_ffree=3D=
0, f_fsid=3D{val=3D[
> 4260464218, 2297804334]}, f_namelen=3D255, f_frsize=3D4096, f_flags=3DS=
T_VALID|ST_RELATIME}) =3D 0
> stat64(".", {st_mode=3DS_IFDIR|0700, st_size=3D228, ...}) =3D 0
> stat64(".", {st_mode=3DS_IFDIR|0700, st_size=3D228, ...}) =3D 0
> open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) =3D 3
> fstat64(3, {st_mode=3DS_IFDIR|0700, st_size=3D228, ...}) =3D 0
> fstat64(1, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 1), ...}) =3D=
 0
> write(1, "Create subvolume './subv1'\n", 27) =3D 27
> ioctl(3, BTRFS_IOC_SUBVOL_CREATE, {fd=3D0, name=3D"subv1"}) =3D -1 ENOT=
TY (Inappropriate ioctl for device)
>=20
> The value of BTRFS_IOC_SUBVOL_CREATE is same on 32bit and 64bit kernels=
=2E
> As it returns ENOTTY, the value is not recognized. A candidate function=

> is btrfs_compat_ioctl that checks for just the IOC32 numbers and return=
s
> -ENOIOCTLCMD otherwise.
>=20
> The callchain in fs/compat_ioctl.c:ioctl cheks for the specific callbac=
k
> first, if it retunrs -ENOIOCTLCMD then goes to the normal ioctl
> callback, so there's always a point we reach the handler of
> BTRFS_IOC_SUBVOL_CREATE. So I don't see how it could happen.

I got a minute to look at this today.  It doesn't fallback to the normal
ioctl handler.  Since we have ->unlocked_ioctl defined, it checks the
hard-coded compat tables and then fails with -ENOTTY.

Fortunately, the fix is simple.  The default stanza of that switch
statement in btrfs_compat_ioctl needs to be removed.  Then it just
works.  I'll post a fix momentarily.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--tdV0v4ulx0GXQKSjJmjCSOHuRHTdouX8K--

--vVwu1GOUaNo84OS3b5UU9A3tlwc3q5Ejm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWJkW4h57S2MheeWyAQhOtA/+LtARwzgiU/x2RzIVYtAVvM4ze5WMwoNc
cS9kM5PSHyF93YJQP/i3mxT+8O3PbswPG+Kd0RZO3UonQxSYb8evvMb50/RG4Ow0
j7SirUD/KGHtmygpQke12mJLSrDkATAhaRH6rmye45dd2FpxtvIQBWkQXGRdzPeB
cANkRkG2YHylI0io2BNusH7YwPCC3HykaUAeC7oDiMVvhHBUOludnEl5j2r4K1Ey
V/3Ju5j+TeIWywk9B7RUnxqYJYPNKH5fmypVBds2KuCx3MyOctu10sDOyTJjQ7p+
A+FVeMno47WtswIOrlUw/2cdfHF866C+guuCx3Jl/RlwG3p/6W9gTDhGdXYEtmiY
QCSSF1Manl7tJcm9TUZitzuIqu0m/L1VfsBgyrwr5qoQNu3F6HfL6vwJt2h3wFHK
Yz4YdpLNB6rbUMWiotdO3UpzoiOzQ3J40NJckbr653bYvNYR6vvejC4DUcmRoor+
ugYPB2O47kvDyGP44x2J9BZfYnd0xr/Rh1KKw9Lg50lNCBcM6QasMXVN3vXIluce
AgAi30pzuXC8ebDoaJknL/acm+vmWcDSUAv5HPwMzteQdT+lyXAKLZW5lpy0yPA+
nzY+hCIBEIYPq04BvNtBoQQ0Gxigc37horGGhb49TmJaJ/Lek/ugBzZ5XfdHLJBk
Qfx2eoHUWF4=
=UTgq
-----END PGP SIGNATURE-----

--vVwu1GOUaNo84OS3b5UU9A3tlwc3q5Ejm--
