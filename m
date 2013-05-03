Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57890 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3ECLnl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 07:43:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYEOi-0000EP-Cd
	for linux-btrfs@vger.kernel.org; Fri, 03 May 2013 13:43:32 +0200
Received: from 84-72-179-110.dclient.hispeed.ch ([84.72.179.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 13:43:32 +0200
Received: from alexanders.mailinglists+nospam by 84-72-179-110.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 13:43:32 +0200
To: linux-btrfs@vger.kernel.org
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Script for creating/managing snapshots of all subvolumes of all filesystems
Date: Fri, 3 May 2013 11:43:18 +0000 (UTC)
Message-ID: <loom.20130503T133254-992@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

FWIW, I've also written a script which creates and "manages"
(ie. deletes old) snapshots.

It figures out all the available filesystems and creates snaps
for all the available (sub)volumes.

It's also on https://copy.com/WI9AXqTH2nD4 and http://pastebin.com/YX8WKcsR 
to avoid line break issues and also with comments.

Regards,
Alexander

----- cut here

#!/bin/sh
    echo "Usage: $0 SNAPSHOT_TAG NUM_SNAPSHOTS
Create hourly, daily, weekly, and monthly snapshots of btrfs filesystems.

Based somewhat on http://article.gmane.org/gmane.comp.file-
systems.btrfs/12609

Here's my crontab:
00,15,30,45  * * * *  $0 frequently  4
38           * * * *  $0 hourly     24
08          00 * * *  $0 daily       7
08          12 * * 0  $0 weekly      4"
    exit 1
fi

SNAPSHOT_TAG="$1"
NUM_SNAPSHOTS="$2"

snap_prefix="snapshot:$SNAPSHOT_TAG:"
snap_date="`date +%Y-%m-%d--%H.%M.%S.%N`"
script_name=`basename "$0"`

log_fac="local5"
log_tag="$script_name"

btrfs_progs_dev_path="/home/a/Copy/Computerkram/Programme/btrfs-
progs.dev/bin"
PATH="$btrfs_progs_dev_path:$PATH"

btrfs fi show 2>/dev/null | awk '/ path / {print $NF}' | while read dev; do
    set -- `btrfs fi show 2>/dev/null | grep -B2 " path $dev" | \
     grep "Label:" | sed  's,.*: \(.*\)  uuid: \(.*\),\1 \2,'`
    label="$1"
    uuid="$2"
    logger -t "$log_tag" -p "$log_fac.info" -- \
     "Processing filesystem with label $label and uuid $uuid on $dev"
    safe_dev=`echo "$dev" | tr / .`
    tmp_mount_dir=`mktemp -d "/tmp/.btrfs.mount.$uuid.$safe_dev.XXXXXX"`
    if ! mount -t btrfs "$dev" "$tmp_mount_dir"; then
        logger -t "$log_tag" -p "$log_fac.err" -- \
         "Error! Could not do: mount -t btrfs $dev $tmp_mount_dir"
        exit 1
    fi
    
    _snap_name="$tmp_mount_dir/,$snap_prefix$snap_date"
    if ! btrfs subv snaps -r "$tmp_mount_dir" "$_snap_name" > /dev/null; 
then
        logger -t "$log_tag" -p "$log_fac.err" -- \
         "Error! Could not do: btrfs subv snaps -r $tmp_mount_dir 
$_snap_name"
        exit 1
    else
        logger -t "$log_tag" -p "$log_fac.info" -- \
        "Created snapshot $Path,$snap_prefix$snap_date for root volume of fs 
with uuid $uuid"
    fi
    (btrfs subv list -r "$tmp_mount_dir" | grep " path ,$snap_prefix" \
     | tail -"$NUM_SNAPSHOTS"
     btrfs subv list -r "$tmp_mount_dir" | grep " path ,$snap_prefix") \
     | sort | uniq -u \
     | while read __id IdDel __gen GenDel __top __level ToplevelDel __path 
PathDel; do
        if ! btrfs subv del "$tmp_mount_dir/$PathDel" > /dev/null; then
            logger -t "$log_tag" -p "$log_fac.err" -- \
             "Error! Could not do: btrfs subv del $tmp_mount_dir/$PathDel"
            exit 1
        else
            logger -t "$log_tag" -p "$log_fac.info" -- \
             "Removed snapshot $PathDel"
        fi
    done
    
    (btrfs subv list -ar $tmp_mount_dir; btrfs subv list -a $tmp_mount_dir) 
\
     | sort | uniq -u \
     | while read _id Id _gen Gen _top _level Toplevel _path Path; do
        _snap_name="$tmp_mount_dir/$Path,$snap_prefix$snap_date"
        if ! btrfs subv snaps -r "$tmp_mount_dir/$Path" "$_snap_name" > 
/dev/null; then
            logger -t "$log_tag" -p "$log_fac.err" -- \
             "Error! Could not do: btrfs subv snaps -r $tmp_mount_dir/$Path 
$_snap_name"
            exit 1
        else
            logger -t "$log_tag" -p "$log_fac.info" -- \
             "Created snapshot $Path,$snap_prefix$snap_date for subvolume 
$Path"
        fi
        (btrfs subv list -r "$tmp_mount_dir" \
         | grep " path $Path,$snap_prefix" | tail -"$NUM_SNAPSHOTS"
         btrfs subv list -r "$tmp_mount_dir"|grep " path 
$Path,$snap_prefix") \
         | sort | uniq -u \
         | while read __id IdDel __gen GenDel __top __level ToplevelDel 
__path PathDel; do
            if ! btrfs subv del "$tmp_mount_dir/$PathDel" > /dev/null; then
                logger -t "$log_tag" -p "$log_fac.err" -- \
                 "Error! Could not do: btrfs subv del 
$tmp_mount_dir/$PathDel"
                exit 1
            else
                logger -t "$log_tag" -p "$log_fac.info" -- \
                 "Removed snapshot $PathDel"
            fi
        done
    done
    if ! umount "$tmp_mount_dir"; then
        logger -t "$log_tag" -p "$log_fac.err" -- \
         "Error! Could not do: umount$tmp_mount_dir"
    fi
    if ! rmdir "$tmp_mount_dir"; then
        logger -t "$log_tag" -p "$log_fac.err" -- \
         "Error! Could not do: rmdir $tmp_mount_dir"
    fi
done

exit 0


