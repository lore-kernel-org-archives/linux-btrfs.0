Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f179.google.com ([209.85.208.179]:39581 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbeITXKa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 19:10:30 -0400
Received: by mail-lj1-f179.google.com with SMTP id l15-v6so9149450lji.6
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 10:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f76d90ea719d9c386ec5a26ed0f4fb07@t-5.eu>
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu> <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
 <bb7c2fdd78c731bdf9b5044f4dfc4223@t-5.eu> <cb7403dd-0e76-8e8c-2389-30283b9e319d@suse.com>
 <165d2939520.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com> <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <91b2f76b-5b1c-6df3-ac8c-058696f27788@suse.com> <165d2e8e110.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <322267c4-5671-73f3-acca-797dd6fe3572@suse.com> <f76d90ea719d9c386ec5a26ed0f4fb07@t-5.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 20 Sep 2018 11:25:55 -0600
Message-ID: <CAJCQCtRDW71_joXV-TzxPudM=pip+h+YMrVfhy_VX4cmYQRFfA@mail.gmail.com>
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
To: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
Cc: Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 1:41 PM, Jürgen Herrmann <t-5@t-5.eu> wrote:
> Am 13.9.2018 14:35, schrieb Nikolay Borisov:
>>
>> On 13.09.2018 15:30, Jürgen Herrmann wrote:
>>>
>>> OK, I will install kdump later and perform a dump after the hang.
>>>
>>> One more noob question beforehand: does this dump contain sensitive
>>> information, for example the luks encryption key for the disk etc? A
>>> Google search only brings up one relevant search result which can only
>>> be viewed with a redhat subscription...
>>
>>
>>
>> So a kdump will dump the kernel memory so it's possible that the LUKS
>> encryption keys could be extracted from that image. Bummer, it's
>> understandable why you wouldn't want to upload it :). In this case you'd
>> have to install also the 'crash' utility to open the crashdump and
>> extract the calltrace of the btrfs process. The rough process should be :
>>
>>
>> crash 'path to vm linux' 'path to vmcore file', then once inside the
>> crash utility :
>>
>> set <pid of btrfs send process>, you can acquire the pid by issuing 'ps'
>> which will give you a ps-like output of all running processes at the
>> time of crash. After the context has been set you can run 'bt' which
>> will give you a backtrace of the send process.
>>
>>
>>
>>>
>>> Best regards,
>>> Jürgen
>>>
>>> Am 13. September 2018 14:02:11 schrieb Nikolay Borisov
>>> <nborisov@suse.com>:
>>>
>>>> On 13.09.2018 14:50, Jürgen Herrmann wrote:
>>>>>
>>>>> I was echoing "w" to /proc/sysrq_trigger every 0.5s which did work also
>>>>> after the hang because I started the loop before the hang. The dmesg
>>>>> output should show the hanging tasks from second 346 on or so. Still
>>>>> not
>>>>> useful?
>>>>>
>>>>
>>>> So from 346 it's evident that transaction commit is waiting for
>>>> commit_root_sem to be acquired. So something else is holding it and not
>>>> giving the transaction chance to finish committing. Now the only place
>>>> where send acquires this lock is in find_extent_clone around the  call
>>>> to extent_from_logical. The latter basically does an extent tree search
>>>> and doesn't loop so can't possibly deadlock. Furthermore I don't see any
>>>> userspace processes being hung in kernel space.
>>>>
>>>> Additionally looking at the userspace processes they indicate that
>>>> find_extent_clone has finished and are blocked in send_write_or_clone
>>>> which does the write. But I guess this actually happens before the hang.
>>>>
>>>>
>>>> So at this point without looking at the stacktrace of the btrfs send
>>>> process after the hung has occurred I don't think much can be done
>>>
>>>
> I know this is probably not the correct list to ask this question but maybe
> someone of the devs can point me to the right list?
>
> I cannot get kdump to work. The crashkernel is loaded and everything is
> setup for it afaict. I asked a question on this over at stackexchange but no
> answer yet.
> https://unix.stackexchange.com/questions/469838/linux-kdump-does-not-boot-second-kernel-when-kernel-is-crashing
>
> So i did a little digging and added some debug printk() statements to see
> whats going on and it seems that panic() is never called. maybe the second
> stack trace is the reason?
> Screenshot is here: https://t-5.eu/owncloud/index.php/s/OegsikXo4VFLTJN
>
> Could someone please tell me where I can report this problem and get some
> help on this topic?


Try kexec mailing list. They handle kdump.

http://lists.infradead.org/mailman/listinfo/kexec



-- 
Chris Murphy
