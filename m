Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49781 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750867AbcLDTVB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Dec 2016 14:21:01 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MYOCL-1c9PMu2cOP-00VBH4 for
 <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 20:20:57 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Date: Sun, 04 Dec 2016 20:20:51 +0100
Message-ID: <5831203.ygVuIMpfzH@thetick>
In-Reply-To: <pan$69035$81ae24e2$d7110ac$22963947@cox.net>
References: <1776088.42rHLKPlSp@thetick> <3405186.JXS0fWUK5s@thetick> <pan$69035$81ae24e2$d7110ac$22963947@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2626642.ofJKjVAHtj"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2626642.ofJKjVAHtj
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Sunday 04 December 2016 18:24:08 Duncan wrote:
> Marc Joliet posted on Sun, 04 Dec 2016 17:02:48 +0100 as excerpted:
> > That's a good idea, although I'll probably start with sysrescuecd (=
Linux
> > 4.8.5 and btrfs-progs 4.7.3), as I already have experience with it.=

> >=20
> > [After trying it]
> >=20
> > Well, crap, I was able to get images of the file system (one saniti=
zed),
> > but mounting always fails with "device or resource busy" (with no
> > corresponding dmesg output).  (Also, that drive's partitions weren'=
t
> > discovered on bootup, I had to run partprobe first.)  I never see t=
hat
> > in the initramfs, so I'm not sure what's causing that.
>=20
> If I understand correctly what you're doing, that part is easily enou=
gh
> explained.
>=20
> Remember that btrfs, unlike most filesystems, is multi-device capable=
.
> The way it tracks which devices belong to which filesystems is by UUI=
D,
> universally *UNIQUE* ID.  If you image a device via dd or similar, yo=
u of
> course image its UUID as well, destroying the "unique" assumption in =
UUID
> and confusing btrfs, which will consider it part of the existing
> filesystem if the original devices with that filesystem UUID remain
> hooked up.
>=20
> So if you did what I believe you did, try to mount the image while th=
e
> original filesystem devices remain attached and mounted, btrfs is sim=
ply
> saying that filesystem (which btrfs identifies by UUID) is already
> mounted: "device or resource busy".
[...]

Nope, sorry if I wasn't clear, I didn't mean that I tried to mount the =
image=20
(can you even mount images created with btrfs-image?).  Plus the images=
 are=20
xz-compressed.

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart2626642.ofJKjVAHtj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRGyTAAoJEL/Q5oYsiHj0FxsP/jQ8RHbdD2ytznY4gleOtLcF
B+AIA+SmtDjJQ6HDxeMFJBaaJEgtyJx3r1vtxxcS0u5EcNM4TukqU5sgHjssmG9X
P3vT6mJsyV/QWkaV48UC14UTDW0mvMN5Mi6aZjAGyRXXymVmyO8yhqfGD9oWnEJY
wEmy1Mb/JbqFHtjKnnDMZF+MjF2Jh9HVm940G+gTsyY1oESnw0R0NcKyhIJ5NVFl
+6MgLGIoXGZc5XRRbFLTt4bLRGDmADMHZfNM/9hHJ/zlk+CKF79RWCCkgdvw148v
ygClvW4nJn5dkFpFTZcKeDXEqvWdjM7fREDxrrw+5kTowXOzkmQJty7iwCZULome
lY515ANJw4S2St5OdSS7N3AS0Je+/uzElUY0qrauR7agW84fDFFt+MdEBYWiIR68
eBnAWYkEt6DxYeXVCQr5m17qcRwlR6i5ScNJLkSCP5JoD2OxktQk083jrerrS4/Z
1ozzNYFwD0uJsW6P5oQp6mG9xIAjtw0FR8Rm8LLBMWxi9UVTzi4qtlGH5dzxvwRk
aDpYv37NksiODnmJOQrBQfg/3YeLhbLTaNtcNlhI5xx8di9j8OVZVuBkBs9yjAdi
9cHveK+/AuX7lDFB2bXo0CS5zPTEAZOkc2y38JOTMRAzBCG3oEgXWCP/GCBMw5qQ
Jrip1qVO/9fVBco/C6Z3
=+NPf
-----END PGP SIGNATURE-----

--nextPart2626642.ofJKjVAHtj--

