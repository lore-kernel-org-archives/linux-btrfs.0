From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Mon, 17 May 2010 16:09:12 -0400
Message-ID: <20100517200912.GE8635@think>
References: <4BF18525.8080904@gmail.com>
 <20100517192554.GB2322@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jakob Unterwurzacher <jakobunt@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100517192554.GB2322@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 17, 2010 at 03:25:54PM -0400, Josef Bacik wrote:
> On Mon, May 17, 2010 at 08:04:21PM +0200, Jakob Unterwurzacher wrote:
> > Hi!
> > 
> > Following Ubuntu's dpkg+ext4 problems I wanted to see if btrfs would
> > solve them all. And it nearly does! Now I wonder if the remaining 0.2
> > seconds window of exposing 0-size files could be closed too.
> > 
> > I tested using two simple scripts (attached for reference) on kernel
> > 2.6.34-rc7:
> > - rentest creates files $i.tmp and renames to $i.cur,
> > - owtest does the same but overwrites existing $i.cur files,
> > letting them run for 30-50 seconds then resetting the virtual machine.
> > 
> > The results for ext3 are as expected: 0-size files are never exposed as
> > $i.cur, overwrites are atomic.
> > 
> > ext4 overwrites are /almost/ atomic (I get one 0-size file in owtest),
> > lots of 0-size files are exposed in rentest (30 seconds window).
> > 
> > btrfs *nearly* does as well as ext3. Overwrites are atomic.
> > 
> > The rentest exposes only a 0.2 seconds windows of 0-size $i.cur files,
> > so that a "ls --full-time" after the crash looks like this (notice the
> > time between 01281.cur and 01292.tmp, only 0.2 seconds):
> > [...]
> > -rw-r--r-- 1 root root 20 2010-05-17 17:06:25.812016407 +0200 01280.cur
> > -rw-r--r-- 1 root root 20 2010-05-17 17:06:25.835999490 +0200 01281.cur
> > -rw-r--r-- 1 root root  0 2010-05-17 17:06:25.868035485 +0200 01282.cur
> > [...]
> > -rw-r--r-- 1 root root  0 2010-05-17 17:06:26.080003626 +0200 01291.cur
> > -rw-rw-rw- 1 root root  0 2010-05-17 17:06:26.108010083 +0200 01292.tmp
> > 
> 
> This isn't actually true.  There is no window, the inode isn't written to disk
> until all of the data is flushed to disk.  So the in memory inode will be
> update, and therefore show an i_size of 0 since the io hasn't finished, but if
> you were to crash at this point, when you came back up you'd have the old data
> in place because the new inode data wasn't written to disk.  I have a feeling
> ext4 is the same way, but I'd have to check for sure.  Thanks,

Jacob, could you please confirm if your test includes a crash?

-chris

