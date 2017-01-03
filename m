Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1925 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756976AbdACAZm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jan 2017 19:25:42 -0500
Subject: Re: [PATCH v2 00/19]
To: <kreijack@inwind.it>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
 <018da5f8-a4e7-f35e-6eac-e01f6936a3e1@inwind.it>
 <94d2445f-46ba-ef8e-709d-61cb36ade32c@cn.fujitsu.com>
 <f957f65f-94f5-db53-c74f-03d2e0bc4979@inwind.it>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <7a8d1d90-63b1-8a9d-eb7f-7e94351c014f@cn.fujitsu.com>
Date: Tue, 3 Jan 2017 08:25:34 +0800
MIME-Version: 1.0
In-Reply-To: <f957f65f-94f5-db53-c74f-03d2e0bc4979@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/31/2016 02:39 AM, Goffredo Baroncelli wrote:
> On 2016-12-30 01:40, Qu Wenruo wrote:
>> Hi Goffredo,
> [...]
>>> So I tried to strace it to check if the program was working properly. The strace output showed me that the program ran correctly.
>>> However form the strace I noticed that the program read several time the same page (size 16k).
>>> I think that this is due to the  walking of the btree. However this could be a possible optimization: cache the last read(s).
>>
>> That doesn't mean it's scrubbing the same leaf, but just normal tree search.
>>
>> The leaf would be extent root or nodes near extent root.
>> The offline scrub heavily rely on extent tree to determine if there is any extent need to be scrubbed.
>>
>> Further more, the idea to cache extent tree is not really that easy, according to what we have learned from btrfsck.
>> (Cache may go out of control to explode your RAM).
>
> Let me to explain better; what I saw is several *sequential* reads of the *same block*: this is an excerpt of what I saw
>
> [...]
> read64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> pread64(4, "\362<\t\357\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727066112) = 16384
> pread64(4, "\374\4\212\321\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384, 9727606784) = 16384
> [...]
>
> Where both the offset and the size are equal. When I wrote about a cache, I am referring to something quite elementary like caching the last 3/4 reads, which could improve a lot the speed.

That seems to be csum tree.
Since we are checking csum in sector size and I don't implement any 
speedup yet, so it will read ctree tree again and again, which I think 
that's part of the cause of slowness.

And since currently the offline scrub function itself seems to work 
quite well, it's time to enhance the speed and UI.

I'll address them all in next version.

Thanks,
Qu

>
>>
>>
>> But your idea to cache still makes sense, for block-device, cache would always be good.
>> (For normal file, kernel provides cache so we don't need to implement by ourself)
>> Although that may need to be implemented in the ctree operation code instead of the offline scrub.
>>
>> BTW, just for reference, what's your device size and how much time it takes to do the offline scrub?
>
> The disk is a 128GB ssd, where 25GB are occupied. I retested the scrub command in order to give you some data:
>
> root@venice:/home/ghigo/btrfs/offline_scrub# echo 3 >/proc/sys/vm/drop_caches
> root@venice:/home/ghigo/btrfs/offline_scrub# time ./btrfs check --scrub /dev/sda3
> Scrub result:
> Tree bytes scrubbed: 1108819968
> Tree extents scrubbed: 135354
> Data bytes scrubbed: 52708061184
> Data extents scrubbed: 735767
> Data bytes without csum: 235622400
> Read error: 0
> Verify error: 0
> Csum error: 0
>
> real    3m37.889s
> user    1m43.060s
> sys     0m39.416s
>
> Instead, the kernel scrub requires:
>
> root@venice:~# echo 3 >/proc/sys/vm/drop_caches
> root@venice:~# time btrfs scrub start -rB /
> scrub done for 931863a5-e0ab-4d90-aeae-af83e096bb64
>         scrub started at Fri Dec 30 19:31:08 2016 and finished after 00:01:48
>         total bytes scrubbed: 25.69GiB with 0 errors
>
> real    1m48.171s
> user    0m0.000s
> sys     0m16.864s
>
>
>
>
> Moreover, I had to explain a little trick which I used. Because this was my root filesystem, and I was lazy to start from another disk, I switched to single mode (systemctl isolate runleve1.target), I mounted the root filesystem RO (mount -o remount,ro /), and then I checked the disk (btrfs check --scrub). I have to point out that I removed some checks from btrfs, because it complaints that
> a) the filesystem was mounted (but in RO it would be safe)
> b) it was not able to open the device in exclusive mode
> To bypass these checks I made the following changes
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 3a16a1f..fe5dee8 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -12589,7 +12589,7 @@ int cmd_check(int argc, char **argv)
>         int qgroup_report = 0;
>         int qgroups_repaired = 0;
>         int scrub = 0;
> -       unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
> +       unsigned ctree_flags = 0; /*OPEN_CTREE_EXCLUSIVE;*/
>
>         while(1) {
>                 int c;
> @@ -12735,7 +12735,7 @@ int cmd_check(int argc, char **argv)
>         radix_tree_init();
>         cache_tree_init(&root_cache);
>
> -       if((ret = check_mounted(argv[optind])) < 0) {
> +/*     if((ret = check_mounted(argv[optind])) < 0) {
>                 error("could not check mount status: %s", strerror(-ret));
>                 err |= !!ret;
>                 goto err_out;
> @@ -12745,13 +12745,16 @@ int cmd_check(int argc, char **argv)
>                 err |= !!ret;
>                 goto err_out;
>         }
> -
> +*/
> +       ret = 0;
>         /* only allow partial opening under repair mode */
>         if (repair)
>                 ctree_flags |= OPEN_CTREE_PARTIAL;
>
>
> Finally I switched to the normal state (systemctl isolate graphical.target)
>
>>
>> Thanks,
>> Qu
>
> BR
> G.Baroncelli
>
>>
>>>
>>> Only my 2¢
>>>
>>> BR
>>> G.Baroncelli
>>>
>>>
>>>
>>> On 2016-12-26 07:29, Qu Wenruo wrote:
>>>> For any one who wants to try it, it can be get from my repo:
>>>> https://github.com/adam900710/btrfs-progs/tree/offline_scrub
>>>>
>>>> Currently, I only tested it on SINGLE/DUP/RAID1/RAID5 filesystems, with
>>>> mirror or parity or data corrupted.
>>>> The tool are all able to detect them and give recoverbility report.
>>>>
>>>> Several reports on kernel scrub screwing up good data stripes are in ML
>>>> for sometime.
>>>>
>>>> And since kernel scrub won't account P/Q corruption, it makes us quite
>>>> to detect error like kernel screwing up P/Q when scrubbing.
>>>>
>>>> To get a comparable tool for kernel scrub, we need a user-space tool to
>>>> act as benchmark to compare their different behaviors.
>>>>
>>>> So here is the patchset for user-space scrub.
>>>>
>>>> Which can do:
>>>>
>>>> 1) All mirror/backup check for non-parity based stripe
>>>>    Which means for RAID1/DUP/RAID10, we can really check all mirrors
>>>>    other than the 1st good mirror.
>>>>
>>>>    Current "--check-data-csum" option will be finally replace by scrub.
>>>>    As it doesn't really check all mirrors, if it hits a good copy, then
>>>>    resting copies will just be ignored.
>>>>
>>>> 2) Comprehensive RAID5/6 full stripe check
>>>>    It will take full use of btrfs csum(both tree and data).
>>>>    It will only recover the full stripe if all recovered data matches
>>>>    with its csum.
>>>>
>>>> In fact, it can already expose several new btrfs kernel bug.
>>>> As it's the main tool I'm using when developing the kernel fixes.
>>>>
>>>> For example, after screwing up a data stripe, kernel did repairs using
>>>> parity, but recovered full stripe has wrong parity.
>>>> Need to scrub again to fix it.
>>>>
>>>> And this patchset also introduced new map_block() function, which is
>>>> more flex than current btrfs_map_block(), and has a unified interface
>>>> for all profiles, not just an array of physical addresses.
>>>>
>>>> Check the 6th and 7th patch for details.
>>>>
>>>> They are already used in RAID5/6 scrub, but can also be used for other
>>>> profiles too.
>>>>
>>>> The to-do list has been shortened, since RAID6 and new check logical is
>>>> introduced.
>>>> 1) Repair support
>>>>    In fact, current tool can already report recoverability, repair is
>>>>    not hard to implement.
>>>>
>>>> 2) Test cases
>>>>    Need to make the infrastructure able to handle multi-device first.
>>>>
>>>> 3) Make btrfsck able to handle RAID5 with missing device
>>>>    Now it doesn't even open RAID5 btrfs with missing device, even though
>>>>    scrub should be able to handle it.
>>>>
>>>> Changelog:
>>>> V0.8 RFC:
>>>>    Initial RFC patchset
>>>>
>>>> v1:
>>>>    First formal patchset.
>>>>    RAID6 recovery support added, mainly copied from kernel radi6 lib.
>>>>    Cleaner recovery logical.
>>>>
>>>> v2:
>>>>    More comments in both code and commit message, suggested by David.
>>>>    File re-arrangement, no check/ dir, raid56.ch moved to kernel-lib,
>>>>    Suggested by David
>>>>
>>>> Qu Wenruo (19):
>>>>   btrfs-progs: raid56: Introduce raid56 header for later recovery usage
>>>>   btrfs-progs: raid56: Introduce tables for RAID6 recovery
>>>>   btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
>>>>   btrfs-progs: raid56: Allow raid6 to recover data and p
>>>>   btrfs-progs: Introduce wrapper to recover raid56 data
>>>>   btrfs-progs: Introduce new btrfs_map_block function which returns more
>>>>     unified result.
>>>>   btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
>>>>   btrfs-progs: csum: Introduce function to read out one data csum
>>>>   btrfs-progs: scrub: Introduce structures to support fsck scrub for
>>>>     RAID56
>>>>   btrfs-progs: scrub: Introduce function to scrub mirror based tree
>>>>     block
>>>>   btrfs-progs: scrub: Introduce function to scrub mirror based data
>>>>     blocks
>>>>   btrfs-progs: scrub: Introduce function to scrub one extent
>>>>   btrfs-progs: scrub: Introduce function to scrub one data stripe
>>>>   btrfs-progs: scrub: Introduce function to verify parities
>>>>   btrfs-progs: extent-tree: Introduce function to check if there is any
>>>>     extent in given range.
>>>>   btrfs-progs: scrub: Introduce function to recover data parity
>>>>   btrfs-progs: scrub: Introduce a function to scrub one full stripe
>>>>   btrfs-progs: scrub: Introduce function to check a whole block group
>>>>   btrfs-progs: fsck: Introduce offline scrub function
>>>>
>>>>  .gitignore                         |    2 +
>>>>  Documentation/btrfs-check.asciidoc |    7 +
>>>>  Makefile.in                        |   19 +-
>>>>  cmds-check.c                       |   12 +-
>>>>  csum.c                             |   96 ++++
>>>>  ctree.h                            |    8 +
>>>>  disk-io.c                          |    4 +-
>>>>  disk-io.h                          |    7 +-
>>>>  extent-tree.c                      |   60 +++
>>>>  kernel-lib/mktables.c              |  148 ++++++
>>>>  kernel-lib/raid56.c                |  359 +++++++++++++
>>>>  kernel-lib/raid56.h                |   58 +++
>>>>  raid56.c                           |  172 ------
>>>>  scrub.c                            | 1004 ++++++++++++++++++++++++++++++++++++
>>>>  volumes.c                          |  283 ++++++++++
>>>>  volumes.h                          |   49 ++
>>>>  16 files changed, 2103 insertions(+), 185 deletions(-)
>>>>  create mode 100644 csum.c
>>>>  create mode 100644 kernel-lib/mktables.c
>>>>  create mode 100644 kernel-lib/raid56.c
>>>>  create mode 100644 kernel-lib/raid56.h
>>>>  delete mode 100644 raid56.c
>>>>  create mode 100644 scrub.c
>>>>
>>>
>>>
>>
>>
>>
>
>


