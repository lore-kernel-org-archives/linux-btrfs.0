Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:59543 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbaDWWa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:30:57 -0400
Message-ID: <53583F1E.7050603@pobox.com>
Date: Wed, 23 Apr 2014 15:30:54 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Cycle of send/receive for backup/restore is incomplete...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So the backup/restore system described using snapshots is incomplete 
because the final restore is a copy operation. As such, the act of 
restoring from the backup will require restarting the entire backup 
cycle because the copy operation will scramble the metadata consanguinity.

The real choice is to restore by sending the snapshot back via send and 
receive so that all the UIDs and metadata continue to match up.

But there's no way to "promote" the final snapshot to a non-snapshot 
subvolume identical to the one made by the original btrfs subvolume 
create operation.

Consider a file system with __System as the default mount (e.g. btrfs 
subvolume create /__System). You make a snapshot (btrfs sub snap -r 
/__System /__System_BACKUP). Then you send the backup to another file 
system with send receive. Nothing new here.

The thing is, if you want to restore from that backup, you'd 
send/receive /__System_BACKUP to the new/restore drive. But that 
snapshot is _forced_ to be read only. So then your only choice is to 
make a writable snapshot called /__System. At this point you have a tiny 
problem, the three drives aren't really the same.

The __System and __System_BACKUP on the final drive are subvolumes of /, 
while on the original system / and /__System were full subvolumes.

It's dumb, it's a tiny difference, but it's annoying. There needs to be 
a way to promote /__System to a non-snapshot status.

If you look at the output of "btrfs subvolume list -s /" on the various 
drives it's not possible to end up with the exact same system as the 
original.

There needs to be either an option to btrfs subvolume create that takes 
a snapshot as an argument to base the new device on, or an option to 
receive that will make a read-write non-snapshot subvolume.

Ideally, from "HOST_A":

mkfs.btrfs /dev/sda  # main device
mount /dev/sda /drivea
cd /drivea
btrfs subvolume create __System
btrfs subvolume set-default __System
#//* use system with __System as root *//
mount -o subvol=/ /dev/sda /drivea
cd /drivea
btrfs subvolume snapshot -r __System __System_BACKUP

mkfs.btrfs /dev/sdb # some backup device (presumably shared here)
mount /dev/sdb /driveb
cd /driveb
btrfs subvolume create HOST_A # host specific region
cd HOST_A
btrfs send /drivea/__System_BACKUP | btrfs receive /driveb/HOST_A
# etc.

## Restoring drive.
mkfs.btrfs /dev/sdc
mount /dev/sdc /drivec
mount /dev/sdb /driveb
btrfs send /driveb/HOST_A/__System_BACKUP | btrfs receive /drivec

## What I've been doing is create a non read-only snapshot of
##   the backup snapshot. But this is now _not_ identical to the
##   original /drivea because __System is listed as a snapshot
##   not a subvolume.
cd /drivec
btrfs subvolume snapshot __System_BACKUP __System

## So Ideally I should instead be able to do
btrfs subvolume create -model /drivec/__System_BACKUP /drivec/__System

## Or I should have been able to do
btrfs send /driveb/HOST_A/__System_BACKUP |
   btrfs subvolume create --receive /drivec/__System

## Or a promote/populate option that takes the writable snapshot and
##   and rearranges its flags and the various connections to other
##   snapshots. e.g. properly handling __System_BACKUP et. al.
##   when doing something like:
btrfs subvolume promote __System


The real goal here is that the well designed system is going to use 
incremental backups. If there's a copy operation used then the whole 
HOST_A hierarchy would need to be recreated, which lowers the integrity 
of the whole backup cycle by interrupting the history.

Imagine if there is a (dated or numbered) history of snapshots, any copy 
based restore breaks it all.

ASIDE: A harder problem is when a snapshot is a child of the subvolume 
itself. e.g. "btrfs snapshot -r . BACKUP". Getting the contents of . 
back seems more or less impossible wihtout copying.
