Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25982 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751433AbaA3QIX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 11:08:23 -0500
Message-ID: <52EA78E3.9060009@fb.com>
Date: Thu, 30 Jan 2014 11:08:03 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs
 send
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com> <52E94FEA.5060404@fb.com> <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com>
In-Reply-To: <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/30/2014 04:42 AM, Wang Shilong wrote:
> Hi Josef,
>
>> On 01/29/2014 10:32 AM, Wang Shilong wrote:
>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>
>>> I sent a patch to kick off transaction from btrfs send, however it gets
>>> a regression that btrfs send try to search extent commit root without
>>> transaction protection.
>>>
>>> To fix this regression, we have two ideas:
>>>
>>>   1. don't use extent commit root for sending.
>>>
>>>   2. add transaction protection to use extent commit root safely.
>>>
>>> Both approaches need transaction actually, however, the first approach
>>> will add extent tree lock contention, so we'd better adopt the second
>>> approach.
>>>
>>> Luckily, now we only need transaction protection when iterating
>>> extent root, the protection's *range* is smaller than before.
>> So what is the problem exactly?  How does it show up and what are you doing to make it happen?  I'd really like to kill the transaction taking completely in the send path so I'd like to know what is going wrong so we can either take the extent commit semaphore and be satisfied that is ok or come up with a different solution.  Thanks,
> See in find_extent_clone(), we have to walk backrefs  while we have to search extent tree!
> i was thinking to kick off transaction for initial  full send, however, we need to consider ref links even
> in the initial send.
>
> It is easy to trigger problems like the following steps:
>
> # mkfs.btrfs -f /dev/sda8
> # mount /dev/sda8 /mnt
> # dd if=/dev/zero of=/mnt/data bs=4k count=102400 oflag=direct
> # btrfs sub snapshot -r /mnt /mnt/snap
> # btrfs send /mnt/snap -f /mnt/send_file &
> # btrfs sub snapshot /mnt/snap /mnt/snap_1
>
> Feel free to correct me if i miss something here^_^(As i sometimes made some mistakes).
>
Ok so this is a lot of broken things, but it's not really the extent 
root, cause like I said before nothings going to change that matters for 
the snapshots bytes.

What _does_ matter is the actual commit root for the actual fs root, and 
that requires quite a bit of manoeuvring to get right.  So I'll send a 
patch in a few minutes when I'm happy with what I have to fix this.  In 
the meantime would you rig this example up into an xfstest so we can 
make sure we don't have this problem in the future? Thanks,

Josef
