Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63544 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbcLCVyC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Dec 2016 16:54:02 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MMk99-1cK8ZU0YIx-008XRn for
 <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 22:46:47 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Date: Sat, 03 Dec 2016 22:46:40 +0100
Message-ID: <4615776.dvopQOigxY@thetick>
In-Reply-To: <CAJCQCtRxhjKAcZy7wuXCFM1=70eG+TJPwEoyD7zq0iEw8f2urQ@mail.gmail.com>
References: <1776088.42rHLKPlSp@thetick> <CAJCQCtRxhjKAcZy7wuXCFM1=70eG+TJPwEoyD7zq0iEw8f2urQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3062194.ZPpYAWVuar"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3062194.ZPpYAWVuar
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Saturday 03 December 2016 13:42:42 Chris Murphy wrote:
> On Sat, Dec 3, 2016 at 11:40 AM, Marc Joliet <marcec@gmx.de> wrote:
> > Hello all,
> >=20
> > I'm having some trouble with btrfs on a laptop, possibly due to qgr=
oups.
> > Specifically, some file system activities (e.g., snapshot creation,=

> > baloo_file_extractor from KDE Plasma) cause the system to hang for =
up to
> > about 40 minutes, maybe more.
>=20
> Do you get any blocked tasks kernel messages? If so, issue sysrq+w
> during the hang, and then check the system log (dmesg may not contain=

> everything if the command fills the message buffer). If it's a hang
> without any kernel messages, then issue sysrq+t.
>=20
> https://www.kernel.org/doc/Documentation/sysrq.txt

As it's a rescue shell, I have only the one shell AFAIK, and it's occup=
ied by=20
mount.  So I can't tell if there are dmesg entries, however, when this =
happens=20
during a normal running system, I never saw any dmesg entries.  Anyway,=
 I ran=20
both.

The output of sysrq+w mentions two tasks: "btrfs-transaction" with=20
btrfs_scrub_pause+0xbe/0xd0 as the top-most entry in the call trace, an=
d=20
"mount" with its top-most entry at schedule+0x33/0x90 (it looks like it=
's=20
still in the "early" processing, since there's also=20
"btrfs_parse_early_options+0190/0x190" in the call trace).

The output of sysrq+t is too big to capture all of it (i.e., I can't sc=
roll=20
back to the beginning), but just looking at the task names that I *can*=
 see,=20
there are: btrfs-fixup, various btrfs-endio*, btrfs-rmw, btrfs-freespac=
e,=20
btrfs-delayed-m (cut off), btrfs-readahead, btrfs-qgroup-re (cut off), =
btrfs-
extent-re (cut off), btrfs-cleaner, and btrfs-transaction.  Oh, and a b=
unch of=20
kworkers.

Should I take photos?  That'll be annoying to do with all the scrolling=
, but I=20
can do that if need be.

> > After I next turned on the laptop, the balance resumed, causing boo=
tup to
> > fail, after which I remembered about the skip_balance mount option,=
 which
> > I
> > tried in a rescue shell from an initramfs.
>=20
> The file system is the root filesystem? If so, skip_balance may not b=
e
> happening soon enough. Use kernel parameter rootflags=3Dskip_balance
> which will apply this mount option at the very first moment the file
> system is mounted during boot.

Yes, it's the root file system (there's that plus a swap partition).  I=
=20
believe I tried rootflags, but I think it also failed, which is why I'm=
 using=20
a rescue shell now.  I can try it again, though, if anybody thinks that=
=20
there's no point in waiting, especially if btrfs_scrub_pause in the btr=
fs-
transaction call trace is significant.

> > Since I couldn't use skip_balance, and logically can't destroy qgro=
ups on
> > a
> > read-only file system, I decided to wait for a regular mount to fin=
ish.=20
> > That has been running since Tuesday, and I am slowly growing impati=
ent.
> Haha, no kidding! I think that's very patient.

Heh :) . I've still got my main desktop (as ancient as it may be), so I=
'm=20
content with waiting for now, but I don't want to wait forever, especia=
lly if=20
there might not even be a point.

> > Thus I arrive at my question(s): is there anything else I can try, =
short
> > of
> > reformatting and restoring from backup?  Can I use btrfs-check here=
, or
> > any
> > other tool?  Or...?
>=20
> Yes, btrfs-progs 4.8.5 has the latest qgroup checks, so if there's
> something wrong it should find it and if not that's a bug of its own.=


The initramfs has 4.8.4, but it looks like 4.8.5 was "only" an urgent b=
ug fix,=20
with no changes to qgroups handling, so I can use that, too.  Can it re=
pair=20
qgroups problems, too?

> > Also, should I be able to avoid reformatting: how do I properly dis=
able
> > quota support?
>=20
> 'btrfs quota disable' is the only command that applies to this and it=

> requires rw mount; there's no 'noquota' mount option.

OK, thanks.

So what should I try next?  I'm sick at home, so I can spend more time =
on this=20
than usual.

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart3062194.ZPpYAWVuar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYQz1BAAoJEL/Q5oYsiHj03GkP+gOQoJef6Z/nUAQCPttn6Ncu
DXKe/4X6x6MhCE2AVqc2VJ+xbkppnyUfqeDwu2xchyKhaohEUPHhxqhqDEb6V1b/
GwVDGQoc/QqPS88jJpPo9bRKQXGrATzQkwxQ+YXKDiQC5LaWNFC2EHMR53pv/AKm
T9vdBIQEri2Avb6lWlb5Xsn4z6O2u5C+dQWNRZHHFQ9btRziHvkdV+R5SWUPL/b8
90cqxCFKz7SP9r1mLA8Rt/8aybfyjTcD5jAMBLgI2KvhmzLl4Izpx9Mr4luhodMM
zWG/yxY1L10njQcEWKjIyTtsAg8G3A5Rr5y8r13ekEW/r8QGBtjSU0seGJ7luatP
h62i0xU5y4xOO0f0WTgLR6BL8UQHkPLi8rLuqfGzttJnVlqQJfQXJyfjc5Lfp/C8
M7AJxp6rrcxIqWgGM1ZiP8dlgC/ZuABJybfaq8HLh9+zgN7QP/iaXwmFmZp1uA2m
+rfNRJI78ivtwp/VI/6osbkoMEDBoQPPYuTnvQc+aAr6UGKNXkMXzQ9rJh98ZULj
HpwHTMgWH7vO50mmGwyYWN0/ybwrJXwOYnWORMcCmWDcsqFo12MAeNkTLZUXUoFI
MnTzdaArRdkBYJRGtSOp3NlDqDDlaRu3WV+bqgw6CNZV3fv6KzaDb422owrdnsUT
2TnyCB0JU+DWnYWhiM+v
=yaae
-----END PGP SIGNATURE-----

--nextPart3062194.ZPpYAWVuar--

