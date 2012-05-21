Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27246 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab2EUJ3N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 05:29:13 -0400
Message-ID: <4FBA0BF1.1000901@cn.fujitsu.com>
Date: Mon, 21 May 2012 17:33:37 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Newbie questions on some of btrfs code...
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>	<20120518115041.GZ8938@carfax.org.uk>	<CAHf9xva5ux5VXbww2YMjORSSdhSKH7L6W5vbP-ZnxijiGK4fUw@mail.gmail.com>	<4FB9A188.9090403@cn.fujitsu.com> <CAHf9xvZ8+ZXFLRM5R_xjekQOsf2Xaj0UEANMVW5BBJ2YjjhGuw@mail.gmail.com>
In-Reply-To: <CAHf9xvZ8+ZXFLRM5R_xjekQOsf2Xaj0UEANMVW5BBJ2YjjhGuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/21/2012 04:20 PM, Alex Lyakas wrote:

> Hi Liu,
> do you think that this should not happen? I see this all the time, and
> I am not doing any stress tests. Just creating a file and writing some
> data at different offsets, to create "holes" in the file offset space.
> btrfsck does not produce any errors.


I happen to know how it works :)

This comes from our COW feature, when we rewrite a file extent from its middle part,
we will find another space for the new data and leave the original extent alone:

So for the following situation:
> 	item 23 key (266 EXTENT_DATA 4096) itemoff 2269 itemsize 53
> 		extent data disk byte 0 nr 0
> 		extent data offset 0 nr 4096 ram 8192
> 		extent compression 0

As your case, after the first 'size 5' inline extent is written,
"nr 4096 < ram 8192" could come from:
1) dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k seek=12 count=4 conv=notrunc;sync
2) dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k seek=8 count=4 conv=notrunc;sync

1) makes
> 	item 23 key (266 EXTENT_DATA 4096) itemoff 2269 itemsize 53
> 		extent data disk byte 0 nr 0
> 		extent data offset 0 nr 8192 ram 8192
> 		extent compression 0

2) makes
> 	item 23 key (266 EXTENT_DATA 4096) itemoff 2269 itemsize 53
> 		extent data disk byte 0 nr 0
> 		extent data offset 0 nr 4096 ram 8192
> 		extent compression 0

> I am using kernel 3.3.6 and btrfs-progrs compiled from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
> as advised by wiki.
> 
> For example, I have now the following file:
> 	item 20 key (266 INODE_ITEM 0) itemoff 2369 itemsize 160
> 		inode generation 64 size 200005 block group 0 mode 100644 links 1
> 	item 21 key (266 INODE_REF 256) itemoff 2348 itemsize 21
> 		inode ref index 10 namelen 11 name: sparse_file
> 	item 22 key (266 EXTENT_DATA 0) itemoff 2322 itemsize 26
> 		inline extent data size 5 ram 5 compress 0
> 	item 23 key (266 EXTENT_DATA 4096) itemoff 2269 itemsize 53
> 		extent data disk byte 0 nr 0
> 		extent data offset 0 nr 4096 ram 8192
> 		extent compression 0
> 	item 24 key (266 EXTENT_DATA 8192) itemoff 2216 itemsize 53
> 		extent data disk byte 432013312 nr 4096
> 		extent data offset 0 nr 4096 ram 4096
> 		extent compression 0
> 	item 25 key (266 EXTENT_DATA 12288) itemoff 2163 itemsize 53
> 		extent data disk byte 0 nr 0
> 		extent data offset 0 nr 86016 ram 90112
> 		extent compression 0
> 	item 26 key (266 EXTENT_DATA 98304) itemoff 2110 itemsize 53
> 		extent data disk byte 432017408 nr 4096
> 		extent data offset 0 nr 4096 ram 4096
> 		extent compression 0
> 	item 27 key (266 EXTENT_DATA 102400) itemoff 2057 itemsize 53
> 		extent data disk byte 0 nr 0
> 		extent data offset 0 nr 94208 ram 98304
> 		extent compression 0
> 	item 28 key (266 EXTENT_DATA 196608) itemoff 2004 itemsize 53
> 		extent data disk byte 432021504 nr 4096
> 		extent data offset 0 nr 4096 ram 4096
> 		extent compression 0
> 
> Some observations for it:
> # There is a real "hole" between first two extents, because the length
> of first extent is 5 bytes, but second extent starts at offset 4096.
> Is this expected? I see this all the time.


Yup, our extents are sectorsize aligned, say 4096.


