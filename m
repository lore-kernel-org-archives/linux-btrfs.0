From: Chris Mason <chris.mason@oracle.com>
Subject: Re: sync-related lockdep warnings
Date: Mon, 15 Dec 2008 16:01:23 -0500
Message-ID: <1229374883.16295.27.camel@think.oraclecorp.com>
References: <Pine.LNX.4.64.0812151045270.3815@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812151045270.3815@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-12-15 at 11:01 -0800, Sage Weil wrote:
> Hi-
> 
> I've been regularly getting a lockdep warning on inode_lock vs tree->lock.  
> It is quickly triggered by my code, which calls ioctl(fd, BTRFS_IOC_SYNC) 
> (which just does a btrfs_sync_fs) at regular intervals.
> 
> 	http://ceph.newdream.net/dump/btrfs-lockdep-sync-ioctl.txt
> 
> The second warning is similar, but looks to be a bit more revealing.  It 
> is easily triggered by 'while [ 1 ] ; do sync ; done' and then something 
> like 'echo a > a' a few times.
> 
> 	http://ceph.newdream.net/dump/btrfs-lockdep-sync.txt
> 
> Let me know if there's any other info on my end that would help sort this 
> out...

If you pull from btrfs-unstable, this should be fixed.

Thanks,
Chris


