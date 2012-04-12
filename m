From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: use i_version instead of our own sequence
Date: Thu, 12 Apr 2012 09:31:07 -0400
Message-ID: <20120412133107.GC1924@localhost.localdomain>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
 <CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 04:22:26PM +0300, Kasatkin, Dmitry wrote:
> On Mon, Apr 9, 2012 at 6:53 PM, Josef Bacik <josef@redhat.com> wrote:
> > We've been keeping around the inode sequence number in hopes that s=
omebody
> > would use it, but nobody uses it and people actually use i_version =
which
> > serves the same purpose, so use i_version where we used the incore =
inode's
> > sequence number and that way the sequence is updated properly acros=
s the
> > board, and not just in file write. =A0Thanks,
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> > =A0fs/btrfs/btrfs_inode.h =A0 | =A0 =A03 ---
> > =A0fs/btrfs/delayed-inode.c | =A0 =A04 ++--
> > =A0fs/btrfs/file.c =A0 =A0 =A0 =A0 =A0| =A0 =A01 -
> > =A0fs/btrfs/inode.c =A0 =A0 =A0 =A0 | =A0 =A05 ++---
> > =A0fs/btrfs/super.c =A0 =A0 =A0 =A0 | =A0 =A02 +-
> > =A05 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index 9b9b15f..3771b85 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -83,9 +83,6 @@ struct btrfs_inode {
> > =A0 =A0 =A0 =A0 */
> > =A0 =A0 =A0 =A0u64 generation;
> >
> > - =A0 =A0 =A0 /* sequence number for NFS changes */
> > - =A0 =A0 =A0 u64 sequence;
> > -
> > =A0 =A0 =A0 =A0/*
> > =A0 =A0 =A0 =A0 * transid of the trans_handle that last modified th=
is inode
> > =A0 =A0 =A0 =A0 */
> > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > index 03e3748..bcd40c7 100644
> > --- a/fs/btrfs/delayed-inode.c
> > +++ b/fs/btrfs/delayed-inode.c
> > @@ -1706,7 +1706,7 @@ static void fill_stack_inode_item(struct btrf=
s_trans_handle *trans,
> > =A0 =A0 =A0 =A0btrfs_set_stack_inode_nbytes(inode_item, inode_get_b=
ytes(inode));
> > =A0 =A0 =A0 =A0btrfs_set_stack_inode_generation(inode_item,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 BTRFS_I(inode)->generation);
> > - =A0 =A0 =A0 btrfs_set_stack_inode_sequence(inode_item, BTRFS_I(in=
ode)->sequence);
> > + =A0 =A0 =A0 btrfs_set_stack_inode_sequence(inode_item, inode->i_v=
ersion);
> > =A0 =A0 =A0 =A0btrfs_set_stack_inode_transid(inode_item, trans->tra=
nsid);
> > =A0 =A0 =A0 =A0btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev=
);
> > =A0 =A0 =A0 =A0btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inod=
e)->flags);
> > @@ -1754,7 +1754,7 @@ int btrfs_fill_inode(struct inode *inode, u32=
 *rdev)
