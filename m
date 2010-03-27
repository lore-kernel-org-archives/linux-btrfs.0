From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: Missing entry for updated directory
Date: Sat, 27 Mar 2010 12:04:20 +0100
Message-ID: <20100327120420.28af24dd@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm using BTRFS_DIR_INDEX_KEY as suggested by Chris to find all updated
directories.

But I'm missing one:

The directory has 3 entries deleted and stat shows different
mtimes and ctimes for the directory in the two snapshots.

The highest generation number in the older snapshot is 82623.

But the generation number of the updated directory is 31758 in both snapshots.

Greetings, Michael
