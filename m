Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44554 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaA3Jm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 04:42:58 -0500
Received: by mail-pd0-f180.google.com with SMTP id x10so2807243pdj.25
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 01:42:58 -0800 (PST)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs send
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <52E94FEA.5060404@fb.com>
Date: Thu, 30 Jan 2014 17:42:47 +0800
Cc: <linux-btrfs@vger.kernel.org>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Message-Id: <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com>
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com> <52E94FEA.5060404@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

> 
> On 01/29/2014 10:32 AM, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> 
>> I sent a patch to kick off transaction from btrfs send, however it gets
>> a regression that btrfs send try to search extent commit root without
>> transaction protection.
>> 
>> To fix this regression, we have two ideas:
>> 
>>  1. don't use extent commit root for sending.
>> 
>>  2. add transaction protection to use extent commit root safely.
>> 
>> Both approaches need transaction actually, however, the first approach
>> will add extent tree lock contention, so we'd better adopt the second
>> approach.
>> 
>> Luckily, now we only need transaction protection when iterating
>> extent root, the protection's *range* is smaller than before.
> So what is the problem exactly?  How does it show up and what are you doing to make it happen?  I'd really like to kill the transaction taking completely in the send path so I'd like to know what is going wrong so we can either take the extent commit semaphore and be satisfied that is ok or come up with a different solution.  Thanks,

See in find_extent_clone(), we have to walk backrefs  while we have to search extent tree!
i was thinking to kick off transaction for initial  full send, however, we need to consider ref links even
in the initial send.

It is easy to trigger problems like the following steps:

# mkfs.btrfs -f /dev/sda8
# mount /dev/sda8 /mnt
# dd if=/dev/zero of=/mnt/data bs=4k count=102400 oflag=direct
# btrfs sub snapshot -r /mnt /mnt/snap
# btrfs send /mnt/snap -f /mnt/send_file &
# btrfs sub snapshot /mnt/snap /mnt/snap_1

Feel free to correct me if i miss something here^_^(As i sometimes made some mistakes).

Thanks,
Wang
> ,
> Josef

