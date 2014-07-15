Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34098 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaGOKuf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 06:50:35 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 15 Jul 2014 20:50:33 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org
Subject: Fiemap inconsistent behaviour when file offset range isn't on a block boundary
Date: Tue, 15 Jul 2014 16:20:29 +0630
Message-ID: <2891198.LvUkX379bh@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All the filesystems created and used below have 4k blocksize. The
"file.bin" file mentioned below is 8k in size and has two 4k
extents. The test program used can be found at http://fpaste.org/118057/.

1. First run (file range being passed is on block boundaries).
   ,----
   | [root@guest0 btrfs]# for f in $(ls -1 /mnt/{btrfs,ext4,xfs}/file.bin) ;
   | >        do
   | >        echo "-------------- File: $f -----------";
   | >        /root/print-fiemap 0 8192 $f;
   | >        done
   | -------------- File: /mnt/btrfs/file.bin -----------
   | File range: 0 - 8191.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 12582912
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 12656640
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   | 
   | -------------- File: /mnt/ext4/file.bin -----------
   | File range: 0 - 8191.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 135270400
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 135278592
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   | 
   | -------------- File: /mnt/xfs/file.bin -----------
   | File range: 0 - 8191.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 49152
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 57344
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   `----

2. If the file offset range being passed as input to fiemap ioctl is
   not on block boundaries and falls within an extent's range then that
   extent is skipped.
   ,----
   | [root@guest0 btrfs]# for f in $(ls -1 /mnt/{btrfs,ext4,xfs}/file.bin) ;
   | > do
   | > echo "-------------- File: $f -----------";
   | > /root/print-fiemap 1 4095 $f;
   | > done
   | -------------- File: /mnt/btrfs/file.bin -----------
   | File range: 1 - 4095.
   | Found 0 extents.
   | 
   | 
   | -------------- File: /mnt/ext4/file.bin -----------
   | File range: 1 - 4095.
   | Found 1 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 135270400
   | 		Length: 4096
   | 		Flags:
   | 
   | -------------- File: /mnt/xfs/file.bin -----------
   | File range: 1 - 4095.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 49152
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 57344
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   `----

   From linux/Documentation/filesystems/fiemap.txt, "fm_start, and
   fm_length specify the logical range within the file which the
   process would like mappings for. Extents returned mirror those on
   disk - that is, the logical offset of the 1st returned extent may
   start before fm_start, and the range covered by the last returned
   extent may end after fm_length. All offsets and lengths are in
   bytes."

   So IMHO, the above would mean that all the extents that map the
   file range [fm_start, fm_start + fm_length - 1] should be returned
   by a fiemap ioctl call (as done by ext4).

   In the case of Btrfs, the commit
   ea8efc74bd0402b4d5f663d007b4e25fa29ea778 i.e. "Btrfs: make sure not
   to return overlapping extents to fiemap", forces the first extent
   returned by btrfs_fiemap() to start from fm_start (if fm_start is
   greater than the file offset mapped by the containing extent's
   first byte). Can somebody please list some example scenarios where
   extent_fiemap() ends up returning dupclicate and overlapping
   extents?
   Also, the commit 4d479cf010d56ec9c54f3099992d039918f1296b
   i.e. "Btrfs: sectorsize align offsets in fiemap", rounds up first
   byte of the file offset range to the next block. Shouldn't it be
   rounded down instead?

   XFS lists both the extents even though the first one encompasses the
   file range specified in the input.
     
-- 
chandan

