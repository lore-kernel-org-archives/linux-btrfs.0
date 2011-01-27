From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] Btrfs: New inode number allocator
Date: Thu, 27 Jan 2011 15:10:56 +0800
Message-ID: <4D411A80.6050109@cn.fujitsu.com>
References: <4D3F7E7C.6080903@cn.fujitsu.com> <1296070624-sup-5026@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296070624-sup-5026@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Excerpts from Li Zefan's message of 2011-01-25 20:53:00 -0500:
>> (WARNING: this patch is not completed or well-tested)
>>
>> We used to allocate inode number by searching through inode items, but 
>> it made the allocation slower and slower as more and more files created.
>>
>> The current code just records the highest objectid in the btree without
>> reusing old inode numbers, which will make the filesystem run out of
>> inode number as we create/delete files.
>>
>> In this patch, free inode numbers are stored in the fs tree with key:
>>
>>     [start, BTRFS_INO_EXTENT_KEY, end]
> 
> Thanks a lot for working on this, it isn't an easy problem.
> 
> I think Josef's free space cache for the extent allocation tree is the
> model you want to use.  They are actually solving exactly the same
> problem:
> 
> In the extent allocation tree, a free extent is one with no keys in the
> tree.
> 
> In the FS tree, a free inode is one with no keys in the tree.
> 
> He has a cache that gets written on a per block group basis for the free
> extents in that block group.  It's a somewhat easier problem to solve in
> the inode number cache because you don't have the same problem where you
> need free blocks to store the free block cache ;)
> 
> In his code, the cache stores the generation number of the commit that
> was used to create the cache.  If a cache unaware kernel mounts the
> filesystem and makes changes, we notice on the next mount because the
> cache generation number doesn't match the filesystem generation number.
> 
> It will probably be easiest to dedicate a specific objectid to the inode
> number cache in each FS tree (say objectid == -12ULL), and then put the
> caching items directly in the tree under that objectid.
> 
> I'd suggest that you also reuse his code to compactly store a range of
> free extents.  It wouldn't be hard to have a simple compression scheme
> that stored ranges for huge chunks of free inode numbers and did a
> bitmask for ranges where there are lots of free individual inodes.
> 

I'll take your suggestion and try to implement it. Thanks.

(btw, I'll be off from Feb 29th to Mar 7th for Chinese Spring Festival)
