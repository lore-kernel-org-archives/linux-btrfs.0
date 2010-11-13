From: "Bron Gondwana" <brong@fastmail.fm>
Subject: Poor performance unlinking hard-linked files
Date: Sat, 13 Nov 2010 14:25:24 +1100
Message-ID: <1289618724.28645.1405062363@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had a spare piece of hardware sitting around, so I thought I'd test btrfs performance with the Cyrus IMAPd server by setting up an extra replica target on the spare machine.

Some background on Cyrus replication: when copying a folder the replication system first "reserves" all messages it's going to need.  It tries to maintain "single instance store" as it's called in Cyrus terminology - hard links between identical messages on disk.

This is done in the latest version of Cyrus by storing the sha1 of each file in an index, and scanning the currently active mailboxes on the replica to see if they already have a copy of the file.  If so, a hard link is made in the data/sync./$pid/ directory back to the original file in the mailbox directory.

Cyrus stores one file per email, which pushes filesystems pretty hard.  We used reiser3 until recently, and are part way through converting to ext4.

If the file is not already available on the replica, a new copy is uploaded directly into the sync./$pid directory.

Either way, when the mailbox is then created or updated, the files get hardlinked from the sync./$pid directory to their final location.

They get kept around for a little while, until the sync_server decides it's time for a reset because it's using too much memory keeping all the tracking data.  Then it unlinks all the files in sync./$pid and starts searching for necessary files again.

Most of the time, this means single instance store works - the source and destination mailboxes always get heated up by adding both of them to the sync log, so the duplication will be found.

-----------------

Anyway, that's the background - a daemon that creates a pile of files in one directory, symlinks them out all over the file system, then unlinks all the original files later.

We're finding that as the filesystem grows (currently about 30% full on a 300Gb filesystem) the unlink performance becomes horrible.  Watching iostat, there's a lot of reading going on as well.  It really looks like the unlinks are performing pretty badly in this one case.

Ideally there would be a nice filesystem API Cyrus could call that said "delete all the files in this directory"!  Failing that, is there anything we can do to improve this use case?  Real-time production use isn't QUITE so bad as an initial sync, but lmtp delivery uses the same method - spool to staging file, parse it there, then symlink to all the delivery targets before unlinking the original.

Thanks,

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

