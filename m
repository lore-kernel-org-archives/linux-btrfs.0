Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:35179 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388812AbeGXVub (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 17:50:31 -0400
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LanoO-1gS9Ro1ymW-00kMvx for
 <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2018 22:42:16 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: File permissions lost during send/receive?
Date: Tue, 24 Jul 2018 22:42:06 +0200
Message-ID: <1611860.S2UmG8tJGO@thetick>
In-Reply-To: <pan$d56e4$375bb872$1bdbd77f$1569f8ce@cox.net>
References: <8202618.Xtt70Sb46P@thetick> <47372f67-70fd-8b11-0573-39d1137356e3@gmail.com> <pan$d56e4$375bb872$1bdbd77f$1569f8ce@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4421828.BPOonBvoQD"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4421828.BPOonBvoQD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Dienstag, 24. Juli 2018, 21:46:14 CEST schrieb Duncan:
> Andrei Borzenkov posted on Tue, 24 Jul 2018 20:53:15 +0300 as excerpted:
> > 24.07.2018 15:16, Marc Joliet =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >> Hi list,
> >>=20
> >> (Preemptive note: this was with btrfs-progs 4.15.1, I have since
> >> upgraded to 4.17.  My kernel version is 4.14.52-gentoo.)
> >>=20
> >> I recently had to restore the root FS of my desktop from backup (extent
> >> tree corruption; not sure how, possibly a loose SATA cable?).
> >> Everything was fine,
> >> even if restoring was slower than expected.  However, I encountered two
> >> files with permission problems, namely:
> >>=20
> >> - /bin/ping, which caused running ping as a normal user to fail due to
> >> missing permissions, and
> >>=20
> >> - /sbin/unix_chkpwd (part of PAM), which prevented me from unlocking
> >> the KDE Plasma lock screen; I needed to log into a TTY and run
> >> "loginctl unlock- session".
> >>=20
> >> Both were easily fixed by reinstalling the affected packages (iputils
> >> and pam), but I wonder why this happened after restoring from backup.
> >>=20
> >> I originally thought it was related to the SUID bit not being set,
> >> because of the explanation in the ping(8) man page (section
> >> "SECURITY"), but cannot find evidence of that -- that is, after
> >> reinstallation, "ls -lh" does not show the sticky bit being set, or any
> >> other special permission bits, for that matter:
> >>=20
> >> % ls -lh /bin/ping /sbin/unix_chkpwd
> >> -rwx--x--x 1 root root 60K 22. Jul 14:47 /bin/ping*
> >> -rwx--x--x 1 root root 31K 23. Jul 00:21 /sbin/unix_chkpwd*
> >>=20
> >> (Note: no ACLs are set, either.)
> >=20
> > What "getcap /bin/ping" says? You may need to install package providing
> > getcap (libcap-progs here on openSUSE).
>=20
> sys-libs/libcap on gentoo.  Here's what I get:
>=20
> $ getcap /bin/ping
> /bin/ping =3D cap_net_raw+ep

On my system I get:

% sudo getcap /bin/ping /sbin/unix_chkpwd=20
/bin/ping =3D cap_net_raw+ep
/sbin/unix_chkpwd =3D cap_dac_override+ep

> (getcap on unix_chkpwd returns nothing, but while I use kde/plasma I
> don't normally use the lockscreen at all, so for all I know that's broken
> here too.)
>=20
> As hinted, it's almost certainly a problem with filecaps.  While I'll
> freely admit to not fully understanding how file-caps work, and my use-
> case doesn't use send/receive, I do recall filecaps are what ping uses
> these days instead of SUID/SGID (on gentoo it'd be iputils' filecaps and
> possibly caps USE flags controlling this for ping), and also that btrfs
> send/receive did have a recent bugfix related to the extended-attributes
> normally used to record filecaps, so the symptoms match the bug and
> that's probably what you were seeing.

Ah, thanks, that looks like it was it!  I didn't think about extended=20
attributes, but including "xattr" in my search yielded the following patche=
s=20
from April this year (this turns out to be that vaguely remembered patch/
discussion that I mentioned):

[PATCH] btrfs: add chattr support for send/receive
[PATCH] btrfs: add verify chattr support for send/receive test

However, IIUC those changes are going to be merged along with other changes=
=20
into a v2 of the send protocoll, so until that gets finalized this is=20
something to be aware of for those like me that use send/receive for backup=
s.

Anyway, thanks for pointing me in the right direction!  At least now I=20
understand what happened.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart4421828.BPOonBvoQD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAltXjx4ACgkQv9DmhiyI
ePTOpg/8DGIFIvPvDd47W7JxPSZBDzONeUVq9mApSex958ZDAiItVnBtbP9uFhT9
M6ZazTXhrUBG2fOLAO/hDnNmJ1rB0QMJ2QaHfx0JOQhB63ymZxawHuEi93UCQhMP
XBJcTDQ1uRK5xZt69TKObMGX4JfYyWZ/CbczPHgHyjn6+l5X7o80YMOAbo5g9IVH
4h1GpY/Av0aw3rhSLNfMwHflegQ297CL0ZsKRraZUtMyQCxokT+W7IZKpZW2Biy1
T0U36iHM1ytvWXk6ReqKGaeDy3FjiOO8OmQnhQA6PeGU5/YiMQffp1Zq3/e0EA/c
Hf+WQL6V+U1z3EJjH7mENLYKq0kUINHbuU6uv+2myr/ak+a08gGwE7/BDkvz6JvX
G40ECQd+8npUVAaB1n45n15XsOBnCNMV642CXBV3Vum4CaATgo60X+Bucn3l8qdd
ZIcfEFiUlQYgSXmVvDfdGdxenTxwHXgwun8bsvTj7S4byzfcueVPygrghUeoQZEH
4/2chkDdZnqHcUriMfbj/OTskxpbFggxmc0IFKhh4enYHbvJ9W3eWEzt01/t6SNy
opNHZ8Rwj9XmvfqhTE83tQTX/sE6clbh0poyPShnMdUndrjRY7JismSP+wI1Dnbp
MyMNFYxzwhmMZqVvsqjQ7P9XVN3V5mBBc5gfhByTyr61YlCeBws=
=givP
-----END PGP SIGNATURE-----

--nextPart4421828.BPOonBvoQD--



