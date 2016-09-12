Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:43899 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755281AbcILVaD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 17:30:03 -0400
Subject: Re: btrfstune -x -> extent-tree.c:2688: btrfs_reserve_extent:
 Assertion `ret` failed.
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <478c1cee-80f0-c8f3-0bb9-c8c8932a9fb5@mendix.com>
 <20160912123946.GC16983@twin.jikos.cz>
 <a6c78673-935e-7774-e2f8-f6f80130d5f5@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <314a7c80-48c1-b521-e2f2-6bfdbf169808@mendix.com>
Date: Mon, 12 Sep 2016 23:29:58 +0200
MIME-Version: 1.0
In-Reply-To: <a6c78673-935e-7774-e2f8-f6f80130d5f5@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/2016 02:46 PM, Hans van Kranenburg wrote:
> On 09/12/2016 02:39 PM, David Sterba wrote:
>> On Fri, Sep 09, 2016 at 11:37:21PM +0200, Hans van Kranenburg wrote:
>>> Hi,
>>>
>>> While trying to enable skinny metadata on a filesystem, I got this error
>>> (after minutes of reading from disk by the program):
>>>
>>> -# btrfstune -x /dev/xvdb
>>> extent-tree.c:2688: btrfs_reserve_extent: Assertion `ret` failed.
>>> [...]
>>>
>>> Does the shown error ring a bell? What's the next step to debug this?
>>
>> It's a bug in the incompat bit handling the free-space-tree. Opening the
>> filesystem for read-write should not be allowed, but was mistakenly
>> enabled by me.
>>
>>> The filesystem is a clone of the production filesystem (not btrfs clone,
>>> but lower level, on iSCSI storage) meant to be used for upgrade-testing
>>> and performance testing, so if anything goes wrong in whatever way,
>>> there will be no panicing involved.
>>
>> The fix is in devel, but it'd mean that writing to a v2-enabled
>> filesystem will not work (which also means changing some fatures via
>> btrfstune as it uses the transaction mechanism that needs to cow blocks
>> and update free space etc).
> 
> As I replied this morning, I tried it again on a fresh clone of the
> underlying snapshot, before doing anything else first with it.
> 
> So that means at that point it's a filesystem that has only seen 3.16
> kernels before, and does still have old free space cache in place, no v2
> tree.
> 
> And, it still blows up.

After a fresh mount with -o clear_cache,space_cache=v1 and the latest
code from devel, it still happens. So, that change is not related I think.

I want to have my skinny metadata, so I started playing around with the
code, putting print statements in to see what's going on [1]:

-# ./btrfstune -x /dev/xvdb
btrfs_reserve_extent search_start 0 data 52
find_free_extent search_start 0 search_end 18446744073709551615
num_bytes 16384
find_free_extent search_start 0 (check_failed)

[.. lots of reading from disk ..]

find_free_extent new_group search_start 65996496830464
find_free_extent search_start 0 (check_failed)
find_free_extent new_group search_start 65996496830464
find_free_extent search_start 0 (check_failed)
find_free_extent new_group search_start 65996496830464
find_free_extent error -28
btrfs_reserve_extent: find_free_extent ret is -28
extent-tree.c:2694: btrfs_reserve_extent: Assertion `ret` failed.
./btrfstune(btrfs_reserve_extent+0xbdc)[0x419441]
./btrfstune(btrfs_alloc_free_block+0x50)[0x4195e0]
./btrfstune(__btrfs_cow_block+0x19d)[0x408dab]
./btrfstune(btrfs_cow_block+0xec)[0x409805]
./btrfstune[0x40efc0]
./btrfstune(btrfs_commit_transaction+0xec)[0x410c25]
./btrfstune(main+0x55f)[0x438e71]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f13e244b700]
./btrfstune(_start+0x29)[0x407c29]

-28 is ENOSPC, 65996496830464 would be the vaddr of a newly added block
group.

So am I right to see that it is looking for a place to put 16kB of
metadata? For some reason, which I didn't find out yet, it can't find a
suitable place, then starts thinking about creating a new block group...
and then again, and then gives up...

I have 850 metadata block groups in this fs, and they're all at ~98%
usage level.

[1]
https://github.com/knorrie/btrfs-progs/commit/80f931627983d52d8a438e00140ae63d98abf74b

-- 
Hans van Kranenburg
