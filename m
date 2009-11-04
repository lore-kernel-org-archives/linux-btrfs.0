From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 00/10] btrfs: Error handling/propagation queue
Date: Wed, 04 Nov 2009 14:03:46 -0500
Message-ID: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch series fixes a few existing problems and then addresses
 the need for better error handling and propagation in btrfs.

 The handling and propagation patch set first finds all locations of
 a particular condition not being checked and annotates them with
 BTRFS_UERROR to designate that there is an error condition that
 is currently unhandled but should be. Then, another patch traverses
 the call path to ensure that errors are properly propogated. When the
 fix for recovering or passing the error is obvious, we do that too.

 This set is not complete and I expect there to be more fixes coming. In
 particular, it currently only annotates btrfs_alloc_path failures as
 the call graph for it is quite large. This is in response to Chris asking
 for what I already have instead of waiting for it to be complete.

 -Jeff

-- 
Jeff Mahoney
SUSE Labs
