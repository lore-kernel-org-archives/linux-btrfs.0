From: Sage Weil <sage@newdream.net>
Subject: Re: inode data not getting included in commits?
Date: Fri, 19 Dec 2008 10:48:45 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0812191028020.29416@cobra.newdream.net>
References: <Pine.LNX.4.64.0812181536060.10446@cobra.newdream.net>
 <3d0408630812181726g7b1be6ey787ff0e6105cfa80@mail.gmail.com>
 <Pine.LNX.4.64.0812182104580.25096@cobra.newdream.net>
 <1229695975.6270.12.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yan Zheng <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1229695975.6270.12.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 Dec 2008, Chris Mason wrote:
> On Thu, 2008-12-18 at 21:21 -0800, Sage Weil wrote:
> > On Fri, 19 Dec 2008, Yan Zheng wrote:
> > > > I noticed some data and metadata getting out of sync on disk, despite
> > > > wrapping my writes with btrfs transactions.  After digging into it a bit,
> > > > it appears to be a larger problem with inode size/data getting written
> > > > during a regular commit.
> > > > [...]
> > > 
> > > This is the desired behaviour of data=ordered. Btrfs transaction commit
> > > don't flush data, and metadata wont get updated until data IO complete.
> > > 
> > > http://article.gmane.org/gmane.comp.file-systems.btrfs/869/match=new+data+ordered+code
> > 
> > Ah, right, so it is.
> > 
> > I think what I'm looking for then is a mount mode to get the old behavior, 
> > such that each commit flushes previously written data.  Probably a call to 
> > btrfs_wait_ordered_extents() in btrfs_commit_transaction(), or something 
> > along those lines...
> 
> Could you describe the end goal a bit?  I'm happy to make modes where
> it'll do what you need.

The end goal is for data to flush and commit with the transaction that was 
running when the write() occured.

So, after a sequence like
 write A
 setxattr B
 <crash>
you should always see A if you see B.

And after a sequence like
 ioctl(fd, BTRFS_IOC_TRANS_START)
 write A
 setxattr B
 close(fd)
 <crash>
you should see either both A and B or neither A nor B.

fsync() isn't really appropriate since it forces a commit (or a tree log 
entry?), and it would still be better to roll lots of operations up 
together.  Either a mount mode that includes dirty data in each 
transaction commit (and probably disables the tree log?), or a per-file 
fsync-like operation that commits an individual file's dirty data to the 
running transaction would do the trick.

sage
