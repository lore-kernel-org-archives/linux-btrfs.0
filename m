Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36947 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307AbaBEUrw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 15:47:52 -0500
Message-ID: <52F2A370.2080509@fb.com>
Date: Wed, 5 Feb 2014 15:47:44 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs
 send
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com> <52E94FEA.5060404@fb.com> <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com> <52EA78E3.9060009@fb.com> <98BBA3BC-1CB6-4840-A5AF-6CE9C76B72AA@gmail.com> <52EA7C78.2030509@fb.com> <2DED49DB-B86D-46FB-B05C-3FB5E655749C@gmail.com> <15132D45-7C4B-41FD-A240-43BCFE314726@gmail.com> <52F00AAE.6070509@fb.com> <15BD028C-7568-4ACF-84D1-CA39092AD285@gmail.com> <52F244DE.9030108@fb.com> <2ECC0789-2FE8-4644-B439-35B682502867@gmail.com>
In-Reply-To: <2ECC0789-2FE8-4644-B439-35B682502867@gmail.com>
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/05/2014 12:23 PM, Wang Shilong wrote:
> Hi Josef,
>
>> On 02/05/2014 03:59 AM, Wang Shilong wrote:
>>> Hi Josef,
>>>
>>> [..SNIP..]
>>>> On 01/31/2014 11:37 AM, Wang Shilong wrote:
>>>>> Hello Josef,
>>>>>
>>>> 2) Remove the per-root rwsem for the commit root and just make one big
>>>> rwsem that covers all commit root switching. This way everybody who
>>>> wants to search with the commit root can just use this semaphore and all
>>>> be safe. It will mean that the inode cache stuff may block longer than
>>>> normal but I don't think that's too big of a deal.
>>>>
>>> I am ok with this fix,  I wanted to talk something about protecting searching commit file root, this is really a
>>> problem especially for full send.
>>>
>>> I have some ideas about this issue:
>>>
>>> #1.don't use commit file root to search.
>>> This will become a nightmare when we are doing full send which will iterate the whole file tree,
>>> at the same time, we snapshot send root, snapshots will be blocked until send finished.
>>>
>>> #2. don't allow snapshot if we are sending root.
>>> This may be a little confusing, snapshots are readonly, but users can not snapshot it.
>> I think this is the best bet. The fact is we don't want to hold this
>> commit_root_sem for the entire duration of the send, it would block
>> people trying to commit the transaction. We could check for contention
>> and drop the sem and re-search down to where we were but I think that
>> would be prone to errors. If we just check to see if the snapshot is
>> being sent and just return -EBUSY when we try to create a snapshot I
>> think that's perfectly reasonable.
>>> #3. after one iteration, we do check send_root's generation, and make sure it doesn't
>>> change, if it changed, then we restart send again.
>>>
>>> I don't know which approach is better,and also snapshot-aware defragment will change
>>> read-only snapshot?
>>>
>>> Did you have any better ideas about this issue? Share it with me here.^_^
>>>
>> Snapshot-aware defrag will definitely screw us here. I think we need to
>> do the same thing above as we do here, which is to simply skip the
>> snapshot aware defrag if we are currently using that root for send. This
>> sound reasonable to you? Thanks,
> Yeah, very reasonable, if you don't mind, i would give a patch for this issue.
Go for it, you'll be faster than I will be, all I do is run xfstests and
try to reproduce things that will never reproduce for me.

Josef
