Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61850 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751168AbcLELBe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 06:01:34 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LaXEN-1cxOaa1AdT-00mKDG for
 <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 12:01:31 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Date: Mon, 05 Dec 2016 12:01:28 +0100
Message-ID: <29619565.vvZbx4DoIQ@thetick>
In-Reply-To: <5f35cc2d-4c3d-b14c-01f6-4bfb0f22823b@cn.fujitsu.com>
References: <1776088.42rHLKPlSp@thetick> <5f35cc2d-4c3d-b14c-01f6-4bfb0f22823b@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart15589648.UhDN21H6vx"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart15589648.UhDN21H6vx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Monday 05 December 2016 08:39:02 Qu Wenruo wrote:
> At 12/04/2016 02:40 AM, Marc Joliet wrote:
> > Hello all,
> >=20
> > I'm having some trouble with btrfs on a laptop, possibly due to qgr=
oups.
> > Specifically, some file system activities (e.g., snapshot creation,=

> > baloo_file_extractor from KDE Plasma) cause the system to hang for =
up to
> > about 40 minutes, maybe more.  It always causes (most of) my deskto=
p to
> > hang, (although I can usually navigate between pre-existing Konsole=
 tabs)
> > and prevents new programs from starting.  I've seen the system load=
 go up
> > to >30 before the laptop suddenly resumes normal operation.  I've b=
een
> > seeing this since Linux 4.7, maybe already 4.6.
>=20
> Qgroup is CPU intensive operation.
>=20
> The main problem is the design of btrfs extent tree, which bias towar=
ds
> snapshot creating speed, but quite complicated if used for tracing al=
l
> referencer (which qgroup heavily relies on it).
>=20
>=20
> The main factor affecting qgroup speed, is how many shared extents ar=
e
> in the fs.
> This including reflinked files and snapshot, under most case snapshot=
 is
> the main part.
>=20
> Unless we find a better solution, to keep both qgroup accurate and fa=
st,
> I'd recommend to keep qgroup under a reasonable number.
> (Personally speaking, 10 would be good)
>=20
> Despite the qgroup, relocation(balancing) should also be affected by =
the
> number of shared extents.

OK

> > Now, I thought that maybe this was (indirectly) due to an overly fu=
ll file
> > system (~90% full), so I deleted some things I didn't need to get i=
t up to
> > 15% free.  (For the record, I also tried mounting with ssd_spread.)=
=20
> > After that, I ran a balance with -dusage=3D50, which started out pr=
omising,
> > but then went back to the "bad" behaviour.  *But* it seemed better =
than
> > before overall, so I started a balance with -musage=3D10, then -mus=
age=3D50.=20
> > That turned out to be a mistake.  Since I had to transport the lapt=
op,
> > and couldn't wait for "balance cancel" to return (IIUC it only retu=
rns
> > after the next block (group?) is freed), I forced the laptop off.
> >=20
> > After I next turned on the laptop, the balance resumed, causing boo=
tup to
> > fail, after which I remembered about the skip_balance mount option,=
 which
> > I
> > tried in a rescue shell from an initramfs.  But wait, that failed, =
too!
> > Specifically, the stack trace I get whenever I try it includes as o=
ne of
> > the last lines:
> >=20
> > "RIP [<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x=
2a8"
>=20
> This seems to be a NULL pointer bug in qgroup relocation fix.
>=20
> The latest fix (not merged yet) should address it.
>=20
> You could try the for-next-20161125 branch from David to fix it:
> https://github.com/kdave/btrfs-devel/tree/for-next-20161125

OK, I'll try that, thanks!  I just have to wait for it to finish clonin=
g...

> > (I can take photos of the full stack trace if requested.)
> >=20
> > So then I ran "btrfs qgroup show /sysroot/", which showed many quot=
a
> > groups, much to my surprise.  On the upside, at least now I discove=
red
> > the likely reason for the performance problems.
>=20
> So, the number of qgroups is the cause for the slowness.

OK

> > (I actually think I know why I'm seeing qgroups: at one point I was=
 trying
> > out various snapshot/backup tools for btrfs, and one (I forgot whic=
h)
> > unconditionally activated quota support, which infuriated me, but I=

> > promptly deactivated it, or so I thought.  Is quota support automat=
ically
> > enabled when qgroups are discovered, or did I perhaps not disable q=
uota
> > support properly?)
> Qgroup will always be enabled after "btrfs quota enable", and until
> "btrfs quota disable" to disable it.
>=20
> No method to temporarily disable quota, since quota must trace any
> modification, or qgroup number will be out of true.
>=20
> So, one should manually disable quota.
> (And that's the backup tool to blame, it should either info user or
> disable qgroup on uninstallation)

