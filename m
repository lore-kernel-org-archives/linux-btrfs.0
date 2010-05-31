From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch 5/11] btrfs: remove unneeded null check in
	btrfs_rename()
Date: Mon, 31 May 2010 09:25:18 +0200
Message-ID: <20100531072518.GO5483@bicker>
References: <20100529094508.GF5483@bicker> <AANLkTikLkpTgkOGi8M8VL_rZRLyzbJKoKW9RiNMJenMi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikLkpTgkOGi8M8VL_rZRLyzbJKoKW9RiNMJenMi@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 29, 2010 at 11:01:56AM -0700, Mike Fedyk wrote:
> On Sat, May 29, 2010 at 2:45 AM, Dan Carpenter <error27@gmail.com> wr=
ote:
> > "old_inode" cannot be null here, because we dereference it
> > unconditionally throughout the function.
> >
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index fa6ccc1..0bc29be 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6487,10 +6487,8 @@ static int btrfs_rename(struct inode *old_di=
r, struct dentry *old_dentry,
> > =A0 =A0 =A0 =A0 * make sure the inode gets flushed if it is replaci=
ng
> > =A0 =A0 =A0 =A0 * something.
> > =A0 =A0 =A0 =A0 */
> > - =A0 =A0 =A0 if (new_inode && new_inode->i_size &&
> > - =A0 =A0 =A0 =A0 =A0 old_inode && S_ISREG(old_inode->i_mode)) {
> > + =A0 =A0 =A0 if (new_inode && new_inode->i_size && S_ISREG(old_ino=
de->i_mode))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_add_ordered_operation(trans, r=
oot, old_inode);
> > - =A0 =A0 =A0 }
>=20
> I think code like this is here because there are still a lot of
> features that are being added to btrfs and it's easier to have the
> additional checks than continually adding and removing them as the
> code changes.

Right right.  I understand about extra checks and api changes.  But in
this case that doesn't aply.  There is no way this particular check hel=
ps
now or in the future, and it just wastes time when someone is auditing
for inconsistent null checking.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
