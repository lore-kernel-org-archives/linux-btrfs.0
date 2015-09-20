Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50907 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbbITKvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 06:51:42 -0400
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
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
 <3ba27cf5afd82cf4e3bde718386b7cc3@all.all>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55FE8FB6.4070509@gmx.com>
Date: Sun, 20 Sep 2015 18:51:34 +0800
MIME-Version: 1.0
In-Reply-To: <3ba27cf5afd82cf4e3bde718386b7cc3@all.all>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月20日 18:35, Stéphane Lesimple 写道:
> Le 2015-09-20 03:22, Qu Wenruo a écrit :
>>>> The mentioned steps are as follows :
>>>>
>>>> 0) Rsync data from the next ext4 "snapshot" to the subvolume
>>>> 1) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
>>>> 2) Create the needed readonly snapshot on btrfs
>>>> 3) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
>>>> 4) Avoid doing IO if possible until step 6)
>>>> 5) Do 'btrfs quota rescan -⁠w' and save it <==
>>>> 6) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
>>>>
>>>> The resulting files are available here:
>>>> http://speed47.net/tmp2/qgroup.tar.gz
>>>> The run2 is the more complete one, during run1 the machine crashed
>>>> even faster.
>>>> It's interesting to note, however, that it seems to have crashed the
>>>> same way and at the same step in the process.
>>
>> Your data really helps a lot!!
>>
>> And the good news is, the qgroup accouting part is working as expected.
>> Although I only checked about 1/3/6 of about 5 snaps, they are all OK.
>>
>> I can make a script to cross check them, but from the last few result,
>> I think qgroup works fine.
>>
>> I'm more confident about the minus number, which should be a result of
>> deleted subvolume, and the real problem is, such qgroup is not handled
>> well with qgroup rescan.
>
> I agree with your analysis, this matches what I observed.
>
>> I'll try to add a hot fix for such case if needed.
>> But right now, I don't have a good idea for it until Mark's work of
>> rescan subtree.
>>
>> Maybe I can add a new option for btrfs-progs to automatically remove
>> the qgroup and trigger a rescan?
>
> Until this is properly fixed in the kernel code, and this is good news to
> know Mark and you are working on it, this would be a good workaround yes!
>
>>> [ 5738.172879] Call Trace:
>>> [ 5738.172887]  [<ffffffffc031565b>] btrfs_start_transaction+0x1b/0x20
>>> [btrfs]
>>> [ 5738.172896]  [<ffffffffc0378038>]
>>> btrfs_qgroup_rescan_worker+0x388/0x5a0 [btrfs]
>>
>> Your netconsole backtrace is also of greate value.
>> This one implies that, my rework also caused some stupid bug.
>> (Yeah, I always make such bugs) or some existing unexposed rescan bug.
>>
>> Would you please use gdb to show the codes of
>> "btrfs_qgroup_rescan_worker+0x388" ?
>> (Need kernel debuginfo)
>>
>> My guess is the following line:(pretty sure, but not 100% sure)
>> ------
>> /*
>>          * only update status, since the previous part has alreay
>> updated the
>>          * qgroup info.
>>          */
>>         trans = btrfs_start_transaction(fs_info->quota_root, 1); <<<<<
>>         if (IS_ERR(trans)) {
>>                 err = PTR_ERR(trans);
>>                 btrfs_err(fs_info,
>>                           "fail to start transaction for status
>> update: %d\n",
>>                           err);
>>                 goto done;
>>         }
>> ------
>
> The kernel and modules were already compiled with debuginfo.
> However for some reason, I couldn't get gdb disassembly of /proc/kcore
> properly
> aligned with the source I compiled: the asm code doesn't match the C
> code shown
> by gdb. In any case, watching the source of this function, this is the
> only place
> btrfs_start_transaction is called, so we can be 100% sure it's where the
> crash
> happens indeed.

Yep, that's the only caller.

Here is some useful small hint to locate the code, if you are 
interestied in kernel development.

# Not sure about whether ubuntu gzipped modules, at least Arch does
# compress it
$ cp <kernel modules dir>/kernel/fs/btrfs/btrfs.ko.gz /tmp/
$ gunzip /tmp/btrfs.ko.gz
$ gdb /tmp/btrfs.ko
# Make sure gdb read all the needed debuginfo
$ gdb list *(btrfs_qgroup_rescan_worker+0x388)

And gdb will find the code position for you.
Quite easy one, only backtrace info is needed.

Another hint is about how to collect the kernel crash info.
Your netconsole setup would be definitely one good practice.

Another one I use to collect crash info is kdump.
Ubuntu should have a good wiki on it.

>
>> But that means, at rescan time, fs_info->quota_root is still NULL,
>> which is quite wired.
>> I can add extra check to avoid such NULL pointer for now, but it's
>> better to review the existing rescan workflow, as I think there is
>> some race for it to init quota_root.
>>
>> You can also try the following hotfix patch to see if it works:
>> http://pastebin.com/966GQXPk
>>
>> My concern is, this may cause qgroup rescan to exit without updating
>> its accounting info...
>>
>> So still need your help.
>> Or I can use your reproducer script to test it next Monday.
>
> Compiling with your patch, just amended of a little printk to know if
> the execution
> flow enters the added if condition. Will let you know about the results.
>
>>>> But I'm pretty sure I can get that (u64)-1 value again by deleting
>>>> snapshots. Shall I ? Or do you have something else for me to run
>>>> before that ?
>>
>> You have already done a great job in helping maturing qgroups.
>> The minus number and 0 excl is somewhat expected for deleted snapshots.
>>
>> Good news is, 1) it doesn't affect valid(non-orphan) qgroup.
>> 2) Mark is already working on it.
>>
>> I'll try to add a btrfs-progs hotfix for you to delete and rescan
>> qgroups to avoid such problem.
>
> That would be good !
>
>>>> So, as a quick summary of this big thread, it seems I've been hitting
>>>> 3 bugs, all reproductible :
>>>> - kernel BUG on balance (this original thread)
>>
>> For this, I can't provide much help, as extent backref bug is quite
>> hard to debug, unless a developer is interested in it and find a
>> stable way to reproduce it.
>
> Yes, unfortunately as it looks so much like a race condition, I know I can
> reproduce it with my worflow, but it can take between 1 minute and 12
> hours,
> so I wouldn't call it a "stable way" to reproduce it unfortunately :(
>
> Still if any dev is interested in it, I can reproduce it, with a patched
> kernel if needed.

Maybe you are already doing it, you can only compile the btrfs modules, 
which will be far more faster than compile the whole kernel, if and only 
if the compiled module can be loaded.

Thanks,
Qu
>
>> The rest two are explained or have hot fix mentioned above.
>
> And thanks for that, will keep you posted.
>
