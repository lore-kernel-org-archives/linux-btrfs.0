From: Chris Mason <chris.mason@oracle.com>
Subject: Re: worse than expected compression ratios with -o compress
Date: Thu, 21 Jan 2010 15:05:41 -0500
Message-ID: <20100121200541.GB23006@think>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
 <20100118141240.GA10710@localhost.localdomain>
 <20100118212951.GC4065@think>
 <alpine.DEB.2.00.1001181706590.31608@alumni-linux.ccs.neu.edu>
 <20100120163011.GE3001@think>
 <alpine.DEB.2.00.1001211224530.19136@alumni-linux.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1001211224530.19136@alumni-linux.ccs.neu.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2010 at 01:16:31PM -0500, Jim Faulkner wrote:
> delta-9 ~ # mount -o noatime,noacl,compress-force /dev/sdi /var/news/mysql
> delta-9 ~ # time cp -a /nfs/media/tmp/btrfs-mysql-test /var/news/mysql/
> 
> real    14m45.742s
> user    0m0.547s
> sys     1m30.551s
> delta-9 ~ # df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdi              187G   14G  173G   8% /var/news/mysql
> delta-9 ~ # cd /var/news/mysql
> delta-9 mysql # du -h --max-depth=1
> 73G     ./btrfs-mysql-test
> 73G     .
> delta-9 mysql #
> 
> Wow!  So not only did mount -o compress-force achieve a 19%
> compression ratio, using 53 GB less disk space than mount -o
> compress, it managed to copy the data in only 15 minutes, compared
> to 57 minutes with mount -o compress.
> 
> The disk in question is an old IDE disk in a cheap external USB 2.0
> enclosure, which is probably not exactly the type of storage that
> btrfs is being developed for.  Nevertheless, it is nice to see such
> a huge improvement in the time required to copy the data around.
> 
> I'd be very happy to see the -o compress-force option in the
> mainline kernel someday!

Great, it is working here so I'll queue it up as well.

The performance improvement just comes from writing less to the disk.
Your first run copied 67GB in 57m6s, which comes out to about 20MB/s
write throughput.

Your compress-force run copied 14GB in 14m45s, which gives us
around 16 or 17MB/s (depending on df rounding).  So, we either lost a
little drive throughput due to overhead in the compression code or the
run was totally CPU bound.

If you look at the output from 'time' the two runs appear to be using
the same amount of system time (cpu time in the kernel).  But, most of
the compression is done by helper threads, so the cpu time spent
compressing data doesn't show up.

Just a quick clarification that we didn't make your drive faster, we
just traded CPU for disk.  Most of the time that's a safe trade,
especially when you put usb and ide into the same sentence ;)

Either way, thanks for testing this out.  Do you happen to remember how
small the file becomes when you just plain gzip it?

-chris

