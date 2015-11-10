Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58534 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbbKJG1y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 01:27:54 -0500
To: btrfs <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Ideas for btrfs-convert fix(or rework)
Message-ID: <56418E5D.9020604@gmx.com>
Date: Tue, 10 Nov 2015 14:27:41 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Someone may already knows, I'm recently trying to fix(or rework) the old 
btrfs-convert, to allow it to support separate data and meta chunks.

[[FIX IDEA]]
The overall idea is quite simple and straight forward:
Separate meta/sys chunk at very *beginning*, then insert data chunks to 
covert ext* used space.
Then use normal btrfs routines to do remaining work.

No custom chunk/extent allocation nor wired system chunk mapping.

1. Create sb,sys and meta chunks at make_btrfs() time
    Created meta and sys chunk will be ensured not covering ext* used
    space
    (Done)

2. Open the temp fs, and insert data chunks to cover all ext* used space
    We will only need to ensure sys/meta chunks is large enough to
    containing created data chunk and block group items.
    Data chunks are 1:1 mapped on disk.
    (Done)

3. Create ext* subvolume and image
    Now do what ever we want, as all data chunks are allocated, we can
    do normal chunk allocation and won't overwrite ext* data.
    Much like old codes. But need some modification to co-operate with
    above codes
    (WIP)

4. Copy inodes
    Should be much like old codes, but it's done after ext2 image, it
    should be easier than old one.
    (Not started yet)

5. Relocate extents covered by first 1M and backup super blocks
    Hard part, maybe I can do it at step 1 and 2 to make things easy.
    (Not started yet)

6. Change may_rollback() check
    As now ext2 image is only mapped for used space, old may_rollback()
    check is not suitable here.
    (Not started yet)

Or ascii art version:
1. Original Ext2/3/4 used space:
0		256M		512M		768M		1G
|///|  |//|	|//|	|/////////////|

2. New sb + meta + sys chunks at make_btrfs() time:
					|SB|<-Sys->|<-Meta->|

3. Insert data chunks
|<-Data--->|	|<-----Data------------>|SB|<-Sys->|<-Meta->|

4. Create subvolume and ext* image
|<-Data--->|NewD|<-----Data------------>|SB|<-Sys->|<-Meta->|NewM|
NewD = new data chunk, NewM = new meta chunk


5. Relocate SB and 1M leading reserve
Not sure yet.
Maybe to relocate the whole chunk like:
|SB| |SB|  |NewD|<-----Data------------>|  |<-Sys->|<-Meta->|NewM|RecD|
RecD = relocated data chunk

Or at Step 2 we already reserved some holes for SB
|SB|D|SB|DD|NewD|<-----Data------------>|  |<-Sys->|<-Meta->|NewM|
D = data chunk


Existing codes can be checked at my github:
https://github.com/adam900710/btrfs-progs/tree/convert_chunk_profile

[[PROBLEMS]]
1. Too many patches
    Even after step 2, I have already 20 patches and near 1500 lines.
    Although most of them are codes to make old make_btrfs() more
    modularized to fit the need of flex of new make_btrfs_v2().

    I'm not sure when the number of patches will stop growing, and what
    makes thing worse is, maybe until the last few patches all the codes
    will be really executed, so I can't submit them half way...

2. superblock reserve is d*mning hard, not matter at what timing.
    Until I need to codes for superblock reserve, the codes are quite
    easy to write.
    But when it comes to sb reserve, I'm going to get crazy...

    I'll either add tons of codes to the simple chunk allocation to
    avoid using SB space and keep all chunks are large enough.
    Or I need to implement user-space whole chunk relocation codes.

    I miss the old days when sb_bytenr can be specified by user...
    Then my work should be quite close to end...

3. Too aggressive rework
    I suppose this will not be a fix, but a total rework of the whole
    btrfs-convert program.
    Maybe only less than 30% old codes will stay, most of them will be
    rewritten.

    No matter how I think the new code will be superior than old one,
    I'm pretty sure there will be tons of regression or new bugs for
    such huge rework.

    But without such work, btrfs-convert will always be a mess and no
    real support for balance.

So any ideas or advice is welcomed for this rework.

Thanks,
Qu
