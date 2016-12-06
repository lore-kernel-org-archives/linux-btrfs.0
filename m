Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55158 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbcLFKSy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Dec 2016 05:18:54 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M3zT0-1cVBQ32Rco-00rZw6 for
 <linux-btrfs@vger.kernel.org>; Tue, 06 Dec 2016 11:12:17 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [SOLVED] Re: system hangs due to qgroups
Date: Tue, 06 Dec 2016 11:12:12 +0100
Message-ID: <2186923.2Z4iRAdtdf@thetick>
In-Reply-To: <593ee12d-a353-d834-2390-a68aaf6377a8@cn.fujitsu.com>
References: <1776088.42rHLKPlSp@thetick> <4448819.RKs36le3Tk@thetick> <593ee12d-a353-d834-2390-a68aaf6377a8@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2174111.vBCS94C1lg"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2174111.vBCS94C1lg
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday 06 December 2016 08:29:48 Qu Wenruo wrote:
> At 12/05/2016 10:43 PM, Marc Joliet wrote:
> > On Monday 05 December 2016 12:01:28 Marc Joliet wrote:
> >>> This seems to be a NULL pointer bug in qgroup relocation fix.
> >>>=20
> >>>=20
> >>>=20
> >>> The latest fix (not merged yet) should address it.
> >>>=20
> >>>=20
> >>>=20
> >>> You could try the for-next-20161125 branch from David to fix it:
> >>> https://github.com/kdave/btrfs-devel/tree/for-next-20161125
> >>=20
> >> OK, I'll try that, thanks!  I just have to wait for it to finish
> >> cloning...
> >=20
> > [...]
> >=20
> >>> And for your recovery, I'd suggest to install an Archlinux into a=
 USB
> >>> HDD or USB stick, and compile David's branch and install it into =
the USB
> >>> HDD.
> >>>=20
> >>>=20
> >>>=20
> >>> Then use the USB storage as rescue tool to mount the fs, which sh=
ould do
> >>> RW mount with or without skip_balance mount option.
> >>> So you could disable quota then.
> >>=20
> >> OK, I'll try that, thanks!
> >=20
> > Excellent, thank you, that worked!  My laptop is working normally a=
gain.=20
> > I'll keep an eye on it, but so far two balance operations ran norma=
lly
> > (that is, they completed within a few minutes and without hanging t=
he
> > system).
> >=20
> > (Specifically, since I didn't find out how to get a different kerne=
l onto
> > the Arch USB stick, I simply installed the kernel on my desktop, th=
en did
> > everything from an initramfs emergency shell, then moved the SSD ba=
ck
> > into the laptop.)
> >=20
> > Thanks, everyone!
>=20
> Glad that helped.
>=20
> I just forgot that you're using gentoo, not archlinux, and kernel
> install script won't work for archlinux.
>=20
> Anyway, I'm glad that works for you.
>=20
> BTW, if you haven't yet disable quota, would you please give a report=
 on
> how many qgroup you have?

I have disabled quotas already (first thing I did after mounting).  How=
ever,=20
there were definitely 20-30, maybe more (enough for 2, maybe 3, console=
 pages=20
=2D- I don't know how many lines the initramfs rescue shell has, but base=
d on=20
that, you could estimate the number of qgroups).

> And how CPU is spinning for balancing with quota enabled?

All I can say is, based on past observations, that I would see a single=
=20
process (usually btrfs-transaction, but often a user-space process, suc=
h as=20
baloo_file_extractor) using a single CPU at 100% and blocking (almost)=20=

everything else, and either finish after a while if it was quick enough=
, or=20
there would be intermittent time frames where other processes weren't b=
locked. =20
With balancing the behaviour was the latter, only it was the btrfs proc=
ess=20
using 100% CPU.  Furthermore, metadata balances were worse than data ba=
lances.

> This would help us to evaluate how qgroup slows down the process if
> there are too many snapshots.

Again, sorry that I was so quick to disable quotas, but I was only will=
ing to=20
do so much debugging with this laptop.

> Thanks,
> Qu

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart2174111.vBCS94C1lg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRo78AAoJEL/Q5oYsiHj0FSkQAMscwYgqb6Idh0VRdyCoBq4K
7CfsW4QSp6iwcH/7av4+nTZ27oJqorMTUfSkd+pdW2MvdC+8PxNMK9tfPXiA0D69
L7Y8EqXYBkBTTHUyJfZfh9NDO7ovA4F0RnnCkOnyI7zVm5p5PxbWWA7vWTzFdHXX
wSyJ1gARClD9zgXavnNTUQYySV/JFHklzxMIzuB+gLPQBKhQ7Zwfsb/YApaz4d+Z
+N1QzwIvg7bPxo2Z/TucQL8/TZ2c9cDzQeRXvr59h6cv52KV1jO4ETaUDp4xlaDh
k4y8csxn89Ak/utYfIqxlhARdo3sIYVEVPpba9e0pFYcGL2mQOtXg4oCqMv5sWzJ
/VtY5VEWWK3t+Xt0v3ujj36INechnn9AbGzC3j6xJR2VtA5BCEiotVklWDq4oWGh
uL20vHCZLD7LXPK6CLw/h84BMGd38H3/Xyx7SUCeI4MrIJH/00iG2rFm54DBuub/
zWV6feT+Sa36q/Mdz5gmPdHtuapK6CzeQP1ce5hLGuSVMS/FiP/VGxCNu98ZuQ3O
qJABRXnXrD70AImEv+HLunl6wA30Cin84BTdq2f0NIpVAEpz0Mx299qKizuhsAYr
VpLnqDpaWZdOxJ7V7pSVNDfqeOjIu9L0Q3PRhVP1qQvQjTtEYEGVbJqojxkbmiKu
nP7+VYLVIf8rD0va8CFw
=4r5K
-----END PGP SIGNATURE-----

--nextPart2174111.vBCS94C1lg--

