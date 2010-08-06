From: Steven Pratt <steve@dangyankee.net>
Subject: 2.6.35 performance results
Date: Fri, 06 Aug 2010 13:44:11 -0500
Message-ID: <4C5C57FB.4090003@dangyankee.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here is the latest set of performance runs from the 2.6.35-rc5 tree. 
Included is a refresh of all the other filesystems with some changes for 
barriers on and off since this has been somewhat of a hot topic recently. 

New data linked in to the history graphs here:
http://btrfs.boxacle.net/repository/raid/history/History.html

 From a BTRFS performance perspective, we took a major regression on 
write heavy workloads. As much as a 10x hit!  The problems seems to be 
due to this changeset:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=5da9d01b66458b180a6bee0e637a1d0a3effc622
Btrfs: Shrink delay allocated space in a synchronized

Shrink delayed allocation space in a synchronized manner is more
controllable than flushing all delay allocated space in an async
thread.

This changeset introduced "btrfs_start_one_delalloc_inode" in
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commitdiff;h=5da9d01b66458b180a6bee0e637a1d0a3effc622

In heavy write workloads this new function is now dominating the profiles:

samples  %        app name                 symbol name
8914973  65.1261  btrfs.ko                 btrfs_start_one_delalloc_inode
1024841   7.4867  vmlinux-2.6.35-rc5-autokern1 rb_get_reader_page
716046    5.2309  vmlinux-2.6.35-rc5-autokern1 ring_buffer_consume
315354    2.3037  oprofile.ko              add_event_entry
202484    1.4792  vmlinux-2.6.35-rc5-autokern1 write_inode_now
195018    1.4247  btrfs.ko                 btrfs_tree_lock


Appears to be major contention on the spin lock, as this gets worse with 
more threads.  This needs to be redone.


Steve
