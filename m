From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [RFC] NFS Support
Date: Mon, 30 Jun 2008 11:08:11 -0400
Message-ID: <20080630150811.GB18866@unused.rdu.redhat.com>
References: <200806290505.31641.balajirrao@gmail.com> <20080630145002.GA18866@unused.rdu.redhat.com> <569c97d20806300820p1e6f3b9eha359f93ea41c6705@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Balaji Rao R <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <569c97d20806300820p1e6f3b9eha359f93ea41c6705@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 30, 2008 at 08:50:46PM +0530, Balaji Rao R wrote:
> On Mon, Jun 30, 2008 at 8:20 PM, Josef Bacik <jbacik@redhat.com> wrote:
> > On Sun, Jun 29, 2008 at 05:05:31AM +0530, Balaji Rao wrote:
> >> Hello,
> >>
> >> Here's a quick implementation of NFS support for btrfs. It works mostly. But
> >> its still a bit buggy. I suspect it has to do something with inode locking.
> >> When I unmount and mount a couple of times, it stops working i.e, when I do an
> >> 'ls', it keeps waiting indefinitely. This is seen when accessing the filesystem
> >> from a local mount point as well.
> >>
> >> Can anybody please review and tell me what stupid mistake I'm committing ?
> >>
> >
> > You may want to send things in patch form.  I'd recommend using the hg quilt
> > plugin, its nice for adding patches easily.
> Yes, since this was just an RFC, i thought it would be  better to send
> just the file I created.
> >
> >>
> >> #include <linux/fs.h>
> >> #include <linux/types.h>
> >> #include "ctree.h"
> >> #include "disk-io.h"
> >> #include "btrfs_inode.h"
> >> #include "print-tree.h"
> >> #include "export.h"
> >>
> >> static int btrfs_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
> >>                       int connectable)
> >> {     struct inode *inode = dentry->d_inode;
> >>       int len = *max_len;
> >>       u64 objectid, root_objectid;
> >>       u32 generation;
> >>       __le32 *fh = (__force __le32 *) fh_in;
> >>
> >>       if ((len < 5 )|| (connectable && len < 8)) {
> >>               return 255;
> >>       }
> >
> > Magic numbers are a no-no.
> OK :) Will change
> >
> >>
> >>       objectid = BTRFS_I(inode)->location.objectid;
> >>       root_objectid = BTRFS_I(inode)->root->objectid;
> >>       generation = inode->i_generation;
> >>
> >>       len  = 5;
> >>       fh[0] = cpu_to_le32((u32)(objectid >> 32));
> >>       fh[1] = cpu_to_le32((u32)(objectid & 0xffffffff));
> >>       fh[2] = cpu_to_le32((u32)(root_objectid >> 32));
> >>       fh[3] = cpu_to_le32((u32)(root_objectid & 0xffffffff));
> >>       fh[4] = cpu_to_le32(generation);
> >>
> >>       if (connectable && !S_ISDIR(inode->i_mode)) {
> >>               struct inode *parent;
> >>
> >>               spin_lock(&dentry->d_lock);
> >>
> >>               parent = dentry->d_parent->d_inode;
> >>               objectid = BTRFS_I(parent)->location.objectid;
> >>               generation = parent->i_generation;
> >>
> >>               fh[5] = cpu_to_le32((u32)(objectid >> 32));
> >>               fh[6] = cpu_to_le32((u32)(objectid & 0xffffffff));
> >>               fh[7] = cpu_to_le32(generation);
> >>
> >>               spin_unlock(&dentry->d_lock);
> >>
> >>               len += 3;
> >
> > there is no need to take the d_lock here.
> OK. Will remove it. It was done at fs/ocfs2/export.c. So probably i
> thought it was necessary.
> 
> <snip>
>

Ahh see this is where me not being familiar with NFS gets me in trouble, you do
need the d_lock in that case.  Sorry about that.

Josef
