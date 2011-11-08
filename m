From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Tue, 8 Nov 2011 13:27:28 -0500
Message-ID: <20111108182728.GR4954@shiny>
References: <20111106183851.GA4339@shiny>
 <CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Dan Merillat <dan.merillat@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 12:55:40PM -0500, Dan Merillat wrote:
> On Sun, Nov 6, 2011 at 1:38 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > Hi everyone,
> >
> > This pull request is pretty beefy, it ended up merging a number of =
long
> > running projects and cleanup queues. =A0I've got btrfs patches in t=
he new
> > kernel.org btrfs repo. =A0There are two different branches with the=
 same
> > changes. =A0for-linus is against 3.1 and has also been tested again=
st
> > Linus' tree as of yesterday.
>=20
> [91795.123286] device label ROOT devid 1 transid 3331 /dev/sdi2
> [91795.123538] btrfs: open_ctree failed
>=20
> FS created on 3.1 (x64), mounted once on 3.2-rc1 (i386), got that
> whenI tried to mount on 3.1 (x64) again.  Format change in 3.2 or
> 32/64 bit compatibility issues?

I'm trying to reproduce right now but I did many bounces between 3.2 an=
d
3.1 code before releasing.  I didn't try jumping between 32 and 64 bit.

Are there any other messages in dmesg?  Could you please see what
btrfs-debug-tree says?

-chris
