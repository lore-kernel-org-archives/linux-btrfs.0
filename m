From: Carl Cook <CACook@quantum-sci.com>
Subject: Various Questions
Date: Fri, 7 Jan 2011 09:15:20 -0800
Message-ID: <201101070915.20468.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


On Fri 07 January 2011 08:14:17 Hubert Kario wrote:
> I'd suggest at least 
> mkfs.btrfs -m raid1 -d raid0 /dev/sdc /dev/sdd
> if you really want raid0

I don't fully understand -m or -d.  Why would this make a truer raid0 that with no options?


Is it necessary to use fdisk on new drives in creating a BTRFS multi-drive array?  Or is this all that's needed:
# mkfs.btrfs /dev/sdb /dev/sdc
# btrfs filesystem show

Is this related to 'subvolumes'?  The FAQ implies that a subvolume is like a directory, but also like a partition.  What's the rationale for being able to create a subvolume under a subvolume, as Hubert says so he can "use the shadow_copy module for samba to publish the snapshots  to windows clients."  I don't have any windows clients, but what difference does his structure make?

I know that if using SATA+LVM, turn off the writeback cache on the drive, as it doesn't do cash flushing, and ensure NCQ is on.  But does this also apply to a BTRFS array?  If so, is this done in rc.local with 
hdparm -I /dev/sdb
hdparm -I /dev/sdc


How do you know what options to rsync are on by default?  I can't find this anywhere.  For example, it seems to me that --perms -ogE  --hard-links and --delete-excluded should be on by default, for a true sync?

If using the  --numeric-ids switch for rsync, do you just have to manually make sure the IDs and usernames are the same on source and destination machines?

For files that fail to transfer, wouldn't it be wise to use  --partial-dir=DIR to at least recover part of lost files?

The rsync man page says that rsync uses ssh by default, but is that the case?  I think -e may be related to engaging ssh, but don't understand the explanation.

So for my system where there is a backup server, I guess I run the rsync daemon on the backup server which presents a port, then when the other systems decide it's time for a backup (cron) they:
- stop mysql, dump the database somewhere, start mysql;
- connect to the backup server's rsync port and dump their data to (hopefully) some specific place there.
Right?




