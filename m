Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35209 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965627AbcLVPO3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 10:14:29 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.88)
        (envelope-from <kilobyte@angband.pl>)
        id 1cK54b-00059K-7s
        for linux-btrfs@vger.kernel.org; Thu, 22 Dec 2016 16:14:25 +0100
Date: Thu, 22 Dec 2016 16:14:25 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs_log2phys: cannot lookup extent mapping
Message-ID: <20161222151425.ecryyvnz2feaygrr@angband.pl>
References: <89be6fee-5b18-7a9d-11ea-85abeab28022@ece.wisc.edu>
 <pan$14679$e5d5bc21$812abe03$ef75194d@cox.net>
 <4e2fcf15-5af4-54b0-f7bb-46518b9bb5a4@ece.wisc.edu>
 <pan$67936$e25a272c$77926cea$931807ed@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$67936$e25a272c$77926cea$931807ed@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 22, 2016 at 10:11:35AM +0000, Duncan wrote:
> Given the maturing-but-not-yet-fully-stable-and-mature state of btrfs 
> today, being no further from a usable current backup than the data you're 
> willing to lose, at least worst-case, remains an even stronger 
> recommendation than it is on fully mature and stable filesystem, kernel 
> and hardware.

The usual rant about backups which I snipped is 110%[1] right, however I
disagree that btrfs is worse than other filesystems for data safety.

On one hand, btrfs:
* is buggy
* fails the KISS principle to a ridiculous degree
* lacks logic people take for granted (especially on RAID)
On the other, other filesystems:
* suffer from silent data loss every time the disk doesn't notice an error!
  Allowing silent data loss fails the most basic requirement for a
  filesystem.  Btrfs at least makes that loss noisy (single) so you can
  recover from backups, or handles it (redundant RAID).
* don't have frequent snapshots to save you from human error (including
  other software)
* make backups time-costly.  rsync needs to at least stat everything, on a
  populated disk that's often half an hour or more, on btrfs a no-op backup
  takes O(1).

So sorry, but I had enough woe with those "fully mature and stable"
filesystems.  Thus I use btrfs pretty much everywhere, backing up my crap
every 24 hours, important bits every 3 hours.


Meow!

[1]. Above 100% as it's more true than people read it.
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
