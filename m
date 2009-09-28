From: Sage Weil <sage@newdream.net>
Subject: Re: user transactions and ENOSPC...
Date: Mon, 28 Sep 2009 09:05:32 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0909280855420.5085@cobra.newdream.net>
References: <Pine.LNX.4.64.0909251405560.9827@cobra.newdream.net>
 <6278d2220909260708w49d8b948t72a4bd4eefc88d31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-1987426808-1254153932=:5085"
Cc: linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2220909260708w49d8b948t72a4bd4eefc88d31@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-1987426808-1254153932=:5085
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 26 Sep 2009, Daniel J Blueman wrote:

> On Fri, Sep 25, 2009 at 10:10 PM, Sage Weil <sage@newdream.net> wrote:
> > So, the btrfs user transaction ioctls work like so
> >
> > =A0ioctl(fd, BTRFS_IOC_TRANS_START);
> > =A0/* do many operations: write(), setxattr(), rmdir(), whatever. */
> > =A0ioctl(fd, BTRFS_IOC_TRANS_END); =A0 =A0/* or close(fd); */
> ...
> > The second problem is that the application may die between START and
> > END. The current ioctls are "safe" in that the transaction handle is
> > closed when the struct file is released, so the fs won't get wedged if
> > you say segfault. =A0On the other hand, they're "unsafe" in that a proc=
ess
> > that is killed or segfaults will result in an imcomplete transaction
> > making it to disk, which leaves the file system in an inconsistent stat=
e
> > (from the point of view of the application).
>=20
> With COW, where a transaction is incomplete due to application exit
> without closing the transaction, is there a way to drop the
> reference/'deallocate' the new tree nodes, thus moving back to the
> prior state? Presumably the new tree nodes would get linked in when
> the transaction is closed.

Not quite.  These are not full ACID transactions.. they're only giving you=
=20
atomicity and durability.  Adding the rollback would mean a huge addition=
=20
of complexity, both in rolling back the btrfs and VFS inode/dentry/page=20
cache states.  The current ioctls are quite simple because they hook into=
=20
the existing btrfs transaction infrastructure that lets multiple btree=20
updates (and, optionally, file data) commit to disk together.

For many applications, atomicity is enough, because they aren't sharing=20
the files/directories they're working on with other applications.  They=20
know whether an update should succeed.  We just need to ensure common=20
failures like ENOSPC and crashes do not violate that atomicity.

sage
--557981400-1987426808-1254153932=:5085--
