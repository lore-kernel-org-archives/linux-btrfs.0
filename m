Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21617 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbbBPEUQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 23:20:16 -0500
Date: Mon, 16 Feb 2015 12:19:58 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic test for fsync followed by truncate and
 link
Message-ID: <20150216041957.GA32547@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1423831674-25678-1-git-send-email-fdmanana@suse.com>
 <20150216003337.GG12722@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150216003337.GG12722@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 16, 2015 at 11:33:37AM +1100, Dave Chinner wrote:
> On Fri, Feb 13, 2015 at 12:47:54PM +0000, Filipe Manana wrote:
> > This test is motivated by an fsync issue discovered in btrfs.
> > The issue was that we could lose file data, that was previously fsync'ed
> > successfully, if we end up shrinking (via truncate) the file, add a hard
> > link to our file and then persist the fsync log later via an fsync of
> > other inode for example. After a power loss our file content wouldn't
> > match what it had when we last fsync'ed, but instead it had the data
> > prior to that fsync.
> 
> Prior to which fsync?
> 
> XFS has strictly ordered metadata journalling, which means
> transactions committed prior to *any* fsync will be present on disk
> after the fsync. ext4 is not quite so strict, but has essentially
> the same behaviour. ext3 in ordered mode behaves like XFS.
> 
> As such, ext3, ext4 and XFS return the state of the file as "0xaa for
> 0 to 5k, 0x00 out to 32k" and the hardlink foo_link is present after
> the filesystem is remounted and the log replayed.

But xfs doesn't work as above, something wrong?  
This my config file,

------------------------------------------
[btrfs]
TEST_DEV=/dev/vdd
TEST_DIR=/mnt/test
SCRATCH_DEV=/dev/vdc
SCRATCH_MNT=/mnt/scratch
FSTYP=btrfs
MKFS_OPTIONS="-f -b2G"
RESULT_BASE="`pwd`/results/`date +%m%d%y_%H%M`"
MOUNT_OPTIONS=""
RECREATE_TEST_DEV=true

[xfs]
FSTYP=xfs
MKFS_OPTIONS="-f"

[ext4]
FSTYP=ext4
MKFS_OPTIONS=""
------------------------------------------

Results:
-------------------------------------
cat btrfs/generic/044.out.bad

QA output created by 044
wrote 8192/8192 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
wrote 4096/4096 bytes at offset 8192
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
File content before:
0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
*
0011600 aa aa aa aa aa aa aa aa 00 00 00 00 00 00 00 00
0011620 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
0100000
File content after:
0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
*
0020000

-------------------------------------
cat xfs/generic/044.out.bad

QA output created by 044
wrote 8192/8192 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
wrote 4096/4096 bytes at offset 8192
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
File content before:
0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
*
0011600 aa aa aa aa aa aa aa aa 00 00 00 00 00 00 00 00
0011620 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
0100000
File content after:
0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
*
0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
0100000

-------------------------------------
cat ext4/generic/044.out.bad

QA output created by 044
wrote 8192/8192 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
wrote 4096/4096 bytes at offset 8192
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
File content before:
0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
*
0011600 aa aa aa aa aa aa aa aa 00 00 00 00 00 00 00 00
0011620 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
0100000
File content after:
0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
*
0011600 aa aa aa aa aa aa aa aa 00 00 00 00 00 00 00 00
0011620 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
0100000


Thanks,

-liubo
> 
> So, as this test is written, it does not encapsulate the
> longstanding, expected behaviour of existing filesystems. btrfs
> should behave like XFS, ext3 and ext4 if possible - being different
> is only going to cause confusion and pain for application
> developers.
> 
> > The btrfs issue was fixed by the following linux kernel patch:
> > 
> >   Btrfs: don't remove extents and xattrs when logging new names
> 
> Sounds like you've just introduced an ordered mode behavioural
> journalling regression into btrfs...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
