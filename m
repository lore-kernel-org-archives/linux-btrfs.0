Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12150 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813AbaBCVbg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 16:31:36 -0500
Message-ID: <52F00AAE.6070509@fb.com>
Date: Mon, 3 Feb 2014 16:31:26 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs
 send
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com> <52E94FEA.5060404@fb.com> <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com> <52EA78E3.9060009@fb.com> <98BBA3BC-1CB6-4840-A5AF-6CE9C76B72AA@gmail.com> <52EA7C78.2030509@fb.com> <2DED49DB-B86D-46FB-B05C-3FB5E655749C@gmail.com> <15132D45-7C4B-41FD-A240-43BCFE314726@gmail.com>
In-Reply-To: <15132D45-7C4B-41FD-A240-43BCFE314726@gmail.com>
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/31/2014 11:37 AM, Wang Shilong wrote:
> Hello Josef,
>
>> ÔÚ 2014-1-31£¬ÉÏÎç12:23£¬Josef Bacik <jbacik@fb.com> Ð´µÀ£º
>>
>>> On 01/30/2014 11:20 AM, Wang Shilong wrote:
>>>> Hello Josef,
>>>>
>>>>> On 01/30/2014 04:42 AM, Wang Shilong wrote:
>>>>>> Hi Josef,
>>>>>>
>>>>>>> On 01/29/2014 10:32 AM, Wang Shilong wrote:
>>>>>>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>>>>>>
>>>>>>>> I sent a patch to kick off transaction from btrfs send, however it gets
>>>>>>>> a regression that btrfs send try to search extent commit root without
>>>>>>>> transaction protection.
>>>>>>>>
>>>>>>>> To fix this regression, we have two ideas:
>>>>>>>>
>>>>>>>> 1. don't use extent commit root for sending.
>>>>>>>>
>>>>>>>> 2. add transaction protection to use extent commit root safely.
>>>>>>>>
>>>>>>>> Both approaches need transaction actually, however, the first approach
>>>>>>>> will add extent tree lock contention, so we'd better adopt the second
>>>>>>>> approach.
>>>>>>>>
>>>>>>>> Luckily, now we only need transaction protection when iterating
>>>>>>>> extent root, the protection's *range* is smaller than before.
>>>>>>> So what is the problem exactly?  How does it show up and what are you doing to make it happen?  I'd really like to kill the transaction taking completely in the send path so I'd like to know what is going wrong so we can either take the extent commit semaphore and be satisfied that is ok or come up with a different solution.  Thanks,
>>>>>> See in find_extent_clone(), we have to walk backrefs  while we have to search extent tree!
>>>>>> i was thinking to kick off transaction for initial  full send, however, we need to consider ref links even
>>>>>> in the initial send.
>>>>>>
>>>>>> It is easy to trigger problems like the following steps:
>>>>>>
>>>>>> # mkfs.btrfs -f /dev/sda8
>>>>>> # mount /dev/sda8 /mnt
>>>>>> # dd if=/dev/zero of=/mnt/data bs=4k count=102400 oflag=direct
>>>>>> # btrfs sub snapshot -r /mnt /mnt/snap
>>>>>> # btrfs send /mnt/snap -f /mnt/send_file &
>>>>>> # btrfs sub snapshot /mnt/snap /mnt/snap_1
>>>>>>
>>>>>> Feel free to correct me if i miss something here^_^(As i sometimes made some mistakes).
>>>>>>
>>>>> Ok so this is a lot of broken things, but it's not really the extent root, cause like I said before nothings going to change that matters for the snapshots bytes.
>>>>>
>>>>> What _does_ matter is the actual commit root for the actual fs root, and that requires quite a bit of manoeuvring to get right.  So I'll send a patch in a few minutes when I'm happy with what I have to fix this.  In the meantime would you rig this example up into an xfstest so we can make sure we don't have this problem in the future? Thanks,
>>>> I am a little confused that we don't need protect extent commit root anyway, it is really safe to search extent commit  root without any transaction protection^_^¡­.
>>>> And i am ok to send a xfstest case for this..
>>>>
>>> Sorry I didn't say that quite right.  We definitely need to protect the commit root for the extent root because we could easily swap it out and then write over blocks as we search down it, which would break things.  But that's not what was screwing up here, we are cow'ing the root for /mnt/snap and swapping out the commit root out from under us which is screwing us up because we end up with a different root level than what we are expecting.
>>>
>>> So we need to use extent_commit_sem anywhere we search the commit root for the extent tree, but we also need to do the same for searching the fs roots.  Thanks,
> By some debugging, i found snapshots  will cow src root(this is a little strange...), we need do the same thing
> for searching fs roots. Really thanks for looking into issue, and correct me,  waiting for your fix.^_^ ^_^
>
So I've figured it out. We definitely need to protect the commit roots,
but that's not what is screwing us. Say we have commit root for snap at
block 1 and we search down the extent tree and see that it is at 1. Then
we go to do the search down to level on the root for that block, but in
the meantime we've snapshotted and switched the commit root for that
fs_tree to block 2. We go to search down and don't find our bytenr we
were looking for and we exit out without finding our original subvolume.

So there are a few things we can do here

1) Only switch the commit roots for the fs_root _after_ we switch the
extent root commit root. This works out well because we'd need to hold
the extent_commit_sem for the entirety of this operation so we'd end up
with a consistent view of everything. The drawback of this is that we
have to process the fs_roots twice, once to update the root items and
then again to swap the commit roots.

2) Remove the per-root rwsem for the commit root and just make one big
rwsem that covers all commit root switching. This way everybody who
wants to search with the commit root can just use this semaphore and all
be safe. It will mean that the inode cache stuff may block longer than
normal but I don't think that's too big of a deal.

3) Go back to using btrfs_join_transaction(). This is probably the least
likely to bite somebody in the ass, but it's taking a transaction in the
place where we really just want read-only protection without some
asshole taking a snapshot and screwing us.

I'm inclined to go with (and am coding up) #2. Yell if you have any
better suggestions or hate my suggestion. Thanks,

Josef
