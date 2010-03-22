From: Josef Bacik <josef@redhat.com>
Subject: Re: locking problems: Btrfs: be more selective in the defrag ioctl
Date: Mon, 22 Mar 2010 10:09:20 -0400
Message-ID: <20100322140920.GB2383@localhost.localdomain>
References: <20100320113851.GB5331@bicker> <20100322134720.GA2383@localhost.localdomain> <20100322140330.GR21571@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dan Carpenter <error27@gmail.com>, Josef Bacik <josef@redhat.com>,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100322140330.GR21571@bicker>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 22, 2010 at 05:03:30PM +0300, Dan Carpenter wrote:
> On Mon, Mar 22, 2010 at 09:47:21AM -0400, Josef Bacik wrote:
> > On Sat, Mar 20, 2010 at 02:38:51PM +0300, Dan Carpenter wrote:
> > > Hi Chris,
> > > 
> > > There is a locking problem in 
> > > 	940100a4a7b78 "Btrfs: be more selective in the defrag ioctl"
> > > 
> > > There are two places where we break out of the while loop under the 
> > > lock.
> > > 
> > > fs/btrfs/ioctl.c +708 btrfs_defrag_file(159) error: double lock 'mutex:&inode->i_mutex'
> > >    600                  mutex_lock(&inode->i_mutex);
> > >    601                  if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
> > >    602                          BTRFS_I(inode)->force_compress = 1;
> > >    603  
> > >    604                  ret = btrfs_check_data_free_space(root, inode, PAGE_CACHE_SIZE);
> > >    605                  if (ret) {
> > >    606                          ret = -ENOSPC;
> > >    607                          break;
> > > 
> > > 	Here.
> > > 
> > >    608                  }
> > >    609  
> > >    610                  ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
> > >    611                  if (ret) {
> > >    612                          btrfs_free_reserved_data_space(root, inode,
> > >    613                                                         PAGE_CACHE_SIZE);
> > >    614                          ret = -ENOSPC;
> > >    615                          break;
> > > 
> > > 	And here.
> > > 
> > >    616                  }
> > > 
> > > Maybe we should have "goto err_reservations;" instead of break?  I
> > > don't know the code well enough to say.
> > 
> > No, everything is accounted for correctly.  If the metadata reservation fails,
> > we free the data space reservation and break.  If the data space reservation
> > fails, we're good to go and can just exit.  Thanks,
> > 
> 
> What about the lock on line 606?
> 
> > >    600                  mutex_lock(&inode->i_mutex);
> 
> If we break on line 615 or 607 that means that we return with the lock 
> held, or if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) is true then we
> dead lock.
> 

Ahh yeah you are right, should probably just put a mutex_unlock before the break
in both cases.  Thanks,

Josef
