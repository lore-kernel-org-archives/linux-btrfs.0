From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Mon, 23 Nov 2009 20:26:08 -0500
Message-ID: <20091124012608.GF24068@think>
References: <200911201950.06662.kreijack@libero.it>
 <934f64a20911201124q2a42fddek87d3f8fe864b3c41@mail.gmail.com>
 <20091120195017.GZ3110@think>
 <934f64a20911201205j70b5b9cfm40260a4a3a6c7b0b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <934f64a20911201205j70b5b9cfm40260a4a3a6c7b0b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2009 at 02:05:11PM -0600, David Nicol wrote:
> On Fri, Nov 20, 2009 at 1:50 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > COW semantics require touching btree nodes all the way up to the ro=
ot of
> > the btree, but this is different from the directory. =A0Directories=
 are
> > stored in the btree, but you won't have to touch more than 8 or so =
btree
> > levels regardless of how deep your directory tree is.
> >
> > -chris
>=20
> Thanks for straightening me out on that point.
>=20
> Still, 8 might be a lot.
>=20
> Regardless of the decoupling of btrees and directories, am I right in
> thinking that mounted subvolumes instead of directories would (1)
> reduce contention

It might, it depends on the workload.  But yes, one point of big
contention is the root node of the btree and each subvolume has its own
root.

> (2) reduce the number of levels touched since number
> of levels is a function of the number of fs entities in the volume,
> therefore

It depends on the overall btree size.  Probably.

> (3) defining a file system entity that transparently becomes
> a mounted subvolume (by transparently I mean without an additional
> mount command) and (4) crafting a utility to streamline
> creation-and-implied-mounting of the entity type from #3 would make
> sense?

Sure.  It definitely makes sense to explore the subvolume and
snapshotting user interfaces.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
