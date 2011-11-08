From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Tue, 8 Nov 2011 15:17:53 -0500
Message-ID: <20111108201753.GA4149@shiny>
References: <20111106183851.GA4339@shiny>
 <CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
 <20111108182728.GR4954@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Dan Merillat <dan.merillat@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111108182728.GR4954@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 01:27:28PM -0500, Chris Mason wrote:
> On Tue, Nov 08, 2011 at 12:55:40PM -0500, Dan Merillat wrote:
> > On Sun, Nov 6, 2011 at 1:38 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
> > > Hi everyone,
> > >
> > > This pull request is pretty beefy, it ended up merging a number o=
f long
> > > running projects and cleanup queues. =A0I've got btrfs patches in=
 the new
> > > kernel.org btrfs repo. =A0There are two different branches with t=
he same
> > > changes. =A0for-linus is against 3.1 and has also been tested aga=
inst
> > > Linus' tree as of yesterday.
> >=20
> > [91795.123286] device label ROOT devid 1 transid 3331 /dev/sdi2
> > [91795.123538] btrfs: open_ctree failed
> >=20
> > FS created on 3.1 (x64), mounted once on 3.2-rc1 (i386), got that
> > whenI tried to mount on 3.1 (x64) again.  Format change in 3.2 or
> > 32/64 bit compatibility issues?
>=20
> I'm trying to reproduce right now but I did many bounces between 3.2 =
and
> 3.1 code before releasing.  I didn't try jumping between 32 and 64 bi=
t.
>=20
> Are there any other messages in dmesg?  Could you please see what
> btrfs-debug-tree says?

Ok, so I spun the wheel going between 32 and 64 and 3.1 and 3.2.  I'm
not having trouble with basic tests.

So, we'll have to dig in and see why the open is failing.  btrfsck or
btrfs-debug-tree will help.

-chris
