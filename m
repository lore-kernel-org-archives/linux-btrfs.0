From: devzero@web.de
Subject: Re: weird bash autocomplete issue
Date: Fri, 19 Dec 2008 10:15:57 +0100
Message-ID: <548803024@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Sure, would be good to have that fixed. Cc: kasievers@novell.com in
> the bug, and I will move it directly to the right guy. :)

ok, just submitted.

https://bugzilla.novell.com/show_bug.cgi?id=3D460560


regards
roland


> -----Urspr=FCngliche Nachricht-----
> Von: "Kay Sievers" <kay.sievers@vrfy.org>
> Gesendet: 19.12.08 02:27:34
> An: devzero@web.de
> CC: "Chris Mason" <chris.mason@oracle.com>,  "linux-btrfs@vger.kernel=
=2Eorg" <linux-btrfs@vger.kernel.org>
> Betreff: Re: weird bash autocomplete issue


> On Fri, Dec 19, 2008 at 01:59,  <devzero@web.de> wrote:
> >> I see the same issue on x86 32 bit, with the additional __llseek()
> >> between the getdents64(), and the last entry returned by readdir
> >> ignored.
> >
> > confirmed - it`s readdir which assumes 32bit.
> >
> > attached is a sample program which shows the issue on my system.
> >
> > if compiled with -D_FILE_OFFSET_BITS=3D64", the problem goes away.
> >
> > old posting from around 2001:
> >
> >>http://sourceware.org/ml/libc-alpha/2001-01/msg00216.html
> >>
> >>This is why everybody will have to compile programs with
> >>_FILE_OFFSET_BITS=3D64.  Did you ever notice that all GNU programs
> >>already do this?
> >
> > as 32bit systems can use 64bit filesystems, i think btrfs is correc=
t and bash is wrong,
> > as it isn`t LFS aware. i think all 32bit stuff should be LFS aware,=
 nowadays.
> >
> > to be exact, it`s not bash but readline library which comes with ba=
sh.
> > bash configure script correctly checks for _FILE_OFFSET_BITS value,=
 but readline configure script doesn`t.
> > this explains why i could not reproduce the issue when i build bash=
 without readline support.
> >
> > does it make sense to file a ticket at novell bugzilla ?
>=20
> Sure, would be good to have that fixed. Cc: kasievers@novell.com in
> the bug, and I will move it directly to the right guy. :)
>=20
> Thanks,
> Kay
>=20


_______________________________________________________________________
Sensationsangebot verl=E4ngert: WEB.DE FreeDSL - Telefonanschluss + DSL
f=FCr nur 16,37 Euro/mtl.!* http://dsl.web.de/?ac=3DOM.AD.AD008K15039B7=
069a

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
