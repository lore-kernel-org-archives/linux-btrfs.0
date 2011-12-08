From: BJ Quinn <bj@placs.net>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 08 Dec 2011 14:38:20 -0600 (CST)
Message-ID: <6d560453-f847-4c7f-a881-ddcdb4e62002@mail.placs.net>
References: <20111208200524.GT8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Phillip Susi <psusi@cfl.rr.com>,
	Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111208200524.GT8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

> Care to share you rsync script? 

Sure.  It's a little raw, and makes some assumptions about my environment, but it does the job other than the fact that it takes weeks to run.  :)

In the below example, the "main" or source FS is mounted at "/mnt/btrfs", the "backup" or target FS at "/mnt/btrfsbackup", and this script is located at "/mnt/btrfs/backupscripts".  I also run a slight variation of this script that makes it only "catch up" on snapshots that don't already exist on the backup FS simply by commenting out the rsync command directly above the echo that says "Export resynced snapshot".  If you don't comment that out, then the script attempts to re-sync ALL snapshots, even ones that have already been copied over in a previous run, effectively double checking that everything has already been copied.

This script is as efficient as I know how to make it, as it uses the --no-whole-file and --inplace rsync switches to prevent btrfs from thinking lots of blocks have changed that haven't really changed and eating up lots of space.

Also, an assumption is made that directly under /mnt/btrfs there are many subvolumes, and that the snapshots for these subvolumes are stored under /mnt/btrfs/snapshots/[subvol name]/[snap name].

Lastly, please note that I *DO* understand the purpose of the --bwlimit switch for rsync.  I've run it without that and it still takes weeks.  It's only in there now because it seemed to prevent issues I was having where the whole system would lock up under heavy btrfs activity.  I can't remember if that was a problem I solved by switching out my SATA controller card or by upgrading my kernel, but I don't believe I'm having that issue anymore.

FWIW.

#!/bin/bash

# The following script is for exporting snapshots from one drive to another.
#  Putting the word "STOP" (all caps, without quotes) in stopexport.txt will abort
#  the process at the end of the current rsync job.

DATE=`date +%Y%m%d`
DATETIME=`date +%Y%m%d%H%M%S`
SCRIPTSFOLDER="/mnt/btrfs/backupscripts"
BACKUPFOLDER="/mnt/btrfs"
EXTERNALDRIVE="/mnt/btrfsbackup"

echo "Export Started `date`"
echo

# This will create all the snapshots in the original drive's snapshots folder
#  on the export drive that don't exist on the export drive.
for PATHNAME in $BACKUPFOLDER/snapshots/*
do
  if [ `cat $SCRIPTSFOLDER/stopexport.txt` = "STOP" ]; then
    echo "STOP"
    break
  fi
  SHARENAME=`basename $PATHNAME`
  btrfs subvolume create $EXTERNALDRIVE/$SHARENAME
  for SNAPPATH in $PATHNAME/*
  do
    echo $SNAPPATH
    SNAPNAME=`basename $SNAPPATH`
    if [ ! -d "$EXTERNALDRIVE/snapshots/$SHARENAME/$SNAPNAME" ]; then
      rsync -avvP --delete --bwlimit=20000 --ignore-errors --no-whole-file --inplace $SNAPPATH/ $EXTERNALDRIVE/$SHARENAME
      mkdir -p $EXTERNALDRIVE/snapshots/$SHARENAME
      btrfs subvolume snapshot $EXTERNALDRIVE/$SHARENAME $EXTERNALDRIVE/snapshots/$SHARENAME/$SNAPNAME
      echo "Export created snapshot $EXTERNALDRIVE/snapshots/$SHARENAME/$SNAPNAME"
    else
      rsync -avvP --delete --bwlimit=20000 --ignore-errors --no-whole-file --inplace $SNAPPATH/ $EXTERNALDRIVE/snapshots/$SHARENAME/$SNAPNAME
      echo "Export resynced snapshot $EXTERNALDRIVE/snapshots/$SHARENAME/$SNAPNAME"
    fi
    if [ `cat $SCRIPTSFOLDER/stopexport.txt` = "STOP" ]; then
     echo "STOP"
     break
    fi
  done;
done;

echo "Export Completed `date`"
