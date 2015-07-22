Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38909 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932093AbbGVDti (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 23:49:38 -0400
Date: Tue, 21 Jul 2015 23:49:37 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Discuss on inband dedup implement (Original "strange data
 backref offset")
Message-ID: <20150722034937.GB21995@hungrycats.org>
References: <55A86AA8.6010404@cn.fujitsu.com>
 <20150718113412.GA11450@localhost.localdomain>
 <20150719072344.GA22025@hungrycats.org>
 <55AC5BE6.90802@cn.fujitsu.com>
 <20150721045505.GB22025@hungrycats.org>
 <55ADEC36.1010504@cn.fujitsu.com>
 <20150721221446.GC22025@hungrycats.org>
 <55AEF6C0.5070207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
In-Reply-To: <55AEF6C0.5070207@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2015 at 09:49:52AM +0800, Qu Wenruo wrote:
> Change subject to reflect the core of the conversation.
>=20
> Zygo Blaxell wrote on 2015/07/21 18:14 -0400:
> >On Tue, Jul 21, 2015 at 02:52:38PM +0800, Qu Wenruo wrote:
> >>Zygo Blaxell wrote on 2015/07/21 00:55 -0400:

> >There's already a read-and-compare in the extent-same ioctl.  :-/
> Yes, but the extent same ioctl needs 2 inode. (one already provided by io=
ctl
> system call)
> One for the source and one for the dest, which makes codes easy to implem=
ent
> as we can just use VFS calls to read the needed pages.
>=20
> But the problem is, for dedup, there is only hash <-> extent mapping.
> We only know the corresponding bytenr of a hash, not a inode.
>=20
> If even using the read-compare method, which means at write routine, we w=
ill
> resuse read routine, causing more complicated read/write path combination=
 to
> test, and later read routine change will be quite dirty to avoid impact on
> write routine.
>=20
> And what's worse is, an extent can be referred by several different inode=
s,
> so even for the best case, we need to find an inode using backref and then
> use address space calls to read the neede pages.
>=20
> That will leads to the hell of delayed ref.
> As at write time, backref is delayed, it needs not only search the extent
> tree for backref item but also go through delayed refs. (Such things were
> the reason causing crazy quota numbers before and I tried to fix in 4.2-r=
c1)
>=20
> And that's what I feared to face, complicated read/write coupling with
> backref search nightmare.

Yes, putting a small-memory dedup into the write path on Linux does
cause some challenging (some might say insurmountable ;) ) problems.

A natural result of having a userspace daemon is that it can keep up
with writes but it is not on the critical path for them, i.e. if we have
memory pressure we just throw the blocks at the disk to free up some RAM,
but remember the block addresses so they can be rescanned later when we're
more idle.  A daemon with a persistent store and a find-new style scanner
can be paused and allowed to run overnight if it's too heavy to run live.

I could see such a facility living inside the kernel and being started and
stopped by an admin...but it might be a better idea to just adjust the
kernel's interface to communicate better with a dedup daemon.

e.g. I have a wishlist item to have something like fanotify which gives me
a file descriptor when a file is modified--but that also includes dirty
block numbers.  I can connect those modified blocks with their duplicate
on-disk counterparts almost immediately, before delalloc even considers
writing them.

> >That's precisely the tradeoff I made:  up to 0.1% more I/O for unique
> >blocks, and duplicate writes would become reads instead (assuming I moved
> >my dedup daemon into the kernel).  There is some extra seeking on writes
> >to confirm duplicate pages--but when they are confirmed, the writes are
> >no longer necessary and their I/O can be dropped.
> >
> >The payoff is that it requires 100 times less RAM, so it can coexist
> >with other things on a medium-sized machine.
>=20
> Quite convincing trade off now.
>=20
> But the above extent reading problem is still here.
> Although I may also be wrong as I'm not quite similar with VFS and filema=
p.
>=20
> If there is any good kernel API to read pages directly by bytenr without
> using filemap/address space infrastructure, I'll be quite happy to try it.

I had assumed (but not checked) that the kernel can do it more easily than
userspace.  The ugliest pieces of code for userspace dedup are the pieces
that translate a block number into a path into a file descriptor, then have
to verify that they ended up with the same physical block that was requeste=
d.

So another wishlist item would be an ioctl for "give me a file descriptor
containing a ref to this blocknr without having to go through all this
root-inode-path resolution crap."  ;)

> >My target environment is a file server device where up to 75% of the
> >system RAM might be devoted to dedup.  It is not something that is
> >intended to run unnoticed on a smartphone.
> The original thought on persist hash map is for database, hard to imagine
> right?
>=20
> From what I read from Oracle datasheet, they claim their database can take
> full use of ZFS deduplication, so I consider such persist hash map idea a=
s a
> supplement to the uncertain LRU drop.
> But that's just a future idea yet...

I looked at a number of databases, hash table structures, bloom filters,
cuckoo tables, exotic modern C++ hashtable libraries from Google, and
ancient articles on hash tables by Knuth.  In the end I gave up and
rolled my own.

I have a lot of duplicate data--almost half--so I can't use algorithms
designed for a 10% hit rate (like bloom and cuckoo).  I don't want to
scan the entire filesystem from scratch every time, so Bloom was out
(no way to delete items, and the variations on Bloom that allow deletion
require almost as much space as the hash table itself).  Indexing overhead
for b-trees and most database engines would be larger than the hash table.

With a 50% duplicate hit rate, _any_ algorithm that spilled out to
disk would be hitting the disk with a random I/O for every 8K of data.
This meant that any data that wasn't going to fit into RAM might as well
be on the moon.  If I tried to keep it, I'd be swapping all the time.
I found a way to work in constant space, because RAM was all the storage
I'd ever be able to use.

Persistence is trivial:  just dump the RAM out to disk every few hours.

> BTW, is your userspace dedup daemon open-source?
> It would be quite nice if we can refer it to improve further.

It is open-source in as much as it is source at all, but it's not in
a usable state yet.  Right now it is a pile of command-line utilities,
several experimental test programs which perform different parts of the
task, some ad-hoc Perl scripts to glue them together, and test-driven
rework that I am slowly converting into a coherent working program
that other human beings can read and use.  The "persistent" on-disk
format changes every three weeks.  I'm on my fourth rewrite of the
extent-matching loop because the first three ran into logical landmines
in my test data.

It was originally supposed to be a 1000-line replacement for
faster-dupemerge to be finished in a week.  This is now month 14, it
has crossed the 2000 line mark, and I'm hoping this month will be
the first month that I rewrite _less_ than 30% of the code.  :-P

> Thanks,
> Qu
> >
> >>In fact, I can reduce the space usage by just(not so easy to call it ju=
st
> >>anyway) change dedup size to 512K. So just one btrfs_dedup_hash for 512K
> >>other than original 128 dedup_hash for 512K.
> >>That's also why Liu Bo uses tunable dedup_size.
> >
> >Anyone can increase the block size to make their dedup faster.  We lose
> >100% of all duplicate extents that are smaller than (or just not aligned
> >to) the block size.
> >
> >>Anyway, my dedup_hash struct is really huge...
> >>It's 120 bytes with all overhead for one btrfs_dedup_hash (and one page
> >>yet).
> >
> >I'm told ZFS is closer to 320.  ;)
> >
> >>>At about 157 bytes per 512K
> >>>(the amount of RAM I have to run dedup) the dedup still covers 92%
> >>>of duplicate extents with length 64K, with less coverage for smaller
> >>>extents and more coverage for larger extents.  The size distribution
> >>>of typical filesystems means I get 99% of all duplicate blocks.
> >>>
> >>Pretty impressive, but still a little worried about the code complexibi=
lity
> >>especially when it needs to go into kernel.
> >>
> >>At last, thanks for your impressive dedup ideas and test data.
> >>
> >>Thanks,
> >>Qu
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWvEtEACgkQgfmLGlazG5zHQwCeNLWcIPFZ5PN/+rnYYuvLPLla
ZbkAnRWCT0FhROuGM/sigcaWkeJFusn+
=CqmM
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
