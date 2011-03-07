From: Jens Rosenboom <j.rosenboom@syseleven.de>
Subject: btrfs lacking inode or file count?
Date: Mon, 07 Mar 2011 17:17:49 +0100
Message-ID: <4D75052D.7050704@syseleven.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm just starting to do some testing with btrfs and I noticed that "df
-i" doesn't give any sensible output:

backup01 ~ # df -i /mnt/backup01-p1/
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/backup01p1
                           0       0       0    -  /mnt/backup01-p1
backup01 ~ # df -h /mnt/backup01-p1/
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/backup01p1
                       20T  444G   20T   3% /mnt/backup01-p1
backup01 ~ # btrfs file show
Label: 'backup01-p1'  uuid: d6a87326-b28b-425a-9c80-0e4b31dfe951
	Total devices 1 FS bytes used 431.13GB
	devid    1 size 20.00TB used 454.29GB path /dev/dm-3

Is it too difficult to provide the number of inodes in use or is this
just not yet implemented?

If inodes are difficult, would the number of files (ideally per
subvolume) be easier to obtain?

