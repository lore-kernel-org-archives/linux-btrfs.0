From: David Brown <btrfs@davidb.org>
Subject: Odd behavior of subvolume find-new
Date: Mon, 9 Jan 2012 08:08:00 -0800
Message-ID: <20120109160759.GA973@davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been creating some time-based snapshots, e.g.

      # btrfs subvolume snapshot @root 2012-01-09-@root

After some changes, I wanted to see what had changed, so I tried:

      # btrfs subvolume find-new @root 2012-01-09-@root
      transid marker was 37

which doesn't print anything out.  Curiously, if I make a snapshot of
the snapshot, then I get output from the delta:

      # btrfs subvolume snapshot 2012-01-09-@root tmp
      # btrfs subvolume find-new @root tmp
      ..... lots of output .....

I haven't seen this behavior on other filesystems or subvolumes.

My intent was to filter through the small script below to compute the
size of the delta.

Thanks,
David

#! /usr/bin/perl

# Process the output of btrfs subvolume find-new and print out the
# size used by the new data.  Doesn't show delta in metadata, only the
# data itself.
use strict;

my $bytes = 0;
while (<>) {
	if (/ len (\d+) /) {
		$bytes += $1;
	}
}
printf "%d bytes\n", $bytes;
printf "%.1f MByte\n", $bytes / 1024.0 / 1024.0;
printf "%.1f GByte\n", $bytes / 1024.0 / 1024.0 / 1024.0;

