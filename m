From: "Kaspar Schleiser" <kaspar@schleiser.de>
Subject: feature request: read/write priorities on multiple devices/raid1
Date: Thu, 25 Sep 2008 11:19:35 +0200 (CEST)
Message-ID: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody!

This is my first post on the list, let me know if I'm not following any
rules.

What do you think about adding priorities for raid1 arrays?

For example, always use /dev/ram0 (ramdisk) for reading/writing, but
nonetheless write everything additionally on /dev/sda1. Restore to
/dev/ram0 after mount if it is empty.

Or use /dev/sd[c-h], maybe a raid 0 of fast read access/slow random write
flash media for reading, but /dev/sda1 (a reasonably fast HD) for writing.
make sure written data get's replicated on the raid0.

The linux md driver supports that in some way using the --write-mostly and
--write-behind options, but that's not very flexible.

Cheers
Kaspar Schleiser

