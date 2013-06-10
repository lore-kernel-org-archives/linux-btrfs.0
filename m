Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from equinox.linksky122.com ([184.173.222.71]:43235 "EHLO
	equinox.linksky122.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3FJPvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 11:51:21 -0400
Message-ID: <20130610101929.162463asym1cxvnl@webmail.kevinokelley.com>
Date: Mon, 10 Jun 2013 10:19:29 -0500
From: kevin@kevinokelley.com
To: linux-btrfs@vger.kernel.org
Subject: How to mount a copy of a disk with a Btrfs file system on it?
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Consider the following environment.  We have a storage array that  
provides its own facilities for creating snapshots, replicas, and  
clones.  We create a Btrfs file system on a volume on one of these  
storage arrays, and we mount a snapshot of that volume on the same  
host.  (The simple use-case is that the snapshot is being used to  
restore a set of files.)

We've noticed two problems:

1. The dmesg log shows that the kernel recognizes the Btrfs object id  
for both devices.  For example:

[ 2920.923517] btrfs: device fsid 54c6e67c-fd51-4aed-a865-4ed4e1cd246a  
devid 1 transid 7 /dev/dm-2
[ 2921.007179] btrfs: device fsid 54c6e67c-fd51-4aed-a865-4ed4e1cd246a devid 1
transid 6 /dev/dm-9

If a user process modifies the original file system, the changes also  
appear on the snapshot.  This is highly undesirable as we want to  
preserve the integrity of the snapshot so that it reflects the state  
of the volume when the snapshot was created.

2. We cannot mount the original volume read-write and mount the  
snapshot read-only.

Is there a mount option for Btrfs that will allow us to mount the  
Btrfs file system and ignore the UUID on the device or allow us to  
assign a new (random) UUID for the volume?   For example, xfs provides  
a mount option "-o nouuid".  Gfs2 allows mount option "-o  
locktable=<UUID>" to specify a new locktable.

Thank you.


