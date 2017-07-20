Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63192 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935828AbdGTJwM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:52:12 -0400
Subject: Re: [PATCH 00/15] Btrfs-progs offline scrub
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170715091053.19725-1-gujx@cn.fujitsu.com>
 <20170718063357.12450-1-gujx@cn.fujitsu.com>
 <e0cbd6df-d88b-1753-f58d-0652afdd5233@prismatelecomtesting.com>
 <7ff53bf4-4755-2e76-8ea5-eb9c38969985@gmx.com>
 <ca725bd3-5e6e-e257-d4e7-4a6acdb3a324@prismatelecomtesting.com>
 <38b8e0e4-b5a6-5bf1-6980-aa6464ec3f62@gmx.com>
 <3c5f665f-6073-b368-f35e-7d3c373b2d43@gmx.com>
 <1915e871-8e63-0146-40f8-9e636f352091@prismatelecomtesting.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ae4d6bc8-6940-b16b-6b8b-e4deb1259a4d@gmx.com>
Date: Thu, 20 Jul 2017 17:51:53 +0800
MIME-Version: 1.0
In-Reply-To: <1915e871-8e63-0146-40f8-9e636f352091@prismatelecomtesting.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月20日 17:40, Marco Lorenzo Crociani wrote:
> On 20/07/2017 11:17, Qu Wenruo wrote:
>>
>>
>> On 2017年07月20日 17:10, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年07月20日 16:55, Marco Lorenzo Crociani wrote:
>>>> On 20/07/2017 05:39, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2017年07月20日 00:45, Marco Lorenzo Crociani wrote:
>>>>>> On 18/07/2017 08:33, Gu Jinxiang wrote:
>>>>>>> For any one who wants to try it, it can be get from my repo:
>>>>>>> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub
>>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>> I'm getting this error during make:
>>>>>>
>>>>>>      [CC]     csum.o
>>>>>> csum.c: In function ‘btrfs_read_data_csums’:
>>>>>> csum.c:119:3: error: ‘for’ loop initial declarations are only 
>>>>>> allowed in C99 mode
>>>>>>     for (u32 i = 0; i != final_len / csum_size; i++)
>>>>>>     ^
>>>>>
>>>>> Oh, this is indeed a problem.
>>>>> Introduced in the version which bitmap for csum is introduced.
>>>>>
>>>>> Should be fixed to use c90 standard (at least gnu90).
>>>>>
>>>>>> csum.c:119:3: note: use option -std=c99 or -std=gnu99 to compile 
>>>>>> your code
>>>>>> make: *** [csum.o] Errore 1
>>>>>>
>>>>>>
>>>>>> git clone https://github.com/gujx2017/btrfs-progs.git
>>>>>> git checkout offline_scrub
>>>>>> ./autogen.sh
>>>>>> ./configure
>>>>>> make
>>>>>>
>>>>>> CentOS 7.3
>>>>>> kernel 4.12
>>>>>
>>>>> Seems to be related to gcc version.
>>>>> Newer gcc use higher std which doesn't have such problem, while gcc 
>>>>> 4.8 is still using lower standard and will print output such warning.
>>>>>
>>>>> I'll try to enhance the Makefile to use gnu90 standard to avoid 
>>>>> such problem.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> No problem compiling official btrfs-progs v4.11.1
>>>>>>
>>>>>> Regards,
>>>>>>
>>>>> -- 
>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>> Hi Qu,
>>>> now I got only a warning:
>>>>
>>>> cmds-subvolume.c: In function 'cmd_subvol_show':
>>>> cmds-subvolume.c:964:7: warning: 'rootid_arg' may be used 
>>>> uninitialized in this function [-Wmaybe-uninitialized]
>>>>     ret = get_subvol_info_by_rootid(fullpath, &get_ri, rootid_arg);
>>>

Find the patch.

author Anand Jain <anand.jain@oracle.com> Thu Jul 13 06:47:11 2017 +0800
committer David Sterba <dsterba@suse.com> Thu Jul 13 01:03:23 2017 +0200

btrfs-progs: subvol show: add support to search subvolume by rootid or uuid

