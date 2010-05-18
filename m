From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Mon, 17 May 2010 20:59:26 -0400
Message-ID: <20100518005926.GM8635@think>
References: <4BF18525.8080904@gmail.com>
 <20100517193652.GC8635@think>
 <4BF1DBCD.7060208@gmail.com>
 <20100518003032.GK8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jakob Unterwurzacher <jakobunt@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100518003032.GK8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 17, 2010 at 08:30:32PM -0400, Chris Mason wrote:
> On Tue, May 18, 2010 at 02:14:05AM +0200, Jakob Unterwurzacher wrote:
> > On 17/05/10 21:36, Chris Mason wrote:
> > > 
> > > That should be a zero second window, we try to force things to disk
> > > during renames.
> > > 
> > > Could you please try this patch:
> > > 
> > > diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> > > index c9f1020..9370a71 100644
> > > --- a/fs/btrfs/ordered-data.c
> > > +++ b/fs/btrfs/ordered-data.c
> > > @@ -806,7 +806,7 @@ int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
> > >  	 * if this file hasn't been changed since the last transaction
> > >  	 * commit, we can safely return without doing anything
> > >  	 */
> > > -	if (last_mod < root->fs_info->last_trans_committed)
> > > +	if (0 && last_mod < root->fs_info->last_trans_committed)
> > 
> > 
> > Ok, I upgraded to 2.6.34 final and switched to defconfig.
> > I only did the rename test ( i.e. no overwrite ), the window is now
> > 1.1s, both with vanilla and with the patch.
> 
> Thanks, so much for the easy fix.  I'll take a look.

Ohhhhh, I read your initial email wrong, I'm sorry.  The test we're
failing, the rentest, doesn't overwrite one file with another.  It is
just creating a file and then renaming it.

Btrfs is explicitly choosing not to sync the file in this case because
the rename isn't replacing good old data with new unwritten data.  The
rename is taking new unwritten data and giving it a different name.

Are there applications that rely on this? 

-chris

