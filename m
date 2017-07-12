Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35554 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbdGLTgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 15:36:01 -0400
Received: by mail-oi0-f50.google.com with SMTP id 191so28534085oii.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 12:36:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e4a12dcf-62e9-adba-72f9-07e2d2c4ca68@suse.com>
References: <CAMp4zn9Bv=ULBx9f-jPAZrmc9oOOT+egpypBPSjajd03WFA71A@mail.gmail.com>
 <CAMp4zn9KmzW2gC9hHsuATsDZSMWT6PeqkA+cBLj3wMroZkXFLA@mail.gmail.com>
 <4c844bc7-2cee-d249-b1af-e1da7cab35a0@suse.com> <c3f16d38-1331-e420-2a92-37db71ea8dee@suse.com>
 <CAMp4zn_6up7FVB=HdkAka7B5qkYDNE_mseiWP2+SC-v_Gu4Vog@mail.gmail.com>
 <4952ca4f-2824-fabf-1b0d-048d8e901e2f@suse.com> <CAMp4zn8mr-24aO6m0_vpc-9WLSkkhgscZUGcxPDhdbUYtOPrOw@mail.gmail.com>
 <e4a12dcf-62e9-adba-72f9-07e2d2c4ca68@suse.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Wed, 12 Jul 2017 12:35:19 -0700
Message-ID: <CAMp4zn-qMk43h+EgsZu53ehOyfhPb5+JEKnA4O_hmz1E7zeJhQ@mail.gmail.com>
Subject: Re: Lock between userspace and btrfs-cleaner on extent_buffer
To: Jeff Mahoney <jeffm@suse.com>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 11:49 AM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 6/29/17 2:46 PM, Sargun Dhillon wrote:
>> On Thu, Jun 29, 2017 at 11:42 AM, Jeff Mahoney <jeffm@suse.com> wrote:
>>> On 6/28/17 6:02 PM, Sargun Dhillon wrote:
>>>> On Wed, Jun 28, 2017 at 2:55 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>>>>> On 6/27/17 5:12 PM, Jeff Mahoney wrote:
>>>>>> On 6/13/17 9:05 PM, Sargun Dhillon wrote:
>>>>>>> On Thu, Jun 8, 2017 at 11:34 AM, Sargun Dhillon <sargun@sargun.me> wrote:
>>>>>>>> I have a deadlock caught in the wild between two processes --
>>>>>>>> btrfs-cleaner, and userspace process (Docker). Here, you can see both
>>>>>>>> of the backtraces. btrfs-cleaner is trying to get a lock on
>>>>>>>> ffff9859d360caf0, which is owned by Docker's pid. Docker on the other
>>>>>>>> hand is trying to get a lock on ffff9859dc0f0578, which is owned by
>>>>>>>> btrfs-cleaner's Pid.
>>>>>>>>
>>>>>>>> This is on vanilla 4.11.3 without much workload. The background
>>>>>>>> workload was basically starting and stopping Docker with a medium
>>>>>>>> sized image like ubuntu:latest with sleep 5. So, snapshot creation,
>>>>>>>> destruction. And there's some stuff that's logging to btrfs.
>>>>>>
>>>>>> Hi Sargun -
>>>>>>
>>>>>> We hit this bug in testing last week.  I have a patch that I've written
>>>>>> up and have run under your reproducer for a while.  So far it hasn't
>>>>>> hit.  I'll post it shortly and CC you.  It does depend lightly on the
>>>>>> rbtree code, though.  Since we'll want this fix for -stable, I'll write
>>>>>> up a version for that too.
>>>>>
>>>>> After thinking about it a bit more, I think my patch just happens to
>>>>> make it less likely to hit but would ultimately degrade into a livelock
>>>>> where it was a deadlock previously.  I was just trylocking and
>>>>> requeuing, so both threads are allowed to do other work and maybe even
>>>>> finish but ultimately if there's a true deadlock it'll hit anyway.
>>>>>
>>>>> -Jeff
>>>>>
>>>> Does it make sense to spend the time on making it so that
>>>> btrfs-cleaner has abortable operations, and the ability to abort if
>>>> the root deletion either takes too long, or if it receives a signal?
>>>> Although, such a case may result in a livelock, to me it seems like a
>>>> lot less bad than deadlocking.
>>>
>>>
>>> For now, reverting:
>>>
>>> commit fb235dc06fac9eaa4408ade9c8b20d45d63c89b7
>>> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> Date:   Wed Feb 15 10:43:03 2017 +0800
>>>
>>>     btrfs: qgroup: Move half of the qgroup accounting time out of commit
>>> trans
>>>
>>> ... should do the trick.
>>>
>>> -Jeff
>>>
>> I thought it was this as well, but we still saw lock-ups even after
>> reverting this change on 4.11. They were rarer, but we still saw
>> issues with locked up btrfs-transactions. It may have been due to a
>> different issue. If you want. I can try to revert this, and run a
>> workload on it to see where the exact lock-up is?
>
> Yeah, I'd be interested in those results.
>
> -Jeff
>
>
> --
> Jeff Mahoney
> SUSE Labs
>
Thanks Jeff,
Upon further analysis, it looks like rolling this back fixed the
btrfs-cleaner lock up, but the we're seeing a different hard lockup,
where num_writers on the current transaction gets stuck at 2.
