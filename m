Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:60383 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbcIQEQ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 00:16:27 -0400
Date: Sat, 17 Sep 2016 00:16:23 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Post ext3 conversion problems
Message-ID: <20160917041622.GB1156@coach.home>
References: <20160916192459.GA13514@coach.home>
 <20160917022758.GA6389@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160917022758.GA6389@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 07:27:58PM -0700, Liu Bo wrote:
> Interesting, seems that we get errors from 
> 
> btrfs_finish_ordered_io
>   insert_reserved_file_extent
>     __btrfs_drop_extents
> 
> And splitting an inline extent throws -95.

Heh, you beat me to the draw. I was just coming to the same conclusion
myself from poking at the source code. What's interesting is that it
seems to be a quite explicit thing:

if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
	ret = -EOPNOTSUPP;
	break;
}

So now the question is why is this happening? Clearly the presence of
inline extents isn't an issue by itself, since another one of my btrfs
/home partitions has plenty of them.

I added some debug prints to my kernel to catch the inode that tripped
the error. Here's the relevant chunk (with filenames scrubbed) from
btrfs-debug-tree:

Inode 140345 triggered the transaction abort.

leaf 175131459584 items 51 free space 7227 generation 118521 owner 5
fs uuid 1d9ee7c7-d13a-4c3c-b730-256c70841c5b
chunk uuid b67a1a82-ff22-48b5-af1b-9d5f85ebee25
	item 0 key (140343 INODE_ITEM 0) itemoff 16123 itemsize 160
		inode generation 1 transid 1 size 180 nbytes 0
		block group 0 mode 40755 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 1 key (140343 INODE_REF 131327) itemoff 16107 itemsize 16
		inode ref index 199 namelen 6 name: <scrubbed>
	item 2 key (140343 DIR_ITEM 1073386496) itemoff 16072 itemsize 35
		location key (142600 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 3 key (140343 DIR_ITEM 1148422723) itemoff 16037 itemsize 35
		location key (142601 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 4 key (140343 DIR_ITEM 2415965623) itemoff 16004 itemsize 33
		location key (131550 INODE_ITEM 0) type SYMLINK
		namelen 3 datalen 0 name: <scrubbed>
	item 5 key (140343 DIR_ITEM 2448077466) itemoff 15965 itemsize 39
		location key (140565 INODE_ITEM 0) type FILE
		namelen 9 datalen 0 name: <scrubbed>
	item 6 key (140343 DIR_ITEM 2566671093) itemoff 15930 itemsize 35
		location key (140564 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 7 key (140343 DIR_ITEM 3391512089) itemoff 15873 itemsize 57
		location key (142599 INODE_ITEM 0) type FILE
		namelen 27 datalen 0 name: <scrubbed>
	item 8 key (140343 DIR_ITEM 3621719155) itemoff 15838 itemsize 35
		location key (131627 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 9 key (140343 DIR_ITEM 3701680574) itemoff 15798 itemsize 40
		location key (142603 INODE_ITEM 0) type FIFO
		namelen 10 datalen 0 name: <scrubbed>
	item 10 key (140343 DIR_ITEM 3816117430) itemoff 15763 itemsize 35
		location key (140563 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 11 key (140343 DIR_ITEM 4214885080) itemoff 15729 itemsize 34
		location key (131544 INODE_ITEM 0) type SYMLINK
		namelen 4 datalen 0 name: <scrubbed>
	item 12 key (140343 DIR_ITEM 4253409616) itemoff 15687 itemsize 42
		location key (140352 INODE_ITEM 0) type FILE
		namelen 12 datalen 0 name: <scrubbed>
	item 13 key (140343 DIR_INDEX 2) itemoff 15653 itemsize 34
		location key (131544 INODE_ITEM 0) type SYMLINK
		namelen 4 datalen 0 name: <scrubbed>
	item 14 key (140343 DIR_INDEX 3) itemoff 15620 itemsize 33
		location key (131550 INODE_ITEM 0) type SYMLINK
		namelen 3 datalen 0 name: <scrubbed>
	item 15 key (140343 DIR_INDEX 4) itemoff 15585 itemsize 35
		location key (131627 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 16 key (140343 DIR_INDEX 5) itemoff 15543 itemsize 42
		location key (140352 INODE_ITEM 0) type FILE
		namelen 12 datalen 0 name: <scrubbed>
	item 17 key (140343 DIR_INDEX 6) itemoff 15508 itemsize 35
		location key (140563 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 18 key (140343 DIR_INDEX 7) itemoff 15473 itemsize 35
		location key (140564 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 19 key (140343 DIR_INDEX 8) itemoff 15434 itemsize 39
		location key (140565 INODE_ITEM 0) type FILE
		namelen 9 datalen 0 name: <scrubbed>
	item 20 key (140343 DIR_INDEX 9) itemoff 15377 itemsize 57
		location key (142599 INODE_ITEM 0) type FILE
		namelen 27 datalen 0 name: <scrubbed>
	item 21 key (140343 DIR_INDEX 10) itemoff 15342 itemsize 35
		location key (142600 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 22 key (140343 DIR_INDEX 11) itemoff 15307 itemsize 35
		location key (142601 INODE_ITEM 0) type SYMLINK
		namelen 5 datalen 0 name: <scrubbed>
	item 23 key (140343 DIR_INDEX 12) itemoff 15267 itemsize 40
		location key (142603 INODE_ITEM 0) type FIFO
		namelen 10 datalen 0 name: <scrubbed>
	item 24 key (140344 INODE_ITEM 0) itemoff 15107 itemsize 160
		inode generation 1 transid 3804 size 2779 nbytes 2779
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 25 key (140344 INODE_REF 131327) itemoff 15088 itemsize 19
		inode ref index 7 namelen 9 name: <scrubbed>
	item 26 key (140344 EXTENT_DATA 0) itemoff 12288 itemsize 2800
		inline extent data size 2779 ram 2779 compress(none)
	item 27 key (140345 INODE_ITEM 0) itemoff 12128 itemsize 160
		inode generation 1 transid 3812 size 53212 nbytes 53248
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 28 key (140345 INODE_REF 147957) itemoff 12109 itemsize 19
		inode ref index 17 namelen 9 name: <scrubbed>
	item 29 key (140345 EXTENT_DATA 0) itemoff 12056 itemsize 53
		extent data disk byte 189201358848 nr 53248
		extent data offset 0 nr 53248 ram 53248
		extent compression(none)
	item 30 key (140347 INODE_ITEM 0) itemoff 11896 itemsize 160
		inode generation 1 transid 1 size 89666 nbytes 90112
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 31 key (140347 INODE_REF 131327) itemoff 11878 itemsize 18
		inode ref index 140 namelen 8 name: <scrubbed>
	item 32 key (140347 EXTENT_DATA 0) itemoff 11825 itemsize 53
		extent data disk byte 154930053120 nr 90112
		extent data offset 0 nr 90112 ram 90112
		extent compression(none)
	item 33 key (140348 INODE_ITEM 0) itemoff 11665 itemsize 160
		inode generation 1 transid 1 size 27 nbytes 28
		block group 0 mode 120777 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 34 key (140348 INODE_REF 131327) itemoff 11646 itemsize 19
		inode ref index 197 namelen 9 name: <scrubbed>
	item 35 key (140348 EXTENT_DATA 0) itemoff 11597 itemsize 49
		inline extent data size 28 ram 28 compress(none)
	item 36 key (140349 INODE_ITEM 0) itemoff 11437 itemsize 160
		inode generation 1 transid 1 size 37963 nbytes 40960
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 37 key (140349 INODE_REF 180481) itemoff 11408 itemsize 29
		inode ref index 2 namelen 19 name: <scrubbed>
	item 38 key (140349 EXTENT_DATA 0) itemoff 11355 itemsize 53
		extent data disk byte 157136482304 nr 180224
		extent data offset 139264 nr 40960 ram 180224
		extent compression(none)
	item 39 key (140352 INODE_ITEM 0) itemoff 11195 itemsize 160
		inode generation 1 transid 1 size 826 nbytes 826
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 40 key (140352 INODE_REF 140343) itemoff 11173 itemsize 22
		inode ref index 5 namelen 12 name: <scrubbed>
	item 41 key (140352 EXTENT_DATA 0) itemoff 10326 itemsize 847
		inline extent data size 826 ram 826 compress(none)
	item 42 key (140354 INODE_ITEM 0) itemoff 10166 itemsize 160
		inode generation 1 transid 1 size 1032 nbytes 1032
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 43 key (140354 INODE_REF 246185) itemoff 10112 itemsize 54
		inode ref index 301 namelen 44 name: <scrubbed>
	item 44 key (140354 EXTENT_DATA 0) itemoff 9059 itemsize 1053
		inline extent data size 1032 ram 1032 compress(none)
	item 45 key (140357 INODE_ITEM 0) itemoff 8899 itemsize 160
		inode generation 1 transid 1 size 0 nbytes 0
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 46 key (140357 INODE_REF 247133) itemoff 8865 itemsize 34
		inode ref index 18 namelen 24 name: <scrubbed>
	item 47 key (140358 INODE_ITEM 0) itemoff 8705 itemsize 160
		inode generation 1 transid 3811 size 0 nbytes 0
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 48 key (140358 INODE_REF 140136) itemoff 8686 itemsize 19
		inode ref index 3 namelen 9 name: <scrubbed>
	item 49 key (140359 INODE_ITEM 0) itemoff 8526 itemsize 160
		inode generation 1 transid 3812 size 1150 nbytes 1150
		block group 0 mode 100644 links 1 uid 1000 gid 1000
		rdev 0 flags 0x0(none)
	item 50 key (140359 INODE_REF 147967) itemoff 8502 itemsize 24
		inode ref index 11 namelen 14 name: <scrubbed>

--Sean