Hmm, I must not be remembering the whole story then, because I was pret=
ty sure=20
that I ran "quota disable" and verified that quotas were off, too, but =
then=20
again, it's been quite a while now (a year?) since it happened.

> > Since I couldn't use skip_balance, and logically can't destroy qgro=
ups on
> > a
> > read-only file system, I decided to wait for a regular mount to fin=
ish.=20
> > That has been running since Tuesday, and I am slowly growing impati=
ent.
> >=20
> > Thus I arrive at my question(s): is there anything else I can try, =
short
> > of
> > reformatting and restoring from backup?  Can I use btrfs-check here=
, or
> > any
> > other tool?  Or...?
> >=20
> > Also, should I be able to avoid reformatting: how do I properly dis=
able
> > quota support?
>=20
> "btrfs quota disable <mnt>", yes you need RW mount.
> Any RW mountable snapshot/subvolume is OK.

OK

> > (BTW, searching for qgroup_fix_relocated_data_extents turned up the=
 ML
> > thread "[PATCH] Btrfs: fix endless loop in balancing block groups",=
 could
> > that be related?)
>=20
> Nope, the actual fixing patches are:
> [PATCH 1/4] btrfs: qgroup: Add comments explaining how btrfs qgroup w=
orks
> [PATCH 2/4] btrfs: qgroup: Rename functions to make it follow
> reserve,trace,account steps
> [PATCH 3/4] btrfs: Expoert and move leaf/subtree qgroup helpers to qg=
roup.c
> [PATCH 4/4] btrfs: qgroup: Fix qgroup data leaking by using subtree t=
racing
>=20
>=20
> The 4th patch is the real working one, but relies on previous 3 to ap=
ply.
>=20
> The regression is also caused by my patch:
> [PATCH v3.1 2/3] btrfs: relocation: Fix leaking qgroups numbers on da=
ta
> extents
>=20
> Sorry for the trouble.

No problem, I just wish I would've thought to check for qgroups before =
getting=20
into this mess.

Although I'm actually *relieved* that it's qgroups, because before that=
 I was=20
worried that I had finally hit a nigh-show-stopping bug.  I thought tha=
t I was=20
merely not seeing it on my other systems, but that it could happen at a=
ny=20
time.  Now I'm more confident in the stability of my systems again :) .=


> And for your recovery, I'd suggest to install an Archlinux into a USB=

> HDD or USB stick, and compile David's branch and install it into the =
USB
> HDD.
>=20
> Then use the USB storage as rescue tool to mount the fs, which should=
 do
> RW mount with or without skip_balance mount option.
> So you could disable quota then.

OK, I'll try that, thanks!

> Thanks,
> Qu
>=20
> > The laptop is currently running Gentoo with Linux 4.8.10 and btrfs-=
progs
> > 4.8.4.
> >=20
> > Greetings
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart15589648.UhDN21H6vx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRUkJAAoJEL/Q5oYsiHj0m4wP/jJqLVEpdP8mbW7X3Ptcyu6E
QMnBgxm9idIuBxZi0WsRWv3tfd5uVQheG4bVJncGTilzY6AYQNMPoxncr9xoPmpN
JS5MKmfrFp0sEKCxllFTWrab5vAfqsNzQ3co/9Fl1Lw9nPs5EcfwEhP4WGl9nQwY
K2IbN4pjIcjPq55l/hxb1ffHoJtPE/Q4LgozwhoOuXBnqSV/9KFoX3NoMqd/zLsu
Yc9ZlVd6GONRZiE2OjflMV6hQsfVwU+6tOcOqCv4Ano1T6R0HK+e/c5GWvKCuBpu
GcSCcq8S56oaQ5TyCJ183074fTx+f1I9hzILidWHYLznlbtp6PvF0MapJBaJRN/b
mrfJCYKTofjqUxwMovQr4UhhmD4RqeCCbsGu5spsoQopchncn0sA54XRrfFzmkYy
LIN5L+CoyPdyF4Cw39DODa1WsgOF7g2HiavKRYM4kNCZdNhu+Z07Q6T0kF+3JAbn
z91Fl2ojpvCQ3xibPKcyCnHZjAlMTraHa0iLNf7YOOBSemEd1oeuZ1N2hSdXvDJL
brPjfyDbA2hCFYbqKuT+H8VzkziwxQO4cUq6OMGxTWgHkZzlSgptW0uoiT3wkdlv
uvHAMDO5gGm6LvGc9ErgmP/6yYcgOabaEyGMu89ni9/Mlp4Cl0ikWYEaULqcafYG
PSEHyF6JrGP4TzPcyjDG
=RbVo
-----END PGP SIGNATURE-----

--nextPart15589648.UhDN21H6vx--

