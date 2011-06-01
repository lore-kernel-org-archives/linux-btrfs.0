From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs error after using kernel 3.0-rc1
Date: Wed, 01 Jun 2011 17:48:37 -0400
Message-ID: <1306964572-sup-4244@shiny>
References: <BANLkTimGPgn9CERxCNQPqJLTiRkFUc03OA@mail.gmail.com> <BANLkTinP-Rit3tc2HRDx4d2WArkxqUBuug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTinP-Rit3tc2HRDx4d2WArkxqUBuug@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Fajar A. Nugraha's message of 2011-06-01 08:22:40 -0400:
> On Wed, Jun 1, 2011 at 6:06 AM, Fajar A. Nugraha <list@fajar.net> wro=
te:
> > While using btrfs as root on kernel 3.0-rc1, there was some errors =
(I
> > wasn't able to capture the error) that forced me to do hard reset.
> >
> > Now during startup system drops to busybox shell because it's unabl=
e
> > to mount root partition.
> > Is there a way to recover the data, as at least grub2 was still hap=
py
> > enough to load kernel and initrd (both of which located on the same
> > btrfs partition)?
> >
> > This is what dmesg says
> >
> > [ =C2=A0 =C2=A04.536798] device label SSD-ROOT devid 1 transid 3824=
5 /dev/sda2
> > [ =C2=A0 =C2=A09.552086] device label SSD-ROOT devid 1 transid 3824=
5
> > /dev/disk/by-label/SSD-ROOT
> > [ =C2=A0 =C2=A09.554563] btrfs: disk space caching is enabled
> > [ =C2=A0 =C2=A09.564301] parent transid verify failed on 44040192 w=
anted 38240 found 32526
> > [ =C2=A0 =C2=A09.564535] parent transid verify failed on 44040192 w=
anted 38240 found 32526
> > [ =C2=A0 =C2=A09.564778] parent transid verify failed on 44040192 w=
anted 38240 found 32526
> > [ =C2=A0 =C2=A09.575679] parent transid verify failed on 44052480 w=
anted 38240 found 31547
> > [ =C2=A0 =C2=A09.575904] parent transid verify failed on 44052480 w=
anted 38240 found 31547
> > [ =C2=A0 =C2=A09.576176] parent transid verify failed on 44052480 w=
anted 38240 found 31547
> > [ =C2=A0 =C2=A09.586121] parent transid verify failed on 44064768 w=
anted 38240 found 34145
> > [ =C2=A0 =C2=A09.586319] parent transid verify failed on 44064768 w=
anted 38240 found 34145
> > [ =C2=A0 =C2=A09.586515] parent transid verify failed on 44064768 w=
anted 38240 found 34145
> > [ =C2=A0 =C2=A09.587027] parent transid verify failed on 44068864 w=
anted 38240 found 34476
> > [ =C2=A0 =C2=A09.589732] Btrfs detected SSD devices, enabling SSD m=
ode
> > [ =C2=A0 =C2=A09.592923] block group 29360128 has an wrong amount o=
f free space
> > [ =C2=A0 =C2=A09.592959] btrfs: failed to load free space cache for=
 block group 29360128
>=20
>=20
> For anyone who got the same problem,
>=20
> I was finally able to mount the fs using Ubuntu Natty's
> 2.6.38-8-generic (the one on live CD).
> Previously I tried using 2.6.38-9-generic and and 3.0-rc1, none works=
=2E
> Now I'm copying the files somewhere else before reinstalling this
> system.

The tools have a command to zero out the btrfs log tree, that would hav=
e
allowed you to mount.  Do you still have the busted FS?

Thanks a lot for this bug report, I'll try to reproduce it.

>=20
> On another note, does anybody know how btrfs allocates ID for subvols=
?
> It doesn't seem to reuse deleted subvol's ID. What happens when the
> last subvol ID is 999?
>=20

We don't reuse the ids for subvols or snapshots, but we can have a
little less than 2^64 of them.  An id can be reused as long as there ar=
e
no blocks with refs for it in the extent allocation tree, but that need=
s
to be checked before we reuse it.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
