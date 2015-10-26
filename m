Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50591 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbbJZOXq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 10:23:46 -0400
Received: from thetick.localnet ([93.181.44.4]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0LlXnX-1aOfnL1AIB-00bGjQ for
 <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 15:23:44 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: random i/o error without error in dmesg
Date: Mon, 26 Oct 2015 15:23:39 +0100
Message-ID: <5339076.FcC2BAjqs5@thetick>
In-Reply-To: <562E0D31.2080003@dblaci.hu>
References: <562E0D31.2080003@dblaci.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4411903.bkLBVbEfPj"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4411903.bkLBVbEfPj
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi

FWIW, this sounds like what I've been seeing with dovecot.  In case it'=
s=20
relevant, I'll try to explain.

After some uptime, I'll see log messages like this:

Okt 26 12:05:46 thetick dovecot[467]: imap(marcec): Error: pread() fail=
ed with=20
file /home/marcec/.mdbox/mailboxes/BTRFS/dbox-Mails/dovecot.index.log:=20=

Input/output error

Occasionally they go away by themselves, but usually I have to reboot t=
o make=20
them go away.  This happens when getmail attempts to fetch mail, which =
fails=20
due to the above error.  After the reboot getmail succeeds again.

As in Szalma's case, btrfs-scrub never reports anything wrong.

I use LZO compression on the relevant file system, so I wanted to wait =
until=20
kernel 4.1.11 before reporting this, but that hasn't hit Gentoo yet (an=
d=20
neither has 4.1.10, for some reason).  I don't use quotas.

According to the what I see in the systemd journal, the errors started =
on=20
2015-06-01 with kernel 3.19.8.  Note that, strangely enough, I had been=
 using=20
that same version since 2015-05-23, so for more than a week before the =
error=20
cropped up.  I checked whether I made any changes to the configuration,=
 and=20
found this:

diff --git a/kernels/kernel-config-3.19.8-gentoo b/kernels/kernel-
config-3.19.8-gentoo
index b061b31..8cf8eba 100644
=2D-- a/kernels/kernel-config-3.19.8-gentoo
+++ b/kernels/kernel-config-3.19.8-gentoo
@@ -64,7 +64,7 @@ CONFIG_INIT_ENV_ARG_LIMIT=3D32
 CONFIG_CROSS_COMPILE=3D""
 # CONFIG_COMPILE_TEST is not set
 CONFIG_LOCALVERSION=3D""
=2DCONFIG_LOCALVERSION_AUTO=3Dy
+# CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_HAVE_KERNEL_GZIP=3Dy
 CONFIG_HAVE_KERNEL_BZIP2=3Dy
 CONFIG_HAVE_KERNEL_LZMA=3Dy
@@ -73,8 +73,8 @@ CONFIG_HAVE_KERNEL_LZO=3Dy
 CONFIG_HAVE_KERNEL_LZ4=3Dy
 # CONFIG_KERNEL_GZIP is not set
 # CONFIG_KERNEL_BZIP2 is not set
=2DCONFIG_KERNEL_LZMA=3Dy
=2D# CONFIG_KERNEL_XZ is not set
+# CONFIG_KERNEL_LZMA is not set
+CONFIG_KERNEL_XZ=3Dy
 # CONFIG_KERNEL_LZO is not set
 # CONFIG_KERNEL_LZ4 is not set
 CONFIG_DEFAULT_HOSTNAME=3D"(none)"
@@ -132,7 +132,7 @@ CONFIG_TICK_CPU_ACCOUNTING=3Dy
 # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
 # CONFIG_IRQ_TIME_ACCOUNTING is not set
 CONFIG_BSD_PROCESS_ACCT=3Dy
=2D# CONFIG_BSD_PROCESS_ACCT_V3 is not set
+CONFIG_BSD_PROCESS_ACCT_V3=3Dy
 CONFIG_TASKSTATS=3Dy
 CONFIG_TASK_DELAY_ACCT=3Dy
 CONFIG_TASK_XACCT=3Dy

The only change I can think of that might affect anything is=20
CONFIG_BSD_PROCESS_ACCT_V3=3Dy (I don't remember why exactly I set it).=
  I can=20
try without it set, but maybe the kernel configuration is a red herring=
?

Anyway, the current state of the system is:

# uname -r=20
4.1.9-gentoo-r1
# btrfs filesystem show /=20
Label: 'MARCEC_ROOT'  uuid: 0267d8b3-a074-460a-832d-5d5fd36bae64
        Total devices 1 FS bytes used 74.40GiB
        devid    1 size 107.79GiB used 105.97GiB path /dev/sda1

btrfs-progs v4.2.2
# btrfs filesystem df /
Data, single: total=3D98.94GiB, used=3D72.30GiB
System, single: total=3D32.00MiB, used=3D20.00KiB
Metadata, single: total=3D7.00GiB, used=3D2.10GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

The filesystem is mounted as (leaving out subvolume mounts which use th=
e same=20
mount options):
/dev/sda1 on / type btrfs (rw,noatime,compress=3Dlzo,ssd,discard,space_=
cache)

Greetings,
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart4411903.bkLBVbEfPj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWLjdvAAoJEL/Q5oYsiHj0gGoP/RNfTqvP8rJsCQPHn8FzCTaz
+Q/0rckeUOhOoAmzEY0nBXD5P5b+XZue4bSkue4hDfvoTyTE7sBsp614/LlFdqEV
H5JLAvoYF+/J/BjXeqiMrLjFTp5Qr60Hzzka8+8mbbNftz4gjL6PXju68JBB2RvC
5SuMtqHo7yMD/Swoq3z+sztP51tzHlCh/lMo6eEBI5/6Azj6KE/bKd6vLYkmKTA+
4rfzb1lqcLxZYlNBmlkVCdCp/KymzZDYQUhnFC4rjax50kCWrLILZPsuaETDuzKm
JZgyrWnxJ8NtY088PMmskLf601IbrvaKTd/JKIzbt4TrlDaWMb3VA4p/fJvAFb1u
+uNCLgqnOA8Onom6Y3dPYdKmncfX243u66sXTofEy+NBar3XGPqg/WexPzxZUiOM
zRTRBQKj9NiyLw6C4UY6ASQ2U/pv2CQiUJ17DmJPCJa3ky7rkTcurPo5SPuxDeBT
UxPTx/uJ3U7NY6wNJHAlIHOuGsZEgDXgD2pEq5GGu18uvjGTr4LhjQAtiQkYq6XT
r0vdDH3POLVrbhm+zUs3P1dapNzJyGiesi4mTATkC8VT9ZjTadRkDcgJms3LJ7te
f7h/ntyHXUmGu4j2txJ5q7TRrilB11LBm1y2dYc3NB/EbPPV2Smsl5RduAvi4XOB
pEX26G8vmcSnj2vzBC+1
=GJF9
-----END PGP SIGNATURE-----

--nextPart4411903.bkLBVbEfPj--

