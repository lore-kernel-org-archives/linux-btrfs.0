From: Andres Freund <andres@anarazel.de>
Subject: Re: [PATCH 1/2] LSEEK: BTRFS: Avoid i_mutex for SEEK_{CUR,SET,END}
Date: Wed, 7 Mar 2012 18:16:06 +0100
Message-ID: <201203071816.07282.andres@anarazel.de>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <20111102082915.GA28153@infradead.org> <20111105152749.GA5576@shiny>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>, robertmhaas@gmail.com,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111105152749.GA5576@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, November 05, 2011 04:27:49 PM Chris Mason wrote:
> On Wed, Nov 02, 2011 at 04:29:15AM -0400, Christoph Hellwig wrote:
> > Andres, can you check with Chris that the btrfs changes made it to
> > his tree?  The core lseek changes from Andi are in mainline now, but
> > I think these bits are better off going through Chrises btrfs tree.
> 
> I'm pulling these in, thanks!
I just stumbled uppon this email when opening up my email client which 
triggered me to recheck the issue - do you have pulled those? A very quick 
look didn't intoicate so.

Andres
> > On Sat, Oct 01, 2011 at 10:49:27PM +0200, Andres Freund wrote:
> > > Don't need the i_mutex for those cases, only for SEEK_HOLE/DATA.
> > > 
> > > Really-From: Andi Kleen <ak@linux.intel.com>
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > Signed-off-by: Andres Freund <andres@anarazel.de>
> > > ---
> > > 
> > >  fs/btrfs/file.c |   27 +++++++++++----------------
> > >  1 files changed, 11 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > > index 7a13337..5bc7116 100644
> > > --- a/fs/btrfs/file.c
> > > +++ b/fs/btrfs/file.c
> > > @@ -1809,24 +1809,19 @@ static loff_t btrfs_file_llseek(struct file
> > > *file, loff_t offset, int origin)
> > > 
> > >  	struct inode *inode = file->f_mapping->host;
> > >  	int ret;
> > > 
> > > +	if (origin != SEEK_DATA && origin != SEEK_HOLE)
> > > +		return generic_file_llseek(file, offset, origin);
> > > +
> > > 
> > >  	mutex_lock(&inode->i_mutex);
> > > 
> > > -	switch (origin) {
> > > -	case SEEK_END:
> > > -	case SEEK_CUR:
> > > -		offset = generic_file_llseek(file, offset, origin);
> > > -		goto out;
> > > -	case SEEK_DATA:
> > > -	case SEEK_HOLE:
> > > -		if (offset >= i_size_read(inode)) {
> > > -			mutex_unlock(&inode->i_mutex);
> > > -			return -ENXIO;
> > > -		}
> > > +	if (offset >= i_size_read(inode)) {
> > > +		mutex_unlock(&inode->i_mutex);
> > > +		return -ENXIO;
> > > +	}
> > > 
> > > -		ret = find_desired_extent(inode, &offset, origin);
> > > -		if (ret) {
> > > -			mutex_unlock(&inode->i_mutex);
> > > -			return ret;
> > > -		}
> > > +	ret = find_desired_extent(inode, &offset, origin);
> > > +	if (ret) {
> > > +		mutex_unlock(&inode->i_mutex);
> > > +		return ret;
> > > 
> > >  	}
> > >  	
> > >  	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
> > 
> > ---end quoted text---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
