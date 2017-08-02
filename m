Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-wd.italiaonline.it ([212.48.13.170]:37658 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752118AbdHBSAn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 14:00:43 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Massive loss of disk space
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, pwm <pwm@iapetus.neab.net>,
        Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
 <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
Date: Wed, 2 Aug 2017 19:52:30 +0200
MIME-Version: 1.0
In-Reply-To: <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2017-08-01 17:00, Austin S. Hemmelgarn wrote:
> OK, I just did a dead simple test by hand, and it looks like I was right.  The method I used to check this is as follows:
> 1. Create and mount a reasonably small filesystem (I used an 8G temporary LV for this, a file would work too though).
> 2. Using dd or a similar tool, create a test file that takes up half of the size of the filesystem.  It is important that this _not_ be fallocated, but just written out.
> 3. Use `fallocate -l` to try and extend the size of the file beyond half the size of the filesystem.
> 
> For BTRFS, this will result in -ENOSPC, while for ext4 and XFS, it will succeed with no error.  Based on this and some low-level inspection, it looks like BTRFS treats the full range of the fallocate call as unallocated, and thus is trying to allocate space for regions of that range that are already allocated.

I can confirm this behavior; below some step to reproduce it [2]; however I don't think that it is a bug, but this is the correct behavior for a COW filesystem (see below).


Looking at the function btrfs_fallocate() (file fs/btrfs/file.c)


static long btrfs_fallocate(struct file *file, int mode,
                            loff_t offset, loff_t len)
{
[...]
        alloc_start = round_down(offset, blocksize);        
        alloc_end = round_up(offset + len, blocksize);
[...]
        /*
         * Only trigger disk allocation, don't trigger qgroup reserve
         *
         * For qgroup space, it will be checked later.
         */
        ret = btrfs_alloc_data_chunk_ondemand(BTRFS_I(inode),
                        alloc_end - alloc_start)


it seems that BTRFS always allocate the maximum space required, without consider the one already allocated. Is it too conservative ? I think no: consider the following scenario:

a) create a 2GB file
b) fallocate -o 1GB -l 2GB
c) write from 1GB to 3GB

after b), the expectation is that c) always succeed [1]: i.e. there is enough space on the filesystem. Due to the COW nature of BTRFS, you cannot rely on the already allocated space because there could be a small time window where both the old and the new data exists on the disk. 

My opinion is that in general this behavior is correct due to the COW nature of BTRFS. 
The only exception that I can find, is about the "nocow" file. For these cases taking in accout the already allocated space would be better.

Comments are welcome.

BR
G.Baroncelli

[1] from man 2 fallocate
[...]
       After  a  successful call, subsequent writes into the range specified by offset and len are
       guaranteed not to fail because of lack of disk space.
[...]


[2]

-- create a 5G btrfs filesystem

# mkdir t1
# truncate --size 5G disk
# losetup /dev/loop0 disk
# mkfs.btrfs /dev/loop0
# mount /dev/loop0 t1

-- test
-- create a 1500 MB file, the expand it to 4000MB
-- expected result: the file is 4000MB size
-- result: fail: the expansion fails

# fallocate -l $((1024*1024*100*15))  file.bin
# fallocate -l $((1024*1024*100*40))  file.bin
fallocate: fallocate failed: No space left on device
# ls -lh file.bin 
-rw-r--r-- 1 root root 1.5G Aug  2 19:09 file.bin


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
