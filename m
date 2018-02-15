Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sn1nam02on0061.outbound.protection.outlook.com ([104.47.36.61]:10931
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1425962AbeBOQao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 11:30:44 -0500
Subject: Re: Status of FST and mount times
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
Date: Thu, 15 Feb 2018 11:30:38 -0500
MIME-Version: 1.0
In-Reply-To: <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/15/2018 06:12 AM, Hans van Kranenburg wrote:
> On 02/15/2018 02:42 AM, Qu Wenruo wrote:
>> Just as said by Nikolay, the biggest problem of slow mount is the size
>> of extent tree (and HDD seek time)
>>
>> The easiest way to get a basic idea of how large your extent tree is
>> using debug tree:
>>
>> # btrfs-debug-tree -r -t extent <device>
>>
>> You would get something like:
>> btrfs-progs v4.15
>> extent tree key (EXTENT_TREE ROOT_ITEM 0) 30539776 level 0  <<<
>> total bytes 10737418240
>> bytes used 393216
>> uuid 651fcf0c-0ffd-4351-9721-84b1615f02e0
>>
>> That level is would give you some basic idea of the size of your extent
>> tree.
>>
>> For level 0, it could contains about 400 items for average.
>> For level 1, it could contains up to 197K items.
>> ...
>> For leven n, it could contains up to 400 * 493 ^ (n - 1) items.
>> ( n <= 7 )
> 
> Another one to get that data:
> 
> https://github.com/knorrie/python-btrfs/blob/master/examples/show_metadata_tree_sizes.py
> 
> Example, with amount of leaves on level 0 and nodes higher up:
> 
> -# ./show_metadata_tree_sizes.py /
> ROOT_TREE         336.00KiB 0(    20) 1(     1)
> EXTENT_TREE       123.52MiB 0(  7876) 1(    28) 2(     1)
> CHUNK_TREE        112.00KiB 0(     6) 1(     1)
> DEV_TREE           80.00KiB 0(     4) 1(     1)
> FS_TREE          1016.34MiB 0( 64113) 1(   881) 2(    52)
> CSUM_TREE         777.42MiB 0( 49571) 1(   183) 2(     1)
> QUOTA_TREE            0.00B
> UUID_TREE          16.00KiB 0(     1)
> FREE_SPACE_TREE   336.00KiB 0(    20) 1(     1)
> DATA_RELOC_TREE    16.00KiB 0(     1)

Very helpful information.  Thank you Qu and Hans!

I have about 1.7TB of homedir data newly rsync'd data on a single 
enterprise 7200rpm HDD and the following output for btrfs-debug:

extent tree key (EXTENT_TREE ROOT_ITEM 0) 543384862720 level 2
total bytes 6001175126016
bytes used 1832557875200

Hans' (very cool) tool reports:
ROOT_TREE         624.00KiB 0(    38) 1(     1)
EXTENT_TREE       327.31MiB 0( 20881) 1(    66) 2(     1)
CHUNK_TREE        208.00KiB 0(    12) 1(     1)
DEV_TREE          144.00KiB 0(     8) 1(     1)
FS_TREE             5.75GiB 0(375589) 1(   952) 2(     2) 3(     1)
CSUM_TREE           1.75GiB 0(114274) 1(   385) 2(     1)
QUOTA_TREE            0.00B
UUID_TREE          16.00KiB 0(     1)
FREE_SPACE_TREE       0.00B
DATA_RELOC_TREE    16.00KiB 0(     1)

Mean mount times across 5 tests: 4.319s (stddev=0.079s)

Taking 100 snapshots (no changes between snapshots however) of the above 
subvolume doesn't appear to impact mount/umount time.  Snapshot creation 
and deletion both operate at between 0.25s to 0.5s.  I am very impressed 
with snapshot deletion in particular now that qgroups is disabled.

I will do more mount testing with twice and three times that dataset and 
see how mount times scale.

All done on 4.5.5.  I really need to move to a newer kernel.

Best,

ellis
