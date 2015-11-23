Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([37.120.165.214]:58118 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbbKWVSV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 16:18:21 -0500
Date: Mon, 23 Nov 2015 22:10:12 +0100
From: Nils Steinger <nst@voidptr.de>
To: Duncan <1i5t5.duncan@cox.net>, Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
Message-ID: <20151123211012.GA12286@ny.voidptr.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56530608.50906@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 23, 2015 at 05:49:05AM +0000, Duncan wrote:
> Btrfs scrub?  Why do you believe it will detect/fix the problem?

I was under the impression that btrfs scrub would detect all kinds of
inconsistencies (not just data-checksum mismatches), including whatever caused
btrfs send to fail.
Thanks for clearing up that misconception!


In this case, I ended up following Austin's first advice: I ran `btrfs receive
-vv` and moved the directory where it failed (something inside my Chromium
profile) off the filesystem and back onto it. When I reran `send` it failed
inside a neighbouring directory, so I recreated that one too. Cue some more
repetitions of that (with files from my Firefox and Skype profile directories).
In the end, I just rsync'd my entire home directory to a new subvolume, which
finally seems to have done the trick — at least I could `btrfs send` a snapshot
of the new subvolume to /dev/null.

Do we anything about what might cause a filesystem to enter a state which
`send` chokes on?
I've only seen a small sample of the corrupted files before growing tired of
the process and just recreating the whole thing, but all of them were database
files (presumably SQLite). Could it be that the files were being written to
during an unclean shutdown, leading to some kind of corruption of the FS?
Unfortunately, I was a little triggerhappy when cleaning up old snapshots, so
there aren't any left to aid in troubleshooting this problem further…


Regards,
Nils
