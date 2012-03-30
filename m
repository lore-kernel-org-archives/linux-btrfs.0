From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs fixes and features
Date: Fri, 30 Mar 2012 16:04:47 -0400
Message-ID: <20120330200447.GL755@shiny>
References: <20120330175106.GB755@shiny>
 <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
 <CA+55aFyn0TL6vJZrGVQkgAscT33nf9_7rH-DRVJbcG3K7d7QKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyn0TL6vJZrGVQkgAscT33nf9_7rH-DRVJbcG3K7d7QKA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2012 at 12:54:03PM -0700, Linus Torvalds wrote:
> On Fri, Mar 30, 2012 at 12:50 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > This causes a new warning for me:
> >
> > =C2=A0fs/btrfs/extent_io.c: In function =E2=80=98repair_eb_io_failu=
re=E2=80=99:
> > =C2=A0fs/btrfs/extent_io.c:1940:6: warning: =E2=80=98ret=E2=80=99 m=
ay be used
> > uninitialized in this function
> >
> > Hmm?
>=20
> Ok, so presumably num_pages (which is "num_extent_pages(eb->start,
> eb->len)") cannot be zero, so I guess the code is ok. But gcc can't
> know that, and it's an annoying warning.

Whoops, my reply was too slow, sorry.  If you're curious my gcc that
doesn't warn in 4.6.3.

>=20
> So please fix, but it's not urgent. In the meantime I've pulled and p=
ushed out.

Ok, I'll send just the incremental in a later pull.

-chris
