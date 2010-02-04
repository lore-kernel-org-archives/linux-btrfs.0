From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Btrfs Partition Reaches 'Disk Full' Early
Date: Wed, 3 Feb 2010 20:43:58 -0600
Message-ID: <26a1f7961002031843t665677aeh53e5b7cc6aaab6a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been trying to get a handle on where my Btrfs partition would run
out of room, and I'm reaching the 'no space left' point earlier than I
was expecting.

I'm running the btrfs-unstable.git version as of commit 035fe03a Thu,
28 Jan 2010 21:20:39 (Btrfs: check total number of devices when
removing missing) back-ported to a 2.6.32 kernel.

Also, I've manually added Josef Bacik's 'btrfsctl -i' patches to get
more information about the state when full.

I'm using a single 13.4GB partition as a root partition for a Sabayon
Linux system.  With the btrfs file system ~59% full, I booted to
another partition, and filled the remainder of the space using 'dd'
(dd if=/dev/urandom of=/<path-to-btrfs-mounted-partition>/randomdata
bs=1024k) to see where I'd get a full-disk error.

A btrfs 'no space left' error is received with the 'df' command
showing only 81% full.

'df -T' reports:
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda5    btrfs    14008648  11314552   2694096  81% /mnt/sabayon-btrfs

The dmesg disk full error reported:
[ 1606.386085] no space left, need 1048576, 89128960 delalloc bytes,
 10639556608 bytes_used, 3981312 bytes_reserved, 0 bytes_pinned,
 0 bytes_readonly, 0 may use 10733551616 total

Josef Bacik's 'btrfsctl -i' command reported:
# btrfsctl -i /mnt/sabayon-btrfs/
Metadata, DUP: total=1.67GB, used=813.89MB
System, DUP: total=8.00MB, used=4.00KB
Data: total=10.00GB, used=10.00GB
Metadata: total=8.00MB, used=0.00
System: total=4.00MB, used=0.00
operation complete
Btrfs Btrfs v0.19

Using 'btrfsctl -i', I'm still having trouble closing the loop on disk
utilization.  10.00 GB Data + 1.67 GB Metadata = 11.67GB.  Since this
is a 13.4GB partition, I'm still missing ~1.7GB, based on the
'btrfsctl -i' reporting.

Is 1.67 GB reserved for Metadata about what might be expected for a
messy root partition with ~10GB of files?
