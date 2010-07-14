From: Mathijs Kwik <bluescreen303@gmail.com>
Subject: snapshotting - what data gets shared?
Date: Wed, 14 Jul 2010 23:27:39 +0200
Message-ID: <AANLkTimYETjLEEIp2vW096vX0IYVFbA5cFRaK_avpMv-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm used to snapshots with LVM and I would like to compare them to btrfs.

The case I want to compare is the following:
At the moment a snapshot is created, no extra space is needed (maybe
some metadata overhead) and all data is shared between the original
and the snapshot.
In LVM, snapshots work at the block-level, so any changes done to the
original volume trigger a COW to the snapshot.
If LVM is configured to use 4Mb blocks (default), this means that
overwriting a 100k file, will lead to 4Mb "snapshot data" to be backed
up.
A 800Mb file will take around 800Mb.
So, for small files (that are not on the same extent/block) this can
waste quite some space, while for bigger files, or lots of files
"close" to each other, it doesn't matter much.

How is this for btrfs snapshots?
Do they work at the file-level? or also at blocks/extents?

I mean, does changing a 100k file lead to 100k being snapshotted?

What would happen if I have a 20G file (for example a disk image for kvm)?
Would minor changes in that file lead to the entire 20G to be COWed/"backed up"?

Is there a distinction between data and metadata?
Or does touching (ctime/mtime) or visiting (atime) a file cause it to be COWed?

Thanks for any info on this.
Mathijs
