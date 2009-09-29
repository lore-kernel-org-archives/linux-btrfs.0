From: Chris Mason <chris.mason@oracle.com>
Subject: ENOSPC patches integrated into the master branch
Date: Tue, 29 Sep 2009 14:42:38 -0400
Message-ID: <20090929184238.GD7283@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, Steven Pratt <slpratt@austin.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

A quick note that Josef's ENOSPC work is now integrated in the master
branch of the btrfs-unstable repo.  There is still a small window in his
accounting where ENOSPC oopsen can creep in, but the code is doing very
well here and the worst case estimates he uses are conservative enough
that I haven't been able to hit it yet.

My plan is to push this out for 2.6.32-rc2 and fine tune any performance
problems we find from there.  Josef is continuing to improve the code so
we'll have updates throughout the release cycle.

Eric and Steve, if you could both feed this into your respective torture
tests, it would be great.

ENOSPC gotchas:

btrfs-vol -b and device shrinking don't yet do all the checks required
for proper enospc support.  They do have some checks in place and most
of the time they will be fine, but we need to add more.

You probably won't hit 100% device utilization.  Btrfs splits up the
disk into metadata and data areas in relatively large chunks of about
1GB (sometimes more in multi-device setups).

This means you can end up with some space dedicated to metadata that
can't be used as data.

-chris

