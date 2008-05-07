From: Chris Mason <chris.mason@oracle.com>
Subject: Online device removal pushed to the unstable trees
Date: Wed, 7 May 2008 11:49:01 -0400
Message-ID: <200805071149.01264.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out some code to remove devices online.  There are no disk format 
changes included.  The basic usage is to:

mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde
# mount, do things

btrfs-vol -r /dev/sdc /mnt

Any blocks on /dev/sdc will be relocated to other chunks.  The algorithm is 
very simple but it works for all the raid levels.  A future project will be 
to optimize this code for drive replacement.

There are also fixes in there for the code that does mount -o subvol=<name>

Next on my list is the ability to mount a degraded filesystem.

-chris



