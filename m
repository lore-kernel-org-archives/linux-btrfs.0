Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:58152 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753730AbeFTCzQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 22:55:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 20 Jun 2018 10:55:14 +0800
From: robbieko <robbieko@synology.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix physical offset reported by fiemap for inline
 extents
In-Reply-To: <20180619113142.9020-1-fdmanana@kernel.org>
References: <20180619113142.9020-1-fdmanana@kernel.org>
Message-ID: <a3ac21e1b8a15a3f8ec8d67992ef4de8@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fdmanana@kernel.org 於 2018-06-19 19:31 寫到:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit 9d311e11fc1f ("Btrfs: fiemap: pass correct bytenr when
> fm_extent_count is zero") introduced a regression where we no longer
> report 0 as the physical offset for inline extents. This is because it
> always sets the variable used to report the physical offset ("disko")
> as em->block_start plus some offset, and em->block_start has the value
> 18446744073709551614 ((u64) -2) for inline extents.
> 
> This made the btrfs test 004 (from fstests) often fail, for example, 
> for
> a file with an inline extent we have the following items in the 
> subvolume
> tree:
> 
>     item 101 key (418 INODE_ITEM 0) itemoff 11029 itemsize 160
>            generation 25 transid 38 size 1525 nbytes 1525
>            block group 0 mode 100666 links 1 uid 0 gid 0 rdev 0
>            sequence 0 flags 0x2(none)
>            atime 1529342058.461891730 (2018-06-18 18:14:18)
>            ctime 1529342058.461891730 (2018-06-18 18:14:18)
>            mtime 1529342058.461891730 (2018-06-18 18:14:18)
>            otime 1529342055.869892885 (2018-06-18 18:14:15)
>     item 102 key (418 INODE_REF 264) itemoff 11016 itemsize 13
>            index 25 namelen 3 name: fc7
>     item 103 key (418 EXTENT_DATA 0) itemoff 9470 itemsize 1546
>            generation 38 type 0 (inline)
>            inline extent data size 1525 ram_bytes 1525 compression 0 
> (none)
> 
> Then when test 004 invoked fiemap against the file it got a non-zero
> physical offset:
> 
>  $ filefrag -v /mnt/p0/d4/d7/fc7
>  Filesystem type is: 9123683e
>  File size of /mnt/p0/d4/d7/fc7 is 1525 (1 block of 4096 bytes)
>   ext:     logical_offset:        physical_offset: length:   expected: 
> flags:
>     0:        0..    4095: 18446744073709551614..      4093:   4096:
>           last,not_aligned,inline,eof
>  /mnt/p0/d4/d7/fc7: 1 extent found
> 
> This resulted in the test failing like this:
> 
> btrfs/004 49s ... [failed, exit status 1]- output mismatch (see
> /home/fdmanana/git/hub/xfstests/results//btrfs/004.out.bad)
>     --- tests/btrfs/004.out	2016-08-23 10:17:35.027012095 +0100
>     +++
> /home/fdmanana/git/hub/xfstests/results//btrfs/004.out.bad	2018-06-18
> 18:15:02.385872155 +0100
>     @@ -1,3 +1,10 @@
>      QA output created by 004
>      *** test backref walking
>     -*** done
>     +./tests/btrfs/004: line 227: [: 7.55578637259143e+22: integer
> expression expected
>     +ERROR: 7.55578637259143e+22 is not a valid numeric value.
>     +unexpected output from
>     +	/home/fdmanana/git/hub/btrfs-progs/btrfs inspect-internal
> logical-resolve -s 65536 -P 7.55578637259143e+22
> /home/fdmanana/btrfs-tests/scratch_1
>     ...
>     (Run 'diff -u tests/btrfs/004.out
> /home/fdmanana/git/hub/xfstests/results//btrfs/004.out.bad'  to see
> the entire diff)
> Ran: btrfs/004
> 
> The large number in scientific notation reported as an invalid numeric
> value is the result from the filter passed to perl which multiplies the
> physical offset by the block size reported by fiemap.
> 
> So fix this by ensuring the physical offset is always set to 0 when we
> are processing an inline extent.
> 
> Fixes: 9d311e11fc1f ("Btrfs: fiemap: pass correct bytenr when
> fm_extent_count is zero")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/extent_io.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8e4a7cdbc9f5..978327d98fc5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4559,6 +4559,7 @@ int extent_fiemap(struct inode *inode, struct
> fiemap_extent_info *fieinfo,
>  			end = 1;
>  			flags |= FIEMAP_EXTENT_LAST;
>  		} else if (em->block_start == EXTENT_MAP_INLINE) {
> +			disko = 0;
>  			flags |= (FIEMAP_EXTENT_DATA_INLINE |
>  				  FIEMAP_EXTENT_NOT_ALIGNED);
>  		} else if (em->block_start == EXTENT_MAP_DELALLOC) {


EXTENT_MAP_DELALLOC should have the same problem.

em->block_start has some special values. The following values ​​should 
not be considered disko
#define EXTENT_MAP_LAST_BYTE((u64)-4)
#define EXTENT_MAP_HOLE((u64)-3)
#define EXTENT_MAP_INLINE((u64)-2)
#define EXTENT_MAP_DELALLOC((u64)-1)

Is the following change more suitable?
if (em->block_start >= EXTENT_MAP_LAST_BYTE)
     disko = 0;
else
     disko = em->block_start + offset_in_extent;

Thanks.
Robbie Ko


