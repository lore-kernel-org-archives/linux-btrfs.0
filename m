From: Chris Mason <chris.mason@oracle.com>
Subject: Multi-device updates pushed to unstable trees
Date: Thu, 3 Apr 2008 16:50:26 -0400
Message-ID: <200804031650.27193.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org, btrfs-devel@oss.oracle.com
Return-path: <btrfs-devel-bounces@oss.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I'm cc'ing both the old and new devel lists for now, but please move over to 
linux-btrfs@vger.kernel.org if you haven't already.

I've just pushed out my latest set of multi-device code to the unstable trees.  
Make sure to update both progs and kernel, there are probably disk format 
changes since the last push.

This includes basic support for raid0, raid1 and duplicate metadata copies on 
a single spindle.  The mirroring code does not cover every type of block yet 
(super blocks and the chunk mapping tree are missing), and while it does read 
from both disks in a mirror set, it does not yet use the alternate copy to 
recover from IO or checksumming errors.

In other words, the mirroring is mostly about writing things twice, so please 
don't go pulling drives out and expect the FS to recover yet.

To create a filesystem with multiple devices:

mkfs.btrfs /dev/sdb /dev/sdc ....

It will default to raid0 for data and raid1 for metadata if you give 
mkfs.btrfs multiple devices.  If you only use one device, it will default to 
duplicating metadata on the single spindle.

mkfs.btrfs has two new options to control allocation policy, --data 
and --metadata can be passed with one of raid0,raid1,single

For example:

mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde
(metadata will be mirrored, data will be striped)

mkfs.btrfs --data raid1 /dev/sd[bcde]
(both metadata and data blocks will be mirrored)

mkfs.btrfs --metadata raid0 /dev/sd[bcde]
(both metadata and data blocks will be striped)

mkfs.btrfs --metadata single /dev/sdb
(only one copy of data metadata will be created)

mkfs.btrfs /dev/sdb
(one copy of data, two copies of metadata on the same drive)

There is still a long todo list, but the code is definitely progressing.  
Performance on the duplicate copies of the metadata is pretty good.  Writing 
things twice isn't faster, but so far it is doing a fairly good job of 
batching the writes out to avoid major regressions.

-chris
