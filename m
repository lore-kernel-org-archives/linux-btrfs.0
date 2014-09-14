Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:58119 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbaINDPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 23:15:31 -0400
Received: from [192.168.9.10] (52-dom-15.acn.waw.pl [85.222.54.52])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id A643F5240F0
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Sep 2014 05:15:27 +0200 (CEST)
Message-ID: <5415083C.4050404@siedziba.pl>
Date: Sun, 14 Sep 2014 05:15:08 +0200
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 failure and recovery
References: <000f01cfce67$9e9015f0$dbb041d0$@csy.ca> <20140912104732.GO5783@carfax.org.uk>
In-Reply-To: <20140912104732.GO5783@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12.09.2014 12:47, Hugo Mills wrote:
> I've done this before, by accident (pulled the wrong drive, reinserted
> it). You can fix it by running a scrub on the device (btrfs scrub
> start /dev/ice, I think).

I'd like to remind everyone that btrfs has weak checksums. It may be 
good for correcting an occasional error, but I wouldn't trust it to 
correct larger amounts of data.

Additionally, nocow files are not checksummed. They will not be 
corrected and may return good data or random garbage, depending on which 
mirror is accessed.

Below is a test I did some time ago, demonstrating the problem with 
nocow files:

#!/bin/sh
MOUNT_DIR=mnt
DISK1=d1
DISK2=d2
SIZE=2G
# create raid1 FS
mkdir $MOUNT_DIR
truncate --size $SIZE $DISK1
truncate --size $SIZE $DISK2
L1=$(losetup --show -f $DISK1)
L2=$(losetup --show -f $DISK2)
mkfs.btrfs -d raid1 -m raid1 $L1 $L2
mount $L1 $MOUNT_DIR
# enable NOCOW
chattr +C $MOUNT_DIR
umount $MOUNT_DIR
# fail the second drive
losetup -d $L2
mount $L1 $MOUNT_DIR -odegraded
# file must be large enough to not get embedded inside metadata
perl -e 'print "Test OK.\n"x4096' >$MOUNT_DIR/testfile
umount $MOUNT_DIR
# reattach the second drive
L2=$(losetup --show -f $DISK2)
mount $L1 $MOUNT_DIR
# let's see what we get - correct data or garbage?
cat $MOUNT_DIR/testfile
# clean up
umount $MOUNT_DIR
losetup -d $L1
losetup -d $L2
rm $DISK1 $DISK2
rmdir $MOUNT_DIR
