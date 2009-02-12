From: Lee Trager <lt73@cs.drexel.edu>
Subject: btrfs lockup after mounting for a second time on 2.6.26
Date: Thu, 12 Feb 2009 01:31:24 -0500
Message-ID: <4993C23C.8000108@cs.drexel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While running a few tests with the btrfs sources pulled from
btrfs-unstable patched with my patch to compile under 2.6.26 I
encountered a very weird problem. Everything works fine the first time I
mount the file system (either actual disk or loop back). When I
unmounted the file system and mounted it again(I'm not doing mount -o
remount ...) btrfs is completely unusable. When I tried to view some of
the data which I previously put on the btrfs partition by doing a simple
ls /mnt/btrfs in bash nothing happens. ls shows nothing, just hangs, and
I am unable to kill ls. The same thing happens when I try to copy a file
from my ext3 partition onto the btrfs partition after mounting it for a
second time. The rest of the system is completely usable and the only
things that are effects are applications which are trying to read/write
from the btrfs file system. There are no kernel opps or any other errors
messages in any of my logs. This happens if I have compression on or
not. I'd be happy to fix this issue but I don't have a clue about where
to start looking for what is wrong.

Could someone please help me?

Thanks,

Lee

