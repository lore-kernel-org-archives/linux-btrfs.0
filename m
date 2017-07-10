Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39338 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdGJG7p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 02:59:45 -0400
Date: Sun, 9 Jul 2017 23:59:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20170710065940.x7ouz5dxsynrbhbx@merlins.org>
References: <20170709053228.donh2nh75idlzfck@merlins.org>
 <pan$de201$b4e6d9dd$ac883479$6ac66e5b@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$de201$b4e6d9dd$ac883479$6ac66e5b@cox.net>
Subject: Re: Can I drop/reset files with corrupted data if they are in a read
 only snapshot?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the Cc/ping, I appreciate it

On Sun, Jul 09, 2017 at 11:38:51AM +0000, Duncan wrote:
> At your own risk you can try using btrfs property to set the ro snapshot 
> to rw.  Then you can delete the corrupted files and reset the snapshot 
> back to ro.
> 
> Of course you'll need to do the same thing on both the send and receive 
> side in ordered to keep the two reference snapshots in sync.
> 
> However, because my use-case doesn't involve send/receive, I've not been 
> able to personally verify that the above procedure doesn't screw up an 
> incremental send/receive job using that modified snapshot as a 
> reference.  There has been one report on the list of someone who did the 

On the plus side, on FS #1, I was able to do this, clear all the
corrupted blocks and both scrub and btrfs check come back clean.

On the 2nd one with more corruption, I'm very saddened to say that I did
clear all the blocks, and on my next scrub I got new files that had
corruption and didn't show up on the previous scrub (!).
So, I rebooted from 4.11 to 4.8 and I'm doing a new scrub will clear all
those blocks too, and see if it stays that way, or not.

For reference the steps look like this:
gargamel:/mnt/btrfs_pool1# btrfs property set Video_ro.20170625_01:23:05 ro false
truncate damaged files
gargamel:/mnt/btrfs_pool1# btrfs property set Video_ro.20170625_01:23:05 ro true
gargamel:/mnt/btrfs_pool1# btrfs scrub start -Bd /mnt/btrfs_pool1
scrub device /dev/mapper/dshelf1 (id 1) done
        scrub started at Sun Jul  9 08:05:44 2017 and finished after 11:31:58
        total bytes scrubbed: 10.43TiB with 0 errors
gargamel:/mnt/btrfs_pool1#

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
