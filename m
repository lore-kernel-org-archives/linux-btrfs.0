From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: BUG() in btrfs-fixup (Was: btrfs invalid opcode)
Date: Wed, 27 Jul 2011 09:33:24 +0100
Message-ID: <chaz20110727083324.GA967@seebyte.com>
References: <j0k65i$29a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <j0k65i$29a$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-25 17:38:10 +0100, Jeremy Sanders:
> I'm afraid this is a rather old kernel, 2.6.35.13-92.fc14.x86_64, but this 
> error looks rather similiar to 
> http://www.spinics.net/lists/linux-btrfs/msg11053.html
> 
> Has this been fixed? I was simultaneously doing rsyncs into different 
> subvolumes (one reading and one writing).
[...]
> [454244.123523] kernel BUG at fs/btrfs/inode.c:1528!
[...]
> [454244.124338] Pid: 3158, comm: btrfs-fixup-0 Not tainted 
> 2.6.35.13-92.fc14.x86_64 #1 C51MCP51/C51GM03
> [454244.124338] RIP: 0010:[<ffffffffa048ed89>]  [<ffffffffa048ed89>] 
> btrfs_writepage_fixup_worker+0xde/0x118 [btrfs]
[...]

Hi Jeremy,

glad I'm not the only one with that issue. That may renew the
interest in it...

I don't think much progress has been made on it.

We could compare our experience to see what contributes to its
occurrence.

It occurs (quite reproducibly) for me when rsyncing from a
multi-device multi-subvolume btrfs fs (mounted with
compress-force) onto a single device, no subvolume btrfs fs also
mounted with compress-force. It also happens when the target is
mounted with compress instead of compress-force but not if I
leave out "compress".

I only get one occurrence of those BUG()s until I reboot.

After the occurrence of that BUG(), I saw a number of
misbehaviors that may or may not be linked to it:

- btrfs eating all memory (mostly in the btrfs_inode_cache slab)
  resulting in crash. That doesn't happen anymore since I'm
  mounting with no atime and use CONFIG_SLUB (though I suspect
  it's noatime alone that did the trick)

- occasionally, 20 to 95% of write(2) system calls to files on
  the source FS take 4 seconds, making it hardly usable. I also
  notice a flush-btrfs-1 stuck in "D" state

How does that compare with your experience?

-- 
Stephane
