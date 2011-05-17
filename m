From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: ssd option for USB flash drive?
Date: Tue, 17 May 2011 23:02:52 +0100
Message-ID: <20110517220252.GA12323@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

I've not found much detail on what the "ssd" btrfs mount option
did. Would it make sense to enable it to a fs on a USB flash
drive?

I'm using btrfs (over LVM) on a Live Linux USB stick to benefit
from btrfs's compression and am trying to improve the
performance.

Would anybody have any recommendation on how to improve
performance there? Like what would be the best way to
enable/increase writeback buffer or any way to make sure writes
are delayed and asynchronous? Would disabling read-ahead help?
(at which level would it be done?). Any other tip (like
disabling atime, aligning blocks/extents, figure out erase block
sizes if relevant...)?

Many thanks in advance,
Stephane
