From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] Btrfs: setup blank root and fs_info for mount time
Date: Mon, 22 Nov 2010 20:59:24 +0800
Message-ID: <1290430764.2602.26.camel@perseus.themaw.net>
References: <1290196755-19607-1-git-send-email-josef@redhat.com>
	 <1290392498.2602.21.camel@perseus.themaw.net>
	 <4CEA3624.8050002@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CEA3624.8050002@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-11-22 at 17:21 +0800, Li Zefan wrote:
> > Have a look in fs/super.c:generic_shutdown_super(), called by
> > fs/super.c:kill_anon_super(), where the super method ->put_super() is
> > called, setting the super s_fs_info to NULL, before taking the sb_lock
> > and removing it from the list of supers.
> > 
> > Here's my patch.
> > 
> > btrfs - fix race between btrfs_get_sb() and umount
> > 
> > From: Ian Kent <raven@themaw.net>
> > 
> > When mounting a btrfs file system btrfs_test_super() may attempt to
> > use sb->s_fs_info, the btrfs root, of a super block that is going away
> > and that has had the btrfs root set to NULL in its ->put_super(). But
> > if the super block is going away it cannot be an existing super block
> > so we can return false in this case.
> 
> I think your analysis is right.
> 
> Actually I ran the test script (posted in an earlier email), and it
> still crashed without your supplementary patch.

And vice versa, as we found out working the Fedora bug, when I thought
this was the actual bug at one point, both patches are needed.

> 
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> > 
> >  fs/btrfs/super.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 6b57da3..960b320 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -565,6 +565,12 @@ static int btrfs_test_super(struct super_block *s, void *data)
> >  	struct btrfs_fs_devices *test_fs_devices = data->fs_info->fs_devices;
> >  	struct btrfs_root *root = btrfs_sb(s);
> >  
> > +	/*
> > +	 * If this super block is going away, return false as it
> > +	 * can't match as an existing super block.
> > +	 */
> > +	if (!atomic_read(&s->s_active))
> > +		return 0;
> >  	return root->fs_info->fs_devices == test_fs_devices;
> >  }
> >  
> > 


