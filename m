Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35536 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbFCATR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jun 2015 20:19:17 -0400
Received: by pdbnf5 with SMTP id nf5so82763302pdb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2015 17:19:16 -0700 (PDT)
Date: Tue, 2 Jun 2015 17:19:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Markus Schauler <mschauler@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't invalidate root dentry when subvolume
 deletion fails
Message-ID: <20150603001914.GA21606@mew>
References: <d901ccc6dbbc8db40962b4b8e4d391a684e88335.1432975901.git.osandov@osandov.com>
 <CAL3q7H6PvooaNWpKCTFgAxc=R0pT1XiwSQvJiYVXiV4iuJHXRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6PvooaNWpKCTFgAxc=R0pT1XiwSQvJiYVXiV4iuJHXRA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 05:56:43PM +0100, Filipe David Manana wrote:
> On Sat, May 30, 2015 at 9:59 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > Since commit bafc9b754f75 ("vfs: More precise tests in d_invalidate"),
> > mounted subvolumes can be deleted because d_invalidate() won't fail.
> > However, we run into problems when we attempt to delete the default
> > subvolume while it is mounted as the root filesystem:
> >
> >         # btrfs subvol list /
> >         ID 257 gen 306 top level 5 path rootvol
> >         ID 267 gen 334 top level 5 path snap1
> >         # btrfs subvol get-default /
> >         ID 267 gen 334 top level 5 path snap1
> >         # btrfs inspect-internal rootid /
> >         267
> >         # mount -o subvol=/ /dev/vda1 /mnt
> >         # btrfs subvol del /mnt/snap1
> >         Delete subvolume (no-commit): '/mnt/snap1'
> >         ERROR: cannot delete '/mnt/snap1' - Operation not permitted
> >         # findmnt /
> >         findmnt: can't read /proc/mounts: No such file or directory
> >         # ls /proc
> >         #
> >
> > Markus reported that this same scenario simply led to a kernel oops.
> >
> > This happens because in btrfs_ioctl_snap_destroy(), we call
> > d_invalidate() before we check may_destroy_subvol(), which means that we
> > detach the submounts and drop the dentry before erroring out. Instead,
> > we should only invalidate the dentry once we know that we're going
> > through with the deletion.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: bafc9b754f75 ("vfs: More precise tests in d_invalidate")
> > Reported-by: Markus Schauler <mschauler@gmail.com>
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> > The other fix for preventing all mounted subvolumes from being deleted
> > would preclude this, but it sounded like we were leaning towards
> > enforcing that in userspace once subvolume info becomes available in
> > /proc/mounts, so this should be fixed separately.
> >
> >  fs/btrfs/ioctl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 1c22c6518504..8edb8544088b 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -2413,14 +2413,14 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
> >                 goto out_unlock_inode;
> >         }
> >
> > -       d_invalidate(dentry);
> > -
> >         down_write(&root->fs_info->subvol_sem);
> >
> >         err = may_destroy_subvol(dest);
> >         if (err)
> >                 goto out_up_write;
> >
> > +       d_invalidate(dentry);
> > +
> 
> Any reason why not calling d_invalidate() only if the call
> btrfs_unlink_subvol() succeeds? Not seeing a reason why we should
> invalidate before doing the actual deletion successfully (before that
> metadata reservation can fail or failure to start/join a transaction,
> etc).

Good point, it's probably best to put it here:

----
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c6518504..5a225cd0af65 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2413,8 +2413,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		goto out_unlock_inode;
 	}
 
-	d_invalidate(dentry);
-
 	down_write(&root->fs_info->subvol_sem);
 
 	err = may_destroy_subvol(dest);
@@ -2508,6 +2506,7 @@ out_up_write:
 out_unlock_inode:
 	mutex_unlock(&inode->i_mutex);
 	if (!err) {
+		d_invalidate(dentry);
 		shrink_dcache_sb(root->fs_info->sb);
 		btrfs_invalidate_inodes(dest);
 		d_delete(dentry);
----

I also can't figure out what that shrink_dcache_sb() is doing there.
d_invalidate() already prunes the dentry cache under the deleted
subvolume, but this clears the dcache for the whole filesystem, which
could incur unnecessary overhead. The call was added by efefb1438be2
("Btrfs: remove negative dentry when deleting subvolumne"), which fixes
a problem in btrfs_dentry_delete(), but the commit message doesn't
explain what shrink_dcache_sb() had to do with it. I'll send in an
updated version with d_invalidate() moved and shrink_dcache_sb() removed
and see if anyone can enlighten me.

> Also, would you consider making an xfstest for this?

No problem.

> thanks

Thanks for the review!

-- 
Omar
