From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS file clone support for cp
Date: Wed, 29 Jul 2009 12:18:26 -0400
Message-ID: <20090729161826.GK13940@think>
References: <87d47o3fip.fsf@master.homenet>
 <4A6CEA48.5050208@draigBrady.com>
 <8763defuvq.fsf@meyering.net>
 <87ws5tvrq8.fsf@master.homenet>
 <4A6E3ADE.6050008@draigBrady.com>
 <8763dcvagk.fsf@master.homenet>
 <20090729130106.GF13940@think>
 <4A705959.7010303@draigBrady.com>
 <20090729161014.GJ13940@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Jim Meyering <jim@meyering.net>, bug-coreutils@gnu.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090729161014.GJ13940@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 29, 2009 at 12:10:14PM -0400, Chris Mason wrote:
> On Wed, Jul 29, 2009 at 03:14:49PM +0100, P=E1draig Brady wrote:
> > Chris Mason wrote:
> > > On Tue, Jul 28, 2009 at 10:06:35PM +0200, Giuseppe Scrivano wrote=
:
> > >>
> > >> I can't replicate it now, all tests I am doing report that block=
s used
> > >> before and after the clone are the same.  Probably yesterday the
> > >> difference I noticed was in reality the original file flushed to=
 the
> > >> disk.
> > >=20
> > > The clone will use some additional space for the metadata require=
d to
> > > point to the cloned blocks.  It isn't exactly O(1) it is O(metada=
ta for
> > > the file).
> >=20
> > Thanks for the clarification Chris.
> > So the just committed change in cp will
> > link the destination file to the extents of the source.
> >=20
> > We may need to play around with fallocate()
> > if we want to get back to the original
> > cp semantics of actually allocating space
> > on the file system for the new file.
>=20
> Well, best to just use the original cp code.  I was talking with
> Giuseppe about this as well, I think we should the option to do regul=
ar
> cp via a flag.
>=20
> There will soon be a reflink system call that can be used on ocfs2 an=
d
> btrfs as well.  Thanks for adding this to glibc!

Um, cp, not glibc, sorry ;)

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
