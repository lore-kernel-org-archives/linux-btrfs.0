From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG at fs/buffer.c:2933 during umount
Date: Tue, 05 May 2009 15:58:53 -0400
Message-ID: <1241553533.7244.104.camel@think.oraclecorp.com>
References: <alpine.DEB.2.01.0905051212210.6162@bogon.housecafe.de>
	 <1241551898.7244.99.camel@think.oraclecorp.com>
	 <alpine.DEB.2.01.0905051246380.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.0905051246380.6162@bogon.housecafe.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-05-05 at 12:51 -0700, Christian Kujau wrote:
> On Tue, 5 May 2009, Chris Mason wrote:
> > Somehow xen is turning a barrier request into an IO error.  That's
> > really quite strange, but you can mount -o nobarrier.
> 
> Thanks for the quick reply - yes, that helped. So, is that something I 
> should report to the Xen folks? These "other filesystems" I can unmount 
> with no BUG :-)

For ext3, mount -o barrier=1 and you should see something exciting.  It
won't BUG because ext3 isn't as serious about telling the users about IO
problems as we are, but you should at least see messages.

> 
> 
> I just noted something else, but completely unrelated to that barrier 
> stuff:
> 
> # ls -ld /mnt/d*
> dr-xr-xr-x 1 root root    0 Jan  1  1970 /mnt/d1
> drwxr-xr-x 3 root root 4096 May  5 21:45 /mnt/d2
> # grep mnt/d /proc/mounts 
> /dev/xvdb /mnt/d1 btrfs rw,relatime,nobarrier 0 0
> /dev/xvdc /mnt/d2 ext3 rw,relatime,errors=continue,data=writeback 0 0
> 
> How comes btrfs thinks it has been created at the beginning of time?

The mkfs.btrfs command needs to properly set the date on the root
directory.  Sorry, I never noticed that one.

-chris


