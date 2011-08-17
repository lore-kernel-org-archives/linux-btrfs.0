From: Anand Jain <Anand.Jain@oracle.com>
Subject: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 10:15:46 +0800
Message-ID: <4E4B2452.9070407@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


sorry forgot to follow the protocol, now included RFC in the subject.


Hi,

  Appears that no one is working on the auto-snapshot feature for btrfs,
  so here I am implementing the same.

  Below is a draft on the feature list.  Any comments / questions /
  suggestions are welcome, please do let me know.

  btrfs auto snapshot feature will include:
  Initially:
      - configurable timely snapshots
      - uses services and crontab to schedule
      - Gnome integration
      - snapshot rollback and cleanups
      - snapshot trashing based on available space
      - snapshot destination will be subvol/.btrfs/snapshot@<time> and
        snapshot/.btrfs/snapshot@<time> for subvolume and snapshot
        respectively

  Later:
      -integration with (a ?) backup software
        - snapshot trashing per backup confirmation
        - rollback from the backup server

  Challenges:
    - rollback per file or dir instead of entire snapshot-rollback ?
    - integrating into the btrfs gui ?
    - some FS (samfs) support continues backup
    - do we need a new role for the snapshot management ? zfs does.
    - we don't need a snapshot if the master file-system didn't change
      at all
    - snapshots are writable by default, hope that sudo-er doesn't
      modify the snapshot - do we need to implement a kind of read-only
      snapshot ?

Thanks, -Anand
