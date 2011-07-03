From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: TRIM support
Date: Sun, 3 Jul 2011 14:20:45 +0200
Message-ID: <201107031420.45718.hka@qbs.com.pl>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com> <CAAeznTrfX9u9YXAz31cjsR=qxqrsnaPHLjZxqTaO4SDVBicF6A@mail.gmail.com> <CAAeznTpwk=Vu6g1xpQSR_By-=o6Sy2=B4cCG97Md4kHRibf6qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTpwk=Vu6g1xpQSR_By-=o6Sy2=B4cCG97Md4kHRibf6qQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 03 of July 2011 00:40:46 Leonidas Spyropoulos wrote:
> On Sat, Jul 2, 2011 at 11:39 PM, Leonidas Spyropoulos
>=20
> <artafinde@gmail.com> wrote:
> > On Sat, Jul 2, 2011 at 8:45 PM, Calvin Walton <calvin.walton@kepsti=
n.ca>=20
wrote:
> >> On Sat, 2011-07-02 at 19:08 +0100, Leonidas Spyropoulos wrote:
> >>> Hello,
> >>>=20
> >>> I just installed an archlinux with btrfs root partition and would=
 like
> >>> to set the correct mount properties
> >>> Following this:
> >>> https://wiki.archlinux.org/index.php/Solid_State_Drives
> >>> it says there that I should use the discard mount parameter to en=
able
> >>> TRIM.
> >>>=20
> >>> I would like to ask by using ssd mount parameter would TRIM be en=
abled?
> >>> The SSD is Intel 320 Series 120Gb
> >>=20
> >> No, the "ssd" mount parameter has nothing to do with TRIM.
> >>=20
> >> The "ssd" mount parameter adjusts a couple of tuning parameters wh=
ere
> >> the default setting is designed to improve performance on spinning=
 HDD,
> >> and instead tunes for the random-access ability of an SSD.
> >>=20
> >> The ssd option is automatically enabled if the kernel detects that=
 your
> >> drive is an SSD (you can check with 'cat /proc/mounts').
> >>=20
> >> The discard option is not currently automatically enabled; I think=
 there
> >> may have been some performance issues in certain cases with drives=
 that
> >> have slow trim implementations. But feel free to give it a try.
> >>=20
> >> --
> >> Calvin Walton <calvin.walton@kepstin.ca>
>=20
> On the same system when I try to compile the btrfs-tools I get an err=
or.
> Since on the wiki you mention only the packages for Fedora and Debian=
,
>=20
> Which are the requirements for the btrfs tools?
>=20
> PS: AUR package is broken as well.

the AUR package is OK, problem is that the sources don't compile with n=
ew gcc.

Download Hugo's integration branch
http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-2=
0110630
and apply my patch to it:
http://www.spinics.net/lists/linux-btrfs/msg10965.html
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
