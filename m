Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727152AbeIMRLR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:11:17 -0400
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>
Cc: linux-btrfs@vger.kernel.org
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
 <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
 <bb7c2fdd78c731bdf9b5044f4dfc4223@t-5.eu>
 <cb7403dd-0e76-8e8c-2389-30283b9e319d@suse.com>
 <165d2939520.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com>
 <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <91b2f76b-5b1c-6df3-ac8c-058696f27788@suse.com>
Date: Thu, 13 Sep 2018 15:02:05 +0300
MIME-Version: 1.0
In-Reply-To: <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 14:50, Jürgen Herrmann wrote:
> I was echoing "w" to /proc/sysrq_trigger every 0.5s which did work also
> after the hang because I started the loop before the hang. The dmesg
> output should show the hanging tasks from second 346 on or so. Still not
> useful?
> 

So from 346 it's evident that transaction commit is waiting for
commit_root_sem to be acquired. So something else is holding it and not
giving the transaction chance to finish committing. Now the only place
where send acquires this lock is in find_extent_clone around the  call
to extent_from_logical. The latter basically does an extent tree search
and doesn't loop so can't possibly deadlock. Furthermore I don't see any
userspace processes being hung in kernel space.

Additionally looking at the userspace processes they indicate that
find_extent_clone has finished and are blocked in send_write_or_clone
which does the write. But I guess this actually happens before the hang.


So at this point without looking at the stacktrace of the btrfs send
process after the hung has occurred I don't think much can be done
