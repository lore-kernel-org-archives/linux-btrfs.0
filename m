From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: BUG at fs/buffer.c:2933 during umount
Date: Tue, 5 May 2009 12:51:03 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0905051246380.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0905051212210.6162@bogon.housecafe.de> <1241551898.7244.99.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1241551898.7244.99.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 May 2009, Chris Mason wrote:
> Somehow xen is turning a barrier request into an IO error.  That's
> really quite strange, but you can mount -o nobarrier.

Thanks for the quick reply - yes, that helped. So, is that something I 
should report to the Xen folks? These "other filesystems" I can unmount 
with no BUG :-)


I just noted something else, but completely unrelated to that barrier 
stuff:

# ls -ld /mnt/d*
dr-xr-xr-x 1 root root    0 Jan  1  1970 /mnt/d1
drwxr-xr-x 3 root root 4096 May  5 21:45 /mnt/d2
# grep mnt/d /proc/mounts 
/dev/xvdb /mnt/d1 btrfs rw,relatime,nobarrier 0 0
/dev/xvdc /mnt/d2 ext3 rw,relatime,errors=continue,data=writeback 0 0

How comes btrfs thinks it has been created at the beginning of time?

Christian.
-- 
Strong cryptography does not exist for Bruce Schneier. There is only weak and
less weak cryptography.
