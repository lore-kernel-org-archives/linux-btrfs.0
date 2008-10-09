From: Chris Mason <chris.mason@oracle.com>
Subject: New disk format pushed out to the git tree
Date: Thu, 09 Oct 2008 13:44:04 -0400
Message-ID: <1223574244.14090.37.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Yan Zheng's latest commit redoes the extent back references to make them
more efficient.  This includes a new disk format, so any pulls from the
git unstable trees will have a new disk format to them.

I've bumped the magic in both the kernel and progs repos, so you can't
accidentally mount an FS with the wrong format.

I still hope to finish off compression this week, which will be yet
another format bump.

-chris


