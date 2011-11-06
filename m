From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: Btrfs default subvolume, /home
Date: Sun, 06 Nov 2011 10:44:03 +0000
Message-ID: <1320576243.2122.11.camel@picard.airangel.com>
References: <CALHG4fEBDSNOVZhHRJdRzZzaLcvYc5dAPtig03ic4ZE9Ex40sQ@mail.gmail.com>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-6v/6qaNBxmlIkHSMvqUN"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALHG4fEBDSNOVZhHRJdRzZzaLcvYc5dAPtig03ic4ZE9Ex40sQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-6v/6qaNBxmlIkHSMvqUN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-11-05 at 22:22 -0400, Eric Griffith wrote:
> Hey guys, I've been trying out BTRFS the last couple days, just to
> kind of see what to expect and what I can do with it once its
> finalized and we have a working fsck. I do have a couple question that
> neither the Arch Wiki, The Fedora WIki, Ubuntu wiki or the kernel.org
> wiki could answer. So here goes;
>=20
>=20
> When I installed fedora (F16 Beta) I made root be an ext4 partition,
> with /home as BTRFS. Ubuntu wiki states that any BTRFS partition has a
> default subvolume called "default," I cant find it for /home.
>=20
> /etc/fstab:
>=20
> #
> # /etc/fstab
> # Created by anaconda on Thu Nov 3 15:24:14 2011
> #
> # Accessible filesystems, by reference, are maintained under '/dev/disk'
> # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more in=
fo
> #
> UUID=3De5021a48-c961-4e73-98a5-beee06355f46 / ext4 defaults 1 1
> UUID=3D97ac420f-2818-4833-b7b6-4ac497716e3b /home btrfs
> defaults,autodefrag,compress 1 2
> UUID=3D0d275462-1ad3-46af-a1b8-637ca5efeca6 swap swap defaults 0 0
>=20
>=20
> btrfs --help says. "btrfs subvolume list <path> : List the
> snapshot/subvolume of a filesystem." I'd expect it to spit out
> "default" at some point.
>=20
> Couple outputs
>=20
> [eric@eric-laptop ~]$ sudo btrfs subvolume list /
> ERROR: '/' is not a subvolume
> [eric@eric-laptop ~]$ sudo btrfs subvolume list /home
> [eric@eric-laptop ~]$
>=20

It doesn't list the root volume (0). I'm not sure if it ever did - it is
root volume so it might not "sub"volume.

> What i wanted was an easy; reliable way to keep a backup of my home
> using btrfs instead of just rsync. Unfortunately, in order to use
> snapshot, it needs to be on, or be a, subvolume.
>=20

Remember that snapshots are not backups. If anything damages your
partition, or even sector your file is in, you have troubles.

> proof:
>=20
> [eric@eric-laptop ~]$ sudo btrfs subvolume snapshot /home/eric /home/eric=
/test
> ERROR: '/home/eric' is not a subvolume
> [eric@eric-laptop ~]$
>=20

Why not (with eric back on /home):

btrfs subvolume snapshot /home /home/snapshot-$(date -u +"%Y%m%d")

Snapshots are not recursive.

(It works for me with integration-20111030 but not integration-20111012
on 3.1.0+)

>=20
> So; I rebooted into single user, mv'ed /home/eric to /home/eric-btrfs,
> made a subvolume in /home/ named 'eric' to take the place of my home,
> and cp'ed all of my files from eric-btrfs to eric, a quick chown, and
> chmod to get the file permissions right.
>=20
> Rebooted, tried to login... error messages, lots of error messages.
> "Cant switch out from /" "/home/eric/.kde/share/config/knotifyrc is
> not writable" despite having read and write permission, and ownership.
>=20

Can you log in from tty to check whether you can access $HOME? I'm not
btrfs developer but I am not sure if you can have subvolume owned by
non-root.

> Can anyone figure out what the heck is going on? I know BTRFS is still
> experimental, but I thought the layout and implementation was
> finalized. OR; what do I have to do to make Btrfs work as a /home as
> it should? (see ZFS / LVM )

Regards

--=-6v/6qaNBxmlIkHSMvqUN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOtmT3AAoJEJIdee2Vr4aPmQwP/3BkmNzMbx7Asc7EkTSK68qk
rX7+WhMqd8ejSwo3u0jGgO3s3wp85Hnn/c4B00KTVHIoLFkkNdltnEjOEatBq7wp
K0zRwI8YfaVNvZHl9396pdOlNn17MQnnKD/+XNfN8uKhvdtJvU2MC3uACjJI1fGD
TOofpcNOcgAP7k/CU9HZXX2Ti+Sgy7auvICLsGce2rqcgSOw44o/VvTs6mIAI+Dt
6Zbt2HivygjD+LqUDrWu0KxUx5aLQlIfCKZ+q3+CUciHweYt7BY0QuQlvbIwCd63
Kj7jXpUGwZcgjYH17CDM1+P0kr2NwHllUHJZiaM0XPX0zQUog2Eal4m9q+dvdKLT
XtzpEMX411CGhflr7xSIXiigqQ10AniW3FUI43j17CHlw6JrUCwmLGFN2s783eMO
aL2t9bWhAR+qjcILsHP7tKvr1USxlpK0BOnsRObNcSaRjov27HlFnEN7p4nVJI/c
girXO2q5yjTgT3du9HpxTTEVDUB8isAMaAogJZfoS50huPoq7v8swYRExCLa36HJ
u3NvpUKKKKayHAD94z74UffvdgYxbvmibP79omUK4O+2Vt2E+dcFdH0YZm2kt/K/
UfvAXTOV7EppV8Rz/qzPtMS6yx/9BvMILtCJN0mMHgG9N0m4Wc1bZ4/+2xdz+N48
Nb+BCyegyP5TarTlhkhR
=QYGU
-----END PGP SIGNATURE-----

--=-6v/6qaNBxmlIkHSMvqUN--


