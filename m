From: "Michael Niederle" <mniederle@gmx.at>
Subject: btrfs subvol find-new
Date: Fri, 26 Mar 2010 11:18:07 +0100
Message-ID: <20100326111807.24dcc2f0@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I want to write a differential backup tool for btrfs snapshots.

The new "btrfs subvol find-new"-command sounds great on first encounter, but I'm
missing informations about updated directories. I would need a list of updated
directories to scan for deleted files.

I had a look at find_updated_files() in btrfs-list.c. To me it seems as if
the ioctl would only return the extents of regular files.

The function find_root_gen() in btrfs-list.c seems to return the newest
generation in a given snapshot. It would be nice to have this exported as a
user command (e.g. "btrfs subvol newest-gen") then one could use the output of 

btrfs subvol newest-gen <old snapshot>

(plus 1) as the input generation number to

btrfs subvol find-new <new snapshot> <gen+1>

(I'm using kernel 2.6.32.10 with the most current btrfs-kernel modules and
userland tools as of last Saturday.)

Greetings, Michael
