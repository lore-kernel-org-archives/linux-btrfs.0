From: Bernhard Duebi <bernhard@due.bi>
Subject: btrfs defra
Date: Mon, 13 Jun 2011 16:50:37 +0200
Message-ID: <1307976637.2285.15.camel@andromeda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

I'm no developer, just a simple user. I use btrfs as the root filesystem
on my laptop. I use VirtualBox. Every VB disk lives in a separat btrfs
subvolume. I use btrfs snapshots for backup and to clone VB VMs.

I wonder what happens when I defrag a file that is part of multiple
snapshots? Will all instances of this file be defragmented, or will the
file get its own fresh copy?

If it is important, my system is a 64bit ubuntu 10.10 and the filesystem
is mounted with the option compress. If it helps, I would consider to
upgrade to 11.04.

BTW: what is the difference between defrag and balance ?

Sincerely
Bernhard


