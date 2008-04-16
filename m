From: Chris Mason <chris.mason@oracle.com>
Subject: Multi-device update
Date: Wed, 16 Apr 2008 11:34:19 -0400
Message-ID: <200804161134.19237.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out another set of changes to the unstable trees, and these 
include:

* RAID 1+0 support
    mkfs.btrfs -d raid10 -m raid10 /dev/sd...
    4 or more drives required.

* async work queues for checksumming writes
* Better back references in the multi-device data structs

The async work queues include code to checksum data pages without the FS mutex 
held, greatly increasing streaming write throughput.  On my 4 drive system, I 
was getting around 120MB/s writes with checksumming on.  Now I get 180MB/s, 
which is disk speed.

The rest of the week will be spent doing hot add/remove of devices.  Happy 
testing ;)

-chris
