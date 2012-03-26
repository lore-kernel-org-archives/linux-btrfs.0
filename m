From: James Courtier-Dutton <james.dutton@gmail.com>
Subject: btrfs and backups
Date: Mon, 26 Mar 2012 09:30:05 +0100
Message-ID: <CAAMvbhFkaz7_N99D3Gu0WcBPKF2oTdaEfZXQDsUE1fRgSi5msw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a local btrfs file system with various sub-volumes that have
had snapshots done on them.

Is there some tool like rsync that I could copy all the data and
snapshots to a backup system, but still only use the same amount of
space as the source filesystem.
I see a problem being getting a consistent and steady state during the rsync.
I was thinking that I might be able to do this with LVM snapshots, but
that would require something along these lines:
1) pause the btrfs filesystem into a consistent state that can be
mounted cleanly
2) Do LVM snapshot on it.
3) un-pause btrfs filesystem.

I can then do a block level backup of the LVM snapshot and it should
be mountable on the backup server.
So, the snapshot is not a snapshot of the current filesystem, it is a
snapshot of all the snapshots and all the sub-volumes at a particular
time, that is in a stable state to be backed up.

I don't know if 1 is supported?
I suppose I am hoping for 1,2,3 to already be supported by some
special btrfs command.


Any ideas?

Kind Regards

James
