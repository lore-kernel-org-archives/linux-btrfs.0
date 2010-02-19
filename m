From: Sage Weil <sage@newdream.net>
Subject: Re: zero-length files in snapshots
Date: Fri, 19 Feb 2010 14:22:25 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1002191355490.21676@cobra.newdream.net>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
 <m38wazywow.fsf@pullcord.laptop.org> <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
 <20100212151940.GA4191@localhost.localdomain>
 <93cdabd21002120818g4c47e2b6k3083a368286651e5@mail.gmail.com>
 <20100212162207.GB4191@localhost.localdomain>
 <93cdabd21002120827k493a4c1ao2ba4b6840f2ab427@mail.gmail.com>
 <20100212163246.GC4191@localhost.localdomain>
 <93cdabd21002120913h1b1eaa2cke8941aa8557b66f3@mail.gmail.com>
 <20100213112540.GB23512@attic.humilis.net> <93cdabd21002131126v4b4d3c1ei2a747a7a5de7b1c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-578634270-1266617746=:21676"
Cc: sander@humilis.net, Josef Bacik <josef@redhat.com>,
	Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002131126v4b4d3c1ei2a747a7a5de7b1c8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-578634270-1266617746=:21676
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1002191419151.21676@cobra.newdream.net>

On Sat, 13 Feb 2010, Mike Fedyk wrote:
> On Sat, Feb 13, 2010 at 3:25 AM, Sander <sander@humilis.net> wrote:
> > Mike Fedyk wrote (ao):
> >> On Fri, Feb 12, 2010 at 8:32 AM, Josef Bacik <josef@redhat.com> wrote:
> >> > Creating a file is a metadata operation, and _any_ metadata operatio=
n has to be
> >> > committed to disk when the transaction commits in order to maintain =
a coherent
> >> > fs. ??Thanks,
> >>
> >> What I still don't understand though is that the create could have
> >> taken up to 30 seconds to commit and the same for the few bytes of
> >> data, but a few ms later a snapshot was made and the metadata change
> >> was there and the data change was not. =A0Could it have happened that
> >> the snapshot would not have the newly created file and this was just a
> >> timing issue that should not be relied upon?
> >>
> >> I'm just wondering why that file was there at all.
> >
> > I would say that is because the moment the file got created, the
> > resulting metadata was commited immediately. The data not yet.
>=20
> Josef explained it to me on IRC.  Meta-data changes like file creation
> get added to the current transaction and snapshots start a new
> transaction so that is why the empty file is in the snapshot.
>=20
> The file is empty because with delayed allocation, the data has not
> hit the filesystem yet and thus has no representation in filesystem
> operations like snapshots.

You can make btrfs include the file data in the snapshot along with the=20
metadata with the 'flushoncommit' mount option.  The problem is that this=
=20
will make _all_ btrfs commits more expensive, as they'll block new=20
operations during the commit while old data is being flushed out.

We could trivially make this happen only when there is a new snapshot, to=
=20
get the behavior you expect (see patch below).  If the goal is to make a=20
perfectly consistent snapshot of the file system, this is better than

=09sync ; btrfsctl -s snap whatever

because there wouldn't be a window where metadata changes make it into the=
=20
snapshot but file data does not.

Is there really a use case for the sort of 'lazy' snapshots with=20
out-of-sync data and metadata (like 0-byte files)?  If so, we should add=20
another ioctl for a full-blown snapshot so that users who _do_ want a=20
fully consistent snapshot can get it.

If not, something like the below should be sufficient to make all=20
snapshots fully consistent...

sage

---

From: Sage Weil <sage@newdream.net>
Date: Fri, 19 Feb 2010 14:13:50 -0800
Subject: [PATCH] Btrfs: flush data on snapshot creation

Flush any delalloc extents when we create a snapshot, so that recently
written file data is always included in the snapshot.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/transaction.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e83d4e1..f5b7029 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1084,13 +1084,10 @@ int btrfs_commit_transaction(struct btrfs_trans_han=
dle *trans,
=20
                mutex_unlock(&root->fs_info->trans_mutex);
=20
-               if (flush_on_commit) {
+               if (flush_on_commit || snap_pending) {
                        btrfs_start_delalloc_inodes(root, 1);
                        ret =3D btrfs_wait_ordered_extents(root, 0, 1);
                        BUG_ON(ret);
-               } else if (snap_pending) {
-                       ret =3D btrfs_wait_ordered_extents(root, 0, 1);
-                       BUG_ON(ret);
                }
=20
                /*
--=20
1.6.6.1

--557981400-578634270-1266617746=:21676--
