Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:57205 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab3AGSUu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 13:20:50 -0500
Message-ID: <50EB11E0.8030403@tiscalinet.it>
Date: Mon, 07 Jan 2013 19:20:16 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz
CC: util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
References: <50E9C267.3050302@inwind.it> <20130107163327.GK20089@twin.jikos.cz>
In-Reply-To: <20130107163327.GK20089@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 01/07/2013 05:33 PM, David Sterba wrote:
> On Sun, Jan 06, 2013 at 07:28:55PM +0100, Goffredo Baroncelli wrote:
>> Currently wipefs doesn't clear all the superblock of btrfs. Only the first 
>> one is cleared.
>>
>> Btrfs has three superblocks. The first one is placed at 64KB, the second 
>> one at 64MB, the third one at 256GB.
> 
> It can have as much as 4 superblock backup copies:
> 
> Superblock offset 0 is 65536 (0x10000, block=16/0x10)
> Superblock offset 1 is 67108864 (0x4000000, block=16384/0x4000)
> Superblock offset 2 is 274877906944 (0x4000000000, block=67108864/0x4000000)
> Superblock offset 3 is 1125899906842624 (0x4000000000000, block=274877906944/0x4000000000)
> Superblock offset 4 is 4611686018427387904 (0x4000000000000000, block=1125899906842624/0x4000000000000)

Are you sure ?

Regarding the btrfs-progs suite, I looked at the btrfs_read_dev_super():
[..]
        for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
                bytenr = btrfs_sb_offset(i);
                ret = pread64(fd, &buf, sizeof(buf), bytenr);

Where BTRFS_SUPER_MIRROR_MAX is 3.

Regarding the kernel code, I looked at several function which call
btrfs_sb_offset(); everywhere there is an upper limit of the superblock
numbero which is BTRFS_SUPER_MIRROR_MAX, which is still 3.

Moreover I performed the following test:

$ ls -lh 7tb-filesystem.img
-rw-r--r-- 1 ghigo ghigo 7.1E Jan  7 18:49 7eb-filesystem.img
$ /sbin/mkfs.btrfs 7eb-filesystem.img

$ cat extract-sign.py
import os

BTRFS_SUPER_MIRROR_SHIFT = 12
BTRFS_SUPER_INFO_OFFSET = (64*1024)

def btrfs_sb_offset(mirror):
    start = 16*1024
    if(mirror):
        return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror)
    return BTRFS_SUPER_INFO_OFFSET

f = open("7eb-filesystem.img","r")
for i in range(5):
    pos = btrfs_sb_offset(i)+64
    f.seek(pos)
    sign = f.read(8)

    print "Superblock #%d - %20d - '%s'"%(i,pos,sign)

$ python extract-sign.py
Superblock #0 -                65600 - '_BHRfS_M'
Superblock #1 -             67108928 - '_BHRfS_M'
Superblock #2 -         274877907008 - '_BHRfS_M'
Superblock #3 -     1125899906842688 - ''
Superblock #4 -  4611686018427387968 - ''


To me it seems that in a 7TB filesystem there is only 3 superblocks.


> 
>> If the first superblock is valid except that the "magic field" is zeroed,
>> btrfs skips the check of the other superblocks.
>> If the first superblock is fully invalid, btrfs checks for the other
>> superblock.
>>
>> So zeroing the first superblock "magic field" at the beginning seems
>> that the filesystem is wiped. But when the first superblock is overwritten
>> (e.g. by another filesystem), then the other two superblocks may be considered
>> valid, and the filesystem may resurrect.
> 
> And for that purpose all the superblock copies should be taken into
> account, regardless of the tricks that btrfs_mount applies.
> 
> 
> david
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
