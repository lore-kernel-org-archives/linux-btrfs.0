Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44293 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750703AbbDTE1e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 00:27:34 -0400
Date: Mon, 20 Apr 2015 00:27:31 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Craig Ringer <craig@2ndquadrant.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Message-ID: <20150420042731.GA20194@hungrycats.org>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
 <49296740.rPqQP4vAjc@merkaba>
 <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
In-Reply-To: <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2015 at 10:31:02PM +0800, Craig Ringer wrote:
> On 19 April 2015 at 22:28, Martin Steigerwald <martin@lichtvoll.de> wrote:
> > Am Sonntag, 19. April 2015, 21:20:11 schrieb Craig Ringer:
> >> Hi all
> >
> > Hi Craig,
> >
> >> I'm looking into the advisability of running PostgreSQL on BTRFS, and
> >> after looking at the FAQ there's something I'm hoping you could
> >> clarify.
> >>
> >> The wiki FAQ says:
> >>
> >> "Btrfs does not force all dirty data to disk on every fsync or O_SYNC
> >> operation, fsync is designed to be fast."
> >>
> >> Is that wording intended narrowly, to contrast with ext3's nasty habit
> >> of flushing *all* dirty blocks for the entire file system whenever
> >> anyone calls fsync() ? Or is it intended broadly, to say that btrfs's
> >> fsync won't necessarily flush all data blocks (just metadata) ?

Normal writes to btrfs filesystems using the versioned filesystem tree are
consistent(ish), atomic, and durable; however, they have high latency as
the filesystem normally delays commit until triggered by a periodic timer
(or sync()--not fsync), then writes all outstanding dirty pages in memory.

btrfs handles fsync separately from the main versioned filesystem tree in
order to decrease the latency of fsync operations.  There is a 'log tree'
which behaves like a journal and contains data flushed with fsync() since
the last fully committed btrfs root.  After a crash, assuming no bugs,
the log is replayed over the last committed version of the filesystem
tree to implement fsync durability.

Unfortunately, in my experience, the log tree's most noticeable effect
at the moment seems to be to add a crapton of special-case code paths,
many of which do contain bugs, which are being fixed one at a time by
btrfs developers.  :-/

> >> Is that statement still true in recent BTRFS versions (3.18, etc)?

3.18 was released 133 days ago.  It has only been 49 days since the last
commit that fixes a btrfs data loss bug involving fsync (3a8b36f on Mar 1,
appearing in mainline as of v4.0-rc3), and 27 days since a commit that
fixes a problem involving fsync and discard (dcc82f4 on Mar 23, queued
for v4.1).

There has been a stream of fsync fixes in the past year, but it would
be naive to believe that there are not still more bugs to be found given
the frequency and recentness of fixes.

> > I don=B4t know, thus leave that for others to answer. I always assumed a
> > strong fsync() guarentee as in "its on disk" with BTRFS. So I am
> > interested in that as well.

That's the intention; however, btrfs is not there yet.

It has been only 28 days since I last detected corrupted data on a
btrfs instance:  after a crash and log tree replay, extents from the
*beginning* of several files written just before the crash were missing,
but the *ends* of the files were present and correct.

There are also cases where btrfs cannot read data that *is* on disk.
I encounter that bug *every* day on some test systems, but can't yet
reproduce it with less than a TB of data and heavy workloads.  :-P

> > But for databases, did you consider the copy on write fragmentation BTR=
FS
> > will give? Even with autodefrag, afaik it is not recommended to use it =
for
> > large databases on rotating media at least.
>=20
> I did, and any testing would need to look at the efficacy of the
> chattr +C option on the database directory tree.
>=20
> PostgreSQL is its self copy-on-write (because of multi-version
> concurrency control), so it doesn't make much sense to have the FS
> doing another layer of COW.

I noticed that redundancy and ended up picking btrfs over PostgreSQL.

I disable fsync in PostgreSQL (as well as a half-dozen assorted
applications that use sqlite, or just seem to like calling fsync
often), turn off full-page-writes on the journal--and also clear the
btrfs log tree before every mount.  A database can happily rely on
btrfs to preserve write ordering as long as all of its data is in one
filesystem(*) and btrfs never gets to replay its log tree (i.e. using
only the every-30-seconds global filesystem commit).  The database is
only able to offer async_commit mode when there is no fsync, but my
applications all want async_commit for performance reasons anyway.

Disabling fsync from PostgreSQL avoids the bugs in the btrfs
implementation of fsync and the log tree.  With fsync + log tree, I
was rebuilding corrupted PostgreSQL databases from backups after almost
every reboot, and sometimes even more often than that.

I stopped testing PostgreSQL with fsync 277 days ago, and I have
PostgreSQL instances running since then without fsync that are 117 days
old...so that configuration seems as stable as anything else in btrfs.

Note that 117 days ago this btrfs instance corrupted itself beyond repair
(garbage tree node pointers with correct checksums!) and the entire
filesystem had to be mkfs'ed and rebuilt from backup.

For reference, my PostgreSQL workload is a nearly continuous stream of
transactions modifying 10K-15K pages per commit (80-120 MB random writes,
plus indexes).

> I'm curious as to whether +C has any effect on BTRFS's durability, too.

I would expect it to be strictly equal to or worse than the CoW
durability.  It would have all the same general filesystem bugs as btrfs,
plus extra bugs that are specific to the no-CoW btrfs code paths, and
you lose write ordering and btrfs data integrity and repair capabilities,
and you have to enable fsync and log tree replay and dodge the bugs.


> --=20
>  Craig Ringer                   http://www.2ndQuadrant.com/
>  PostgreSQL Development, 24x7 Support, Training & Services
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

(*) or maybe subvol.  I haven't tested a multi-subvol-single-filesystem
btrfs, but I don't see much real-world advantage in configuring that way.

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlU0gDMACgkQgfmLGlazG5w8RQCfaPEx5xXrvKL7JHmFdbCITaMA
CGgAnA2+LK20Esm4Dfg0z+l7KngzWHCP
=vxcJ
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
