From: Chris Mason <chris.mason@oracle.com>
Subject: Re: worse than expected compression ratios with -o compress
Date: Mon, 18 Jan 2010 16:29:51 -0500
Message-ID: <20100118212951.GC4065@think>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
 <20100118141240.GA10710@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Faulkner <jfaulkne@ccs.neu.edu>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100118141240.GA10710@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 18, 2010 at 09:12:40AM -0500, Josef Bacik wrote:
> On Sat, Jan 16, 2010 at 11:16:50AM -0500, Jim Faulkner wrote:
> >
> > I have a mysql database which consists of hundreds of millions, if not  
> > billions of Usenet newsgroup headers.  This data should be highly  
> > compressable, so I put the mysql data directory on a btrfs filesystem  
> > mounted with the compress option:
> > /dev/sdi on /var/news/mysql type btrfs (rw,noatime,compress,noacl)
> >
> > However, I'm not seeing the kind of compression ratios that I would 
> > expect with this type of data.  FYI, all my tests are using Linux 
> > 2.6.32.3. Here's my current disk usage:
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/sdi              302G  122G  181G  41% /var/news/mysql
> >
> > and here's the actual size of all files:
> > delta-9 mysql # pwd
> > /var/news/mysql
> > delta-9 mysql # du -h --max-depth=1
> > 747K    ./mysql
> > 0       ./test
> > 125G    ./urd
> > 125G    .
> > delta-9 mysql #
> >
> > As you can see, I am only shaving off 3 gigs out of 125 gigs worth of 
> > what should be very compressable data.  The compressed data ends up being 
> > around 98% the size of the original data.
> >
> > To contrast, rzip can compress a database dump of this data to around 7%  
> > of its original size.  This is an older database dump, which is why it is 
> > smaller.  Before:
> > -rw------- 1 root root  69G 2010-01-15 14:55 mysqlurdbackup.2010-01-15
> > and after:
> > -rw------- 1 root root 5.2G 2010-01-16 05:34 mysqlurdbackup.2010-01-15.rz
> >
> > Of course it took 15 hours to compress the data, and btrfs wouldn't be  
> > able to use rzip for compression anyway.
> >
> > However, I still would expect to see better compression ratios than 98% 
> > on such data.  Are there plans to implement a better compression 
> > algorithm? Alternatively, is there a way to tune btrfs compression to 
> > achieve better ratios?
> >
> 
> Currently the only compression algorithm we support is gzip, so try gzipp'ing
> your database to get a better comparison.  The plan is to eventually support
> other compression algorithms, but currently we do not.  Thanks,

The compression code backs off compression pretty quickly if parts of
the file do not compress well.  This is another way of saying it favors
CPU time over the best possible compression.  If gzip ends up better
than what you're getting from btrfs, I can give you a patch to force
compression all the time.

-chris

