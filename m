Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9994 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab2EUBzP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 21:55:15 -0400
Message-ID: <4FB9A188.9090403@cn.fujitsu.com>
Date: Mon, 21 May 2012 09:59:36 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Newbie questions on some of btrfs code...
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>	<20120518115041.GZ8938@carfax.org.uk> <CAHf9xva5ux5VXbww2YMjORSSdhSKH7L6W5vbP-ZnxijiGK4fUw@mail.gmail.com>
In-Reply-To: <CAHf9xva5ux5VXbww2YMjORSSdhSKH7L6W5vbP-ZnxijiGK4fUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/18/2012 09:32 PM, Alex Lyakas wrote:

> Thank you, Hugo, for the detailed explanation. I am now able to find
> the CHUNK_ITEMs and to successfully locate the file data on disk.
> Can you maybe address several follow-up questions I have?
> 
> # When looking for CHUNK_ITEMs, should I check that their
> btrfs_chunk::type==BTRFS_BLOCK_GROUP_DATA (and not SYSTEM/METADATA
> etc)? Or file extent should always be mapped to BTRFS_BLOCK_GROUP_DATA
> chunk?
> 
> # It looks like I don't even need to bother with the extent tree at
> this point, because from EXTENT_DATA in fs tree I can navigate
> directly to CHUNK_ITEM in chunk tree, correct?
> 
> # For replicating RAID levels, you said there will be multiple
> CHUNK_ITEMs. How do I find them then? Should I know in advance how
> much there should be, and look for them, considering only
> btrfs_chunk::type==BTRFS_BLOCK_GROUP_DATA? (I don't bother for
> replication at this point, though).
> 
> # If I find in the fs tree an EXTENT_DATA of type
> BTRFS_FILE_EXTENT_PREALLOC, how should I treat it? What does it mean?
> (BTRFS_FILE_EXTENT_INLINE are easy to treat).
> 
> # One of my files has two EXTENT_DATAs, like this:
> 	item 14 key (270 EXTENT_DATA 0) itemoff 1812 itemsize 53
> 		extent data disk byte 432508928 nr 1474560
> 		extent data offset 0 nr 1470464 ram 1474560
> 		extent compression 0
> 	item 15 key (270 EXTENT_DATA 1470464) itemoff 1759 itemsize 53
> 		extent data disk byte 432082944 nr 126976
> 		extent data offset 0 nr 126976 ram 126976
> 		extent compression 0
> Summing btrfs_file_extent_item::num_bytes gives
> 1470464+126976=1597440. (I know that I should not be summing
> btrfs_file_extent_item::disk_num_bytes, but num_bytes).
> However, it's INODE_ITEM gives size of 1593360, which is less:
> 	item 11 key (270 INODE_ITEM 0) itemoff 1970 itemsize 160
> 		inode generation 26 size 1593360 block group 0 mode 100700 links 1
> 
> Is this a valid situation, or I should always consider size in
> INODE_ITEM as the correct one?
> 


Hi Alex,

Have you tried btrfsck on this 'inode size mismatch' box?

And I'm interest in if it can be reproduced and how?


thanks,
liubo

> Thanks again,
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


