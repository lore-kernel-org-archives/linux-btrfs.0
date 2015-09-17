Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57065 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbIQKlg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 06:41:36 -0400
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
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
 <3386a8bfa1a5796460306a53a668e47e@all.all>
Cc: linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55FA98D8.5010301@gmx.com>
Date: Thu, 17 Sep 2015 18:41:28 +0800
MIME-Version: 1.0
In-Reply-To: <3386a8bfa1a5796460306a53a668e47e@all.all>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月17日 18:08, Stéphane Lesimple 写道:
> Le 2015-09-17 10:11, Qu Wenruo a écrit :
>> Stéphane Lesimple wrote on 2015/09/17 10:02 +0200:
>>> Le 2015-09-17 08:42, Qu Wenruo a écrit :
>>>> Stéphane Lesimple wrote on 2015/09/17 08:11 +0200:
>>>>> Le 2015-09-17 05:03, Qu Wenruo a écrit :
>>>>>> Stéphane Lesimple wrote on 2015/09/16 22:41 +0200:
>>>>>>> Le 2015-09-16 22:18, Duncan a écrit :
>>>>>>>> Stéphane Lesimple posted on Wed, 16 Sep 2015 15:04:20 +0200 as
>>>>>>>> excerpted:
>>>>>>>>
>>>>>>>
>>>>>>> Well actually it's the (d) option ;)
>>>>>>> I activate the quota feature for only one reason : being able to
>>>>>>> track
>>>>>>> down how much space my snapshots are taking.
>>>>>>
>>>>>> Yeah, that's completely one of the ideal use case of btrfs qgroup.
>>>>>>
>>>>>> But I'm quite curious about the btrfsck error report on qgroup.
>>>>>>
>>>>>> If btrfsck report such error, it means either I'm too confident about
>>>>>> the recent qgroup accounting rework, or btrfsck has some bug which I
>>>>>> didn't take much consideration during the kernel rework.
>>>>>>
>>>>>> Would you please provide the full result of previous btrfsck with
>>>>>> qgroup error?
>>>>>
>>>>> Sure, I've saved the log somewhere just in case, here your are :
>>>>>
>>>>> [...]
>>>> Thanks for your log, pretty interesting result.
>>>>
>>>> BTW, did you enabled qgroup from old kernel earlier than 4.2-rc1?
>>>> If so, I would be much relaxed as they can be the problem of old
>>>> kernels.
>>>
>>> The mkfs.btrfs was done under 3.19, but I'm almost sure I enabled quota
>>> under 4.2.0 precisely. My kern.log tends to confirm that (looking for
>>> 'qgroup scan completed').
>>
>> Emmm, seems I need to pay more attention on this case now.
>> Any info about the workload for this btrfs fs?
>>
>>>
>>>> If it's OK for you, would you please enable quota after reproducing
>>>> the bug and use for sometime and recheck it?
>>>
>>> Sure, I've just reproduced the bug twice as I wanted, and posted the
>>> info, so now I've cancelled the balance and I can reenable quota. Will
>>> do it under 4.3.0-rc1. I'll keep you posted if btrfsck complains about
>>> it in the following days.
>>>
>>> Regards,
>>>
>> Thanks for your patience and detailed report.
>
> You're very welcome.
>
>> But I still have another question, did you do any snapshot deletion
>> after quota enabled?
>> (I'll assume you did it, as there are a lot of backup snapshot, old
>> ones should be already deleted)
>
> Actually no : this btrfs system is quite new (less than a week old) as
> I'm migrating from mdadm(raid1)+ext4 to btrfs. So those snapshots were
> actually rsynced one by one from my hardlinks-based "snapshots" under
> ext4 (those pseudo-snapshots are created using a program named
> "rsnapshot", if you know it. This is basically a wrapper to cp -la). I
> didn't activate yet an automatic snapshot/delete on my btrfs system, due
> to the bugs I'm tripping on. So no snapshot was deleted.

Now things are getting tricky, as all known bugs are ruled out, it must 
be another hidden bug, even we tried to rework the qgroup accounting code.

>
>> That's one of the known bug and Mark is working on it actively.
>> If you delete non-empty snapshot a lot, then I'd better add a hot fix
>> to mark qgroup inconsistent after snapshot delete, and trigger a
>> rescan if possible.
>
> I've made a btrfs-image of the filesystem just before disabling quotas
> (which I did to get a clean btrfsck and eliminate quotas from the
> equation trying to reproduce the bug I have). Would it be of any use if
> I drop it somewhere for you to pick it up ? (2.9G in size).

For dismatch case, static btrfs-image dump won't really help.
As the important point is, when and which operation caused qgroup 
accounting to dismatch.

>
> In the meantime, I've reactivated quotas, umounted the filesystem and
> ran a btrfsck on it : as you would expect, there's no qgroup problem
> reported so far.

At least, rescan code is working without problem.

> I'll clear all my snapshots, run an quota rescan, then
> re-create them one by one by rsyncing from my ext4 system I still have.
> Maybe I'll run into the issue again.
>

Would you mind to do the following check for each subvolume rsync?

1) Do 'sync; btrfs qgroup show -prce --raw' and save the output
2) Create the needed snapshot
3) Do 'sync; btrfs qgroup show -prce --raw' and save the output
4) Avoid doing IO if possible until step 6)
5) Do 'btrfs quota rescan -w' and save it
6) Do 'sync; btrfs qgroup show -prce --raw' and save the output
7) Rsync data from ext4 to the newly created snapshot

The point is, as you mentioned, rescan is working fine, we can compare 
output from 3), 6) and 1) to see which qgroup accounting number changes.

And if differs, which means the qgroup update at write time OR snapshot 
creation has something wrong, at least we can locate the problem to 
qgroup update routine or snapshot creation.

Thanks,
Qu