> > =A0 =A0 =A0 =A0set_nlink(inode, btrfs_stack_inode_nlink(inode_item)=
);
> > =A0 =A0 =A0 =A0inode_set_bytes(inode, btrfs_stack_inode_nbytes(inod=
e_item));
> > =A0 =A0 =A0 =A0BTRFS_I(inode)->generation =3D btrfs_stack_inode_gen=
eration(inode_item);
> > - =A0 =A0 =A0 BTRFS_I(inode)->sequence =3D btrfs_stack_inode_sequen=
ce(inode_item);
> > + =A0 =A0 =A0 inode->i_version =3D btrfs_stack_inode_sequence(inode=
_item);
> > =A0 =A0 =A0 =A0inode->i_rdev =3D 0;
> > =A0 =A0 =A0 =A0*rdev =3D btrfs_stack_inode_rdev(inode_item);
> > =A0 =A0 =A0 =A0BTRFS_I(inode)->flags =3D btrfs_stack_inode_flags(in=
ode_item);
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 431b565..f0da02b 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1404,7 +1404,6 @@ static ssize_t btrfs_file_aio_write(struct ki=
ocb *iocb,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&inode->i_mutex);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> > =A0 =A0 =A0 =A0}
> > - =A0 =A0 =A0 BTRFS_I(inode)->sequence++;
> >
> > =A0 =A0 =A0 =A0start_pos =3D round_down(pos, root->sectorsize);
> > =A0 =A0 =A0 =A0if (start_pos > i_size_read(inode)) {
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 7a084fb..7d3dd2f 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -2510,7 +2510,7 @@ static void btrfs_read_locked_inode(struct in=
ode *inode)
> >
> > =A0 =A0 =A0 =A0inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inod=
e_item));
> > =A0 =A0 =A0 =A0BTRFS_I(inode)->generation =3D btrfs_inode_generatio=
n(leaf, inode_item);
> > - =A0 =A0 =A0 BTRFS_I(inode)->sequence =3D btrfs_inode_sequence(lea=
f, inode_item);
> > + =A0 =A0 =A0 inode->i_version =3D btrfs_inode_sequence(leaf, inode=
_item);
> > =A0 =A0 =A0 =A0inode->i_generation =3D BTRFS_I(inode)->generation;
> > =A0 =A0 =A0 =A0inode->i_rdev =3D 0;
> > =A0 =A0 =A0 =A0rdev =3D btrfs_inode_rdev(leaf, inode_item);
> > @@ -2594,7 +2594,7 @@ static void fill_inode_item(struct btrfs_tran=
s_handle *trans,
> >
> > =A0 =A0 =A0 =A0btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(i=
node));
> > =A0 =A0 =A0 =A0btrfs_set_inode_generation(leaf, item, BTRFS_I(inode=
)->generation);
> > - =A0 =A0 =A0 btrfs_set_inode_sequence(leaf, item, BTRFS_I(inode)->=
sequence);
> > + =A0 =A0 =A0 btrfs_set_inode_sequence(leaf, item, inode->i_version=
);
> > =A0 =A0 =A0 =A0btrfs_set_inode_transid(leaf, item, trans->transid);
> > =A0 =A0 =A0 =A0btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
> > =A0 =A0 =A0 =A0btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->fl=
ags);
> > @@ -6884,7 +6884,6 @@ struct inode *btrfs_alloc_inode(struct super_=
block *sb)
> > =A0 =A0 =A0 =A0ei->root =3D NULL;
> > =A0 =A0 =A0 =A0ei->space_info =3D NULL;
> > =A0 =A0 =A0 =A0ei->generation =3D 0;
> > - =A0 =A0 =A0 ei->sequence =3D 0;
> > =A0 =A0 =A0 =A0ei->last_trans =3D 0;
> > =A0 =A0 =A0 =A0ei->last_sub_trans =3D 0;
> > =A0 =A0 =A0 =A0ei->logged_trans =3D 0;
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 54e7ee9..ee1bb31 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -770,7 +770,7 @@ static int btrfs_fill_super(struct super_block =
*sb,
> > =A0#ifdef CONFIG_BTRFS_FS_POSIX_ACL
> > =A0 =A0 =A0 =A0sb->s_flags |=3D MS_POSIXACL;
> > =A0#endif
> > -
> > + =A0 =A0 =A0 sb->s_flags |=3D MS_I_VERSION;
> > =A0 =A0 =A0 =A0err =3D open_ctree(sb, fs_devices, (char *)data);
> > =A0 =A0 =A0 =A0if (err) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("btrfs: open_ctree failed\n")=
;
> > --
> > 1.7.5.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>=20
> BTW.
> 1. where is BTRFS devel git tree?
> 2. when this is coming to mainline?
>=20

There's a bunch, my personal tree with just my patches is here

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git

a tree with all outstanding mailinglist patches is here

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

and Chris's tree which is where all things go through to get to mainlin=
e is here

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git

It will probably be in the next merge window.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
