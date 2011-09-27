From: Artem <artemciy@gmail.com>
Subject: File compression control, again.
Date: Tue, 27 Sep 2011 17:17:18 +0000 (UTC)
Message-ID: <loom.20110927T185853-434@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

So, it makes sense to keep the compression on by default
and with LZO many people are going there.

But, I want to create a database on a compressed btrfs filesystem
which is seek-heavy rather than throughput-heavy
and I really want to turn the compression off just for that database
(smaller I/O reads, more precise cache usage).

Maintenance nightmare that Miguel mentioned
( http://thread.gmane.org/gmane.comp.file-systems.btrfs/1665/focus=1669 )
isn't really a problem as I'm going to automatically set the flags
from the program, just before opening the database.

Looking at "fs/btrfs/ioctl.h" I don't see any way to to this.
Subvolume compression control isn't working either from what I heard
(cf. https://bbs.archlinux.org/viewtopic.php?id=126635
     http://thread.gmane.org/gmane.comp.file-systems.btrfs/6237/ ).

Am I right that fine-grained compression control is no longer supported by btrfs?
If so, I would like to vote for it to be added.

