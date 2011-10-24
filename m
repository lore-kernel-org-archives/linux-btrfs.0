From: Sage Weil <sage@newdream.net>
Subject: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Mon, 24 Oct 2011 10:06:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
 <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-290282573-1319474820=:15349"
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-290282573-1319474820=:15349
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1110240952141.15349@cobra.newdream.net>

[adding linux-btrfs to cc]

Josef, Chris, any ideas on the below issues?

On Mon, 24 Oct 2011, Christian Brunner wrote:
> Thanks for explaining this. I don't have any objections against btrfs
> as a osd filesystem. Even the fact that there is no btrfs-fsck doesn't
> scare me, since I can use the ceph replication to recover a lost
> btrfs-filesystem. The only problem I have is, that btrfs is not stable
> on our side and I wonder what you are doing to make it work. (Maybe
> it's related to the load pattern of using ceph as a backend store for
> qemu).
>=20
> Here is a list of the btrfs problems I'm having:
>=20
> - When I run ceph with the default configuration (btrfs snaps enabled)
> I can see a rapid increase in Disk-I/O after a few hours of uptime.
> Btrfs-cleaner is using more and more time in
> btrfs_clean_old_snapshots().

In theory, there shouldn't be any significant difference between taking a=
=20
snapshot and removing it a few commits later, and the prior root refs that=
=20
btrfs holds on to internally until the new commit is complete.  That's=20
clearly not quite the case, though.

In any case, we're going to try to reproduce this issue in our=20
environment.

> - When I run ceph with btrfs snaps disabled, the situation is getting
> slightly better. I can run an OSD for about 3 days without problems,
> but then again the load increases. This time, I can see that the
> ceph-osd (blkdev_issue_flush) and btrfs-endio-wri are doing more work
> than usual.

FYI in this scenario you're exposed to the same journal replay issues that=
=20
ext4 and XFS are.  The btrfs workload that ceph is generating will also=20
not be all that special, though, so this problem shouldn't be unique to=20
ceph.

> Another thing is that I'm seeing a WARNING: at fs/btrfs/inode.c:2114
> from time to time. Maybe it's related to the performance issues, but
> seems to be able to verify this.

I haven't seen this yet with the latest stuff from Josef, but others have. =
=20
Josef, is there any information we can provide to help track it down?

> It's really sad to see, that ceph performance and stability is
> suffering that much from the underlying filesystems and that this
> hasn't changed over the last months.

We don't have anyone internally working on btrfs at the moment, and are=20
still struggling to hire experienced kernel/fs people.  Josef has been=20
very helpful with tracking these issues down, but he hass responsibilities=
=20
beyond just the Ceph related issues.  Progress is slow, but we are=20
working on it!

sage


>=20
> Kind regards,
> Christian
>=20
> 2011/10/24 Sage Weil <sage@newdream.net>:
> > Although running on ext4, xfs, or whatever other non-btrfs you want mos=
tly
> > works, there are a few important remaining issues:
> >
> > 1- ext4 limits total xattrs for 4KB. =A0This can cause problems in some
> > cases, as Ceph uses xattrs extensively. =A0Most of the time we don't hi=
t
> > this. =A0We do hit the limit with radosgw pretty easily, though, and ma=
y
> > also hit it in exceptional cases where the OSD cluster is very unhealth=
y.
> >
> > There is a large xattr patch for ext4 from the Lustre folks that has be=
en
> > floating around for (I think) years. =A0Maybe as interest grows in runn=
ing
> > Ceph on ext4 this can move upstream.
> >
> > Previously we were being forgiving about large setxattr failures on ext=
3,
> > but we found that was leading to corruption in certain cases (because w=
e
> > couldn't set our internal metadata), so the next release will assert/cr=
ash
> > in that case (fail-stop instead of fail-maybe-eventually-corrupt).
> >
> > XFS does not have an xattr size limit and thus does have this problem.
> >
> > 2- The other problem is with OSD journal replay of non-idempotent
> > transactions. =A0On non-btrfs backends, the Ceph OSDs use a write-ahead
> > journal. =A0After restart, the OSD does not know exactly which transact=
ions
> > in the journal may have already been committed to disk, and may reapply=
 a
> > transaction again during replay. =A0For most operations (write, delete,
> > truncate) this is fine.
> >
> > Some operations, though, are non-idempotent. =A0The simplest example is
> > CLONE, which copies (efficiently, on btrfs) data from one object to
> > another. =A0If the source object is modified, the osd restarts, and the=
n
> > the clone is replayed, the target will get incorrect (newer) data. =A0F=
or
> > example,
> >
> > 1- clone A -> B
> > 2- modify A
> > =A0 <osd crash, replay from 1>
> >
> > B will get new instead of old contents.
> >
> > (This doesn't happen on btrfs because the snapshots allow us to replay
> > from a known consistent point in time.)
> >
> > For things like clone, skipping the operation of the target exists almo=
st
> > works, except for cases like
> >
> > 1- clone A -> B
> > 2- modify A
> > ...
> > 3- delete B
> > =A0 <osd crash, replay from 1>
> >
> > (Although in that example who cares if B had bad data; it was removed
> > anyway.) =A0The larger problem, though, is that that doesn't always wor=
k;
> > CLONERANGE copies a range of a file from A to B, where B may already
> > exist.
> >
> > In practice, the higher level interfaces don't make full use of the
> > low-level interface, so it's possible some solution exists that careful
> > avoids the problem with a partial solution in the lower layer. =A0This =
makes
> > me nervous, though, as it is easy to break.
> >
> > Another possibility:
> >
> > =A0- on non-btrfs, we set a xattr on every modified object with the
> > =A0 op_seq, the unique sequence number for the transaction.
> > =A0- for any (potentially) non-idempotent operation, we fsync() before
> > =A0 continuing to the next transaction, to ensure that xattr hits disk.
> > =A0- on replay, we skip a transaction if the xattr indicates we already
> > =A0 performed this transaction.
> >
> > Because every 'transaction' only modifies on a single object (file),
> > this ought to work. =A0It'll make things like clone slow, but let's fac=
e it:
> > they're already slow on non-btrfs file systems because they actually co=
py
> > the data (instead of duplicating the extent refs in btrfs). =A0And it s=
hould
> > make the full ObjectStore iterface safe, without upper layers having to
> > worry about the kinds and orders of transactions they perform.
> >
> > Other ideas?
> >
> > This issue is tracked at http://tracker.newdream.net/issues/213.
> >
> > sage
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
--557981400-290282573-1319474820=:15349--
