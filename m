Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:56235 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754561AbbIVOb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:31:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 22 Sep 2015 16:31:54 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <5601169B.4060600@gmx.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <55F9486F.4040302@googlemail.com> <0973de930ee87e102c533c719807b748@all.all>
 <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
 <d2f30d85fa83b8b98af3c7e5a862044d@all.all> <55FA2D9A.1060405@cn.fujitsu.com>
 <e80ea6421a1f6a5f84c5d1032fc6a3e8@all.all> <55FA60C5.5090002@cn.fujitsu.com>
 <7a6f2d794fb6cbf7d598b92e3470201c@all.all> <55FA759E.6030707@cn.fujitsu.com>
 <3386a8bfa1a5796460306a53a668e47e@all.all> <55FA98D8.5010301@gmx.com>
 <53a5553a9c5301789e246144bb264e43@all.all> <55FB61E9.4000300@cn.fujitsu.com>
 <2ce9b35f73732b145e0f80b18f230a52@all.all>
 <c605d4d156f9a880b216e89ca0705269@all.all>
 <762ec73d5389b5057be4d3c17f74e1f9@all.all> <55FE0A50.9060607@gmx.com>
 <3ba27cf5afd82cf4e3bde718386b7cc3@all.all> <55FE8FB6.4070509@gmx.com>
 <72b4368e7180a4d703ef3ea1112d7358@all.all>
 <4749d42363070fcd228af172781750df@all.all> <5600B0BF.604@cn.fujitsu.com>
 <0a4be8fab4876a245900e4833e8139e0@all.all> <560113EF.2090209@gmx.com>
 <5601169B.4060600@gmx.com>
Message-ID: <69919cd93d3942e8210fb45a53fc42ac@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-22 10:51, Qu Wenruo a écrit :
>>>>> [92098.842261] Call Trace:
>>>>> [92098.842277]  [<ffffffffc035a5d8>] ? 
>>>>> read_extent_buffer+0xb8/0x110
>>>>> [btrfs]
>>>>> [92098.842304]  [<ffffffffc0396d00>] ? 
>>>>> btrfs_find_all_roots+0x60/0x70
>>>>> [btrfs]
>>>>> [92098.842329]  [<ffffffffc039af3d>]
>>>>> btrfs_qgroup_rescan_worker+0x28d/0x5a0 [btrfs]
>>>> 
>>>> Would you please show the code of it?
>>>> This one seems to be another stupid bug I made when rewriting the
>>>> framework.
>>>> Maybe I forgot to reinit some variants or I'm screwing memory...
>>> 
>>> (gdb) list *(btrfs_qgroup_rescan_worker+0x28d)
>>> 0x97f6d is in btrfs_qgroup_rescan_worker (fs/btrfs/ctree.h:2760).
>>> 2755
>>> 2756    static inline void btrfs_disk_key_to_cpu(struct btrfs_key 
>>> *cpu,
>>> 2757                                             struct 
>>> btrfs_disk_key
>>> *disk)
>>> 2758    {
>>> 2759            cpu->offset =e64_to_cpu(disk->offset);
>>> 2760            cpu->type =isk->type;
>>> 2761            cpu->objectid =e64_to_cpu(disk->objectid);
>>> 2762    }
>>> 2763
>>> 2764    static inline void btrfs_cpu_key_to_disk(struct 
>>> btrfs_disk_key
>>> *disk,
>>> (gdb)
>>> 
>>> 
>>> Does it makes sense ?
>> So it seems that the memory of cpu key is being screwed up...
>> 
>> The code is be specific thin inline function, so what about other 
>> stack?
>> Like btrfs_qgroup_rescan_helper+0x12?
>> 
>> Thanks,
>> Qu
> Oh, I forgot that you can just change the number of
> btrfs_qgroup_rescan_worker+0x28d to smaller value.
> Try +0x280 for example, which will revert to 14 bytes asm code back,
> which may jump out of the inline function range, and may give you a
> good hint.
> 
> Or gdb may have a better mode for inline function, but I don't know...

Actually, "list -" is our friend here (show 10 lignes before the last 
src output)

(gdb) list *(btrfs_qgroup_rescan_worker+0x28d)
0x97f6d is in btrfs_qgroup_rescan_worker (fs/btrfs/ctree.h:2760).
2755
2756    static inline void btrfs_disk_key_to_cpu(struct btrfs_key *cpu,
2757                                             struct btrfs_disk_key 
*disk)
2758    {
2759            cpu->offset = le64_to_cpu(disk->offset);
2760            cpu->type = disk->type;
2761            cpu->objectid = le64_to_cpu(disk->objectid);
2762    }
2763
2764    static inline void btrfs_cpu_key_to_disk(struct btrfs_disk_key 
*disk,
(gdb) list -
2745                                                struct 
btrfs_disk_key *key)
2746    {
2747            write_eb_member(eb, h, struct btrfs_free_space_header, 
location, key);
2748    }
2749
2750    /* struct btrfs_disk_key */
2751    BTRFS_SETGET_STACK_FUNCS(disk_key_objectid, struct 
btrfs_disk_key,
2752                             objectid, 64);
2753    BTRFS_SETGET_STACK_FUNCS(disk_key_offset, struct btrfs_disk_key, 
offset, 64);
2754    BTRFS_SETGET_STACK_FUNCS(disk_key_type, struct btrfs_disk_key, 
type, 8);
(gdb) list -
2735
2736    static inline void btrfs_free_space_key(struct extent_buffer 
*eb,
2737                                            struct 
btrfs_free_space_header *h,
2738                                            struct btrfs_disk_key 
*key)
2739    {
2740            read_eb_member(eb, h, struct btrfs_free_space_header, 
location, key);
2741    }
2742
2743    static inline void btrfs_set_free_space_key(struct extent_buffer 
*eb,
2744                                                struct 
btrfs_free_space_header *h,
(gdb)

Lots of inline funcs and macros it seems.

-- 
Stéphane.

