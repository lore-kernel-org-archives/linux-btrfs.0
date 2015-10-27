Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:53823 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbbJ0JTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 05:19:39 -0400
Received: from thetick.localnet ([93.181.44.4]) by smtp.web.de (mrweb101) with
 ESMTPSA (Nemesis) id 0LvBV8-1aYYe32RhS-010Myl for
 <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 10:19:37 +0100
From: Marc Joliet <marcec@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: random i/o error without error in dmesg
Date: Tue, 27 Oct 2015 10:19:25 +0100
Message-ID: <2322903.OV4byPN1Sl@thetick>
In-Reply-To: <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick> <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11039667.CLOt1kI8zo"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart11039667.CLOt1kI8zo
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday 27 October 2015 06:23:06 Duncan wrote:
>Marc Joliet posted on Mon, 26 Oct 2015 15:23:39 +0100 as excerpted:
>> Occasionally they go away by themselves, but usually I have to reboo=
t to
>> make them go away.  This happens when getmail attempts to fetch mail=
,
>> which fails due to the above error.  After the reboot getmail succee=
ds
>> again.
>
>Just out of curiosity, does a remount,ro, followed by a remount,rw, so=
lve
>the problem?
>
>The ro/rw cycle should force anything in memory to device, so if that
>eliminates the problem, it could well be some sort of sync issue.  If =
it
>doesn't, then it's more likely an in-memory filesystem state issue,
>that's cleared by the reboot.
>
>And if the ro/rw cycle doesn't clear the problem, what about a full
>unmount/mount cycle, at least of that subvolume?
>
>If you're running multiple subvolumes with root being one of them, you=

>can't of course unmount the entire filesystem, but you could go down t=
o
>emergency mode (systemctl emergency), try unmounting everything but /,=

>mounting / ro, and then switching back to normal mode (from emergency
>mode, simply exiting should return you to normal multi-user or gui
>target, remounting filesystems as necessary, etc).
>
>IOW, does it take a full reboot to clear the problem, or is a simple r=
o/rw
>mount cycle enough, or an unmount/remount?
>
>Finally, assuming root itself isn't btrfs, if you have btrfs configure=
d
>as a module, you could try unmounting all btrfs and then unloading the=

>module, then reloading and remounting.  That should entirely clear all=
 in-
>memory btrfs state, so if that doesn't solve the problem, while reboot=
ing
>does, then the problem's very possibly outside of btrfs scope.  Of cou=
rse
>if root is btrfs, you can't really check that.

Thanks for the hints.  I just upgraded to gentoo-sources 4.1.11 and wil=
l see=20
if that changes anything.  If not, I'll have to try unmounting /home fr=
om=20
emergency mode (it's a subvolume mount).

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart11039667.CLOt1kI8zo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWL0GoAAoJEL/Q5oYsiHj0ki4P/2mrl3u/wrQs8+BwiTrUJysQ
eYwy/dJO06auqqOdNmH0yZ1wCEWw8caaLcmidRuiOvcRaDtNdr4srh3JOsjXrvAL
6qVds6314GrSUlfQ8M1ujg8dy/ln79zklQehmrRt1Tef3VBhk/H7jYLl8NbvFUQT
hMpJ66S5HwYNzQ4dhSsJeX6ashrrY7UJbyZlbBvBPUucm0wBMs3bD6IFLgm5vmy/
EhsszQazM2nkScO+nyTjUso0RVbPnjDp0+Cg9LYn3JRIwMSjtpO989Qltp3e7Wpi
ZxqBEcQjtXHVcXcPnqP+fM80VX8rk9jzcZbDR71tr23rOH3E2CGyaxMd9/k1pp1K
LsKPak8VoR59FtbSRYxmUOG2Sk33L4OjoRIMNeyiohDt1Aays8d8A+XHEtPVbWMv
R80I1c+EwzYCBcioZr1DNlqrimtwnhZuTlISQ0mgUItHgkzYHPpauSvEa5i4/Ibm
1zlSoJWQ9t68/W2jVhUmVlh94BzjP7rQiFDeNJi5+y1IS+fhC2sne8Vq9RZOjRIc
GXCr2WrOj7hbCrlcNXxlnZE100NfTqIaOxspQp78lmYbLC+QZOWJujtc3iAgg+Xe
yNrT1zro5JlDsS7BWF57sOp6AgZMlRklxCGGq3AeXvzDoHPQGBb1zbOvVum0Hv6v
MSYpqZFkXR4lljCuWB1/
=8WJL
-----END PGP SIGNATURE-----

--nextPart11039667.CLOt1kI8zo--

