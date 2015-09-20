Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:38651 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754958AbbITLOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 07:14:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 20 Sep 2015 13:14:09 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <55FE8FB6.4070509@gmx.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
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
Message-ID: <72b4368e7180a4d703ef3ea1112d7358@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-20 12:51, Qu Wenruo a écrit :
>>> Would you please use gdb to show the codes of
>>> "btrfs_qgroup_rescan_worker+0x388" ?
>>> (Need kernel debuginfo)
>>> 
>>> My guess is the following line:(pretty sure, but not 100% sure)
>>> ------
>>> /*
>>>          * only update status, since the previous part has alreay
>>> updated the
>>>          * qgroup info.
>>>          */
>>>         trans = btrfs_start_transaction(fs_info->quota_root, 1); 
>>> <<<<<
>>>         if (IS_ERR(trans)) {
>>>                 err = PTR_ERR(trans);
>>>                 btrfs_err(fs_info,
>>>                           "fail to start transaction for status
>>> update: %d\n",
>>>                           err);
>>>                 goto done;
>>>         }
>>> ------
>> 
>> The kernel and modules were already compiled with debuginfo.
>> However for some reason, I couldn't get gdb disassembly of /proc/kcore
>> properly
>> aligned with the source I compiled: the asm code doesn't match the C
>> code shown
>> by gdb. In any case, watching the source of this function, this is the
>> only place
>> btrfs_start_transaction is called, so we can be 100% sure it's where 
>> the
>> crash
>> happens indeed.
> 
> Yep, that's the only caller.
> 
> Here is some useful small hint to locate the code, if you are
> interestied in kernel development.
> 
> # Not sure about whether ubuntu gzipped modules, at least Arch does
> # compress it
> $ cp <kernel modules dir>/kernel/fs/btrfs/btrfs.ko.gz /tmp/
> $ gunzip /tmp/btrfs.ko.gz
> $ gdb /tmp/btrfs.ko
> # Make sure gdb read all the needed debuginfo
> $ gdb list *(btrfs_qgroup_rescan_worker+0x388)
> 
> And gdb will find the code position for you.
> Quite easy one, only backtrace info is needed.

Ah, thanks for the tips, I was loading whole vmlinux and using 
/proc/kcore
as the core info, then adding the module with "add-symbol-file". But as
we're just looking for the code and not the variables, it was indeed
completely overkill.

(gdb) list *(btrfs_qgroup_rescan_worker+0x388)
0x98068 is in btrfs_qgroup_rescan_worker (fs/btrfs/qgroup.c:2328).
2323
2324            /*
2325             * only update status, since the previous part has 
alreay updated the
2326             * qgroup info.
2327             */
2328            trans = btrfs_start_transaction(fs_info->quota_root, 1);
2329            if (IS_ERR(trans)) {
2330                    err = PTR_ERR(trans);
2331                    btrfs_err(fs_info,
2332                              "fail to start transaction for status 
update: %d\n",

So this just confirms what we were already 99% sure of.

> Another hint is about how to collect the kernel crash info.
> Your netconsole setup would be definitely one good practice.
> 
> Another one I use to collect crash info is kdump.
> Ubuntu should have a good wiki on it.

I've already come across kdump a few times, but never really look into 
it.
To debug the other complicated extend backref bug, it could be of some 
use.

>>>>> So, as a quick summary of this big thread, it seems I've been 
>>>>> hitting
>>>>> 3 bugs, all reproductible :
>>>>> - kernel BUG on balance (this original thread)
>>> 
>>> For this, I can't provide much help, as extent backref bug is quite
>>> hard to debug, unless a developer is interested in it and find a
>>> stable way to reproduce it.
>> 
>> Yes, unfortunately as it looks so much like a race condition, I know I 
>> can
>> reproduce it with my worflow, but it can take between 1 minute and 12
>> hours,
>> so I wouldn't call it a "stable way" to reproduce it unfortunately :(
>> 
>> Still if any dev is interested in it, I can reproduce it, with a 
>> patched
>> kernel if needed.
> 
> Maybe you are already doing it, you can only compile the btrfs
> modules, which will be far more faster than compile the whole kernel,
> if and only if the compiled module can be loaded.

Yes, I've compiled this 4.3.0-rc1 in a completely modular form, so I'll 
try to
load the modified module and see if the running kernel accepts it. I 
have to rmmod
the loaded module first, hence umounting any btrfs fs before that. 
Should be able
to do it in a couple hours.

I'll delete again all my snapshots and run my script. Should be easy to 
trigger
the (hopefully worked-around) bug again.

Regards,

-- 
Stéphane.

