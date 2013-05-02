Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34877 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850Ab3EBXbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 May 2013 19:31:21 -0400
Date: Fri, 3 May 2013 09:31:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: imperfect FIEMAP results on btrfs
Message-ID: <20130502233103.GA15549@dastard>
References: <1367510414.32396.90.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1367510414.32396.90.camel@sauron.fi.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 02, 2013 at 07:00:14PM +0300, Artem Bityutskiy wrote:
> Hi,
> 
> I have a rather extensive FIEMAP test which works fine on ext4 but fails
> on btrfs. I've took a look at one of the failures, and simplified it to
> the following:
> 
> 1. create a 4KiB non-sparse file
> 2. truncate it to 8KiB
> 3. truncate it to 4KiB + 1 byte
> 
> IOW:
> 
> $ dd if=/dev/urandom of=file bs=4096 count=1
> $ truncate -s 8192 file
> $ truncate -s 4097 file
> 
> Let's assume that the FS block size is 4KiB, as it is returned the
> FIGETBSZ ioctl. These actions result in:
> 
> 1. the file will have only 1 block mapped on ext4
> 2. the file will have 2 blocks mapped on btrfs
> 
> IOW, on ext4:
> 
> $ stat file
>   File: ‘file’
>   Size: 4097            Blocks: 8          IO Block: 4096   regular file
> 
> and on btrfs
> 
> $ stat file
>   File: ‘file’
>   Size: 4097            Blocks: 16         IO Block: 4096   regular file
> 
> Notice 8 vs 16 blocks.
> 
> Interesting enough that just creating a 4KiB file and then truncating it
> to 4097 bytes works as I expect in btrfs - results in a file with only
> the first block mapped.
> 
> It looks like ext4 is "perfect" in detecting sparse 4KiB blocks while
> btrfs sometimes maps seemingly sparse 4KiB blocks. Is this considered to
> be a defect or this is fine since the FS does not probably give any
> guarantees WRT mapped and unmapped blocks?

Not a bug. Different filesystems treat the same operations
differently in terms of allocation and hole detection. Indeed, the
same filesystem with different configurations will treat the same
test differently....

XFS on a 4k filesystem block:

$ xfs_io -f -c "pwrite 0 4k" -c "truncate 8k" -c "truncate 4097" -c "fiemap -v" /mnt/scratch/test
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0000 sec (144.676 MiB/sec and 37037.0370 ops/sec)
/mnt/scratch/test:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
    0: [0..15]:         112..127            16   0x1
$

gives the same result as btrfs. But on a 512 byte filesystem block
size filesytem:

$ xfs_io -f -c "pwrite 0 4k" -c "truncate 8k" -c "truncate 4097" -c "bmap -vp" -c stat /mnt/scratch/test
wrote 4096/4096 bytes at offset 0
4 KiB, 8 ops; 0.0000 sec (84.918 MiB/sec and 173913.0435 ops/sec)
/mnt/scratch/test:
 EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET        TOTAL FLAGS
   0: [0..8]:          48..56             0 (48..56)             9 00000
$

XFS results in 9 basic blocks being allocated, not 16....

IOWs, you simply can't assume that a specific test will give you the
same block layout across filesystems and different filesystem
configurations. Welcome to the world of "can't assume anything about
block layout" pain xfstests has been dealing with for years ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
