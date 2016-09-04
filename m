Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35396 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754121AbcIDWBT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 18:01:19 -0400
Received: by mail-oi0-f52.google.com with SMTP id p186so190550138oia.2
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Sep 2016 15:01:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <em5bdcb5a1-be8c-43a7-a360-87ae4971a5c7@laptophendrik>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
 <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com>
 <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik> <em5bdcb5a1-be8c-43a7-a360-87ae4971a5c7@laptophendrik>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Sep 2016 16:01:18 -0600
Message-ID: <CAJCQCtSOaH4JsBBr+P=PRX_a2SxNkaQSc7Hqzm3afQEjfZDK8Q@mail.gmail.com>
Subject: Re: Re[3]: btrfs check "Couldn't open file system" after error in transaction.c
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 4, 2016 at 12:51 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello again,
>
> before overwriting the filesystem, some last questions:
>
>>>  Maybe
>>> take advantage of the fact it does read only and recreate it. You
>>> could take a btrfs-image and btrfs-debug-tree first,
>>
>> And what do I do with it?
>>
>>> because there's
>>> some bug somewhere: somehow it became inconsistent, and can't be fixed
>>> at mount time or even with btrfs check.
>>
>> Ok, so is there any way to help you finding this bug?
>
> Anything, I can do here?
>
>> Coming back to my objectives:
>> -Understand the reason behind the issue and prevent it in future
>> Finding the but would help on the above
>>
>> -If not possible to repair the filesystem:
>>    -understand if the data that I read from the drive is valid or
>> corrupted
>> Can you answer this?
>>
>> As mentioned: I do have a backup, a month old. The data does not change so
>> regularly, so most should be ok.
>> Now I have two sources of data:
>> the backup and the current degraded filesystem.
>> If data differs, which one do I take? Is it safe to use the more recent
>> one from the degraded filesystem?
>>
> And can you help me on these points?
>
> FYI, I did a
> btrfsck --init-csum-tree /dev/sdd
> btrfs rescue zero-log btrfs-zero-log
> btrfsck /dev/sdd

Curious that this is fixing a parenttransid problem...not sure why.
Only a developer working on btrfsck could answer this. They'd need the
btrfs-image before these things were done and see what's wrong with
the file system that causes check to fail. Changing anything changes
the evidence of what was wrong.

>
> now. The last command is still running. It seems to be working; Is there a
> way to be sure, that the data is all ok again?

Not by Brfs. The problem now is that by init-csum-tree it recomputed
the csums for everything. If there were any files corrupt, they now
have csums based on that corruption, so they will read as OK by Btrfs.
That's the problem with init-csum-tree. So now you need a different
way to confirm/deny if they files are really good or not.



-- 
Chris Murphy
