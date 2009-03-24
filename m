From: Chris Mason <chris.mason@oracle.com>
Subject: btrfs-unstable updates
Date: Tue, 24 Mar 2009 17:03:22 -0400
Message-ID: <1237928602.5633.25.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The experimental branch is proving pretty stable, and growing important
fixes, so I've rebased those commits on top of 2.6.29 into the master
branch.  These aren't quite ready for sending to Linus, but pretty
close.

I'll also pull in fixes the mailing list has collected for the master
branch.

I've put all of my locking work into the experimental branch, along with
some cleanups from Josef.  This stuff is still pretty dangerous, but
they make a very big difference on lock contention.

-chris


