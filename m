From: Carl Cook <CACook@quantum-sci.com>
Subject: Synching a Backup Server
Date: Thu, 6 Jan 2011 09:35:13 -0800
Message-ID: <201101060935.14059.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I am setting up a backup server for the garage, to back up my HTPC in case of theft or fire.  The HTPC has a 4TB RAID10 array (mdadm, JFS), and will be connected to the backup server using GB ethernet.  The backup server will have a 4TB BTRFS RAID0 array.  Debian Testing running on both.

I want to keep a duplicate copy of the HTPC data, on the backup server, and I think a regular full file copy is not optimal and may take days to do.  So I'm looking for a way to sync the arrays at some interval.  Ideally the sync would scan the HTPC with a CRC check to look for differences, copy over the differences, then email me on success.

Is there a BTRFS tool that would do this?

Also with this system, I'm concerned that if there is corruption on the HTPC, it could be propagated to the backup server.  Is there some way to address this?  Longer intervals to sync, so I have a chance to discover?

How about migrating to -all- BTRFS?  Would going all BTRFS give any advantages as to synching over GB ethernet?  If I fail out one drive in my RAID10, add another and set up these two as a BTRFS RAID0 array, could I then copy over the data remaining on the mdadm array?  Any gotchas in setting up the BTRFS RAID0 array?

