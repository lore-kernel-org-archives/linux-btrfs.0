Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:40523 "EHLO
        mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdLLK37 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 05:29:59 -0500
To: linux-btrfs@vger.kernel.org
Reply-To: service@automatix.de
From: Juergen Sauer <juergen.sauer@automatix.de>
Subject: OFF-By-One Trouble? [BTRFS in Debian Stretch Kernel 4.9.0-4-amd64]
Message-ID: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>
Date: Tue, 12 Dec 2017 11:22:40 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="C930XosdwtSQorqsm8SNtelfVfbwONv7k"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C930XosdwtSQorqsm8SNtelfVfbwONv7k
Content-Type: multipart/mixed; boundary="ftqaJOqqtiN263mTPGI4bQd2okM7B1G7S";
 protected-headers="v1"
From: Juergen Sauer <juergen.sauer@automatix.de>
Reply-To: service@automatix.de
To: linux-btrfs@vger.kernel.org
Message-ID: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>
Subject: OFF-By-One Trouble? [BTRFS in Debian Stretch Kernel 4.9.0-4-amd64]

--ftqaJOqqtiN263mTPGI4bQd2okM7B1G7S
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Hi collegues,
this morning we've got a problm with btrfs in Debian Stable.

Yesterday we had our fs filled below 30% space usage.
No further usage came in the usage is nearly the same, but ...

# df -h .
Dateisystem    Gr=C3=B6=C3=9Fe Benutzt Verf. Verw% Eingeh=C3=A4ngt auf
/dev/vdb1      483G    483G  148K  100% /mnt

# btrfs fi df .
Data, single: total=3D480.97GiB, used=3D480.97GiB
System, single: total=3D32.00MiB, used=3D96.00KiB
Metadata, single: total=3D2.00GiB, used=3D1.29GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

# btrfs fi show .
Label: 'AXSDaten'  uuid: fde7e31f-4127-4a9d-b7c6-774ceff8f7c1
        Total devices 1 FS bytes used 482.26GiB
        devid    1 size 483.00GiB used 483.00GiB path /dev/vdb1

# btrfs --version
btrfs-progs v4.7.3

we found exerpt of kernel log:
[  199.391577] attempt to access beyond end of device
[  199.391598] vdb1: rw=3D536870984, want=3D1012922336, limit=3D101292233=
5
[  199.391615] BTRFS error (device vdb1): bdev /dev/vdb1 errs: wr 301,
rd 0, flush 0, corrupt 0, gen 0
r
If I interpret the log right, on the FS the kernel wants to write on
block  1012922336, but the fs was created with max 1012922335 blocks.

Looks to us here like a typical off-by-one error on accessing the last
block of device.

This error was repeating under ff. conditions:
- shutdown the virtual server (kvm),
- extend the physical file of the according virtual hdd by 20% (from 483
Gib to 520 GiB)
- restart virtual server
- fixed partion size (parted), mounted
- called btrfs fi resize max on the corresponding mount point

Error came back, nearly at once.

Any other Idea to fix this error?

mit freundlichen Gr=C3=BC=C3=9Fen
J=C3=BCrgen Sauer

--=20
J=C3=BCrgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Gesch=C3=A4ftsf=C3=BChrer: J=C3=BCrgen Sauer,
Gerichtstand: Amtsgericht Walsrode =E2=80=A2 HRB 120986
Ust-Id: DE191468481 =E2=80=A2 St.Nr.: 36/211/08000
GPG Public Key zur Signaturpr=C3=BCfung:
http://www.automatix.de/juergen_sauer_publickey.gpg


--ftqaJOqqtiN263mTPGI4bQd2okM7B1G7S--

--C930XosdwtSQorqsm8SNtelfVfbwONv7k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXnJOAsmrKYVtqq/xbtQoj0SpqsQUCWi+t9AAKCRBbtQoj0Spq
sQGaAKCKAbCur/NsESIjTUoU2FbMYj0PXQCeIk2TU1hphroNevJnt5Po1V2TNzM=
=HOD5
-----END PGP SIGNATURE-----

--C930XosdwtSQorqsm8SNtelfVfbwONv7k--
