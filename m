Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:56590 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdIRGK7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 02:10:59 -0400
Received: by mail-io0-f180.google.com with SMTP id m103so15979963iod.13
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 23:10:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
References: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
 <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Mon, 18 Sep 2017 02:10:37 -0400
Message-ID: <CAH=dxU4yTdKQwZX3L-oOMs2ZYiR82m1-F0GhbSU4SV_K2jrBGA@mail.gmail.com>
Subject: Re: ERROR: parent determination failed (btrfs send-receive)
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 18, 2017 at 12:23 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 18.09.2017 05:31, Dave пишет:
>> Sometimes when using btrfs send-receive, I get errors like this:
>>
>> ERROR: parent determination failed for <subvolume name>
>>
>> When this happens, btrfs send-receive backups fail. And all subsequent
>> backups fail too.
>>
>> The issue seems to stem from the fact that an automated cleanup
>> process removes certain earlier subvolumes. (I'm using Snapper.)
>>
>> I'd like to understand exactly what is happening so that my backups do
>> not unexpectedly fail.
>>
>
> You try to send incremental changes but you deleted subvolume to compute
> changes against. It is hard to tell more without seeing subvolume list
> with uuid/parent uuid.

I do not have a current subvolume list to provide UUID's. To ensure
integrity of my backups, I was forced to delete all backup snapshots
and start over. (After this initial parent determination error, my
attempted solution created a new problem related to Received UUID's,
so removing all backups was the best solution in the end.)

For my understanding, what are the restrictions on deleting snapshots?

What scenarios can lead to "ERROR: parent determination failed"?

After all, it should not be necessary to retain every snapshot ever
made. We have to delete snapshots periodically.

In my case, I still retained every snapshot on the target volume. None
had ever been deleted (yet). And I also retained around 30 recent
snapshots on the source, according to the snapper timeline cleanup
config. Yet I still ran into "ERROR: parent determination failed".

>
>> In my scenario, no parent subvolumes have been deleted from the
>> target. Some subvolumes have been deleted from the source, but why
>> does that matter? I am able to take a valid snapshot at this time and
>> every snapshot ever taken continues to reside at the target backup
>> destination (seemingly meaning that a parent subvolume can be found at
>> the target).
>>
>> This issue seems to make btrfs send-receive a very fragile backup
>> solution.
>
> btrfs send/receive is not backup solution - it is low level tool that
> does exactly what it is told to do. You may create backup solution that
> is using btrfs send/receive to transfer data stream, but then do not
> blame tool for incorrect usage.
>
> To give better advice how to fix your situation you need to describe
> your backup solution - how exactly you select/create snapshots.

I use snap-sync to create and send snapshots.

GitHub - wesbarnett/snap-sync: Use snapper snapshots to backup to external drive
https://github.com/wesbarnett/snap-sync

>
> I hope, instead, there is some knowledge I'm missing, that
>> when learned, will make this a robust backup solution.
>>
>> Thanks
>> --
