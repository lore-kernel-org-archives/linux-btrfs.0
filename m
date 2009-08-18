From: Nick Piggin <npiggin@suse.de>
Subject: btrfs failing fsx-linux
Date: Tue, 18 Aug 2009 19:26:41 +0200
Message-ID: <20090818172641.GC30325@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Don't know if this is a known issue, but I have btrfs (after my previous
inode_tree fixup patch) failing fsx-linux in Linus's current git tree.

This makes it a bit hard for me to test my btrfs truncate conversion patch
unfortunately, though it does seem pretty stable so I will probably just
send it out anyway.

Anyway, just a head's up. Oh, the way I reproduce is to create btrfs
on 1GB rd, run 4 instances of fsx-linux on different files in the root
directory, and run `while true ; do sync ; echo 3 > /proc/sys/vm/drop_caches;
done` at the same time.

Thanks,
Nick

