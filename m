Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:41819 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751234AbaLQCo7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 21:44:59 -0500
Date: Tue, 16 Dec 2014 20:42:28 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Oddly slow read performance with near-full largish FS
Message-ID: <20141217024228.GA5544@pyropus.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been running btrfs for various filesystems for a few years now, and have
recently run into problems with a large filesystem becoming *really* slow for
basic reading.  None of the debugging/testing suggestions I've come across in
the wiki or in the mailing list archives seems to have helped.

Background: this particular filesystem holds backups for various other
machines on the network, a mix of rdiff-backup data (so lots of small files)
and rsync copies of larger files (everything from ~5MB data files to ~60GB VM
HD images).  There's roughly 16TB of data in this filesystem (the filesystem
is ~17TB).  The btrfs filesystem is a simple single volume, no snapshots,
multiple devices, or anything like that.  It's an LVM logical volume on top of
dmcrypt on top of an mdadm RAID set (8 disks in RAID 6).

The performance:  trying to copy the data off this filesystem to another
(non-btrfs) filesystem with rsync or just cp was taking aaaages - I found one
suggestion that it could be because updating the atimes required a COW of the
metadata in btrfs, so I mounted the filesystem noatime, but this doesn't
appear to have made any difference.  The speeds I'm seeing (with iotop)
fluctuate a lot.  They spend most of the time in the range of 1-3 MB/s, with
large periods of time where no IO seems to happen at all, and occasional short
spikes to ~25-30 MB/s.  System load seems to sit around 10-12 (with only 2
processes reported as running, everything else sleeping) while this happens.
The server is doing nothing other than this copy at the time.  The only
processes using any noticable CPU are rsync (source and destination processes,
around 3% CPU each, plus an md0:raid6 process around 2-3%), and a handful of
"kworker" processes, perhaps one per CPU (there are 8 physical cores in the
server, plus hyperthreading).

Other filesystems on the same physical disks have no trouble exceeding 100MB/s
reads.  The machine is not swapping (16GB RAM, ~8GB swap with 0 swap used).

Is there something obvious I'm missing here?  Is there a reason I can only
average ~3MB/s reads from a btrfs filesystem?

kernel is x86_64 linux-stable 3.17.6.  btrfs-progs is v3.17.3-3-g8cb0438.
Output of the various info commands is:

  $ sudo btrfs fi df /media/backup/
  Data, single: total=16.24TiB, used=15.73TiB
  System, DUP: total=8.00MiB, used=1.75MiB
  System, single: total=4.00MiB, used=0.00
  Metadata, DUP: total=35.50GiB, used=34.05GiB
  Metadata, single: total=8.00MiB, used=0.00
  unknown, single: total=512.00MiB, used=0.00

  $ btrfs --version
  Btrfs v3.17.3-3-g8cb0438

  $ sudo btrfs fi show

  Label: 'backup'  uuid: c18dfd04-d931-4269-b999-e94df3b1918c
    Total devices 1 FS bytes used 15.76TiB
    devid    1 size 16.37TiB used 16.31TiB path /dev/mapper/vg-backup

Thanks in advance for any suggestions.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
