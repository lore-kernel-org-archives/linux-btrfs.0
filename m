Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752585AbcLCSkl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Dec 2016 13:40:41 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LzoSt-1chRSu13Wl-0154EO for
 <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 19:40:39 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: system hangs due to qgroups
Date: Sat, 03 Dec 2016 19:40:37 +0100
Message-ID: <1776088.42rHLKPlSp@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2521038.i4JNgvaHUW"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2521038.i4JNgvaHUW
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello all,

I'm having some trouble with btrfs on a laptop, possibly due to qgroups=
. =20
Specifically, some file system activities (e.g., snapshot creation,=20
baloo_file_extractor from KDE Plasma) cause the system to hang for up t=
o about=20
40 minutes, maybe more.  It always causes (most of) my desktop to hang,=
=20
(although I can usually navigate between pre-existing Konsole tabs) and=
=20
prevents new programs from starting.  I've seen the system load go up t=
o >30=20
before the laptop suddenly resumes normal operation.  I've been seeing =
this=20
since Linux 4.7, maybe already 4.6.

Now, I thought that maybe this was (indirectly) due to an overly full f=
ile=20
system (~90% full), so I deleted some things I didn't need to get it up=
 to 15%=20
free.  (For the record, I also tried mounting with ssd_spread.)  After =
that, I=20
ran a balance with -dusage=3D50, which started out promising, but then =
went back=20
to the "bad" behaviour.  *But* it seemed better than before overall, so=
 I=20
started a balance with -musage=3D10, then -musage=3D50.  That turned ou=
t to be a=20
mistake.  Since I had to transport the laptop, and couldn't wait for "b=
alance=20
cancel" to return (IIUC it only returns after the next block (group?) i=
s=20
freed), I forced the laptop off.

After I next turned on the laptop, the balance resumed, causing bootup =
to=20
fail, after which I remembered about the skip_balance mount option, whi=
ch I=20
tried in a rescue shell from an initramfs.  But wait, that failed, too!=
 =20
Specifically, the stack trace I get whenever I try it includes as one o=
f the=20
last lines:

"RIP [<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x2a8"=


(I can take photos of the full stack trace if requested.)

So then I ran "btrfs qgroup show /sysroot/", which showed many quota gr=
oups,=20
much to my surprise.  On the upside, at least now I discovered the like=
ly=20
reason for the performance problems.

(I actually think I know why I'm seeing qgroups: at one point I was try=
ing out=20
various snapshot/backup tools for btrfs, and one (I forgot which)=20
unconditionally activated quota support, which infuriated me, but I pro=
mptly=20
deactivated it, or so I thought.  Is quota support automatically enable=
d when=20
qgroups are discovered, or did I perhaps not disable quota support prop=
erly?)

Since I couldn't use skip_balance, and logically can't destroy qgroups =
on a=20
read-only file system, I decided to wait for a regular mount to finish.=
  That=20
has been running since Tuesday, and I am slowly growing impatient.

Thus I arrive at my question(s): is there anything else I can try, shor=
t of=20
reformatting and restoring from backup?  Can I use btrfs-check here, or=
 any=20
other tool?  Or...?

Also, should I be able to avoid reformatting: how do I properly disable=
 quota=20
support?

(BTW, searching for qgroup_fix_relocated_data_extents turned up the ML =
thread=20
"[PATCH] Btrfs: fix endless loop in balancing block groups", could that=
 be=20
related?)

The laptop is currently running Gentoo with Linux 4.8.10 and btrfs-prog=
s=20
4.8.4.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart2521038.i4JNgvaHUW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYQxGmAAoJEL/Q5oYsiHj0YSsP/1YHFWSvfC2E/AWZhjPujkj9
ZgiEZ2USfd6VP/gk0hyqINQxiy4C3eIVqAy0wh9FJKssw8lM4/aOyT9+sf6VUu3v
BGbpqCevCS56SBZbw+/iNSqrEHtIB/p5UXzEX3XjMuonGTAhbXcOWp0rCETdZtD7
IjsQMs94h2DIfQF1BJXjZu0liIg+jpoGrIlHU+jyk/r2x0Ytn5ASUhIq982k2GP3
JFVv98Dm1vKAL5UPbbo47Xv+1vC8CuHzjaVzm3rSI9ej4P7OpAEVzW9yrHHOPPSH
7KE2apm6g1vJQ5AXizOfwxWqg1F1f6pl2H0zo8kkQkwdxUbbgKhY0Qu9wkvUgmiC
SbcyJpIytQXuy+w6X+g//wp88Yo9hYpgGzE8X60htomr8XbPt6eEJVF+Sk8gV/6h
S8yhxGtkxMuORO87T4pYGSTNilwO5C7peB0yHge5MGI/NT17R1rHVQPkEAe95Omb
7Fe+vaMpL2eeJJas3w3i5VYr/VAPunCgWyfjB8rJCGjF2E2bxhEJ2h/ZDcgLlrer
Rx8g6eRVBcittrlLXHR5PodVBncjmak8xtoGMPUYPqhOjV9rEVhnE6k2m5/+nx45
pnFy2PYtTDJByO9YZEzVrf3iwJahfkre9BYJfVj5mRNwMiAp5PPPV2PEpJSVWJtM
uqqLLGN7o7rXJpEIr4KD
=GFMr
-----END PGP SIGNATURE-----

--nextPart2521038.i4JNgvaHUW--

