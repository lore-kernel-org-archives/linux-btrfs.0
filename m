From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.31-rc7] warning: i_state not free/freeing/clear...
Date: Fri, 28 Aug 2009 18:06:48 +0100
Message-ID: <6278d2220908281006w5e73434ep4886fad1f2daec8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With 2.6.31-rc7, I just hit the warning at fs/btrfs/inode.c:3120 [1]
on my NFS4 server.

I ran the current btrfsck on my 500GB partition while still on rc7 a
week ago - if this would have cleared it, then it's a race that still
exists in rc7.

Let me know if more info would be helpful, or if you'd like the
stacktrace, as I can resolve the symbols by hand.

Many thanks,
  Daniel

--- [1]

WARN_ON(!(entry->vfs_inode.i_state & (I_WILL_FREE | I_FREEING | I_CLEAR)));
-- 
Daniel J Blueman
