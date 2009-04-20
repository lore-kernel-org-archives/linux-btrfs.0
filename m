From: Chris Mason <chris.mason@oracle.com>
Subject: Unstable tree updated to 2.6.29-rc2
Date: Mon, 20 Apr 2009 16:32:19 -0400
Message-ID: <1240259539.7114.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've updated the unstable tree to 2.6.29-rc2 and pushed out some of the
pending fixes.  This has my current fixes for fsync latency, which make
btrfs behave much better when mixing synchronous and async writes.

-chris


