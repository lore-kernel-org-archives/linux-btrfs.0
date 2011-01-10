From: Carl Cook <CACook@quantum-sci.com>
Subject: Backup Command
Date: Mon, 10 Jan 2011 05:25:32 -0800
Message-ID: <201101100525.32427.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Here is my proposed cron:

btrfs subvolume snapshot hex:///home /media/backups/snapshots/hex-{DATE}

rsync --archive --hard-links --delete-during --delete-excluded --inplace --numeric-ids -e ssh --exclude-from=/media/backups/exclude-hex hex:///home /media/backups/hex

btrfs subvolume snapshot droog:///home /media/backups/snapshots/droog-{DATE}

rsync --archive --hard-links --delete-during --delete-excluded --inplace --numeric-ids -e ssh --exclude-from=/media/backups/exclude-droog droog:///home /media/backups/droog

Comments?  Criticisms?

