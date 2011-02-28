From: Maria =?ISO-8859-1?Q?Wikstr=F6m?= <maria@ponstudios.se>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Mon, 28 Feb 2011 17:45:56 +0100
Message-ID: <1298911556.11118.8.camel@mainframe>
References: <1298857223-sup-5612@think>
	 <201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
	 <20110228161056.GA2769@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110228161056.GA2769@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

m=C3=A5n 2011-02-28 klockan 11:10 -0500 skrev Josef Bacik:
> On Mon, Feb 28, 2011 at 11:13:59AM +0100, Johannes Hirte wrote:
> > On Monday 28 February 2011 02:46:05 Chris Mason wrote:
> > > Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -0500=
:
> > > > Some clarification on my previous message...
> > > >=20
> > > > After looking at my ftrace log more closely, I can see where Bt=
rfs is
> > > > trying to release the allocated pages.  However, the calculatio=
n for
> > > > the number of dirty_pages is equal to 1 when "copied =3D=3D 0".
> > > >=20
> > > > So I'm seeing at least two problems:
> > > > (1)  It keeps looping when "copied =3D=3D 0".
> > > > (2)  One dirty page is not being released on every loop even th=
ough
> > > > "copied =3D=3D 0" (at least this problem keeps it from being an=
 infinite
> > > > loop by eventually exhausting reserveable space on the disk).
> > >=20
> > > Hi everyone,
> > >=20
> > > There are actually tow bugs here.  First the one that Mitch hit, =
and a
> > > second one that still results in bad file_write results with my
> > > debugging hunks (the first two hunks below) in place.
> > >=20
> > > My patch fixes Mitch's bug by checking for copied =3D=3D 0 after
> > > btrfs_copy_from_user and going the correct delalloc accounting.  =
This
> > > one looks solved, but you'll notice the patch is bigger.
> > >=20
> > > First, I add some random failures to btrfs_copy_from_user() by fa=
iling
> > > everyone once and a while.  This was much more reliable than tryi=
ng to
> > > use memory pressure than making copy_from_user fail.
> > >=20
> > > If copy_from_user fails and we partially update a page, we end up=
 with a
> > > page that may go away due to memory pressure.  But, btrfs_file_wr=
ite
> > > assumes that only the first and last page may have good data that=
 needs
> > > to be read off the disk.
> > >=20
> > > This patch ditches that code and puts it into prepare_pages inste=
ad.
> > > But I'm still having some errors during long stress.sh runs.  Ide=
as are
> > > more than welcome, hopefully some other timezones will kick in id=
eas
> > > while I sleep.
> >=20
> > At least it doesn't fix the emerge-problem for me. The behavior is =
now the same=20
> > as with 2.6.38-rc3. It needs a 'emerge --oneshot dev-libs/libgcrypt=
' with no=20
> > further interaction to get the emerge-process hang with a svn-proce=
ss=20
> > consuming 100% CPU. I can cancel the emerge-process with ctrl-c but=
 the=20
> > spawned svn-process stays and it needs a reboot to get rid of it.=20
>=20
> Can you cat /proc/$pid/wchan a few times so we can get an idea of whe=
re it's
> looping?  Thanks,
>=20
> Josef

It behaves the same way here with btrfs-unstable.
The output of "cat /proc/$pid/wchan" is 0.=20

// Maria

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
