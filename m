From: Chris Mason <chris.mason@oracle.com>
Subject: new disk format pushed to btrfs-unstable
Date: Thu, 21 Aug 2008 16:00:11 -0400
Message-ID: <1219348811.7854.71.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pulled in David's NFS changes and directory hashing change.  This
means the btrfs-unstable tree now has a new disk format.

All of the critical performance and stability fixes are in the
btrfs-stable tree, without disk format changes.  I'll continue putting
anything important there until the next release.

Thanks to David and Balaji Rao for getting NFS support working!

-chris


