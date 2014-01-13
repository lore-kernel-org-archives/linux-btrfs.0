Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39348 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaAMQJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 11:09:06 -0500
Received: by mail-pd0-f171.google.com with SMTP id x10so2882142pdj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 08:09:06 -0800 (PST)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs send: page allocation failure
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <52D40D99.8010301@jrs-s.net>
Date: Tue, 14 Jan 2014 00:09:00 +0800
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <6D735AF4-6D5A-400F-9CE5-DFFCDBE6E0C3@gmail.com>
References: <52D3E308.7060309@jrs-s.net> <1AFA86F3-02FD-4A97-AA64-EA2FC73B2410@gmail.com> <52D4042F.8020805@jrs-s.net> <952CD9A1-4907-4DE4-B840-6668E11DD421@gmail.com> <B716228A-AE53-40F5-9D0A-76B254BD220D@gmail.com> <52D40D99.8010301@jrs-s.net>
To: Jim Salter <jim@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> It's a pretty new kernel - 3.13.0-031300rc7-generic.
> 
> Sorry if I'm misunderstanding something, but... how can I send with -p
> if the parent snapshot doesn't already exist on the target?

Obviously, you can not¡­

Sorry, i was just thinking you use all the operations in one machine just like me ^_^

> 
> What I'm doing is btrfs send /.snapshots/name-of-snapshot | ssh
> othermachine btrfs receive /.snapshots. If the parent specified in -p
> doesn't exist on othermachine, won't the receive operation fail?
> 
> On 01/13/2014 10:44 AM, Wang Shilong wrote:
>> Just double check, what is your kernel version to trigger this problem¡­
>> I suppose this should be an older kernel? If yes,  can you have a try at the latest
>> upstream kernel and see if problem still exist? 
>> 
>> Thanks,
>> Wang
>> 
>>> ÔÚ 2014-1-13£¬ÏÂÎç11:20£¬Jim Salter <jim@jrs-s.net> Ð´µÀ£º
>>> 
>>>> Er... I can't use incremental send if I can't get one full send to go through first. =)
>>> sory,  i mean one approach is use '-p' option, you can use:
>>> 
>>> # btrfs sub create subv
>>> # btrfs sub snapshot -r subv snap
>>> # btrfs sub snapshot -r sub  snap1
>>> # btrfs send snap -p snap1 -f 1
>>> # btrfs receive -f 1 backup
>>> # btrfs sub delete snap1 -<-- now you can delete snap1 safely
>>> 
>>> The above approach is much faster, i think you can try it!
>>> 
>>> Thanks,
>>> Wang
>>>> I'm hoping the problem will go away for long enough to get a full send completed once I reboot the box, but I can't do that until (much) later in the day.
>>>> 
>>>> On 01/13/2014 10:17 AM, Wang Shilong wrote:
>>>>> Hello,
>>>>> 
>>>>> I took a careful think about your problems below, i think this is because btrfs *ulist* implement use
>>>>> krealloc which might cause memory allocation fails especial you use full send.
>>>>> 
>>>>> Before we kicked off now stupid  *ulist* implements, i think you can use incremental send to solve
>>>>> this issue.
>>>>> 
>>>>> Thanks,
>>>>> Wang
>>>>> 
>>>>>> Hi list -
>>>>>> 
>>>>>> Getting sporadic page allocation failures in btrfs send. This happened once several weeks ago but was fine after a reboot; yesterday I did not reboot, but had the failure back-to-back trying to send two different snapshots. These are full sends, not incremental, of a bit over 600G of data. Test machine has 32G of RAM, with 21G of it free (not including cache):
>>>>>> 
>>>>>> root@gwa-virt1:/data/images/.snapshots# free -m
>>>>>>           total       used       free     shared    buffers cached
>>>>>> Mem:         32159      31789        369          0          0 21276
>>>>>> -/+ buffers/cache:      10513      21646
>>>>>> Swap:            0          0          0
>>>>>> 
>>>>>> In both cases (all three, really) the btrfs send failed a bit more than half of the way through the send (somewhere around the 380GB mark).
>>>>>> 
>>>>>> Kern log snippets follow:
>>>>>> 
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627611] btrfs: page allocation failure: order:6, mode:0x104050
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627622] CPU: 6 PID: 9642 Comm: btrfs Not tainted 3.13.0-031300rc7-generic #201401041835
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627773] [<ffffffffa0142214>] ? btrfs_get_token_64+0x64/0xf0 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627818] [<ffffffffa01876dd>] ? ulist_add_merge+0xcd/0x270 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627860] [<ffffffffa01876dd>] ulist_add_merge+0xcd/0x270 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627894] [<ffffffffa018615c>] find_parent_nodes+0x50c/0x6f0 [btrf ]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627930] [<ffffffffa018e550>] ? compare_refs.isra.23+0x130/0x130 btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627965] [<ffffffffa0187019>] iterate_extent_inodes+0xf9/0x270 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628003] [<ffffffffa014b7a5>] ? free_extent_buffer+0x35/0x40 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628037] [<ffffffffa018dc9d>] find_extent_clone.isra.26+0x26d/0x340 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628072] [<ffffffffa0191207>] process_extent+0xd7/0x180 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628107] [<ffffffffa01918ff>] changed_cb+0xdf/0x170 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628141] [<ffffffffa0191ad2>] full_send_tree+0x142/0x280 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628174] [<ffffffffa0191ccc>] ? send_subvol_begin+0xbc/0x2b0 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628209] [<ffffffffa0191fa0>] send_subvol+0xe0/0xf0 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628244] [<ffffffffa01922f1>] btrfs_ioctl_send+0x341/0x520 [btrfs]
>>>>>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.628279] [<ffffffffa01606d3>] btrfs_ioctl+0x953/0xac0 [btrfs]
>>>>>> 
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016512] btrfs: page allocation failure: order:5, mode:0x104050
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016518] CPU: 4 PID: 18689 Comm: btrfs Not tainted 3.13.0-031300rc7-generic #201401041835
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016597] [<ffffffffa0142214>] ? btrfs_get_token_64+0x64/0xf0 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016617] [<ffffffffa01876dd>] ? ulist_add_merge+0xcd/0x270 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016637] [<ffffffffa01876dd>] ulist_add_merge+0xcd/0x270 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016653] [<ffffffffa018615c>] find_parent_nodes+0x50c/0x6f0 [btrf ]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016669] [<ffffffffa018e550>] ? compare_refs.isra.23+0x130/0x130 btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016684] [<ffffffffa0187019>] iterate_extent_inodes+0xf9/0x270 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016700] [<ffffffffa014b7a5>] ? free_extent_buffer+0x35/0x40 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016716] [<ffffffffa018dc9d>] find_extent_clone.isra.26+0x26d/0x340 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016732] [<ffffffffa0191207>] process_extent+0xd7/0x180 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016747] [<ffffffffa01918ff>] changed_cb+0xdf/0x170 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016763] [<ffffffffa0191ad2>] full_send_tree+0x142/0x280 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016778] [<ffffffffa0191ccc>] ? send_subvol_begin+0xbc/0x2b0 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016794] [<ffffffffa0191fa0>] send_subvol+0xe0/0xf0 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016810] [<ffffffffa01922f1>] btrfs_ioctl_send+0x341/0x520 [btrfs]
>>>>>> Jan 12 21:34:00 gwa-virt1 kernel: [562448.016826] [<ffffffffa01606d3>] btrfs_ioctl+0x953/0xac0 [btrfs]
>>>>>> 
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

