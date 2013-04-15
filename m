Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:63076 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3DOMcf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 08:32:35 -0400
Message-ID: <516BF361.3090300@giantdisaster.de>
Date: Mon, 15 Apr 2013 14:32:33 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add a free space cache checker to fsck V2
References: <1365083870-3241-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1365083870-3241-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 4 Apr 2013 09:57:50 -0400, Josef Bacik wrote:
> In trying to track down a weird tree log problem I wanted to make sure that the
> free space cache was actually valid, which we currently have no way of doing.
> So this patch adds a bunch of support for the free space cache code and then a
> checker to fsck.  Basically we go through and if we can actually load the free
> space cache then we will walk the extent tree and verify that the free space
> cache exactly matches what is in the extent tree.  Hopefully this will always be
> correct, the only time it wouldn't is if the extent tree is corrupt or we have
> some sort of awful bug in the free space cache.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2:
> - fix ret == 1 from btrfs_search_slot leaking out of verify_space_cache
> - check the last bit of free space from the last extent to the end of the block
>   group
> - unlink any entries we find so we can check and make sure the free space cache
>   tree is empty once we're done.
> 

Josef, xfstests 013, 068 and 113 fail with your new fsck free space cache checker, see below.
$TEST_DEV /dev/sdc is a 50GB SSD, $SCRATCH_DEV /dev/sds is a 100GB SSD. Default mount options.
 

# mkfs.btrfs -f -n 16384 $SCRATCH_DEV
# mkfs.btrfs -f -n 16384 $TEST_DEV
# ./check 013
# btrfsck $TEST_DEV
Checking filesystem on /dev/sdc
UUID: 1c91dbb9-2495-4324-bb53-f96e15cff0dc
checking extents
checking free space cache
Wanted bytes 606208, found 16384 for off 191184896
Wanted bytes 911917056, found 16384 for off 191184896
cache appears valid but isnt 29360128
btrfs: unable to add free space :-17
btrfsck: free-space-cache.c:815: btrfs_add_free_space: Assertion `!(ret == -17)' failed.
Aborted

# mkfs.btrfs -f -n 16384 $SCRATCH_DEV
# mkfs.btrfs -f -n 16384 $TEST_DEV
# ./check 013
# btrfsck $TEST_DEV
Checking filesystem on /dev/sdc
UUID: 18046b2a-9c98-4b34-9294-954d094049c2
checking extents
checking free space cache
Wanted bytes 16203776, found 9355264 for off 168624128
Wanted bytes 934477824, found 9355264 for off 168624128
cache appears valid but isnt 29360128
There is no free space entry for 1115480064-1115504640
There is no free space entry for 1115480064-2176843776
cache appears valid but isnt 1103101952
found 380784640 bytes used err is -22
total csum bytes: 87084
total tree bytes: 4833280
total fs tree bytes: 4390912
total extent tree bytes: 245760
btree space waste bytes: 952741
file data blocks allocated: 500023296
 referenced 363667456
Btrfs v0.20-rc1-298-gf65141e

# mkfs.btrfs -f -n 16384 $SCRATCH_DEV
# mkfs.btrfs -f -n 16384 $TEST_DEV
# ./check 068
_check_btrfs_filesystem: filesystem on /dev/sds is inconsistent
*** fsck.btrfs output ***
checking extents
checking free space cache
Wanted bytes 490909696, found 536870912 for off 1103101952
Wanted bytes 1073741824, found 536870912 for off 1103101952
cache appears valid but isnt 1103101952
Checking filesystem on /dev/sds
UUID: d5340e2c-d1e5-4155-afc2-70afb6bbbe85
found 638976 bytes used err is -22
total csum bytes: 0
total tree bytes: 114688
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 107558
file data blocks allocated: 524288
 referenced 524288
Btrfs v0.20-rc1-298-gf65141e
*** end fsck.btrfs output

# mkfs.btrfs -f -n 16384 $SCRATCH_DEV
# mkfs.btrfs -f -n 16384 $TEST_DEV
# ./check 113
_check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
*** fsck.btrfs output ***
checking extents
checking free space cache
btrfs: unable to add free space :-17
btrfsck: free-space-cache.c:815: btrfs_add_free_space: Assertion `!(ret == -17)' failed.
Checking filesystem on /dev/sdc
UUID: 9fef532c-2cf2-4bad-8b00-aa997403b415
*** end fsck.btrfs output


