From: Sage Weil <sage@newdream.net>
Subject: sync-related lockdep warnings
Date: Mon, 15 Dec 2008 11:01:29 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0812151045270.3815@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi-

I've been regularly getting a lockdep warning on inode_lock vs tree->lock.  
It is quickly triggered by my code, which calls ioctl(fd, BTRFS_IOC_SYNC) 
(which just does a btrfs_sync_fs) at regular intervals.

	http://ceph.newdream.net/dump/btrfs-lockdep-sync-ioctl.txt

The second warning is similar, but looks to be a bit more revealing.  It 
is easily triggered by 'while [ 1 ] ; do sync ; done' and then something 
like 'echo a > a' a few times.

	http://ceph.newdream.net/dump/btrfs-lockdep-sync.txt

Let me know if there's any other info on my end that would help sort this 
out...

sage

