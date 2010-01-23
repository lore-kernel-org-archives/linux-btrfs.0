From: "Michael Niederle" <mniederle@gmx.at>
Subject: btrfsck failed
Date: Sat, 23 Jan 2010 14:49:02 +0100
Message-ID: <20100123144902.43dafd60@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I tried an (offline) btrfsck and got the following error message:

> btrfsck /dev/sdb3
btrfsck: btrfsck.c:584: splice_shared_node: Assertion `!(src ==
&src_node->root_cache)' failed. Aborted

I use kernel version 2.6.32.2 with builtin btrfs-drivers.

Greetings, Michael
