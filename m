Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:43060 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932340AbbIVHeW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 03:34:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 22 Sep 2015 09:34:19 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <5600B0BF.604@cn.fujitsu.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
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
Message-ID: <0a4be8fab4876a245900e4833e8139e0@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-22 03:37, Qu Wenruo a écrit :
> Stéphane Lesimple wrote on 2015/09/22 03:30 +0200:
>> Le 2015-09-20 13:14, Stéphane Lesimple a écrit :
>>> Le 2015-09-20 12:51, Qu Wenruo a écrit :
>>>>>> Would you please use gdb to show the codes of
>>>>>> "btrfs_qgroup_rescan_worker+0x388" ?
>>>>>> (Need kernel debuginfo)
>>>>>> 
>>>>>> My guess is the following line:(pretty sure, but not 100% sure)
>>>>>> ------
>>>>>> /*
>>>>>>          * only update status, since the previous part has alreay
>>>>>> updated the
>>>>>>          * qgroup info.
>>>>>>          */
>>>>>>         trans = btrfs_start_transaction(fs_info->quota_root, 1); 
>>>>>> <<<<<
>>>>>>         if (IS_ERR(trans)) {
>>>>>>                 err = PTR_ERR(trans);
>>>>>>                 btrfs_err(fs_info,
>>>>>>                           "fail to start transaction for status
>>>>>> update: %d\n",
>>>>>>                           err);
>>>>>>                 goto done;
>>>>>>         }
>>>>>> ------
>>>>> 
>>>>> The kernel and modules were already compiled with debuginfo.
>>>>> However for some reason, I couldn't get gdb disassembly of 
>>>>> /proc/kcore
>>>>> properly
>>>>> aligned with the source I compiled: the asm code doesn't match the 
>>>>> C
>>>>> code shown
>>>>> by gdb. In any case, watching the source of this function, this is 
>>>>> the
>>>>> only place
>>>>> btrfs_start_transaction is called, so we can be 100% sure it's 
>>>>> where
>>>>> the
>>>>> crash
>>>>> happens indeed.
>>>> 
>>>> Yep, that's the only caller.
>>>> 
>>>> Here is some useful small hint to locate the code, if you are
>>>> interestied in kernel development.
>>>> 
>>>> # Not sure about whether ubuntu gzipped modules, at least Arch does
>>>> # compress it
>>>> $ cp <kernel modules dir>/kernel/fs/btrfs/btrfs.ko.gz /tmp/
>>>> $ gunzip /tmp/btrfs.ko.gz
>>>> $ gdb /tmp/btrfs.ko
>>>> # Make sure gdb read all the needed debuginfo
>>>> $ gdb list *(btrfs_qgroup_rescan_worker+0x388)
>>>> 
>>>> And gdb will find the code position for you.
>>>> Quite easy one, only backtrace info is needed.
>>> 
>>> Ah, thanks for the tips, I was loading whole vmlinux and using
>>> /proc/kcore
>>> as the core info, then adding the module with "add-symbol-file". But 
>>> as
>>> we're just looking for the code and not the variables, it was indeed
>>> completely overkill.
>>> 
>>> (gdb) list *(btrfs_qgroup_rescan_worker+0x388)
>>> 0x98068 is in btrfs_qgroup_rescan_worker (fs/btrfs/qgroup.c:2328).
>>> 2323
>>> 2324            /*
>>> 2325             * only update status, since the previous part has
>>> alreay updated the
>>> 2326             * qgroup info.
>>> 2327             */
>>> 2328            trans = btrfs_start_transaction(fs_info->quota_root, 
>>> 1);
>>> 2329            if (IS_ERR(trans)) {
>>> 2330                    err = PTR_ERR(trans);
>>> 2331                    btrfs_err(fs_info,
>>> 2332                              "fail to start transaction for
>>> status update: %d\n",
>>> 
>>> So this just confirms what we were already 99% sure of.
>>> 
>>>> Another hint is about how to collect the kernel crash info.
>>>> Your netconsole setup would be definitely one good practice.
>>>> 
>>>> Another one I use to collect crash info is kdump.
>>>> Ubuntu should have a good wiki on it.
>>> 
>>> I've already come across kdump a few times, but never really look 
>>> into
>>> it.
>>> To debug the other complicated extend backref bug, it could be of 
>>> some
>>> use.
>>> 
>>>>>>>> So, as a quick summary of this big thread, it seems I've been
>>>>>>>> hitting
>>>>>>>> 3 bugs, all reproductible :
>>>>>>>> - kernel BUG on balance (this original thread)
>>>>>> 
>>>>>> For this, I can't provide much help, as extent backref bug is 
>>>>>> quite
>>>>>> hard to debug, unless a developer is interested in it and find a
>>>>>> stable way to reproduce it.
>>>>> 
>>>>> Yes, unfortunately as it looks so much like a race condition, I 
>>>>> know
>>>>> I can
>>>>> reproduce it with my worflow, but it can take between 1 minute and 
>>>>> 12
>>>>> hours,
>>>>> so I wouldn't call it a "stable way" to reproduce it unfortunately 
>>>>> :(
>>>>> 
>>>>> Still if any dev is interested in it, I can reproduce it, with a
>>>>> patched
>>>>> kernel if needed.
>>>> 
>>>> Maybe you are already doing it, you can only compile the btrfs
>>>> modules, which will be far more faster than compile the whole 
>>>> kernel,
>>>> if and only if the compiled module can be loaded.
>>> 
>>> Yes, I've compiled this 4.3.0-rc1 in a completely modular form, so
>>> I'll try to
>>> load the modified module and see if the running kernel accepts it. I
>>> have to rmmod
>>> the loaded module first, hence umounting any btrfs fs before that.
>>> Should be able
>>> to do it in a couple hours.
>>> 
>>> I'll delete again all my snapshots and run my script. Should be easy
>>> to trigger
>>> the (hopefully worked-around) bug again.
>> 
>> Well, I didn't trigger this exact bug, but another one, not less 
>> severe
>> though, as it also crashed the system:
>> 
>> [92098.841309] general protection fault: 0000 [#1] SMP
>> [92098.841338] Modules linked in: ...
>> [92098.841814] CPU: 1 PID: 24655 Comm: kworker/u4:12 Not tainted
>> 4.3.0-rc1 #1
>> [92098.841834] Hardware name: ASUS All Series/H87I-PLUS, BIOS 1005
>> 01/06/2014
>> [92098.841868] Workqueue: btrfs-qgroup-rescan 
>> btrfs_qgroup_rescan_helper
>> [btrfs]
>> [92098.841889] task: ffff8800b6cc4100 ti: ffff8800a3dc8000 task.ti:
>> ffff8800a3dc8000
>> [92098.841910] RIP: 0010:[<ffffffff813ae6c6>]  [<ffffffff813ae6c6>]
>> memcpy_erms+0x6/0x10
>> [92098.841935] RSP: 0018:ffff8800a3dcbcc8  EFLAGS: 00010207
>> [92098.841950] RAX: ffff8800a3dcbd67 RBX: 0000000000000009 RCX:
>> 0000000000000009
>> [92098.841970] RDX: 0000000000000009 RSI: 0005080000000000 RDI:
>> ffff8800a3dcbd67
>> [92098.841989] RBP: ffff8800a3dcbd00 R08: 0000000000019c60 R09:
>> ffff88011fb19c60
>> [92098.842009] R10: ffffea0003006480 R11: 0000000001000000 R12:
>> ffff8800b76c32c0
>> [92098.842028] R13: 0000160000000000 R14: ffff8800a3dcbd70 R15:
>> 0000000000000009
>> [92098.842048] FS:  0000000000000000(0000) GS:ffff88011fb00000(0000)
>> knlGS:0000000000000000
>> [92098.842070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [92098.842086] CR2: 00007fe1f2bd8000 CR3: 0000000001c10000 CR4:
>> 00000000000406e0
>> [92098.842105] Stack:
>> [92098.842111]  ffffffffc035a5d8 ffffffffc0396d00 000000000000028b
>> 0000000000000000
>> [92098.842212]  0000cc6c00000000 ffff8800b76c3200 0000160000000000
>> ffff8800a3dcbdc0
>> [92098.842237]  ffffffffc039af3d ffff8800c7196dc8 ffff8800c7196e08
>> ffff8800c7196da0
>> [92098.842261] Call Trace:
>> [92098.842277]  [<ffffffffc035a5d8>] ? read_extent_buffer+0xb8/0x110
>> [btrfs]
>> [92098.842304]  [<ffffffffc0396d00>] ? btrfs_find_all_roots+0x60/0x70
>> [btrfs]
>> [92098.842329]  [<ffffffffc039af3d>]
>> btrfs_qgroup_rescan_worker+0x28d/0x5a0 [btrfs]
> 
> Would you please show the code of it?
> This one seems to be another stupid bug I made when rewriting the 
> framework.
> Maybe I forgot to reinit some variants or I'm screwing memory...

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
(gdb)


Does it makes sense ?


>> [92098.842351]  [<ffffffff810a1a0d>] ?
>> ttwu_do_activate.constprop.90+0x5d/0x70
>> [92098.842377]  [<ffffffffc03674e0>] normal_work_helper+0xc0/0x270 
>> [btrfs]
>> [92098.842401]  [<ffffffffc03678a2>]
>> btrfs_qgroup_rescan_helper+0x12/0x20 [btrfs]
>> [92098.842421]  [<ffffffff8109127e>] process_one_work+0x14e/0x3d0
>> [92098.842438]  [<ffffffff8109192a>] worker_thread+0x11a/0x470
>> [92098.842454]  [<ffffffff81091810>] ? rescuer_thread+0x310/0x310
>> [92098.842471]  [<ffffffff81097059>] kthread+0xc9/0xe0
>> [92098.842485]  [<ffffffff81096f90>] ? kthread_park+0x60/0x60
>> [92098.842502]  [<ffffffff817aac4f>] ret_from_fork+0x3f/0x70
>> [92098.842517]  [<ffffffff81096f90>] ? kthread_park+0x60/0x60
>> [92098.842532] Code: ff eb eb 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 
>> 48
>> c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 
>> 48
>> 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38
>> [92098.842658] RIP  [<ffffffff813ae6c6>] memcpy_erms+0x6/0x10
>> [92098.842675]  RSP <ffff8800a3dcbcc8>
>> [92098.849594] ---[ end trace 9d5fb7931a3ec713 ]---
>> 
>> I would definitely say that rescans should be avoided on current 
>> kernels
>> as the possibility that it'll bring the system down shouldn't be 
>> ignored.
>> It confirms that this code really needs a rewrite !
>> 
>> Regards,
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