> # There are several extents with
> btrfs_file_extent_item::disk_bytenr==0. According to some hints within
> the kernel btrfs code, I presume that these are zero-extents. So when
> I see disk_bytenr==0, I should not try looking up this extent in
> extent tree or in chunk tree, I should assume that this extent should
> be filled by zeros. Is my understanding correct?


'disk_bytenr == 0' means dummy extents, which has no data.


> # The last extent has offset=196608 and size=4096. Adding them up
> gives 200704. However, the file size within INODE_ITEM is 200005. So
> this is the issue you asked about.
> 


Given the sectorsize aligned stuff, the file size of INODE_ITEM is correct, 200005 here.


> I have some more pesky questions, which hopefully you or some other
> devs can help with. Or at least point me at a relevant code to look
> at.
> 
> # What is BTRFS_FILE_EXTENT_PREALLOC? How should I treat
> btrfs_file_extent_item of such type?
> 


IIRC, PREALLOC comes from fallocate or something like that, which means we allocate the
space in advance, and will use it in the future.


> # Why btrfs_previous_item() in btrfs-progs in different from kernel
> code? In kernel code, there are additional checks like this:
> 		nritems = btrfs_header_nritems(leaf);
> 		if (nritems == 0)
> 			return 1;
> 		if (path->slots[0] == nritems)
> 			path->slots[0]--;
> 


The kernel side is more careful, it's ok.


> # What is the btrfs_dir_item::data_len value is used for? I saw it
> appearing in XATTR_ITEM, but not in DIR_INDEX/DIR_ITEM
> 


data_len is xattr relative, plz check the source code: btrfs_set_acl()


thanks,
liubo

> Thanks!
> Alex.
> 
> 
> 
> 
> 
> On Mon, May 21, 2012 at 4:59 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
>> On 05/18/2012 09:32 PM, Alex Lyakas wrote:
>>
>>> Thank you, Hugo, for the detailed explanation. I am now able to find
>>> the CHUNK_ITEMs and to successfully locate the file data on disk.
>>> Can you maybe address several follow-up questions I have?
>>>
>>> # When looking for CHUNK_ITEMs, should I check that their
>>> btrfs_chunk::type==BTRFS_BLOCK_GROUP_DATA (and not SYSTEM/METADATA
>>> etc)? Or file extent should always be mapped to BTRFS_BLOCK_GROUP_DATA
>>> chunk?
>>>
>>> # It looks like I don't even need to bother with the extent tree at
>>> this point, because from EXTENT_DATA in fs tree I can navigate
>>> directly to CHUNK_ITEM in chunk tree, correct?
>>>
>>> # For replicating RAID levels, you said there will be multiple
>>> CHUNK_ITEMs. How do I find them then? Should I know in advance how
>>> much there should be, and look for them, considering only
>>> btrfs_chunk::type==BTRFS_BLOCK_GROUP_DATA? (I don't bother for
>>> replication at this point, though).
>>>
>>> # If I find in the fs tree an EXTENT_DATA of type
>>> BTRFS_FILE_EXTENT_PREALLOC, how should I treat it? What does it mean?
>>> (BTRFS_FILE_EXTENT_INLINE are easy to treat).
>>>
>>> # One of my files has two EXTENT_DATAs, like this:
>>>       item 14 key (270 EXTENT_DATA 0) itemoff 1812 itemsize 53
>>>               extent data disk byte 432508928 nr 1474560
>>>               extent data offset 0 nr 1470464 ram 1474560
>>>               extent compression 0
>>>       item 15 key (270 EXTENT_DATA 1470464) itemoff 1759 itemsize 53
>>>               extent data disk byte 432082944 nr 126976
>>>               extent data offset 0 nr 126976 ram 126976
>>>               extent compression 0
>>> Summing btrfs_file_extent_item::num_bytes gives
>>> 1470464+126976=1597440. (I know that I should not be summing
>>> btrfs_file_extent_item::disk_num_bytes, but num_bytes).
>>> However, it's INODE_ITEM gives size of 1593360, which is less:
>>>       item 11 key (270 INODE_ITEM 0) itemoff 1970 itemsize 160
>>>               inode generation 26 size 1593360 block group 0 mode 100700 links 1
>>>
>>> Is this a valid situation, or I should always consider size in
>>> INODE_ITEM as the correct one?
>>>
>>
>> Hi Alex,
>>
>> Have you tried btrfsck on this 'inode size mismatch' box?
>>
>> And I'm interest in if it can be reproduced and how?
>>
>>
>> thanks,
>> liubo
>>
>>> Thanks again,
>>> Alex.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


