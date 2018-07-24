Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f43.google.com ([209.85.208.43]:34818 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388427AbeGXTBG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 15:01:06 -0400
Received: by mail-ed1-f43.google.com with SMTP id e6-v6so4862254edr.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2018 10:53:28 -0700 (PDT)
Subject: Re: File permissions lost during send/receive?
To: Marc Joliet <marcec@gmx.de>, linux-btrfs@vger.kernel.org
References: <8202618.Xtt70Sb46P@thetick>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <47372f67-70fd-8b11-0573-39d1137356e3@gmail.com>
Date: Tue, 24 Jul 2018 20:53:15 +0300
MIME-Version: 1.0
In-Reply-To: <8202618.Xtt70Sb46P@thetick>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0ACfyYdsEGQYQ4u9ohMCVrUQc1MIm61XI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0ACfyYdsEGQYQ4u9ohMCVrUQc1MIm61XI
Content-Type: multipart/mixed; boundary="YtHsN06XqY37zjjwh4AwHYlop7f1EkB65";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Marc Joliet <marcec@gmx.de>, linux-btrfs@vger.kernel.org
Message-ID: <47372f67-70fd-8b11-0573-39d1137356e3@gmail.com>
Subject: Re: File permissions lost during send/receive?
References: <8202618.Xtt70Sb46P@thetick>
In-Reply-To: <8202618.Xtt70Sb46P@thetick>

--YtHsN06XqY37zjjwh4AwHYlop7f1EkB65
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

24.07.2018 15:16, Marc Joliet =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> Hi list,
>=20
> (Preemptive note: this was with btrfs-progs 4.15.1, I have since upgrad=
ed to=20
> 4.17.  My kernel version is 4.14.52-gentoo.)
>=20
> I recently had to restore the root FS of my desktop from backup (extent=
 tree=20
> corruption; not sure how, possibly a loose SATA cable?).  Everything wa=
s fine,=20
> even if restoring was slower than expected.  However, I encountered two=
 files=20
> with permission problems, namely:
>=20
> - /bin/ping, which caused running ping as a normal user to fail due to =
missing=20
> permissions, and
>=20
> - /sbin/unix_chkpwd (part of PAM), which prevented me from unlocking th=
e KDE=20
> Plasma lock screen; I needed to log into a TTY and run "loginctl unlock=
-
> session".
>=20
> Both were easily fixed by reinstalling the affected packages (iputils a=
nd=20
> pam), but I wonder why this happened after restoring from backup.
>=20
> I originally thought it was related to the SUID bit not being set, beca=
use of=20
> the explanation in the ping(8) man page (section "SECURITY"), but canno=
t find=20
> evidence of that -- that is, after reinstallation, "ls -lh" does not sh=
ow the=20
> sticky bit being set, or any other special permission bits, for that ma=
tter:
>=20
> % ls -lh /bin/ping /sbin/unix_chkpwd=20
> -rwx--x--x 1 root root 60K 22. Jul 14:47 /bin/ping*                    =
                                                                         =
                                                                         =
                                                     =20
> -rwx--x--x 1 root root 31K 23. Jul 00:21 /sbin/unix_chkpwd*
>=20
> (Note: no ACLs are set, either.)
>=20

What "getcap /bin/ping" says? You may need to install package providing
getcap (libcap-progs here on openSUSE).

> I do remember the qcheck program (a Gentoo-specific program that checks=
 the=20
> integrity of installed packages) complaining about wrong file permissio=
ns, but=20
> I didn't save its output, and there's a chance it *might* have been bec=
ause I=20
> ran qcheck without root permissions :-/ .
>=20
> I vaguely remember some patches and/or discussion regarding permission =

> transfer issues with send/receive on this ML, but didn't find anything =
after=20
> searching through my Email archive, so I might be misremembering.
>=20
> Does anybody have any idea what possibly went wrong, or any similar exp=
erience=20
> to speak of?
>=20
> Greetings
>=20



--YtHsN06XqY37zjjwh4AwHYlop7f1EkB65--

--0ACfyYdsEGQYQ4u9ohMCVrUQc1MIm61XI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAltXZ5UACgkQR6LMutpd94wVMgCfSUH1v8Z4fIgGLTvBzeAWyTtQ
QVMAmweHfay/DG02m/z9kqBg2g3gMTjd
=cSu3
-----END PGP SIGNATURE-----

--0ACfyYdsEGQYQ4u9ohMCVrUQc1MIm61XI--
