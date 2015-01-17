Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56919 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbAQMDW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Jan 2015 07:03:22 -0500
Received: by mail-wg0-f44.google.com with SMTP id y19so24591786wgg.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Jan 2015 04:03:21 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Jan 2015 13:03:20 +0100
Message-ID: <CAOsFrTexWG-SZ=22fO8myx+trqz-w1qQ9XPFDOZJTHoNVgggEw@mail.gmail.com>
Subject: Backup: Lost local reference
From: G EO <1g2e3o4@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I know I have discussed it already on this list, but unfortunately it
did no work out for me.
I am creating backups with btrfs send/receive, like described on the
wiki page https://btrfs.wiki.kernel.org/index.php/Incremental_Backup.

That means I have a subvolume "home", create a snapshot
"home-snapshot" and send it to the backup drive. Then the following
times I create another snapshot "home-snapshot-1" and send the
difference to the backup drive using "btrfs send -p home-snapshot
home-snapshot-1 | btrfs receive /path". For that to work I always need
to keep the last local reference (like home-snapshot) in this example.

Now I am in the unfortunate situation that I deleted the local
reference accidentally out of my own stupidity and wonder if there is
a way to determine the difference between the last snapshot on the
backup drive and the state of my sub-volume now.

I tried the following: I sent the last snapshot (in this example
home-snapshot-1) on the backup drive to an empty btrfs filesystem.
Then I created a read/write snapshot of this one
(home-snapshot-1-snap) and copied my whole current subvolume to the
read/write snapshot in the hope btrfs would only writes changes, but
that was hopeless, when sending the "diff -p" between the imported
snapshot (home-snapshot-1) and the read write snapshot
(home-snapshot-1-snap) back to the backup drive, it did not send any
differences but the whole subvolume (home-snapshot-1-snap).

So is there any way I can let compute the differences in order to
restore the old situation and continue with my incremental backups?

For information: I do not have any older local snapshots :-(, all of
the snapshot were deleted because of a regex problem in a script I
ran.
