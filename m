From: Kiran Patil <kirantpatil@gmail.com>
Subject: bcache with SSD instead of battery powered raid cards
Date: Tue, 13 Mar 2012 15:36:44 +0530
Message-ID: <CANT588ujRWQtreA07dPK9ynj7dXVGykRMXjcQy_kFd3mFimZ6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is anybody using bcache with SSD instead of battery powered raid cards
with Btrfs ?

Hard drives are cheap and big, SSDs are fast but small and expensive.
Wouldn't it be nice if you could transparently get the advantages of
both? With Bcache, you can have your cake and eat it too.

Bcache is a patch for the Linux kernel to use SSDs to cache other
block devices. It's analogous to L2Arc for ZFS, but Bcache also does
writeback caching, and it's filesystem agnostic. It's designed to be
switched on with a minimum of effort, and to work well without
configuration on any setup. By default it won't cache sequential IO,
just the random reads and writes that SSDs excel at. It's meant to be
suitable for desktops, servers, high end storage arrays, and perhaps
even embedded.

http://bcache.evilpiepirate.org/

http://news.gmane.org/gmane.linux.kernel.bcache.devel

Thanks,
Kiran.