>>> I don't remember the patchset modified that part.
>>> So maybe a false alert caused by old gcc version?
> 
> I confirm no warnings with official btrfs-progs v4.11.1
> 
> If can help on branch ext/suyue/lowmem_repair
> 
> I got:
>      [CC]     cmds-check.o
> cmds-check.c: In function 'repair_ternary_lowmem':
> cmds-check.c:4367:6: warning: 'ret' may be used uninitialized in this 
> function [-Wmaybe-uninitialized]
>    int ret;
>        ^

Thanks for reporting this.
I'll double check it soon.

> 
>>>
>>>>
>>>> I tried to run scrub on an umounted btrfs raid6 filesystem but 
>>>> instead of "ERROR: '/dev/sda1' is not a mounted btrfs device" I got:
>>>>
>>>> btrfs scrub start --offline /dev/sda1
>>>> couldn't open RDWR because of unsupported option features (3).
>>>
>>> Please post output of "btrfs-show-super /dev/sda1".
>>>
> 
> # btrfs-show-super /dev/sda1
> superblock: bytenr=65536, device=/dev/sda1
> ---------------------------------------------------------
> csum            0xdc944aa7 [match]
> bytenr            65536
> flags            0x1
>              ( WRITTEN )
> magic            _BHRfS_M [match]
> fsid            1845d590-4bf5-466f-953d-aee669fd579e
> label            provabtrfs
> generation        811
> root            1852255092736
> sys_array_size        449
> chunk_root_generation    810
> root_level        1
> chunk_root        20987904
> chunk_root_level    1
> log_root        0
> log_root_transid    0
> log_root_level        0
> total_bytes        48002664235008
> bytes_used        2855626117120
> sectorsize        4096
> nodesize        16384
> leafsize        16384
> stripesize        4096
> root_dir        6
> num_devices        12
> compat_flags        0x0
> compat_ro_flags        0x3

Just as expected.
You're using free space tree, which btrfs-progs can't modify it yet.

But it's unrelated to offline scrub as it doesn't modify tree.

I'll add extra open ctree flag to work this around.

BTW, if you still want to test offline scrub using the image, "btrfs 
check --clear-space-cache v2" can be used to clear the free space tree 
along with its superblock flag.
Then you can test offline scrub without problem.

Thanks,
Qu

> incompat_flags        0x3e9
>              ( MIXED_BACKREF |
>                COMPRESS_LZO |
>                BIG_METADATA |
>                EXTENDED_IREF |
>                RAID56 |
>                SKINNY_METADATA |
>                NO_HOLES )
> csum_type        0
> csum_size        4
> cache_generation    18446744073709551615
> uuid_tree_generation    811
> dev_item.uuid        009add32-9813-4d56-900d-9587b1fff792
> dev_item.fsid        1845d590-4bf5-466f-953d-aee669fd579e [match]
> dev_item.type        0
> dev_item.total_bytes    4000222019584
> dev_item.bytes_used    286326915072
> dev_item.io_align    4096
> dev_item.io_width    4096
> dev_item.sector_size    4096
> dev_item.devid        1
> dev_item.dev_group    0
> dev_item.seek_speed    0
> dev_item.bandwidth    0
> dev_item.generation    0
> 
> 
> 
>>> Seems like RO_FREE_SPACE_TREE_VALID option preventing us to mount it RW.
>>
>> OK, it is the new free space tree RO flag preventing us open it RW.
>>
>> Currently btrfs-progs can't modify free space tree (if I remember it 
>> correctly), so RW open is not allowed now.
>>
>> But the fact offline scrub doesn't care about the btrfs trees 
>> (metadata), but the chunk level on-disk data, it is OK to allow 
>> offline scrub to RW mount.
>>
>> This can be addressed by adding a new btrfs-progs open ctree flag to 
>> bypass RO compat flag check.
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>> ERROR: cannot open file system
>>>> Segmentation fault (core dumped)
>>
>> The segfault seems to be another problem.
>> I'll try to fix it soon.
>>
>> Thanks,
>> Qu
>>>>
>>>> [1182841.663283] btrfs[30198]: segfault at 46474e548 ip 
>>>> 00007f0eeeac838c sp 00007fff35a52c58 error 4 in 
>>>> libc-2.17.so[7f0eeea48000+1b7000]
>>>>
>>>> Regards,
>>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Thanks,
> 
