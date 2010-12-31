From: "Ken D'Ambrosio" <ken@jots.org>
Subject: "Failed to read block groups" -- is this a problem?
Date: Fri, 31 Dec 2010 12:01:19 -0500 (EST)
Message-ID: <30d9d219de101068ecd3dd993a9b0620.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "Linux Btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey, all.  I'm dealing with a potentially flaky 3Ware controller.  Got
seven 2 TB disks in a RAID-6.  The BTRFS partition is a 9 TB partition. 
I've had to do a couple hard shutdowns on the system, and now I'm getting
sporadic "Failed to read block groups" errors in dmesg:

root@parsley:~# dmesg | egrep "Failed to read block groups:|btrfs"
[   27.184179] Failed to read block groups: -5
[   27.295231] btrfs: open_ctree failed
[ 2758.862565] Failed to read block groups: -5
[ 2758.896175] btrfs: open_ctree failed
[ 3292.539509] Failed to read block groups: -5
[ 3292.591306] btrfs: open_ctree failed


Is this a Bad Thing?  Is there something I should do to try to rectify
this?  Running Ubuntu with its 2.6.37-11-server kernel (64-bit).

Thanks!

-Ken




