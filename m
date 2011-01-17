From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Kernel error during btrfs balance
Date: Mon, 17 Jan 2011 15:14:19 +0100
Message-ID: <4D344EBB.6030903@logtenberg.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs balance results in:

http://pastebin.com/v5j0809M

My system: fully up-to-date Fedora 14 with rawhide kernel to make btrfs
balance do useful stuff to my free space:

kernel-2.6.37-2.fc15.x86_64
btrfs-progs-0.19-12.fc14.x86_64

Filesystem had 0 bytes free, should be 45G, so on darklings advice I ran
btrfs balance on the fs, while doing heavy I/O (re-running 5 backup jobs
that had failed due to ENOSP).
Up until the crash, btrfs balance did retrieve a couple of Gigs free
space though, so that part of the plan worked just fine.

Thanks,

Erik.
