Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38026 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbeIMRjW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:39:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id w11-v6so5414865wrc.5
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 05:30:06 -0700 (PDT)
From: =?UTF-8?B?SsO8cmdlbiBIZXJybWFubg==?= <t-5@t-5.eu>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 13 Sep 2018 14:30:02 +0200
Message-ID: <165d2e8e110.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
In-Reply-To: <91b2f76b-5b1c-6df3-ac8c-058696f27788@suse.com>
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
 <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
 <bb7c2fdd78c731bdf9b5044f4dfc4223@t-5.eu>
 <cb7403dd-0e76-8e8c-2389-30283b9e319d@suse.com>
 <165d2939520.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com>
 <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <91b2f76b-5b1c-6df3-ac8c-058696f27788@suse.com>
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, I will install kdump later and perform a dump after the hang.

One more noob question beforehand: does this dump contain sensitive 
information, for example the luks encryption key for the disk etc? A Google 
search only brings up one relevant search result which can only be viewed 
with a redhat subscription...

Best regards,
Jürgen

Am 13. September 2018 14:02:11 schrieb Nikolay Borisov <nborisov@suse.com>:

> On 13.09.2018 14:50, Jürgen Herrmann wrote:
>> I was echoing "w" to /proc/sysrq_trigger every 0.5s which did work also
>> after the hang because I started the loop before the hang. The dmesg
>> output should show the hanging tasks from second 346 on or so. Still not
>> useful?
>>
>
> So from 346 it's evident that transaction commit is waiting for
> commit_root_sem to be acquired. So something else is holding it and not
> giving the transaction chance to finish committing. Now the only place
> where send acquires this lock is in find_extent_clone around the  call
> to extent_from_logical. The latter basically does an extent tree search
> and doesn't loop so can't possibly deadlock. Furthermore I don't see any
> userspace processes being hung in kernel space.
>
> Additionally looking at the userspace processes they indicate that
> find_extent_clone has finished and are blocked in send_write_or_clone
> which does the write. But I guess this actually happens before the hang.
>
>
> So at this point without looking at the stacktrace of the btrfs send
> process after the hung has occurred I don't think much can be done


Mit AquaMail Android
https://www.mobisystems.com/aqua-mail
