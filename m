From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: [PATCH] Btrfs: Don't error on resizing FS to same size
Date: Fri, 18 Nov 2011 08:14:29 +0000
Message-ID: <20111118081428.GA27710@gmail.com>
References: <20111117210433.GA1817@gmail.com>
 <4EC5E470.4030605@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC5E470.4030605@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2011 at 03:52:00PM +1100, Chris Samuel wrote:
> On 18/11/11 08:04, Mike Fleetwood wrote:
> 
> > It seems overly harsh to fail a resize of a btrfs file system to the
> > same size when a shrink or grow would succeed.  User app GParted trips
> > over this error.  Allow it by bypassing the shrink or grow operation.
> 
> OK - I'm a newbie with the code (and I'm looking at Linus's current git
> rather than any dev tree of Chris's), but...
> 
> > Signed-off-by: Mike Fleetwood <mike.fleetwood@googlemail.com>
> > ---
> [...]
> > ---
> >  fs/btrfs/ioctl.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index dae5dfe..00b7024 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -1251,7 +1251,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
> >  		}
> >  		ret = btrfs_grow_device(trans, device, new_size);
> >  		btrfs_commit_transaction(trans, root);
> > -	} else {
> > +	} else if (new_size > old_size) {
> 
> shouldn't that be:
> 
> +	} else if (new_size < old_size) {
> 
> otherwise you'll never try and shrink if new_size is < old_size..
> 
> >  		ret = btrfs_shrink_device(device, new_size);
> >  	}
> >  

Chris, you're correct.  I have messed up a 1 line patch by rushing.
Will send corrected patch after some more testing!

Embarrassed,
Mike
