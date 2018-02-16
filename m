Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:36037 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033347AbeBPOUG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 09:20:06 -0500
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <82cda32d-8069-4a27-7f78-cf3242eeeb36@mendix.com>
Date: Fri, 16 Feb 2018 15:20:02 +0100
MIME-Version: 1.0
In-Reply-To: <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/16/2018 03:12 PM, Ellis H. Wilson III wrote:
> On 02/15/2018 08:55 PM, Qu Wenruo wrote:
>> On 2018年02月16日 00:30, Ellis H. Wilson III wrote:
>>> Very helpful information.  Thank you Qu and Hans!
>>>
>>> I have about 1.7TB of homedir data newly rsync'd data on a single
>>> enterprise 7200rpm HDD and the following output for btrfs-debug:
>>>
>>> extent tree key (EXTENT_TREE ROOT_ITEM 0) 543384862720 level 2
>>> total bytes 6001175126016
>>> bytes used 1832557875200
>>>
>>> Hans' (very cool) tool reports:
>>> ROOT_TREE         624.00KiB 0(    38) 1(     1)
>>> EXTENT_TREE       327.31MiB 0( 20881) 1(    66) 2(     1)
>>
>> Extent tree is not so large, a little unexpected to see such slow mount.
>>
>> BTW, how many chunks do you have?
>>
>> It could be checked by:
>>
>> # btrfs-debug-tree -t chunk <device> | grep CHUNK_ITEM | wc -l
> 
> Since yesterday I've doubled the size by copying the homdir dataset in
> again.  Here are new stats:
> 
> extent tree key (EXTENT_TREE ROOT_ITEM 0) 385990656 level 2
> total bytes 6001175126016
> bytes used 3663525969920
> 
> $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -l
> 3454
> 
> $ sudo ./show_metadata_tree_sizes.py /mnt/btrfs/
> ROOT_TREE           1.14MiB 0(    72) 1(     1)
> EXTENT_TREE       644.27MiB 0( 41101) 1(   131) 2(     1)
> CHUNK_TREE        384.00KiB 0(    23) 1(     1)
> DEV_TREE          272.00KiB 0(    16) 1(     1)
> FS_TREE            11.55GiB 0(754442) 1(  2179) 2(     5) 3(     2)
> CSUM_TREE           3.50GiB 0(228593) 1(   791) 2(     2) 3(     1)
> QUOTA_TREE            0.00B
> UUID_TREE          16.00KiB 0(     1)
> FREE_SPACE_TREE       0.00B
> DATA_RELOC_TREE    16.00KiB 0(     1)
> 
> The old mean mount time was 4.319s.  It now takes 11.537s for the
> doubled dataset.  Again please realize this is on an old version of
> BTRFS (4.5.5), so perhaps newer ones will perform better, but I'd still
> like to understand this delay more.  Should I expect this to scale in
> this way all the way up to my proposed 60-80TB filesystem so long as the
> file size distribution stays roughly similar?  That would definitely be
> in terms of multiple minutes at that point.

Well, imagine you have a big tree (an actual real life tree outside) and
you need to pick things (e.g. apples) which are hanging everywhere.

So, what you need to to is climb the tree, climb on a branch all the way
to the end where the first apple is... climb back, climb up a bit, go
onto the next branch to the end for the next apple... etc etc....

The bigger the tree is, the longer it keeps you busy, because the apples
will be semi-evenly distributed around the full tree, and they're always
hanging at the end of the branch. The speed with which you can climb
around (random read disk access IO speed for btrfs, because your disk
cache is empty when first mounting) determines how quickly you're done.

So, yes.

>>> Taking 100 snapshots (no changes between snapshots however) of the above
>>> subvolume doesn't appear to impact mount/umount time.
>>
>> 100 unmodified snapshots won't affect mount time.
>>
>> It needs new extents, which can be created by overwriting extents in
>> snapshots.
>> So it won't really cause much difference if all these snapshots are all
>> unmodified.
> 
> Good to know, thanks!
> 
>>> Snapshot creation
>>> and deletion both operate at between 0.25s to 0.5s.
>>
>> IIRC snapshot deletion is delayed, so the real work doesn't happen when
>> "btrfs sub del" returns.
> 
> I was using btrfs sub del -C for the deletions, so I believe (if that
> command truly waits for the subvolume to be utterly gone) it captures
> the entirety of the snapshot.
> 
> Best,
> 
> ellis


-- 
Hans van Kranenburg
