From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS file clone support for cp
Date: Wed, 29 Jul 2009 09:01:06 -0400
Message-ID: <20090729130106.GF13940@think>
References: <87d47o3fip.fsf@master.homenet>
 <4A6CEA48.5050208@draigBrady.com>
 <8763defuvq.fsf@meyering.net>
 <87ws5tvrq8.fsf@master.homenet>
 <4A6E3ADE.6050008@draigBrady.com>
 <8763dcvagk.fsf@master.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	Jim Meyering <jim@meyering.net>, bug-coreutils@gnu.org,
	linux-btrfs@vger.kernel.org
To: Giuseppe Scrivano <gscrivano@gnu.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8763dcvagk.fsf@master.homenet>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2009 at 10:06:35PM +0200, Giuseppe Scrivano wrote:
> Hi P=E1draig,
>=20
>=20
> P=E1draig Brady <P@draigBrady.com> writes:
>=20
> > How different exactly?
> > OK I tried this myself on F11 with inconclusive results.
>=20
> I can't replicate it now, all tests I am doing report that blocks use=
d
> before and after the clone are the same.  Probably yesterday the
> difference I noticed was in reality the original file flushed to the
> disk.

The clone will use some additional space for the metadata required to
point to the cloned blocks.  It isn't exactly O(1) it is O(metadata for
the file).

>=20
>=20
> > The above suggests that the clone does actually allocate space
> > but btrfs isn't reporting it through statvfs correctly?
>=20
> The same message appeared here too some days ago, though I cloned onl=
y
> few Kb files, not much to fill the entire partition.
>=20
>=20
> > If the clone does allocate space, then how can one
> > clone without allocation which could be very useful
> > for snapshotting for example?
>=20
> I don't know if snapshotting is handled in the same way as a "clone",
> but in this case it seems more obvious to me that no additional space
> should be reported.

The COW for snapshotting and a clone are the same, but the way we get
there is a little different.  For a snapshot, we have two btree roots
pointing to the same nodes, and we've incremented the reference count o=
n
each of the nodes they both point to.  No matter how big the subvolume
is, this will always be O(number of pointers in the root block).

Cloning a file is done by walking the file metadata and taking a
reference on each extent pointed to by the file.  The file data is neve=
r
read in, but all of the file metadata is read in.

>=20
>=20
> > Also I tried the above twice and both times got:
> > http://www.kerneloops.org/submitresult.php?number=3D578993
>=20
> I didn't get these errors.  I am using the btrfs git version.

These have been fixed.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
