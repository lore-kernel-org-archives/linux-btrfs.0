Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65200 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750930AbcL3Akj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 19:40:39 -0500
Subject: Re: [PATCH v2 00/19]
To: <kreijack@inwind.it>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
 <018da5f8-a4e7-f35e-6eac-e01f6936a3e1@inwind.it>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <94d2445f-46ba-ef8e-709d-61cb36ade32c@cn.fujitsu.com>
Date: Fri, 30 Dec 2016 08:40:24 +0800
MIME-Version: 1.0
In-Reply-To: <018da5f8-a4e7-f35e-6eac-e01f6936a3e1@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

At 12/30/2016 02:15 AM, Goffredo Baroncelli wrote:
> Hi Qu,
>
> I tried your patch, because I had an hardware failure and I needed to check the data integrity.

I'm glad the function helps.

> I didn't find any problem however I was not able to understand what "btrfs check --scrub" was doing because the program didn't give any output (there is no progress bar).

Right, I should add a progress bar to it.
Maybe in next version along with repair function.

The good thing is, no output means good, just like normal fsck.

> So I tried to strace it to check if the program was working properly. The strace output showed me that the program ran correctly.
> However form the strace I noticed that the program read several time the same page (size 16k).
> I think that this is due to the  walking of the btree. However this could be a possible optimization: cache the last read(s).

That doesn't mean it's scrubbing the same leaf, but just normal tree search.

The leaf would be extent root or nodes near extent root.
The offline scrub heavily rely on extent tree to determine if there is 
any extent need to be scrubbed.

Further more, the idea to cache extent tree is not really that easy, 
according to what we have learned from btrfsck.
(Cache may go out of control to explode your RAM).


But your idea to cache still makes sense, for block-device, cache would 
always be good.
(For normal file, kernel provides cache so we don't need to implement by 
ourself)
Although that may need to be implemented in the ctree operation code 
instead of the offline scrub.

BTW, just for reference, what's your device size and how much time it 
takes to do the offline scrub?

Thanks,
Qu

>
> Only my 2¢
>
> BR
> G.Baroncelli
>
>
>
> On 2016-12-26 07:29, Qu Wenruo wrote:
>> For any one who wants to try it, it can be get from my repo:
>> https://github.com/adam900710/btrfs-progs/tree/offline_scrub
>>
>> Currently, I only tested it on SINGLE/DUP/RAID1/RAID5 filesystems, with
>> mirror or parity or data corrupted.
>> The tool are all able to detect them and give recoverbility report.
>>
>> Several reports on kernel scrub screwing up good data stripes are in ML
>> for sometime.
>>
>> And since kernel scrub won't account P/Q corruption, it makes us quite
>> to detect error like kernel screwing up P/Q when scrubbing.
>>
>> To get a comparable tool for kernel scrub, we need a user-space tool to
>> act as benchmark to compare their different behaviors.
>>
>> So here is the patchset for user-space scrub.
>>
>> Which can do:
>>
>> 1) All mirror/backup check for non-parity based stripe
>>    Which means for RAID1/DUP/RAID10, we can really check all mirrors
>>    other than the 1st good mirror.
>>
>>    Current "--check-data-csum" option will be finally replace by scrub.
>>    As it doesn't really check all mirrors, if it hits a good copy, then
>>    resting copies will just be ignored.
>>
>> 2) Comprehensive RAID5/6 full stripe check
>>    It will take full use of btrfs csum(both tree and data).
>>    It will only recover the full stripe if all recovered data matches
>>    with its csum.
>>
>> In fact, it can already expose several new btrfs kernel bug.
>> As it's the main tool I'm using when developing the kernel fixes.
>>
>> For example, after screwing up a data stripe, kernel did repairs using
>> parity, but recovered full stripe has wrong parity.
>> Need to scrub again to fix it.
>>
>> And this patchset also introduced new map_block() function, which is
>> more flex than current btrfs_map_block(), and has a unified interface
>> for all profiles, not just an array of physical addresses.
>>
>> Check the 6th and 7th patch for details.
>>
>> They are already used in RAID5/6 scrub, but can also be used for other
>> profiles too.
>>
>> The to-do list has been shortened, since RAID6 and new check logical is
>> introduced.
>> 1) Repair support
>>    In fact, current tool can already report recoverability, repair is
>>    not hard to implement.
>>
>> 2) Test cases
>>    Need to make the infrastructure able to handle multi-device first.
>>
>> 3) Make btrfsck able to handle RAID5 with missing device
>>    Now it doesn't even open RAID5 btrfs with missing device, even though
>>    scrub should be able to handle it.
>>
>> Changelog:
>> V0.8 RFC:
>>    Initial RFC patchset
>>
>> v1:
>>    First formal patchset.
>>    RAID6 recovery support added, mainly copied from kernel radi6 lib.
>>    Cleaner recovery logical.
>>
>> v2:
>>    More comments in both code and commit message, suggested by David.
>>    File re-arrangement, no check/ dir, raid56.ch moved to kernel-lib,
>>    Suggested by David
>>
>> Qu Wenruo (19):
>>   btrfs-progs: raid56: Introduce raid56 header for later recovery usage
>>   btrfs-progs: raid56: Introduce tables for RAID6 recovery
>>   btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
>>   btrfs-progs: raid56: Allow raid6 to recover data and p
>>   btrfs-progs: Introduce wrapper to recover raid56 data
>>   btrfs-progs: Introduce new btrfs_map_block function which returns more
>>     unified result.
>>   btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
>>   btrfs-progs: csum: Introduce function to read out one data csum
>>   btrfs-progs: scrub: Introduce structures to support fsck scrub for
>>     RAID56
>>   btrfs-progs: scrub: Introduce function to scrub mirror based tree
>>     block
>>   btrfs-progs: scrub: Introduce function to scrub mirror based data
>>     blocks
>>   btrfs-progs: scrub: Introduce function to scrub one extent
>>   btrfs-progs: scrub: Introduce function to scrub one data stripe
>>   btrfs-progs: scrub: Introduce function to verify parities
>>   btrfs-progs: extent-tree: Introduce function to check if there is any
>>     extent in given range.
>>   btrfs-progs: scrub: Introduce function to recover data parity
>>   btrfs-progs: scrub: Introduce a function to scrub one full stripe
>>   btrfs-progs: scrub: Introduce function to check a whole block group
>>   btrfs-progs: fsck: Introduce offline scrub function
>>
>>  .gitignore                         |    2 +
>>  Documentation/btrfs-check.asciidoc |    7 +
>>  Makefile.in                        |   19 +-
>>  cmds-check.c                       |   12 +-
>>  csum.c                             |   96 ++++
>>  ctree.h                            |    8 +
>>  disk-io.c                          |    4 +-
>>  disk-io.h                          |    7 +-
>>  extent-tree.c                      |   60 +++
>>  kernel-lib/mktables.c              |  148 ++++++
>>  kernel-lib/raid56.c                |  359 +++++++++++++
>>  kernel-lib/raid56.h                |   58 +++
>>  raid56.c                           |  172 ------
>>  scrub.c                            | 1004 ++++++++++++++++++++++++++++++++++++
>>  volumes.c                          |  283 ++++++++++
>>  volumes.h                          |   49 ++
>>  16 files changed, 2103 insertions(+), 185 deletions(-)
>>  create mode 100644 csum.c
>>  create mode 100644 kernel-lib/mktables.c
>>  create mode 100644 kernel-lib/raid56.c
>>  create mode 100644 kernel-lib/raid56.h
>>  delete mode 100644 raid56.c
>>  create mode 100644 scrub.c
>>
>
>


