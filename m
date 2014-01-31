Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63516 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaAaQhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 11:37:40 -0500
Received: by mail-pa0-f53.google.com with SMTP id lj1so4586065pab.26
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 08:37:40 -0800 (PST)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs send
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <2DED49DB-B86D-46FB-B05C-3FB5E655749C@gmail.com>
Date: Sat, 1 Feb 2014 00:37:15 +0800
Cc: <linux-btrfs@vger.kernel.org>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Message-Id: <15132D45-7C4B-41FD-A240-43BCFE314726@gmail.com>
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com> <52E94FEA.5060404@fb.com> <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com> <52EA78E3.9060009@fb.com> <98BBA3BC-1CB6-4840-A5AF-6CE9C76B72AA@gmail.com> <52EA7C78.2030509@fb.com> <2DED49DB-B86D-46FB-B05C-3FB5E655749C@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

> 
> ÔÚ 2014-1-31£¬ÉÏÎç12:23£¬Josef Bacik <jbacik@fb.com> Ð´µÀ£º
> 
>> 
>> On 01/30/2014 11:20 AM, Wang Shilong wrote:
>>> Hello Josef,
>>> 
>>>> On 01/30/2014 04:42 AM, Wang Shilong wrote:
>>>>> Hi Josef,
>>>>> 
>>>>>> On 01/29/2014 10:32 AM, Wang Shilong wrote:
>>>>>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>>>>> 
>>>>>>> I sent a patch to kick off transaction from btrfs send, however it gets
>>>>>>> a regression that btrfs send try to search extent commit root without
>>>>>>> transaction protection.
>>>>>>> 
>>>>>>> To fix this regression, we have two ideas:
>>>>>>> 
>>>>>>> 1. don't use extent commit root for sending.
>>>>>>> 
>>>>>>> 2. add transaction protection to use extent commit root safely.
>>>>>>> 
>>>>>>> Both approaches need transaction actually, however, the first approach
>>>>>>> will add extent tree lock contention, so we'd better adopt the second
>>>>>>> approach.
>>>>>>> 
>>>>>>> Luckily, now we only need transaction protection when iterating
>>>>>>> extent root, the protection's *range* is smaller than before.
>>>>>> So what is the problem exactly?  How does it show up and what are you doing to make it happen?  I'd really like to kill the transaction taking completely in the send path so I'd like to know what is going wrong so we can either take the extent commit semaphore and be satisfied that is ok or come up with a different solution.  Thanks,
>>>>> See in find_extent_clone(), we have to walk backrefs  while we have to search extent tree!
>>>>> i was thinking to kick off transaction for initial  full send, however, we need to consider ref links even
>>>>> in the initial send.
>>>>> 
>>>>> It is easy to trigger problems like the following steps:
>>>>> 
>>>>> # mkfs.btrfs -f /dev/sda8
>>>>> # mount /dev/sda8 /mnt
>>>>> # dd if=/dev/zero of=/mnt/data bs=4k count=102400 oflag=direct
>>>>> # btrfs sub snapshot -r /mnt /mnt/snap
>>>>> # btrfs send /mnt/snap -f /mnt/send_file &
>>>>> # btrfs sub snapshot /mnt/snap /mnt/snap_1
>>>>> 
>>>>> Feel free to correct me if i miss something here^_^(As i sometimes made some mistakes).
>>>>> 
>>>> Ok so this is a lot of broken things, but it's not really the extent root, cause like I said before nothings going to change that matters for the snapshots bytes.
>>>> 
>>>> What _does_ matter is the actual commit root for the actual fs root, and that requires quite a bit of manoeuvring to get right.  So I'll send a patch in a few minutes when I'm happy with what I have to fix this.  In the meantime would you rig this example up into an xfstest so we can make sure we don't have this problem in the future? Thanks,
>>> I am a little confused that we don't need protect extent commit root anyway, it is really safe to search extent commit  root without any transaction protection^_^¡­.
>>> And i am ok to send a xfstest case for this..
>>> 
>> Sorry I didn't say that quite right.  We definitely need to protect the commit root for the extent root because we could easily swap it out and then write over blocks as we search down it, which would break things.  But that's not what was screwing up here, we are cow'ing the root for /mnt/snap and swapping out the commit root out from under us which is screwing us up because we end up with a different root level than what we are expecting.
>> 
>> So we need to use extent_commit_sem anywhere we search the commit root for the extent tree, but we also need to do the same for searching the fs roots.  Thanks,

By some debugging, i found snapshots  will cow src root(this is a little strange...), we need do the same thing
for searching fs roots. Really thanks for looking into issue, and correct me,  waiting for your fix.^_^ ^_^

Thanks,
Wang
> 
> Looking into codes, we are always searching commit fs root for sending, snapshot will change src root's level(it will cow everything in tree root).
> Since we only support readonly root to send, we only need to protect extent root, and the search from tree root.
> 
> So here i think by holding @extent_commit_sem outside find_extent_clone() is ok, right?
> 
> Thank,
> Wang
> 
>> 
>> Josef
> 

