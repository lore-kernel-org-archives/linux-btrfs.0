Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.sr71.net ([198.145.64.142]:59133 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbcCPUxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 16:53:21 -0400
To: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>
From: Dave Hansen <dave@sr71.net>
Subject: qgroup code slowing down rebalance
Message-ID: <56E9C7BB.7060509@sr71.net>
Date: Wed, 16 Mar 2016 13:53:15 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a medium-sized multi-device btrfs filesystem (4 disks, 16TB
total) running under 4.5.0-rc5.  I recently added a disk and needed to
rebalance.  I started a rebalance operation three days ago.  It was on
the order of 20% done after those three days. :)

During this rebalance, the disks were pretty lightly used.  I would see
a small burst of tens of MB/s, then it would go back to no activity for
a few minutes, small burst, no activity, etc...  During the quiet times
(for the disk) one processor would be pegged inside the kernel and would
have virtually no I/O wait time.  Also during this time, the filesystem
was pretty unbearably slow.  An ls of a small directory would hang for
minutes.

A perf profile shows 92% of the cpu time is being spend in
btrfs_find_all_roots(), called under this call path:

	btrfs_commit_transaction
	 -> btrfs_qgroup_prepare_account_extents
	   -> btrfs_find_all_roots

So I tried disabling quotas by doing:

	btrfs quota disable /mnt/foo

which took a few minutes to complete, but once it did, the disks went
back up to doing ~200MB/s, the kernel time went down to ~20%, and the
system now has lots of I/O wait time.  It looks to be behaving nicely.

Is this expected?  From my perspective, it makes quotas pretty much
unusable at least during a rebalance.  I have a full 'perf record'
profile with call graphs if it would be helpful.
