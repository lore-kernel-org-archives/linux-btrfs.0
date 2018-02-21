Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0077.outbound.protection.outlook.com ([104.47.41.77]:6656
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932496AbeBUOt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 09:49:29 -0500
Subject: Re: Status of FST and mount times
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
 <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
 <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <bcb18a10-3e87-66f7-63a4-b6f9906680ec@panasas.com>
Date: Wed, 21 Feb 2018 09:49:22 -0500
MIME-Version: 1.0
In-Reply-To: <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2018 08:49 PM, Qu Wenruo wrote:
>>>> On 2018年02月16日 22:12, Ellis H. Wilson III wrote:
>>>>> $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -l
>>>>> 3454
>>>>
> Increasing node size may reduce extent tree size. Although at most
> reduce one level AFAIK.
> 
> But considering that the higher the node is, the more chance it's
> cached, reducing tree height wouldn't bring much performance impact AFAIK.
> 
> If one could do real world benchmark to beat or prove my assumption, it
> would be much better though.

I'm willing to try this if you tell me exactly what you'd like me to do. 
  I've not mucked with nodesize before, so I'd like to avoid changing it 
to something absurd.

>> Qu's suggestion is actually independent of all the above reasons, but
>> does kind of fit in with the fourth as another case of preventative
>> maintenance.
> 
> My suggestion is to use balance to reduce number of block groups, so we
> could do less search at mount time.
> 
> It's more like reason 2.
> 
> But it only works for case where there are a lot of fragments so a lot
> of chunks are not fully utilized.
> Unfortunately, that's not the case for OP, so my suggestion doesn't make
> sense here.

I ran the balance all the same, and the number of chunks has not 
changed.  Before 3454, and after 3454:
  $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -l
3454

HOWEVER, the time to mount has gone up somewhat significantly, from 
11.537s to 16.553s, which was very unexpected.  Output from previously 
run commands shows the extent tree metadata grew about 25% due to the 
balance.  Everything else stayed roughly the same, and no additional 
data was added to the system (nor snapshots taken, nor additional 
volumes added, etc):

Before balance:
$ sudo ./show_metadata_tree_sizes.py /mnt/btrfs/
ROOT_TREE           1.14MiB 0(    72) 1(     1)
EXTENT_TREE       644.27MiB 0( 41101) 1(   131) 2(     1)
CHUNK_TREE        384.00KiB 0(    23) 1(     1)
DEV_TREE          272.00KiB 0(    16) 1(     1)
FS_TREE            11.55GiB 0(754442) 1(  2179) 2(     5) 3(     2)
CSUM_TREE           3.50GiB 0(228593) 1(   791) 2(     2) 3(     1)
QUOTA_TREE            0.00B
UUID_TREE          16.00KiB 0(     1)
FREE_SPACE_TREE       0.00B
DATA_RELOC_TREE    16.00KiB 0(     1)

After balance:
$ sudo ./show_metadata_tree_sizes.py /mnt/btrfs/
ROOT_TREE           1.16MiB 0(    73) 1(     1)
EXTENT_TREE       806.50MiB 0( 51419) 1(   196) 2(     1)
CHUNK_TREE        384.00KiB 0(    23) 1(     1)
DEV_TREE          272.00KiB 0(    16) 1(     1)
FS_TREE            11.55GiB 0(754442) 1(  2179) 2(     5) 3(     2)
CSUM_TREE           3.49GiB 0(227920) 1(   804) 2(     2) 3(     1)
QUOTA_TREE            0.00B
UUID_TREE          16.00KiB 0(     1)
FREE_SPACE_TREE       0.00B
DATA_RELOC_TREE    16.00KiB 0(     1)

> BTW, if OP still wants to try something to possibly to reduce mount time
> with same the fs, I could try some modification to current block group
> iteration code to see if it makes sense.

I'm glad to try anything if it's helpful to improving BTRFS.  Just let 
me know.

Best,

ellis
