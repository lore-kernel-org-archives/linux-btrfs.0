From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs experimental branch updates
Date: Fri, 13 Mar 2009 11:56:14 -0400
Message-ID: <1236959774.17095.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've rebased the experimental branch to include most of the
optimizations I've been working on.

The two major changes are doing all extent tree operations in delayed
processing queues and removing many of the blocking points with btree
locks held.

In addition to smoothing out IO performance, these changes really cut
down on the amount of stack btrfs is using, which is especially
important for kernels with 4k stacks enabled (fedora).

-chris


