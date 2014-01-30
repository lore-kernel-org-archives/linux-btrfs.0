Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61726 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaA3QUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 11:20:42 -0500
Received: by mail-pb0-f41.google.com with SMTP id up15so3311011pbc.28
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 08:20:42 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs send
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <52EA78E3.9060009@fb.com>
Date: Fri, 31 Jan 2014 00:20:27 +0800
Cc: <linux-btrfs@vger.kernel.org>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Message-Id: <98BBA3BC-1CB6-4840-A5AF-6CE9C76B72AA@gmail.com>
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com> <52E94FEA.5060404@fb.com> <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com> <52EA78E3.9060009@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

> 
> On 01/30/2014 04:42 AM, Wang Shilong wrote:
>> Hi Josef,
>> 
>>> On 01/29/2014 10:32 AM, Wang Shilong wrote:
>>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>> 
>>>> I sent a patch to kick off transaction from btrfs send, however it gets
>>>> a regression that btrfs send try to search extent commit root without
>>>> transaction protection.
>>>> 
>>>> To fix this regression, we have two ideas:
>>>> 
>>>>  1. don't use extent commit root for sending.
>>>> 
>>>>  2. add transaction protection to use extent commit root safely.
>>>> 
>>>> Both approaches need transaction actually, however, the first approach
>>>> will add extent tree lock contention, so we'd better adopt the second
>>>> approach.
>>>> 
>>>> Luckily, now we only need transaction protection when iterating
>>>> extent root, the protection's *range* is smaller than before.
>>> So what is the problem exactly?  How does it show up and what are you doing to make it happen?  I'd really like to kill the transaction taking completely in the send path so I'd like to know what is going wrong so we can either take the extent commit semaphore and be satisfied that is ok or come up with a different solution.  Thanks,
>> See in find_extent_clone(), we have to walk backrefs  while we have to search extent tree!
>> i was thinking to kick off transaction for initial  full send, however, we need to consider ref links even
>> in the initial send.
>> 
>> It is easy to trigger problems like the following steps:
>> 
>> # mkfs.btrfs -f /dev/sda8
>> # mount /dev/sda8 /mnt
>> # dd if=/dev/zero of=/mnt/data bs=4k count=102400 oflag=direct
>> # btrfs sub snapshot -r /mnt /mnt/snap
>> # btrfs send /mnt/snap -f /mnt/send_file &
>> # btrfs sub snapshot /mnt/snap /mnt/snap_1
>> 
>> Feel free to correct me if i miss something here^_^(As i sometimes made some mistakes).
>> 
> Ok so this is a lot of broken things, but it's not really the extent root, cause like I said before nothings going to change that matters for the snapshots bytes.
> 
> What _does_ matter is the actual commit root for the actual fs root, and that requires quite a bit of manoeuvring to get right.  So I'll send a patch in a few minutes when I'm happy with what I have to fix this.  In the meantime would you rig this example up into an xfstest so we can make sure we don't have this problem in the future? Thanks,

I am a little confused that we don't need protect extent commit root anyway, it is really safe to search extent commit  root without any transaction protection^_^….
And i am ok to send a xfstest case for this..

Thanks,
Wang
> 
> Josef

